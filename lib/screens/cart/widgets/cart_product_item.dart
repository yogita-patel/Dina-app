import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';

import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/quantity_selector.dart';
import '../../../common_widgets/unit_dropdown.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../main.dart';
import '../../../models/cart/cart_model.dart';
import '../cart_popup_logic.dart';

class CartProductItem extends StatefulWidget {
  const CartProductItem(
      this.product,
      this.localizations,
      this.bloc,
      this.quantity,
      this.onUpdateClick,
      this.onDeleteClick,
      this.onBackorderClick,
      this.onUnitSaleChange,
      this.indexValue,
      {this.isLastItem = false,
      this.forceShowBackorderButton = false,
      super.key});

  final void Function()? onUpdateClick;
  final void Function()? onDeleteClick;
  final void Function()? onBackorderClick;
  final void Function(int index)? onUnitSaleChange;
  final int indexValue;
  final Products? product;
  final AppLocalizations? localizations;
  final dynamic bloc;
  final int quantity;
  final bool isLastItem;
  final bool forceShowBackorderButton;

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  late int quantity;
  late String selectedUnit;
  double totalPrice = 0.0;
  List<String> unitOptions = [];
  int unitValueInt = 1;

  @override
  void initState() {
    super.initState();
    print("This is running");
    final productQty = int.tryParse(widget.product?.quantity ?? '0') ?? 0;
    final unitOfSale = int.tryParse(widget.product?.UnitofSalenew ?? '1') ?? 1;

    // Popup receives the same product object already normalized by the cart row,
    // so avoid converting the display quantity a second time.
    quantity = cartItemDisplayQuantity(
      productQty: productQty,
      unitOfSale: unitOfSale,
      preserveDisplayQuantity: widget.forceShowBackorderButton,
    );

    //quantity = productQty > unitOfSale ? unitOfSale > 0 ? (productQty ~/ unitOfSale) : productQty : 1 ;

    selectedUnit = widget.product?.UnitofSalenew ?? '';
    _initUnitOptions();
    _updateTotalPrice();
  }

  void _initUnitOptions() {
    final rawUnitMap = {
      'Mini Pack': widget.product?.miniPack ?? '',
      'Carton': widget.product?.carton ?? '',
      'Inner': widget.product?.inner ?? '',
    };

    final Map<String, String> unitMap = {};
    rawUnitMap.forEach((label, value) {
      if (value.trim().isNotEmpty) {
        unitMap['$label (${value.trim()})'] = label;
      }
    });

    unitOptions = unitMap.keys.toList();

    // Match using UnitofSalenew value (like "12") against actual values (like carton = 12)
    String? unitOfSaleValue = widget.product?.UnitofSalenew?.trim();

    String matchedKey = '';
    rawUnitMap.forEach((label, value) {
      if (value.trim() == unitOfSaleValue) {
        matchedKey = '$label (${value.trim()})';
      }
    });

    if (unitOptions.contains(matchedKey)) {
      selectedUnit = matchedKey;
    } else if (unitOptions.isNotEmpty) {
      selectedUnit = unitOptions.first;
    }

    final unitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
    unitValueInt = int.tryParse(unitMatch?.group(1) ?? '') ?? 1;
  }

  void _updateTotalPrice() {
    final cleanUnitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
    final selectedUnitValue = int.tryParse(cleanUnitMatch?.group(1) ?? '') ?? 1;
    final totalUnits = selectedUnitValue * quantity;

    double? unitPrice = double.tryParse(
          (widget.product?.price ?? '').replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;

    final discounts = widget.product?.discounts ?? [];

    final List<Map<String, dynamic>> parsedDiscounts = discounts
        .where((d) => int.tryParse(d.quantity ?? '') != null)
        .map((d) => {
              'quantity': int.parse(d.quantity!),
              'price':
                  double.tryParse(d.price?.replaceAll("£", "").trim() ?? '') ??
                      0.0,
            })
        .toList();

    parsedDiscounts
        .sort((a, b) => (a['quantity'] as int).compareTo(b['quantity'] as int));

    for (var discount in parsedDiscounts.reversed) {
      if ((discount['quantity'] as int) <= totalUnits) {
        unitPrice = discount['price'] as double;
        break;
      }
    }

    setState(() {
      totalPrice = (unitPrice ?? 0.0) * totalUnits;
    });
  }

  void _syncUnitWithTotalUnits() {
    // Parse sizes from unitOptions labels like 'Carton (24)'
    final Map<String, int> labelToSize = {};
    for (var label in unitOptions) {
      final m = RegExp(r'\((\d+)\)').firstMatch(label);
      final size = int.tryParse(m?.group(1) ?? '') ?? 0;
      labelToSize[label] = size;
    }
    print("sdgdfgfdgfg");
    if (labelToSize.isEmpty) return;
    print("547567567567fttyy");
    // Current total items (individual units)
    final currentTotalItems = quantity * unitValueInt;

    // Find the best unit: largest size <= currentTotalItems
    String bestLabel = unitOptions.first;
    int bestSize = labelToSize[bestLabel] ?? 1;

    for (var entry in labelToSize.entries) {
      final lbl = entry.key;
      final sz = entry.value;
      if (sz <= currentTotalItems && sz > bestSize) {
        bestLabel = lbl;
        bestSize = sz;
      }
    }
    print("sdfgsdfefdfdfdsf");
    // If no unit size is <= currentTotalItems, pick the smallest size
    if (bestSize == 0 || bestSize > currentTotalItems) {
      // find smallest
      final smallest = labelToSize.values.where((v) => v > 0).fold<int?>(
          null, (prev, v) => prev == null ? v : (v < prev ? v : prev));
      if (smallest != null) {
        bestSize = smallest;
        bestLabel =
            labelToSize.entries.firstWhere((e) => e.value == smallest).key;
      }
    }
    print("sdgrdgdfggweer");
    print(bestLabel);
    print(selectedUnit);
    // If the bestLabel is different from selectedUnit, update selectedUnit and adjust quantity
    if (bestLabel != selectedUnit) {
      print("sdfgsargwergfsdfqwfdsf");
      final newUnitSize = bestSize > 0 ? bestSize : 1;

      final newQuantity = (currentTotalItems ~/ newUnitSize).clamp(1, 999999);

      setState(() {
        selectedUnit = bestLabel;
        unitValueInt = newUnitSize;
        quantity = newQuantity;

        // 🔥 MAIN FIX: Update the product object ALSO
        widget.product?.UnitofSalenew = unitValueInt.toString();

        print("rgrgggfdgfg");
        print(widget.product?.UnitofSalenew);
      });
    } else if (bestLabel == selectedUnit) {
      print("sdfgsargwergfsdfqwfdsf");
      final newUnitSize = bestSize > 0 ? bestSize : 1;

      final newQuantity = (currentTotalItems ~/ newUnitSize).clamp(1, 999999);

      setState(() {
        selectedUnit = bestLabel;
        unitValueInt = newUnitSize;
        quantity = newQuantity;

        // 🔥 MAIN FIX: Update the product object ALSO
        widget.product?.UnitofSalenew = unitValueInt.toString();

        print("rgrgggfdgfg");
        print(widget.product?.UnitofSalenew);
      });
    }
  }

  void _onQuantityChanged(int newQty) {
    quantity = newQty;

    final miniPack = int.tryParse(widget.product?.miniPack ?? '0') ?? 0;
    final inner = int.tryParse(widget.product?.inner ?? '0') ?? 0;
    final carton = int.tryParse(widget.product?.carton ?? '0') ?? 0;

    // ---------------------------------------------------
    // CASE 1 : Selected Unit is MINI PACK → NO RULES
    // ---------------------------------------------------
    if (selectedUnit.contains("Mini Pack")) {
      print("Ajay Mini Pack");
      _syncUnitWithTotalUnits();
      _updateTotalPrice();
      return;
    }

    // ---------------------------------------------------
    // CASE 2 : Selected Unit is CARTON → NO AUTO CHANGE
    // ---------------------------------------------------

    // ---------------------------------------------------
    // CASE 3 : Selected Unit is INNER → apply rule
    // ---------------------------------------------------
    if (selectedUnit.contains("Inner")) {
      print("Ajay Inner");
      if (inner > 0 && carton > 0) {
        final totalUnits = newQty * inner;

        // If totalUnits >= carton size → move to carton
        if (totalUnits >= carton) {
          final newCartonQty = (totalUnits ~/ carton);

          setState(() {
            selectedUnit = "Carton ($carton)";
            unitValueInt = carton;
            quantity = 1;
            widget.product?.UnitofSalenew = carton.toString();
          });

          _updateTotalPrice();
          return;
        }
      }

      // Inner allowed as normal (if not exceeding carton)
      unitValueInt = inner;
      widget.product?.UnitofSalenew = inner.toString();
      _updateTotalPrice();
      return;
    }

    if (selectedUnit.contains("Carton")) {
      print("Ajay Carton$totalPrice");
      // Keep Carton as unit always
      unitValueInt = carton;
      widget.product?.UnitofSalenew = carton.toString();
      quantity = newQty;
      _updateTotalPrice();
      return;
    }

    // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    widget.product?.quantity = quantity.toString();
    final product = widget.product;
    final localizations = widget.localizations;
    final isPopupLayout = widget.forceShowBackorderButton;
    final compactTitleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: isPopupLayout ? 14 : null,
          fontWeight: FontWeight.w400,
        );
    final compactStrongStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: isPopupLayout ? 14 : null,
          fontWeight: FontWeight.w600,
        );
    final productImageSize = isPopupLayout ? 72.0 : AppSizes.size88;
    final horizontalPadding = isPopupLayout ? AppSizes.size8 : AppSizes.size12;
    final controlGap = isPopupLayout ? AppSizes.size8 : 16.0;
    print("ejfedv${product?.UnitofSalenew ?? ''}");
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.size12, vertical: AppSizes.size8)
                .copyWith(
              left: horizontalPadding,
              right: horizontalPadding,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoute.productPage,
                  arguments: getProductDataAttributeMap(
                    product?.name ?? "",
                    product?.productId ?? "",
                  ),
                );
              },
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.size8),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.size4),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.shade300, width: AppSizes.size1),
                      ),
                      child: ImageView(
                        url: product?.thumb ?? '',
                        height: productImageSize,
                        width: productImageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.size10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.size4),
                          child: Text(
                            product?.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: isPopupLayout ? 1 : 2,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontSize: isPopupLayout ? 14 : null,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        const SizedBox(height: AppSizes.size10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  //color: (product?.stock ?? false)? Color(0xFF00C48C):const Color(0xFFE7000B),
                                  color: (product?.stock ?? false)
                                      ? (((int.tryParse(product?.carton ??
                                                          "0") ??
                                                      0) *
                                                  10 >
                                              (int.tryParse(
                                                      product?.totalQuantity ??
                                                          "0") ??
                                                  0))
                                          ? const Color(0xFFFFA500)
                                          : product?.totalQuantity == "0"
                                              ? const Color(0xFFE7000B)
                                              : const Color(0xFF00C48C))
                                      : const Color(0xFFE7000B),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                  (product?.stock ?? false)
                                      ? (((int.tryParse(product?.carton ??
                                                          "0") ??
                                                      0) *
                                                  10 >
                                              (int.tryParse(
                                                      product?.totalQuantity ??
                                                          "0") ??
                                                  0))
                                          ? "Low Stock"
                                          : product?.totalQuantity == "0"
                                              ? "Out Of Stock"
                                              : "In Stock")
                                      :
                                      //localizations?.translate(AppStringConstant.inStock) ?? '' :
                                      localizations?.translate(
                                              AppStringConstant.outStock) ??
                                          '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontSize: isPopupLayout ? 12 : null,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(product?.model ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontSize: isPopupLayout ? 14 : null,
                                          fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSizes.size10),
                        if (product?.price != false)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.size4),
                            child: Row(
                              children: [
                                Text("${product?.price ?? ""}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall
                                        ?.copyWith(
                                            fontSize:
                                                isPopupLayout ? 17 : null)),
                                widgetSpace(1, AppSizes.size8),
                                Expanded(
                                  child: Text(
                                      localizations?.translate(
                                              AppStringConstant.perItem) ??
                                          '',
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontSize:
                                                  isPopupLayout ? 14 : null,
                                              fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Flex(
              direction: isPopupLayout ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: isPopupLayout
                  ? CrossAxisAlignment.stretch
                  : CrossAxisAlignment.center,
              children: <Widget>[
                isPopupLayout
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                                titleLarge: compactTitleStyle,
                              ),
                        ),
                        child: UnitDropdown(
                          // key: Key(selectedUnit),
                          units: unitOptions,
                          selectedUnit: selectedUnit,
                          onChanged: (newUnit) {
                            // widget.onUnitSaleChange!(widget.indexValue);
                            cartActionDisableToQuote = true;
                            Future.delayed(const Duration(seconds: 1), () {
                              print("dcfddvfdvv..............1");
                              cartActionDisableToQuote = false;
                            });
                            setState(() {
                              print("dcfddvfdvv..............");

                              selectedUnit = newUnit ?? "";

                              quantity = 1;
                              widget.product?.quantity = quantity.toString();
                              widget.product?.UnitofSalenew =
                                  selectedUnit.toString();

                              final unitMatch =
                                  RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
                              unitValueInt =
                                  int.tryParse(unitMatch?.group(1) ?? '') ?? 1;
                              widget.product?.UnitofSalenew =
                                  unitValueInt.toString();
                              _updateTotalPrice();
                            });
                          },
                        ),
                      )
                    : Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.copyWith(
                                  titleLarge: compactTitleStyle,
                                ),
                          ),
                          child: UnitDropdown(
                            // key: Key(selectedUnit),
                            units: unitOptions,
                            selectedUnit: selectedUnit,
                            onChanged: (newUnit) {
                              // widget.onUnitSaleChange!(widget.indexValue);
                              cartActionDisableToQuote = true;
                              Future.delayed(const Duration(seconds: 1), () {
                                print("dcfddvfdvv..............1");
                                cartActionDisableToQuote = false;
                              });
                              setState(() {
                                print("dcfddvfdvv..............");

                                selectedUnit = newUnit ?? "";

                                quantity = 1;
                                widget.product?.quantity = quantity.toString();
                                widget.product?.UnitofSalenew =
                                    selectedUnit.toString();

                                final unitMatch = RegExp(r'\((\d+)\)')
                                    .firstMatch(selectedUnit);
                                unitValueInt =
                                    int.tryParse(unitMatch?.group(1) ?? '') ??
                                        1;
                                widget.product?.UnitofSalenew =
                                    unitValueInt.toString();
                                _updateTotalPrice();
                              });
                            },
                          ),
                        ),
                      ),
                SizedBox(
                  width: isPopupLayout ? 0 : controlGap,
                  height: isPopupLayout ? AppSizes.size10 : 0,
                ),
                isPopupLayout
                    ? Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: Theme.of(context).textTheme.copyWith(
                                titleLarge: compactTitleStyle,
                              ),
                        ),
                        child: QuantitySelector(
                          quantity: quantity,
                          // Allow manual input and increment/decrement even for Mini Pack
                          enabled: true,
                          // onIncrement: () {
                          //   setState(() {
                          //     quantity++;
                          //   });
                          //   _syncUnitWithTotalUnits();
                          //   _updateTotalPrice();
                          // },
                          onIncrement: () {
                            setState(() {
                              quantity++;
                            });

                            // ------------------------------
                            // 🔥 SPECIAL CASE: Mini Pack Logic
                            // ------------------------------
                            if (selectedUnit.contains("Mini Pack")) {
                              // Parse all unit sizes
                              final Map<String, int> labelToSize = {};
                              for (var label in unitOptions) {
                                final m =
                                    RegExp(r'\((\d+)\)').firstMatch(label);
                                final size =
                                    int.tryParse(m?.group(1) ?? '') ?? 0;
                                if (size > 0) labelToSize[label] = size;
                              }

                              // Move directly to Inner if available
                              if (labelToSize.keys
                                  .any((e) => e.contains("Inner"))) {
                                final entry = labelToSize.entries
                                    .firstWhere((e) => e.key.contains("Inner"));
                                setState(() {
                                  selectedUnit = entry.key;
                                  unitValueInt = entry.value;
                                  quantity = 1;
                                  widget.product?.UnitofSalenew = unitValueInt
                                      .toString(); // IMPORTANT: Reset to 1
                                });
                                _syncUnitWithTotalUnits();
                                _updateTotalPrice();
                                return;
                              }

                              // Else move to Carton
                              if (labelToSize.keys
                                  .any((e) => e.contains("Carton"))) {
                                final entry = labelToSize.entries.firstWhere(
                                    (e) => e.key.contains("Carton"));
                                setState(() {
                                  selectedUnit = entry.key;
                                  unitValueInt = entry.value;
                                  quantity = 1;
                                  widget.product?.UnitofSalenew =
                                      unitValueInt.toString();
                                });
                                _syncUnitWithTotalUnits();
                                print("selectedUnit---->>${selectedUnit}");
                                print("selectedUnit---->>${unitValueInt}");
                                _updateTotalPrice();
                                return;
                              }

                              // If no Inner/Carton, keep Mini Pack (rare case)
                              _syncUnitWithTotalUnits();
                              _updateTotalPrice();
                              return;
                            }

                            // ------------------------------
                            // Default logic (Inner / Carton)
                            // ------------------------------
                            _syncUnitWithTotalUnits();
                            _updateTotalPrice();
                          },
                          onDecrement: () {
                            if (selectedUnit.contains("Mini Pack")) {
                              return; // nothing should update
                            }
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                              _syncUnitWithTotalUnits();
                              _updateTotalPrice();
                            } else {
                              // quantity == 1: reduce overall total items by 1 and move to the appropriate smaller unit

                              // CARTON → MINI PACK (when INNER not available)
                              if (selectedUnit.contains("Carton")) {
                                final hasInner =
                                    unitOptions.any((e) => e.contains("Inner"));
                                final miniLabel = unitOptions.firstWhere(
                                  (e) => e.contains("Mini Pack"),
                                  orElse: () => "",
                                );

                                // If INNER not present but MINI PACK exists
                                if (!hasInner && miniLabel.isNotEmpty) {
                                  final m = RegExp(r'\((\d+)\)')
                                      .firstMatch(miniLabel);
                                  final miniSize =
                                      int.tryParse(m?.group(1) ?? '') ?? 1;

                                  setState(() {
                                    selectedUnit = miniLabel;
                                    unitValueInt = miniSize;
                                    quantity = 1; // ✅ force 1
                                  });

                                  _syncUnitWithTotalUnits();
                                  _updateTotalPrice();
                                  return; // STOP other logic
                                }
                              }

                              if (selectedUnit.contains("Inner")) {
                                final miniLabel = unitOptions.firstWhere(
                                  (e) => e.contains("Mini Pack"),
                                  orElse: () => "",
                                );

                                if (miniLabel.isNotEmpty) {
                                  final m = RegExp(r'\((\d+)\)')
                                      .firstMatch(miniLabel);
                                  final miniSize =
                                      int.tryParse(m?.group(1) ?? "") ?? 1;

                                  setState(() {
                                    selectedUnit = miniLabel; // Mini Pack
                                    unitValueInt = miniSize; // 6
                                    quantity = 1;
                                    widget.product?.UnitofSalenew =
                                        unitValueInt.toString(); // always 1
                                  });
                                  _syncUnitWithTotalUnits();
                                  _updateTotalPrice();
                                  return; // STOP other logic
                                }
                              }
                              final currentTotalItems = quantity * unitValueInt;
                              final newTotalItems = currentTotalItems - 1;

                              if (newTotalItems <= 0) {
                                // nothing to decrement below 1 total item
                                return;
                              }

                              // Build map of label -> size
                              final Map<String, int> labelToSize = {};
                              for (var label in unitOptions) {
                                final m =
                                    RegExp(r'\((\d+)\)').firstMatch(label);
                                final size =
                                    int.tryParse(m?.group(1) ?? '') ?? 0;
                                if (size > 0) labelToSize[label] = size;
                              }

                              if (labelToSize.isEmpty) return;

                              // Find the largest size that is <= newTotalItems
                              final eligible = labelToSize.entries
                                  .where((e) => e.value <= newTotalItems)
                                  .toList();

                              String targetLabel;
                              int targetSize;

                              if (eligible.isNotEmpty) {
                                eligible
                                    .sort((a, b) => b.value.compareTo(a.value));
                                targetLabel = eligible.first.key;
                                targetSize = eligible.first.value;
                              } else {
                                // no eligible size <= newTotalItems: pick the smallest available size
                                final smallest = labelToSize.entries.reduce(
                                    (a, b) => a.value < b.value ? a : b);
                                targetLabel = smallest.key;
                                targetSize = smallest.value;
                              }

                              final computedQuantity =
                                  (newTotalItems ~/ targetSize);
                              final newQuantity =
                                  computedQuantity >= 1 ? computedQuantity : 1;

                              setState(() {
                                selectedUnit = targetLabel;
                                unitValueInt = targetSize;
                                quantity = newQuantity;
                                widget.product?.UnitofSalenew =
                                    unitValueInt.toString();
                              });
                              _syncUnitWithTotalUnits();
                              _updateTotalPrice();
                            }
                          },
                          onQuantityChanged: (newQty) {
                            _onQuantityChanged(newQty);
                          },
                        ),
                      )
                    : Expanded(
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: Theme.of(context).textTheme.copyWith(
                                  titleLarge: compactTitleStyle,
                                ),
                          ),
                          child: QuantitySelector(
                            quantity: quantity,
                            // Allow manual input and increment/decrement even for Mini Pack
                            enabled: true,
                            // onIncrement: () {
                            //   setState(() {
                            //     quantity++;
                            //   });
                            //   _syncUnitWithTotalUnits();
                            //   _updateTotalPrice();
                            // },
                            onIncrement: () {
                              setState(() {
                                quantity++;
                              });

                              // ------------------------------
                              // 🔥 SPECIAL CASE: Mini Pack Logic
                              // ------------------------------
                              if (selectedUnit.contains("Mini Pack")) {
                                // Parse all unit sizes
                                final Map<String, int> labelToSize = {};
                                for (var label in unitOptions) {
                                  final m =
                                      RegExp(r'\((\d+)\)').firstMatch(label);
                                  final size =
                                      int.tryParse(m?.group(1) ?? '') ?? 0;
                                  if (size > 0) labelToSize[label] = size;
                                }

                                // Move directly to Inner if available
                                if (labelToSize.keys
                                    .any((e) => e.contains("Inner"))) {
                                  final entry = labelToSize.entries.firstWhere(
                                      (e) => e.key.contains("Inner"));
                                  setState(() {
                                    selectedUnit = entry.key;
                                    unitValueInt = entry.value;
                                    quantity = 1;
                                    widget.product?.UnitofSalenew = unitValueInt
                                        .toString(); // IMPORTANT: Reset to 1
                                  });
                                  _syncUnitWithTotalUnits();
                                  _updateTotalPrice();
                                  return;
                                }

                                // Else move to Carton
                                if (labelToSize.keys
                                    .any((e) => e.contains("Carton"))) {
                                  final entry = labelToSize.entries.firstWhere(
                                      (e) => e.key.contains("Carton"));
                                  setState(() {
                                    selectedUnit = entry.key;
                                    unitValueInt = entry.value;
                                    quantity = 1;
                                    widget.product?.UnitofSalenew =
                                        unitValueInt.toString();
                                  });
                                  _syncUnitWithTotalUnits();
                                  print("selectedUnit---->>${selectedUnit}");
                                  print("selectedUnit---->>${unitValueInt}");
                                  _updateTotalPrice();
                                  return;
                                }

                                // If no Inner/Carton, keep Mini Pack (rare case)
                                _syncUnitWithTotalUnits();
                                _updateTotalPrice();
                                return;
                              }

                              // ------------------------------
                              // Default logic (Inner / Carton)
                              // ------------------------------
                              _syncUnitWithTotalUnits();
                              _updateTotalPrice();
                            },
                            onDecrement: () {
                              if (selectedUnit.contains("Mini Pack")) {
                                return; // nothing should update
                              }
                              if (quantity > 1) {
                                setState(() {
                                  quantity--;
                                });
                                _syncUnitWithTotalUnits();
                                _updateTotalPrice();
                              } else {
                                // quantity == 1: reduce overall total items by 1 and move to the appropriate smaller unit

                                // CARTON → MINI PACK (when INNER not available)
                                if (selectedUnit.contains("Carton")) {
                                  final hasInner = unitOptions
                                      .any((e) => e.contains("Inner"));
                                  final miniLabel = unitOptions.firstWhere(
                                    (e) => e.contains("Mini Pack"),
                                    orElse: () => "",
                                  );

                                  // If INNER not present but MINI PACK exists
                                  if (!hasInner && miniLabel.isNotEmpty) {
                                    final m = RegExp(r'\((\d+)\)')
                                        .firstMatch(miniLabel);
                                    final miniSize =
                                        int.tryParse(m?.group(1) ?? '') ?? 1;

                                    setState(() {
                                      selectedUnit = miniLabel;
                                      unitValueInt = miniSize;
                                      quantity = 1; // ✅ force 1
                                    });

                                    _syncUnitWithTotalUnits();
                                    _updateTotalPrice();
                                    return; // STOP other logic
                                  }
                                }

                                if (selectedUnit.contains("Inner")) {
                                  final miniLabel = unitOptions.firstWhere(
                                    (e) => e.contains("Mini Pack"),
                                    orElse: () => "",
                                  );

                                  if (miniLabel.isNotEmpty) {
                                    final m = RegExp(r'\((\d+)\)')
                                        .firstMatch(miniLabel);
                                    final miniSize =
                                        int.tryParse(m?.group(1) ?? "") ?? 1;

                                    setState(() {
                                      selectedUnit = miniLabel; // Mini Pack
                                      unitValueInt = miniSize; // 6
                                      quantity = 1;
                                      widget.product?.UnitofSalenew =
                                          unitValueInt.toString(); // always 1
                                    });
                                    _syncUnitWithTotalUnits();
                                    _updateTotalPrice();
                                    return; // STOP other logic
                                  }
                                }
                                final currentTotalItems =
                                    quantity * unitValueInt;
                                final newTotalItems = currentTotalItems - 1;

                                if (newTotalItems <= 0) {
                                  // nothing to decrement below 1 total item
                                  return;
                                }

                                // Build map of label -> size
                                final Map<String, int> labelToSize = {};
                                for (var label in unitOptions) {
                                  final m =
                                      RegExp(r'\((\d+)\)').firstMatch(label);
                                  final size =
                                      int.tryParse(m?.group(1) ?? '') ?? 0;
                                  if (size > 0) labelToSize[label] = size;
                                }

                                if (labelToSize.isEmpty) return;

                                // Find the largest size that is <= newTotalItems
                                final eligible = labelToSize.entries
                                    .where((e) => e.value <= newTotalItems)
                                    .toList();

                                String targetLabel;
                                int targetSize;

                                if (eligible.isNotEmpty) {
                                  eligible.sort(
                                      (a, b) => b.value.compareTo(a.value));
                                  targetLabel = eligible.first.key;
                                  targetSize = eligible.first.value;
                                } else {
                                  // no eligible size <= newTotalItems: pick the smallest available size
                                  final smallest = labelToSize.entries.reduce(
                                      (a, b) => a.value < b.value ? a : b);
                                  targetLabel = smallest.key;
                                  targetSize = smallest.value;
                                }

                                final computedQuantity =
                                    (newTotalItems ~/ targetSize);
                                final newQuantity = computedQuantity >= 1
                                    ? computedQuantity
                                    : 1;

                                setState(() {
                                  selectedUnit = targetLabel;
                                  unitValueInt = targetSize;
                                  quantity = newQuantity;
                                  widget.product?.UnitofSalenew =
                                      unitValueInt.toString();
                                });
                                _syncUnitWithTotalUnits();
                                _updateTotalPrice();
                              }
                            },
                            onQuantityChanged: (newQty) {
                              _onQuantityChanged(newQty);
                            },
                          ),
                        ),
                      ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding, vertical: AppSizes.size8),
            child: isPopupLayout
                ? Column(
                    children: [
                      _buildTotalSummary(context, compactTitleStyle,
                          compactStrongStyle, isPopupLayout),
                      const SizedBox(height: AppSizes.size10),
                      Row(
                        children: [
                          Expanded(
                            child: commonButton(context, () {
                              widget.onBackorderClick?.call();
                              print("Rishabh is making api Call");
                              // widget.productPageBloc?.add(AddProductToCartEvent("${widget.product?.productId??0}", "$quantity", "",'${unitValueInt}'));
                              // widget.bloc?.add(AddProductToWishListEvent(productId, key));
                            },
                                (localizations?.translate(
                                        AppStringConstant.addToBackorders) ??
                                    ""),
                                backgroundColor: const Color(0xFFFF914D),
                                textColor: AppColors.black),
                          ),
                          const SizedBox(width: AppSizes.size12),
                          InkWell(
                            onTap: widget.onUpdateClick,
                            child: Image.asset(AppImages.refreshButton,
                                width: 36, height: 36),
                          ),
                          const SizedBox(width: AppSizes.size12),
                          InkWell(
                            onTap: () {
                              DialogHelper.confirmationDialog(
                                  AppStringConstant.deleteItemFromCart,
                                  context,
                                  localizations,
                                  onConfirm: widget.onDeleteClick);
                            },
                            child: Image.asset(AppImages.delete,
                                width: AppSizes.size24,
                                height: AppSizes.size24),
                          ),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildTotalSummary(context, compactTitleStyle,
                            compactStrongStyle, isPopupLayout),
                      ),
                      const SizedBox(width: AppSizes.size20),
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onUpdateClick,
                            child: Image.asset(AppImages.refreshButton,
                                width: AppSizes.size40,
                                height: AppSizes.size40),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {
                              DialogHelper.confirmationDialog(
                                  AppStringConstant.deleteItemFromCart,
                                  context,
                                  localizations,
                                  onConfirm: widget.onDeleteClick);
                            },
                            child: Image.asset(AppImages.delete,
                                width: AppSizes.size24,
                                height: AppSizes.size24),
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
          ),
          ((product?.stock ?? false) || isPopupLayout)
              ? SizedBox()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: commonButton(context, () {
                    widget.onBackorderClick?.call();
                    print("Rishabh is making api Call");
                    // widget.productPageBloc?.add(AddProductToCartEvent("${widget.product?.productId??0}", "$quantity", "",'${unitValueInt}'));
                    // widget.bloc?.add(AddProductToWishListEvent(productId, key));
                  },
                      (localizations
                              ?.translate(AppStringConstant.addToBackorders) ??
                          ""),
                      backgroundColor: const Color(0xFFFF914D),
                      textColor: AppColors.black),
                ),
          if (!widget.isLastItem)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.size12),
              child: Divider(color: AppColors.dividerColor, thickness: 1),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalSummary(
    BuildContext context,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    bool isPopupLayout,
  ) {
    return Container(
      height: AppSizes.size45,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSizes.size6),
      ),
      padding: EdgeInsets.symmetric(
          horizontal: isPopupLayout ? AppSizes.size8 : AppSizes.size12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              children: [
                Text(
                  'Total ',
                  style: labelStyle,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '£${totalPrice.toStringAsFixed(2)}',
                      maxLines: 1,
                      style: valueStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSizes.size8),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total Qty ',
                  style: labelStyle,
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${quantity * unitValueInt}',
                      maxLines: 1,
                      style: valueStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
