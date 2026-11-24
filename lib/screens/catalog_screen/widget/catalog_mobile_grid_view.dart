import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/common_widgets/product_status_badges.dart';
import 'package:oc_demo/common_widgets/quantity_selector.dart';
import 'package:oc_demo/common_widgets/unit_dropdown.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/hive/prefetch_service.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_bloc.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_event.dart';

String catalogMobileGridUnitOfSaleLabel(int unitSize) {
  return '${unitSize <= 0 ? 1 : unitSize} Unit of Sale';
}

const int catalogMobileGridPriceRowPriceFlex = 0;
const int catalogMobileGridPriceRowUnitOfSaleFlex = 1;

class CatalogMobileGridView extends StatefulWidget {
  const CatalogMobileGridView({
    super.key,
    this.products,
    this.controller,
    this.addProductToWishList,
    this.byDefultSelected = '',
    this.bloc,
    this.localizations,
  });

  final List<Product>? products;
  final ScrollController? controller;
  final Function(String, int)? addProductToWishList;
  final String byDefultSelected;
  final CatalogScreenBloc? bloc;
  final AppLocalizations? localizations;

  @override
  State<CatalogMobileGridView> createState() => _CatalogMobileGridViewState();
}

class _CatalogMobileGridViewState extends State<CatalogMobileGridView> {
  final Map<int, String> _selectedUnits = {};
  final Map<int, int> _quantities = {};
  bool? _isUserLogin;

  @override
  void initState() {
    super.initState();
    AppSharedPref.isLogin().then((value) {
      if (!mounted) return;
      setState(() {
        _isUserLogin = value;
      });
    });
  }

  int _safeParse(String? value) => int.tryParse(value ?? '') ?? 0;

  double _priceAsDouble(String price) {
    return double.tryParse(price.replaceAll('£', '').trim()) ?? 0.0;
  }

  List<String> _unitOptions(Product? product) {
    return [
      if (_safeParse(product?.miniPack) > 0) "Mini Pack (${product!.miniPack})",
      if (_safeParse(product?.inner) > 0) "Inner (${product!.inner})",
      if (_safeParse(product?.carton) > 0) "Carton (${product!.carton})",
    ];
  }

  String _capitalize(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }

  String _defaultUnit(Product? product, List<String> options) {
    if (options.isEmpty) return '';
    final defaultUnit = _capitalize(
      product?.inner?.isNotEmpty == true ? widget.byDefultSelected : 'Carton',
    );
    final defaultIndex =
        options.indexWhere((unit) => unit.startsWith(defaultUnit));
    return defaultIndex != -1 ? options[defaultIndex] : options.first;
  }

  int _unitSize(String unitLabel) {
    final match = RegExp(r'\((\d+)\)').firstMatch(unitLabel);
    return _safeParse(match?.group(1));
  }

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
    final selectedUnitLabel = _selectedUnits[index] ?? '';
    final currentQty = _quantities[index] ?? 1;
    final unitMap = _buildUnitMap(product);

    if (selectedUnitLabel.isEmpty || unitMap.isEmpty) return;

    if (selectedUnitLabel.contains("Mini Pack")) {
      final innerEntry = _findUnitEntry(unitMap, "Inner");
      if (innerEntry != null) {
        _selectedUnits[index] = innerEntry.key;
        _quantities[index] = 1;
        return;
      }

      final cartonEntry = _findUnitEntry(unitMap, "Carton");
      if (cartonEntry != null) {
        _selectedUnits[index] = cartonEntry.key;
        _quantities[index] = 1;
      }
      return;
    }

    if (selectedUnitLabel.contains("Inner")) {
      final innerSize = _extractUnitSize(selectedUnitLabel);
      final cartonEntry = _findUnitEntry(unitMap, "Carton");

      if (innerSize > 0 && cartonEntry != null) {
        final totalUnits = innerSize * currentQty;
        if (totalUnits >= cartonEntry.value) {
          _selectedUnits[index] = cartonEntry.key;
          _quantities[index] =
              (totalUnits ~/ cartonEntry.value).clamp(1, 999999);
          return;
        }
      }
    }

    final unitSize = _extractUnitSize(selectedUnitLabel);
    final totalUnits = unitSize * currentQty;
    final newUnit = _getUnitFromTotalUnits(totalUnits, unitMap);

    if (newUnit != _selectedUnits[index]) {
      _selectedUnits[index] = newUnit;

      final newUnitSize = _extractUnitSize(newUnit);
      _quantities[index] = (totalUnits / newUnitSize).ceil();
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

  String _priceForTotal(Product? product, int totalUnits) {
    var matchedPrice =
        product?.price != false ? product?.price?.toString() ?? '' : '';
    for (final discount in product?.discounts ?? <Discounts>[]) {
      final discountQty = _safeParse(discount.quantity);
      if (discountQty > 0 && discountQty <= totalUnits) {
        matchedPrice = discount.price ?? matchedPrice;
      }
    }
    return matchedPrice;
  }

  String _stockLabel(Product? product) {
    if (_isBackorder(product)) {
      return product?.expected == '' ? 'Out Of Stock' : product?.expected ?? '';
    }

    final carton = _safeParse(product?.carton);
    final quantity = _safeParse(product?.quantity);
    return carton * 10 > quantity ? 'Low Stock' : 'In Stock';
  }

  Color _stockColor(Product? product) {
    if (_isBackorder(product)) {
      return const Color(0xFFE7000B);
    }

    final carton = _safeParse(product?.carton);
    final quantity = _safeParse(product?.quantity);
    return carton * 10 > quantity
        ? const Color(0xFFFFA500)
        : const Color(0xFF00BC7D);
  }

  bool _isBackorder(Product? product) => product?.quantity?.trim() == '0';

  @override
  Widget build(BuildContext context) {
    final showPurchaseActions = _isUserLogin ?? false;

    return GridView.builder(
      controller: widget.controller,
      itemCount: widget.products?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: showPurchaseActions ? 385 : 250,
      ),
      itemBuilder: (context, index) {
        final product = widget.products?[index];
        if (product == null) return const SizedBox.shrink();

        PrefetchService.preFetchProductDetails(product.productId ?? '');

        final isRightColumn = index.isOdd;
        final unitOptions = _unitOptions(product);
        _selectedUnits[index] ??= _defaultUnit(product, unitOptions);
        _quantities[index] ??= 1;

        final selectedUnit = _selectedUnits[index] ?? '';
        final unitSize = _unitSize(selectedUnit);
        final quantity = _quantities[index] ?? 1;
        final totalUnits = (unitSize == 0 ? 1 : unitSize) * quantity;
        final price = _priceForTotal(product, totalUnits);
        final totalAmount = _priceAsDouble(price) * totalUnits;
        final canBuy = showPurchaseActions && product.price != false;
        final canViewPrice = showPurchaseActions && product.price != false;
        final isBackorder = _isBackorder(product);

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoute.productPage,
              arguments: getProductDataAttributeMap(
                product.name ?? '',
                product.productId ?? '',
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                right: isRightColumn
                    ? BorderSide.none
                    : const BorderSide(
                        color: AppColors.dividerColor,
                        width: 1,
                      ),
                bottom: const BorderSide(
                  color: AppColors.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.size8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Center(
                              child: ImageView(
                                url: product.thumb ?? '',
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                        if (ProductStatusBadges.shouldShowBought(
                          product.bought,
                        ))
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: ProductBoughtBadge(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.size8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.size6),
                  if (canViewPrice)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size6,
                            vertical: AppSizes.size4,
                          ),
                          decoration: BoxDecoration(
                            color: _stockColor(product),
                            borderRadius: BorderRadius.circular(AppSizes.size4),
                          ),
                          child: Text(
                            _stockLabel(product),
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSizes.size6),
                        Expanded(
                          child: Text(
                            product.model ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    )
                  else
                    Text(
                      product.model ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  const SizedBox(height: AppSizes.size6),
                  if (canViewPrice)
                    Row(
                      children: [
                        Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        const SizedBox(width: AppSizes.size6),
                        Expanded(
                          flex: catalogMobileGridPriceRowUnitOfSaleFlex,
                          child: Text(
                            catalogMobileGridUnitOfSaleLabel(unitSize),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ],
                    ),
                  if (canBuy && unitOptions.isNotEmpty) ...[
                    const SizedBox(height: AppSizes.size8),
                    Offstage(
                      offstage: true,
                      child: UnitDropdown(
                        units: unitOptions,
                        selectedUnit: selectedUnit,
                        onChanged: (newUnit) {
                          setState(() {
                            _selectedUnits[index] = newUnit ?? selectedUnit;
                            _quantities[index] = 1;
                          });
                        },
                      ),
                    ),
                    _MobileGridSubtotalBox(
                      totalAmount: totalAmount,
                      quantity: totalUnits,
                    ),
                    const SizedBox(height: AppSizes.size8),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        QuantitySelector(
                          key: ValueKey(
                              'mobile_grid_quantity_${_quantities[index]}_$index'),
                          quantity: quantity,
                          enabled: true,
                          onIncrement: () {
                            setState(() {
                              _quantities[index] = quantity + 1;
                              _syncCatalogUnitAfterIncrease(product, index);
                            });
                          },
                          onDecrement: () {
                            setState(() {
                              final currentQty = _quantities[index] ?? 1;
                              final selectedUnitLabel =
                                  _selectedUnits[index] ?? '';
                              final unitMap = _buildUnitMap(product);

                              if (selectedUnitLabel.contains("Mini Pack")) {
                                return;
                              }

                              if (currentQty == 1) {
                                if (selectedUnitLabel.contains("Inner") &&
                                    !unitMap.keys
                                        .any((e) => e.contains("Mini Pack"))) {
                                  _quantities[index] = 1;
                                  return;
                                }

                                if (selectedUnitLabel.contains("Carton") &&
                                    unitMap.keys
                                        .any((e) => e.contains("Inner"))) {
                                  final cartonSize =
                                      _extractUnitSize(selectedUnitLabel);

                                  final innerEntry = unitMap.entries.firstWhere(
                                      (e) => e.key.contains("Inner"));
                                  final innerSize = innerEntry.value;

                                  final totalUnits = cartonSize * currentQty;
                                  final convertedQty =
                                      (totalUnits / innerSize).floor();

                                  final finalQty =
                                      (convertedQty - 1).clamp(1, 999999);

                                  _selectedUnits[index] = "Inner ($innerSize)";
                                  _quantities[index] = finalQty;
                                  return;
                                }

                                if (selectedUnitLabel.contains("Carton") &&
                                    unitMap.keys
                                        .any((e) => e.contains("Mini Pack"))) {
                                  final miniEntry = unitMap.entries.firstWhere(
                                      (e) => e.key.contains("Mini Pack"));
                                  _selectedUnits[index] = miniEntry.key;
                                  _quantities[index] = 1;
                                  return;
                                }

                                if (selectedUnitLabel.contains("Inner") &&
                                    unitMap.keys
                                        .any((e) => e.contains("Mini Pack"))) {
                                  final miniEntry = unitMap.entries.firstWhere(
                                      (e) => e.key.contains("Mini Pack"));
                                  _selectedUnits[index] = miniEntry.key;
                                  _quantities[index] = 1;
                                  return;
                                }

                                _quantities[index] = 1;
                                return;
                              }

                              _quantities[index] = currentQty - 1;

                              final unitSize =
                                  _extractUnitSize(selectedUnitLabel);
                              final totalUnits =
                                  unitSize * (_quantities[index] ?? 1);

                              final newUnit =
                                  _getUnitFromTotalUnits(totalUnits, unitMap);

                              if (newUnit != _selectedUnits[index]) {
                                _selectedUnits[index] = newUnit;

                                final newUnitSize = _extractUnitSize(newUnit);
                                _quantities[index] = (totalUnits / newUnitSize)
                                    .floor()
                                    .clamp(1, 999999);
                              }
                            });
                          },
                          onQuantityChanged: (newQty) {
                            setState(() {
                              _quantities[index] = newQty;

                              final miniPack =
                                  int.tryParse(product.miniPack ?? '0') ?? 0;
                              final inner =
                                  int.tryParse(product.inner ?? '0') ?? 0;
                              final carton =
                                  int.tryParse(product.carton ?? '0') ?? 0;
                              final selectedUnitLabel =
                                  _selectedUnits[index] ?? '';

                              if (selectedUnitLabel.contains("Mini Pack")) {
                                if (miniPack > 0 && inner > 0) {
                                  final totalUnits = newQty * inner;

                                  if (totalUnits >= carton) {
                                    _selectedUnits[index] = "Inner ($inner)";
                                    _quantities[index] = 1;
                                    return;
                                  }
                                }

                                _quantities[index] = newQty;
                                return;
                              }

                              if (selectedUnitLabel.contains("Carton")) {
                                _quantities[index] = newQty;
                                return;
                              }

                              if (selectedUnitLabel.contains("Inner")) {
                                if (inner > 0 && carton > 0) {
                                  final totalUnits = newQty * inner;

                                  if (totalUnits >= carton) {
                                    final newCartonQty = (totalUnits ~/ carton);

                                    _selectedUnits[index] = "Carton ($carton)";
                                    _quantities[index] =
                                        newCartonQty.clamp(1, 999999);
                                    return;
                                  }
                                }

                                _quantities[index] = newQty;
                                return;
                              }

                              _quantities[index] = newQty;
                            });
                          },
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: ValueListenableBuilder<Set<String>>(
                            valueListenable:
                                ProductCartStatusController.addedProductIds,
                            builder: (context, addedProductIds, _) {
                              if (!ProductCartStatusController.isAdded(
                                product.productId,
                                product.isCartAdded,
                                addedProductIds,
                              )) {
                                return const SizedBox.shrink();
                              }

                              return const ProductAddedBadge(
                                iconSize: AppSizes.size16,
                                fontSize: AppSizes.size12,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSizes.size8),
                    _MobileGridAddToBasketButton(
                      buttonText: isBackorder
                          ? widget.localizations?.translate(
                                  AppStringConstant.addToBackorders) ??
                              ''
                          : widget.localizations
                                  ?.translate(AppStringConstant.addToBasket) ??
                              '',
                      isBackorder: isBackorder,
                      onPressed: () {
                        final unitValue =
                            _unitSize(_selectedUnits[index] ?? '');
                        isBackorder
                            ? widget.bloc?.add(AddToWishlistEvent(
                                '${product.productId ?? 0}',
                                '$quantity',
                                '$unitValue',
                              ))
                            : widget.bloc?.add(AddProductToCartEvent(
                                '${product.productId ?? ''}',
                                '$quantity',
                                '',
                                '$unitValue',
                              ));
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MobileGridSubtotalBox extends StatelessWidget {
  const _MobileGridSubtotalBox({
    required this.totalAmount,
    required this.quantity,
  });

  final double totalAmount;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.size40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(AppSizes.size6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size6),
      child: Text(
        'Total £${totalAmount.toStringAsFixed(2)} Qty $quantity',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
      ),
    );
  }
}

class _MobileGridAddToBasketButton extends StatelessWidget {
  const _MobileGridAddToBasketButton({
    required this.buttonText,
    required this.isBackorder,
    required this.onPressed,
  });

  final String buttonText;
  final bool isBackorder;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.size40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isBackorder ? const Color(0xFFFF914D) : const Color(0xFF0D479C),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSizes.size6),
            ),
          ),
        ),
        child: Text(
          buttonText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
