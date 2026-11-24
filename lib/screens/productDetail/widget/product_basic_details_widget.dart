import 'package:flutter/material.dart';

import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';

import '../../../common_widgets/quantity_selector.dart';
import '../../../common_widgets/unit_dropdown.dart';
import '../../../config/theme.dart';
import '../../../constants/app_constants.dart';

import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class ProductPageBasicDetailsWidget extends StatefulWidget {
  final ProductDetailScreenModel? product;
  final bool addedToWishlist;
  final ProductDetailBloc? productPageBloc;
  final String? miniPack;
  final String? carton;
  final String? inner;
  final int? productId;
  final bool isFromQuickCart;

  ProductPageBasicDetailsWidget(
      {super.key,
      required this.addedToWishlist,
      required this.productPageBloc,
      required this.product,
      required this.miniPack,
      required this.carton,
      required this.inner,
      required this.productId,
      this.isFromQuickCart = false});

  @override
  State<StatefulWidget> createState() => ProductPageBasicDetailsWidgetState();
}

class ProductPageBasicDetailsWidgetState
    extends State<ProductPageBasicDetailsWidget> {
  AppLocalizations? _localizations;
  bool? isDarkMode;

  int? selectedIndex;
  late int quantity;
  late String selectedUnit;
  double totalPrice = 0.0;
  List<String> unitOptions = [];
  int unitValueInt = 1;
  String? UpdateTempPricevalue = "";

  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    quantity = 1;

    selectedUnit = '';
    _initUnitOptions();

    // Defer price update until after the widget is fully built and product data is available
    // Also ensure selectedUnit is properly set before calling _updateTotalPrice
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // Check if we have valid data to proceed
      final bool hasValidData =
          widget.product != null && selectedUnit.isNotEmpty;

      if (hasValidData) {
        // We have valid data, update price and show view
        _updateTotalPrice();
        setState(() {
          isInitialized = true;
        });
      } else if (selectedUnit.isEmpty && widget.product != null) {
        // selectedUnit not set yet, wait and retry
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && widget.product != null && selectedUnit.isNotEmpty) {
            _updateTotalPrice();
          }
          // Mark initialized after retry to avoid infinite loading
          if (mounted) {
            setState(() {
              isInitialized = true;
            });
          }
        });
      } else {
        // No product data, mark initialized anyway to avoid infinite loading
        setState(() {
          isInitialized = true;
        });
      }
    });
  }

  void _initUnitOptions() {
    final rawUnitMap = {
      'Mini Pack': widget.product?.mini_pack ?? '',
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

    // if (unitOptions.isNotEmpty) {
    //   selectedUnit = unitOptions.first;
    // }
    String pickDefaultUnit(List<String> options) {
      if (options.isEmpty) return '';
      String capitalize(String s) {
        if (s.isEmpty) return s;
        return s[0].toUpperCase() + s.substring(1).toLowerCase();
      }

      final defaultUnit = capitalize((widget.product?.inner?.isNotEmpty == true)
          ? "${widget.product?.byDefultSelected ?? ""}"
          : "Carton");

      final cartonIdx = options.indexWhere((u) => u.startsWith(defaultUnit));
      return cartonIdx != -1 ? options[cartonIdx] : options.first;
    }

    selectedUnit = pickDefaultUnit(unitOptions);
    final unitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
    unitValueInt = int.tryParse(unitMatch?.group(1) ?? '') ?? 1;
  }

  void _updateTotalPrice() {
    // Ensure selectedUnit is not empty before proceeding
    if (selectedUnit.isEmpty) {
      print(
          "UpdateTempPricevalue: selectedUnit is empty, skipping price update");
      return;
    }

    // Also ensure we have valid product price data
    if (widget.product?.price == null) {
      print(
          "UpdateTempPricevalue: product price is null, skipping price update");
      return;
    }

    final cleanUnitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
    final selectedUnitValue = int.tryParse(cleanUnitMatch?.group(1) ?? '') ?? 1;
    final totalUnits = selectedUnitValue * quantity;

    final rawPrice = widget.product?.price;
    final priceString = rawPrice is String ? rawPrice : rawPrice?.toString();
    double unitPrice = double.tryParse(
          priceString?.replaceAll(RegExp(r'[^\d.]'), '') ?? '',
        ) ??
        0.0;

    final discounts = widget.product?.discounts ?? [];

    final parsedDiscounts = discounts
        .where((d) => int.tryParse(d.quantity ?? '') != null)
        .map((d) => {
              'quantity': int.parse(d.quantity!),
              'price': double.tryParse(
                    (d.price is String ? d.price : d.price?.toString())
                            ?.replaceAll("£", "")
                            .replaceAll(",", "")
                            .trim() ??
                        '',
                  ) ??
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
      totalPrice = unitPrice * totalUnits;
      UpdateTempPricevalue = unitPrice.toStringAsFixed(2);
    });
    print(
        "UpdateTempPricevalue: $UpdateTempPricevalue, unitPrice: $unitPrice, isFinite: ${unitPrice.isFinite}");

    // Validate price before dispatching event - ensure it's not empty and is a valid finite number
    if (widget.productPageBloc != null &&
        UpdateTempPricevalue != null &&
        UpdateTempPricevalue!.isNotEmpty &&
        unitPrice.isFinite) {
      widget.productPageBloc!.add(UpdateTempPriceEvent(
        "$UpdateTempPricevalue",
      ));
    }
  }

  // When quantity changes, ensure the selected unit is appropriate for the total items
  void _syncUnitWithTotalUnits() {
    // Parse sizes from unitOptions labels like 'Carton (24)'
    final Map<String, int> labelToSize = {};
    for (var label in unitOptions) {
      final m = RegExp(r'\((\d+)\)').firstMatch(label);
      final size = int.tryParse(m?.group(1) ?? '') ?? 0;
      labelToSize[label] = size;
    }

    if (labelToSize.isEmpty) return;

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

    // If the bestLabel is different from selectedUnit, update selectedUnit and adjust quantity
    if (bestLabel != selectedUnit) {
      final newUnitSize = bestSize > 0 ? bestSize : 1;
      // Preserve total items as much as possible: compute new quantity as integer division
      final newQuantity = (currentTotalItems ~/ newUnitSize).clamp(1, 999999);
      setState(() {
        selectedUnit = bestLabel;
        unitValueInt = newUnitSize;
        quantity = newQuantity;
      });
    }
  }

  // void _onQuantityChanged(int newQty) {
  //   // central handler for quantity changes
  //   quantity = newQty;
  //   // First, try to sync unit selection according to total items
  //   _syncUnitWithTotalUnits();
  //   // Then update price according to possibly changed unit/quantity
  //   _updateTotalPrice();
  // }

  void _onQuantityChanged(int newQty) {
    quantity = newQty;

    final miniPack = int.tryParse(widget.product?.mini_pack ?? '0') ?? 0;
    final inner = int.tryParse(widget.product?.inner ?? '0') ?? 0;
    final carton = int.tryParse(widget.product?.carton ?? '0') ?? 0;

    // ---------------------------------------------------
    // CASE 1 : Selected Unit is MINI PACK → NO RULES
    // ---------------------------------------------------
    if (selectedUnit.contains("Mini Pack")) {
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
      if (inner > 0 && carton > 0) {
        final totalUnits = newQty * inner;

        // If totalUnits >= carton size → move to carton
        if (totalUnits >= carton) {
          final newCartonQty = (totalUnits ~/ carton);

          setState(() {
            widget.product?.UnitofSalenew = carton.toString();
            selectedUnit = unitOptions.firstWhere(
                (element) =>
                    element.contains("(${widget.product?.UnitofSalenew})"),
                orElse: () => "Carton ($carton)");
            unitValueInt = carton;
            quantity = newCartonQty;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  void didUpdateWidget(covariant ProductPageBasicDetailsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle case where product data becomes available after widget was initially built
    // This happens when API response is delayed
    if (oldWidget.product == null && widget.product != null) {
      // Product data just became available
      _initUnitOptions();

      // Wait for selectedUnit to be set then update price
      if (selectedUnit.isNotEmpty) {
        _updateTotalPrice();
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && selectedUnit.isNotEmpty) {
            _updateTotalPrice();
          }
        });
      }
    }
    // Also handle case where product changes to a different one
    else if (oldWidget.product != null &&
        widget.product != null &&
        oldWidget.product != widget.product) {
      final previousUnit = selectedUnit;
      _initUnitOptions();
      if (previousUnit.isNotEmpty && unitOptions.contains(previousUnit)) {
        selectedUnit = previousUnit;
        final unitMatch = RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
        unitValueInt = int.tryParse(unitMatch?.group(1) ?? '') ?? 1;
      }

      if (selectedUnit.isNotEmpty) {
        _updateTotalPrice();
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted && selectedUnit.isNotEmpty) {
            _updateTotalPrice();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized || widget.product == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: [
        Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // widget.isFromQuickCart?const SizedBox(height: 0,):Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       margin: const EdgeInsets.only(top: 14),
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 10, vertical: 6),
                //       decoration: BoxDecoration(
                //         color: widget.product?.stock != "In Stock"
                //             ? AppColors.red
                //             : AppColors.green,
                //         borderRadius: BorderRadius.circular(5),
                //       ),
                //       child: Text(widget.product?.stock ?? '',
                //           style: Theme.of(context)
                //               .textTheme
                //               .titleLarge
                //               ?.copyWith(color: AppColors.white)
                //         // SizedBox(height: AppSizes.size8),
                //
                //       ),
                //     ),
                //     Text("Product Code: ${widget.product?.model}" ?? '',
                //         style: Theme.of(context)
                //             .textTheme
                //             .titleLarge
                //             ?.copyWith(fontWeight: FontWeight.w400)
                //       // SizedBox(height: AppSizes.size8),
                //     )
                //   ],
                // ),
                // constants SizedBox(height: AppSizes.size8),

                if (widget.product?.discounts?.length != null)
                  widget.isFromQuickCart
                      ? const SizedBox()
                      : Column(
                          children: [
                            // List of discount options

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.product?.discounts?.length,
                              itemBuilder: (context, index) {
                                final discounts =
                                    widget.product?.discounts ?? [];
                                final item = widget.product?.discounts?[index];
                                final quantity1 =
                                    int.tryParse(item?.quantity ?? "1") ?? 1;
                                final priceString = item?.price
                                        ?.toString()
                                        .replaceAll("£", "")
                                        .trim() ??
                                    "0.0";
                                final pricePerItem =
                                    double.tryParse(priceString) ?? 0.0;
                                final lastHighlightedIndex = List.generate(
                                    discounts.length, (i) => i).where((i) {
                                  final q1 =
                                      int.parse(discounts[i].quantity ?? "1");
                                  return q1 <= (quantity * unitValueInt);
                                }).fold<int?>(
                                    null, (prev, i) => i); // get last or null
                                if (index == lastHighlightedIndex) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      final newPrice =
                                          pricePerItem.toStringAsFixed(2);
                                      if (UpdateTempPricevalue != newPrice) {
                                        setState(() {
                                          UpdateTempPricevalue = newPrice;
                                        });
                                        // Dispatch event to bloc
                                        if (widget.productPageBloc != null &&
                                            newPrice.isNotEmpty) {
                                          widget.productPageBloc!.add(
                                              UpdateTempPriceEvent(newPrice));
                                        }
                                      }
                                    }
                                  });
                                }

                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: index == lastHighlightedIndex
                                          ? MobikulTheme.accentColor
                                          : Colors.white,
                                      // color: Colors.white,
                                      //isSelected
                                      //? MobikulTheme.accentColor
                                      // : Colors.white,
                                      border: Border.all(
                                          color: Colors.transparent,
                                          // isSelected
                                          //     ? MobikulTheme.accentColor
                                          //     : Colors.transparent,
                                          width: 0
                                          //isSelected ? 2 : 0,
                                          ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "£${pricePerItem.toStringAsFixed(2)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontSize: 16),
                                          ),
                                          TextSpan(
                                            text: " per item $quantity1+ Qty",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: AppSizes.size72,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${quantity * unitValueInt}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Total Qty",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: AppSizes.size72,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          '£${totalPrice.toStringAsFixed(2)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          "Total Price",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                widget.isFromQuickCart
                    ? const SizedBox(
                        height: 0,
                      )
                    : const SizedBox(height: AppSizes.size16),

                /// Unit Dropdown + Quantity Selector
                Row(
                  children: <Widget>[
                    Expanded(
                      child: UnitDropdown(
                        units: unitOptions,
                        selectedUnit: selectedUnit,
                        onChanged: (newUnit) {
                          setState(() {
                            selectedUnit = newUnit ?? "";
                            quantity = 1;

                            final unitMatch =
                                RegExp(r'\((\d+)\)').firstMatch(selectedUnit);
                            unitValueInt =
                                int.tryParse(unitMatch?.group(1) ?? '') ?? 1;

                            _updateTotalPrice();
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
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
                              final m = RegExp(r'\((\d+)\)').firstMatch(label);
                              final size = int.tryParse(m?.group(1) ?? '') ?? 0;
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
                                quantity = 1; // IMPORTANT: Reset to 1
                              });
                              _syncUnitWithTotalUnits();
                              _updateTotalPrice();
                              return;
                            }

                            // Else move to Carton
                            if (labelToSize.keys
                                .any((e) => e.contains("Carton"))) {
                              final entry = labelToSize.entries
                                  .firstWhere((e) => e.key.contains("Carton"));
                              setState(() {
                                selectedUnit = entry.key;
                                unitValueInt = entry.value;
                                quantity = 1;
                              });
                              _syncUnitWithTotalUnits();
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

                            if (selectedUnit.contains("Carton")) {
                              final hasInner =
                                  unitOptions.any((e) => e.contains("Inner"));
                              final miniLabel = unitOptions.firstWhere(
                                (e) => e.contains("Mini Pack"),
                                orElse: () => "",
                              );

                              // If INNER not present but MINI PACK exists
                              if (!hasInner && miniLabel.isNotEmpty) {
                                final m =
                                    RegExp(r'\((\d+)\)').firstMatch(miniLabel);
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
                                final m =
                                    RegExp(r'\((\d+)\)').firstMatch(miniLabel);
                                final miniSize =
                                    int.tryParse(m?.group(1) ?? "") ?? 1;

                                setState(() {
                                  selectedUnit = miniLabel; // Mini Pack
                                  unitValueInt = miniSize; // 6
                                  quantity = 1; // always 1
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
                              final m = RegExp(r'\((\d+)\)').firstMatch(label);
                              final size = int.tryParse(m?.group(1) ?? '') ?? 0;
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
                              final smallest = labelToSize.entries
                                  .reduce((a, b) => a.value < b.value ? a : b);
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
                            });

                            _updateTotalPrice();
                          }
                        },
                        onQuantityChanged: (newQty) {
                          _onQuantityChanged(newQty);
                        },
                      ),
                    ),
                  ],
                ),

                widget.isFromQuickCart
                    ? Row(
                        children: [
                          Container(
                            height: AppSizes.size45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.size12,
                            ),
                            // Light grey background
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Total
                                Row(
                                  children: [
                                    Text(
                                      'Total ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    Text(
                                      '£${totalPrice.toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: AppSizes.size4,
                                ),
                                // Quantity
                                Row(
                                  children: [
                                    Text(
                                      'Qty ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    ),
                                    Text(
                                      '${(quantity * unitValueInt)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.size8,
                              ),
                              child: commonButton(
                                context,
                                () {
                                  print("Rishabh is making api Call");
                                  // widget.productPageBloc?.add(AddProductToCartEvent("${widget.product?.productId??0}", "$quantity", "",'${unitValueInt}'));
                                  widget.product?.stock == "Out Of Stock"
                                      ? widget.productPageBloc?.add(
                                          AddProductToWishListEvent(
                                              "${widget.product?.productId ?? 0}",
                                              "$quantity",
                                              '$unitValueInt'))
                                      : widget.productPageBloc?.add(
                                          AddProductToCartEvent(
                                              "${widget.product?.productId ?? 0}",
                                              "$quantity",
                                              "",
                                              '$unitValueInt'));
                                },
                                widget.product?.stock == "Out Of Stock"
                                    ? (_localizations?.translate(
                                            AppStringConstant
                                                .addToBackorders) ??
                                        "")
                                    : (_localizations?.translate(
                                            AppStringConstant.add) ??
                                        ""),
                                backgroundColor:
                                    widget.product?.stock == "Out Of Stock"
                                        ? const Color(0xFFFF914D)
                                        : const Color(0xFF0D479C),
                                textColor:
                                    widget.product?.stock == "Out Of Stock"
                                        ? AppColors.black
                                        : AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                widget.isFromQuickCart
                    ? const SizedBox(
                        height: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSizes.size8,
                        ),
                        child: commonButton(
                          context,
                          () {
                            print("Rishabh is making api Call");
                            widget.product?.stock == "Out Of Stock"
                                ? widget.productPageBloc?.add(
                                    AddProductToWishListEvent(
                                        "${widget.product?.productId ?? 0}",
                                        "$quantity",
                                        '$unitValueInt'))
                                : widget.productPageBloc?.add(
                                    AddProductToCartEvent(
                                        "${widget.product?.productId ?? 0}",
                                        "$quantity",
                                        "",
                                        '$unitValueInt'));
                            // Refresh product details via an event instead of calling emit directly
                            widget.productPageBloc?.add(GetProductDetailEvent(
                                widget.productId?.toString() ?? ""));
                          },
                          widget.product?.stock == "Out Of Stock"
                              ? (_localizations?.translate(
                                      AppStringConstant.addToBackorders) ??
                                  "")
                              : (_localizations?.translate(
                                      AppStringConstant.addToBasket) ??
                                  ""),
                          backgroundColor:
                              widget.product?.stock == "Out Of Stock"
                                  ? const Color(0xFFFF914D)
                                  : const Color(0xFF0D479C),
                          textColor: widget.product?.stock == "Out Of Stock"
                              ? AppColors.black
                              : AppColors.white,
                        ),
                      ),
              ]),
        ),
      ],
    );
  }
}

String toTitleCase(String text) {
  if (text.isEmpty) return '';
  return text
      .split(' ')
      .map((word) => word.isEmpty
          ? ''
          : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}
