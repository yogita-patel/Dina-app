import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_event.dart';

import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/product_status_badges.dart';
import '../../../common_widgets/quantity_selector.dart';
import '../../../common_widgets/unit_dropdown.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../hive/prefetch_service.dart';
import '../bloc/catalog_screen_bloc.dart';
import 'add_to_basket_subtotal_price_card.dart';

class CatalogListView extends StatefulWidget {
  final List<Product>? products;
  final String byDefultSelected;
  final CatalogScreenBloc? bloc;
  final AppLocalizations? localizations;
  final ScrollController? controller;

  final Function(String, int)? addProductToWishList;

  const CatalogListView({
    this.products,
    this.byDefultSelected = '',
    this.bloc,
    this.controller,
    this.addProductToWishList,
    this.localizations,
    super.key,
  });

  @override
  State<CatalogListView> createState() => _CatalogListViewState();
}

class _CatalogListViewState extends State<CatalogListView> {
  Map<int, String> selectedUnits = {};
  Map<int, int> quantities = {};
  Map<int, bool> isMiniPackSelected = {};
  int? quantity;
  Map<int, String> matchedPrices = {};

  int _safeParse(String? value) => int.tryParse(value ?? '') ?? 0;

  Map<String, int> _buildUnitMap(Product? product) {
    return {
      if (_safeParse(product?.miniPack) > 0)
        "Mini Pack (${product!.miniPack})": _safeParse(product.miniPack),
      if (_safeParse(product?.inner) > 0)
        "Inner (${product!.inner})": _safeParse(product.inner),
      if (_safeParse(product?.carton) > 0)
        "Carton (${product!.carton})": _safeParse(product.carton),
    };
  }

  int _extractUnitSize(String unitLabel) {
    final match = RegExp(r'\((\d+)\)').firstMatch(unitLabel);
    return _safeParse(match?.group(1));
  }

  MapEntry<String, int>? _findUnitEntry(
    Map<String, int> unitMap,
    String unitName,
  ) {
    for (final entry in unitMap.entries) {
      if (entry.key.contains(unitName)) {
        return entry;
      }
    }
    return null;
  }

  void _syncCatalogUnitAfterIncrease(Product? product, int index) {
    final selectedUnitLabel = selectedUnits[index] ?? '';
    final currentQty = quantities[index] ?? 1;
    final unitMap = _buildUnitMap(product);

    if (selectedUnitLabel.isEmpty || unitMap.isEmpty) return;

    if (selectedUnitLabel.contains("Mini Pack")) {
      final innerEntry = _findUnitEntry(unitMap, "Inner");
      if (innerEntry != null) {
        selectedUnits[index] = innerEntry.key;
        quantities[index] = 1;
        return;
      }

      final cartonEntry = _findUnitEntry(unitMap, "Carton");
      if (cartonEntry != null) {
        selectedUnits[index] = cartonEntry.key;
        quantities[index] = 1;
      }
      return;
    }

    if (selectedUnitLabel.contains("Inner")) {
      final innerSize = _extractUnitSize(selectedUnitLabel);
      final cartonEntry = _findUnitEntry(unitMap, "Carton");

      if (innerSize > 0 && cartonEntry != null) {
        final totalUnits = innerSize * currentQty;
        if (totalUnits >= cartonEntry.value) {
          selectedUnits[index] = cartonEntry.key;
          quantities[index] =
              (totalUnits ~/ cartonEntry.value).clamp(1, 999999);
          return;
        }
      }
    }

    final unitSize = _extractUnitSize(selectedUnitLabel);
    final totalUnits = unitSize * currentQty;
    final newUnit = _getUnitFromTotalUnits(totalUnits, unitMap);

    if (newUnit != selectedUnits[index]) {
      selectedUnits[index] = newUnit;

      final newUnitSize = _extractUnitSize(newUnit);
      quantities[index] = (totalUnits / newUnitSize).ceil();
    }
  }

  String _getUnitFromTotalUnits(int totalUnits, Map<String, int> unitMap) {
    final sorted = unitMap.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    String selected = sorted.first.key;

    for (final unit in sorted) {
      if (totalUnits % unit.value == 0) {
        selected = unit.key;
      }
    }

    return selected;
  }

  @override
  Widget build(BuildContext context) {
    print("defgrtghtyh${widget?.byDefultSelected}");
    return Container(
      child: ListView.builder(
        controller: widget.controller,
        shrinkWrap: true,
        itemCount: (widget.products?.length ?? 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.products?.length) {
            return const Padding(
              padding:
                  EdgeInsets.only(top: AppSizes.size4, bottom: AppSizes.size4),
              child: Center(
                child: SizedBox(
                  width: AppSizes.size30,
                  height: AppSizes.size30,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                  ),
                ),
              ),
            );
          }

          var product = widget.products?[index];
          PrefetchService.preFetchProductDetails(product?.productId ?? '');

          // Dynamically build unitOptions from API fields (only if not empty)
          final Map<String, String> rawUnitMap = {
            'Mini Pack': product?.miniPack ?? '',
            'Carton': product?.carton ?? '',
            'Inner': product?.inner ?? '',
          };

          // Label: Mini Pack (6), Carton (24), etc.
          final Map<String, String> unitMap = {};
          rawUnitMap.forEach((label, value) {
            if (value.trim().isNotEmpty) {
              print("djfghyhj$value");
              print("djfghyhj$label");
              unitMap['$label (${value.trim()})'] = label;
            }
          });

          final List<String> unitOptions = unitMap.keys.toList();
          final List<String> unitOptionsValue = unitMap.values.toList();
          String pickDefaultUnit(List<String> options) {
            if (options.isEmpty) return '';
            String capitalize(String s) {
              if (s.isEmpty) return s;
              return s[0].toUpperCase() + s.substring(1).toLowerCase();
            }

            final defaultUnit = capitalize((product?.inner?.isNotEmpty == true)
                ? "${widget?.byDefultSelected ?? ""}"
                : "Carton");
            //final defaultUnit = capitalize(widget.byDefultSelected ?? '');

            final cartonIdx =
                options.indexWhere((u) => u.startsWith(defaultUnit));
            return cartonIdx != -1 ? options[cartonIdx] : options.first;
          }

          selectedUnits[index] =
              selectedUnits[index] ?? pickDefaultUnit(unitOptions);

          // Set default unit and matched price
          final defaultUnit = selectedUnits[index]!;
          final defaultMatch = RegExp(r'\((\d+)\)').firstMatch(defaultUnit);
          final defaultQuantity =
              int.tryParse(defaultMatch?.group(1) ?? '') ?? 1;
          // quantities[index] = defaultQuantity;
          quantities[index] = quantities[index] ?? 1; //

          String? matchedPrice;
          if (product?.discounts != null) {
            for (var discount in product!.discounts!) {
              if (discount.quantity?.trim() == defaultQuantity.toString()) {
                print("price-------${discount.price}");
                print("discounts${product?.discounts}");
                print("quantity${discount.quantity}");
                matchedPrice = discount.price;
                break;
              }
            }
          }
          matchedPrices[index] = matchedPrice ??
              ((product?.price != false) ? product?.price ?? '' : "");

          // Set default unit if not already set
          final productPriceDouble = double.tryParse(
                matchedPrices[index].toString().replaceAll("£", "").trim() ??
                    '0',
              ) ??
              0.0;
// 1. Extract unit count from selected unit
          final selectedUnitLabel = selectedUnits[index] ?? '';
          final unitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnitLabel);
          final unitValueInt = int.tryParse(unitMatch?.group(1) ?? '') ?? 1;

// 2. Get quantity and calculate total units
          final quantity = quantities[index] ?? 1;
          final totalUnits = unitValueInt * quantity;

// 3. Get discount list
          final discounts = product?.discounts ?? [];

// 4. Find the best match from discount: exact or nearest lower
          double unitPrice = productPriceDouble; // fallback to original
          if (discounts.isNotEmpty) {
            List<Map<String, dynamic>> parsedDiscounts = discounts
                .where((d) => int.tryParse(d.quantity ?? '') != null)
                .map((d) => {
                      'quantity': int.parse(d.quantity!),
                      'price': double.tryParse(
                          d.price?.replaceAll("£", "").trim() ?? '')
                    })
                .where((d) => d['price'] != null)
                .toList();

            // Sort by quantity ascending
            parsedDiscounts.sort((a, b) =>
                (a['quantity'] as int).compareTo(b['quantity'] as int));

            // Find the largest quantity less than or equal to totalUnits
            for (var discount in parsedDiscounts.reversed) {
              if ((discount['quantity'] as int) <= totalUnits) {
                unitPrice = discount['price'];
                break;
              }
            }
          }

// 5. Calculate total amount
          final calculatedTotalAmount = unitPrice * totalUnits;
          final calculatedDisplayPrice = "£${totalUnits}";
          print("defghjukilo-----${calculatedDisplayPrice}");
          Map<String, dynamic>? matchedDiscount;

          if (discounts.isNotEmpty) {
            List<Map<String, dynamic>> parsedDiscounts = discounts
                .where((d) => int.tryParse(d.quantity ?? '') != null)
                .map((d) => {
                      'quantity': int.parse(d.quantity!),
                      'price': d.price ?? '',
                    })
                .toList();

            parsedDiscounts.sort((a, b) =>
                (a['quantity'] as int).compareTo(b['quantity'] as int));

            for (var discount in parsedDiscounts.reversed) {
              if ((discount['quantity'] as int) <= totalUnits) {
                matchedDiscount = discount;
                break;
              }
            }
          }

          Color _getStockColor(product) {
            int quantity = int.tryParse(product?.quantity ?? "0") ?? 0;
            int carton = int.tryParse(product?.carton ?? "0") ?? 0;

            // 1. Out of Stock → RED
            if (quantity == 0) {
              return const Color(0xFFE7000B);
            }

            // 2. Low Stock (carton * 10 <= quantity) → ORANGE
            if ((carton * 10) > quantity) {
              return const Color(0xFFFFA500); // Orange
            }

            // 3. In Stock → GREEN
            return const Color(0xFF00BC7D);
          }

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: const Border(
                bottom: BorderSide(
                  color: AppColors.dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoute.productPage,
                      arguments: getProductDataAttributeMap(
                        product?.name ?? "",
                        product?.productId ?? "",
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.size8, horizontal: AppSizes.size8),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: AppSizes.size8),
                          padding: const EdgeInsets.all(AppSizes.size4),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: AppSizes.size1,
                            ),
                          ),
                          child: ImageView(
                            url: product?.thumb ?? '',
                            height: AppSizes.size88,
                            width: AppSizes.size88,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: AppSizes.size10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: AppSizes.size4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product?.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: AppSizes.size10),
                              Row(
                                children: [
                                  if (product?.price != false)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStockColor(product),
                                        //color:  product?.quantity=="0"?const Color(0xFFE7000B):const Color(0xFF00BC7D),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        product?.quantity == "0"
                                            ? (product?.expected == ""
                                                ? "Out Of Stock"
                                                : product?.expected ?? "")
                                            : (((int.tryParse(product?.carton ??
                                                                "0") ??
                                                            0) *
                                                        10 >
                                                    (int.tryParse(
                                                            product?.quantity ??
                                                                "0") ??
                                                        0))
                                                ? "Low Stock"
                                                : product?.quantity == "0"
                                                    ? "Out Of Stock"
                                                    : "In Stock"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                      ),
                                    ),
                                  if (product?.price != false)
                                    const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      product?.model ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  if (ProductStatusBadges.shouldShowBought(
                                      product?.bought))
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: AppSizes.size6),
                                      child: ProductBoughtBadge(),
                                    ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.size10),
                              product?.price != false
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: AppSizes.size4),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            flex: 2,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    matchedDiscount != null
                                                        ? "${matchedDiscount['price']}"
                                                        : (matchedPrices[
                                                                index] ??
                                                            product?.price ??
                                                            ""),
                                                    // "${matchedPrices[index] ?? product?.price ?? ""}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      decoration: product
                                                                      ?.special ==
                                                                  null ||
                                                              product?.special ==
                                                                  0
                                                          ? TextDecoration.none
                                                          : TextDecoration
                                                              .lineThrough,
                                                      fontSize: AppSizes.size14,
                                                      fontWeight: (product
                                                                      ?.special !=
                                                                  null &&
                                                              (product?.special ??
                                                                      0) >
                                                                  0)
                                                          ? FontWeight.w400
                                                          : FontWeight.w700,
                                                      color: (product?.special !=
                                                                  null &&
                                                              (product?.special ??
                                                                      0) >
                                                                  0)
                                                          ? AppColors.darkGray
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.color,
                                                    ),
                                                  ),
                                                ),
                                                widgetSpace(1, AppSizes.size4),
                                                Flexible(
                                                  child: Text(
                                                    widget.localizations
                                                            ?.translate(
                                                                AppStringConstant
                                                                    .perItem) ??
                                                        '',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          widgetSpace(1, AppSizes.size1),
                                          if (product?.special != null &&
                                              (product?.special ?? 0) > 0)
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                "${product?.formattedSpecial}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                              ),
                                            ),
                                          Flexible(
                                            flex: 2,
                                            child: Text(
                                              "${unitValueInt} Unit of Sale",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Visibility(
                                visible: ((product?.rating ?? 0) > 0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: List.generate(
                                      5,
                                      (i) => _buildStar(
                                          context, i, (product?.rating ?? 0)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (unitOptions.isNotEmpty && product?.price != false)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: UnitDropdown(
                            units: unitOptions,
                            selectedUnit: selectedUnits[index] ?? '',
                            onChanged: (newUnit) {
                              setState(() {
                                selectedUnits[index] = newUnit!;

                                // Extract numeric unit value
                                final unitMatch =
                                    RegExp(r'\((\d+)\)').firstMatch(newUnit);
                                final unitValueInt =
                                    int.tryParse(unitMatch?.group(1) ?? '') ??
                                        1;

                                // Update isMiniPack flag
                                final unitLabel = newUnit.split(' (').first;
                                isMiniPackSelected[index] =
                                    unitLabel == 'Mini Pack';

                                // Reset quantity to 1 when user explicitly selects a unit
                                quantities[index] = 1;
                                print(
                                    "Changed unit to: $newUnit, quantity reset to 1");
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: QuantitySelector(
                            key: ValueKey(
                                'quantity_${quantities[index]}_$index'),
                            quantity: quantities[index] ?? 1,
                            enabled: true,
                            labelTrailing: ValueListenableBuilder<Set<String>>(
                              valueListenable:
                                  ProductCartStatusController.addedProductIds,
                              builder: (context, addedProductIds, _) {
                                if (!ProductCartStatusController.isAdded(
                                  product?.productId,
                                  product?.isCartAdded,
                                  addedProductIds,
                                )) {
                                  return const SizedBox.shrink();
                                }

                                return const ProductAddedBadge();
                              },
                            ),
                            onIncrement: () {
                              setState(() {
                                quantities[index] =
                                    (quantities[index] ?? 1) + 1;
                                _syncCatalogUnitAfterIncrease(product, index);
                              });
                            },

                            onDecrement: () {
                              setState(() {
                                final currentQty = quantities[index] ?? 1;
                                final selectedUnitLabel = selectedUnits[index]!;

                                int safeParse(String? v) =>
                                    int.tryParse(v ?? "") ?? 0;

                                // Build unit map
                                Map<String, int> getUnitMap(Product? product) {
                                  return {
                                    if (safeParse(product?.miniPack) > 0)
                                      "Mini Pack (${product!.miniPack})":
                                          safeParse(product!.miniPack),
                                    if (safeParse(product?.inner) > 0)
                                      "Inner (${product!.inner})":
                                          safeParse(product!.inner),
                                    if (safeParse(product?.carton) > 0)
                                      "Carton (${product!.carton})":
                                          safeParse(product!.carton),
                                  };
                                }

                                final unitMap = getUnitMap(product);

                                // 🔥 Mini Pack → no decrement
                                if (selectedUnitLabel.contains("Mini Pack")) {
                                  return;
                                }

                                // Special handling if qty = 1 → switch unit down
                                if (currentQty == 1) {
                                  // INNER without mini pack should stay on inner.
                                  // Avoid falling through to qty 0, which later resolves to carton.
                                  if (selectedUnitLabel.contains("Inner") &&
                                      !unitMap.keys.any(
                                          (e) => e.contains("Mini Pack"))) {
                                    quantities[index] = 1;
                                    return;
                                  }

                                  // CARTON → INNER
                                  if (selectedUnitLabel.contains("Carton") &&
                                      unitMap.keys
                                          .any((e) => e.contains("Inner"))) {
                                    final cartonMatch = RegExp(r'\((\d+)\)')
                                        .firstMatch(selectedUnitLabel);
                                    final cartonSize =
                                        safeParse(cartonMatch?.group(1));

                                    final innerEntry = unitMap.entries
                                        .firstWhere(
                                            (e) => e.key.contains("Inner"));
                                    final innerSize = innerEntry.value;

                                    final totalUnits = cartonSize * currentQty;
                                    final convertedQty =
                                        (totalUnits / innerSize).floor();

                                    // Rule: subtract 1 because 1 carton removed
                                    final finalQty =
                                        (convertedQty - 1).clamp(1, 999999);

                                    selectedUnits[index] = "Inner ($innerSize)";
                                    quantities[index] = finalQty;
                                    return;
                                  }

                                  // CARTON → MINI PACK fallback
                                  if (selectedUnitLabel.contains("Carton") &&
                                      unitMap.keys.any(
                                          (e) => e.contains("Mini Pack"))) {
                                    final miniEntry = unitMap.entries
                                        .firstWhere(
                                            (e) => e.key.contains("Mini Pack"));
                                    selectedUnits[index] = miniEntry.key;
                                    quantities[index] = 1;
                                    return;
                                  }

                                  // INNER → MINI PACK
                                  if (selectedUnitLabel.contains("Inner") &&
                                      unitMap.keys.any(
                                          (e) => e.contains("Mini Pack"))) {
                                    final miniEntry = unitMap.entries
                                        .firstWhere(
                                            (e) => e.key.contains("Mini Pack"));
                                    selectedUnits[index] = miniEntry.key;
                                    quantities[index] = 1;
                                    return;
                                  }

                                  // No smaller unit available, so keep current selection stable.
                                  quantities[index] = 1;
                                  return;
                                }

                                // Normal decrement (qty > 1)
                                quantities[index] = currentQty - 1;

                                final match = RegExp(r'\((\d+)\)')
                                    .firstMatch(selectedUnitLabel);
                                final unitSize = safeParse(match?.group(1));
                                final totalUnits =
                                    unitSize * quantities[index]!;

                                final newUnit =
                                    _getUnitFromTotalUnits(totalUnits, unitMap);

                                if (newUnit != selectedUnits[index]) {
                                  selectedUnits[index] = newUnit;

                                  final newMatch =
                                      RegExp(r'\((\d+)\)').firstMatch(newUnit);
                                  final newUnitSize =
                                      safeParse(newMatch?.group(1));

                                  quantities[index] = (totalUnits / newUnitSize)
                                      .floor()
                                      .clamp(1, 999999);
                                }
                              });
                            },

                            // onQuantityChanged: (newQty) {
                            //   setState(() {
                            //     quantities[index] = newQty;
                            //   });
                            // },
                            onQuantityChanged: (newQty) {
                              setState(() {
                                // Update entered qty
                                quantities[index] = newQty;

                                final productItem = product;

                                int miniPack = int.tryParse(
                                        productItem?.miniPack ?? '0') ??
                                    0;
                                int inner =
                                    int.tryParse(productItem?.inner ?? '0') ??
                                        0;
                                int carton =
                                    int.tryParse(productItem?.carton ?? '0') ??
                                        0;

                                final selectedUnitLabel =
                                    selectedUnits[index] ?? '';

                                // Extract numeric unit size from label
                                final match = RegExp(r'\((\d+)\)')
                                    .firstMatch(selectedUnitLabel);
                                final currentUnitSize =
                                    int.tryParse(match?.group(1) ?? '') ?? 1;

                                // ---------------------------------------------------------
                                // RULE 1: MINI PACK → allow free manual input, no logic
                                // ---------------------------------------------------------
                                if (selectedUnitLabel.contains("Mini Pack")) {
                                  if (miniPack > 0 && inner > 0) {
                                    final totalUnits = newQty * inner;

                                    // If totalUnits reach carton threshold → convert to carton
                                    if (totalUnits >= carton) {
                                      final newCartonQty =
                                          (totalUnits ~/ carton);

                                      selectedUnits[index] = "Inner ($inner)";
                                      quantities[index] = 1;
                                      return;
                                    }
                                  }

                                  // Regular inner logic → keep inner
                                  quantities[index] = newQty;
                                  return;
                                }

                                // ---------------------------------------------------------
                                // RULE 2: CARTON → never downgrade / auto-change unit
                                // ---------------------------------------------------------
                                if (selectedUnitLabel.contains("Carton")) {
                                  // Keep carton always
                                  print("Ajay Carton");
                                  quantities[index] = newQty;
                                  return;
                                }

                                // ---------------------------------------------------------
                                // RULE 3: INNER → apply special logic
                                // ---------------------------------------------------------
                                if (selectedUnitLabel.contains("Inner")) {
                                  print("Ajay Inner");
                                  if (inner > 0 && carton > 0) {
                                    final totalUnits = newQty * inner;

                                    // If totalUnits reach carton threshold → convert to carton
                                    if (totalUnits >= carton) {
                                      final newCartonQty =
                                          (totalUnits ~/ carton);

                                      selectedUnits[index] = "Carton ($carton)";
                                      quantities[index] =
                                          newCartonQty.clamp(1, 999999);
                                      return;
                                    }
                                  }

                                  // Regular inner logic → keep inner
                                  quantities[index] = newQty;
                                  return;
                                }

                                // ---------------------------------------------------------
                                // DEFAULT fallback
                                // ---------------------------------------------------------
                                quantities[index] = newQty;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (product?.price != false)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: AppSizes.size20, horizontal: AppSizes.size8),
                    child: AddToBasketAndSubtotalpriceCard(
                      localizations: widget.localizations,
                      totalAmount: calculatedTotalAmount,
                      quantity: totalUnits,
                      product: product,
                      onAddToBasket: () {
                        product?.quantity == "0"
                            ? widget.bloc?.add(AddToWishlistEvent(
                                "${product?.productId ?? 0}",
                                "$quantity",
                                "$unitValueInt"))
                            : widget.bloc?.add(AddProductToCartEvent(
                                "${product?.productId ?? ""}",
                                "$quantity",
                                "",
                                "$unitValueInt"));
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStar(BuildContext context, int index, int rating) {
    return Icon(
      rating > index ? Icons.star : Icons.star_border,
      color: AppColors.yellow,
      size: 16.0,
    );
  }
}
