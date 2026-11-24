import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/product_status_badges.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';
import 'package:oc_demo/models/catalog/catalog_model.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';
import 'package:oc_demo/models/catalog/sort.dart';
import 'package:oc_demo/models/product/product.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_bloc.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_event.dart';
import 'package:oc_demo/screens/catalog_screen/bloc/catalog_screen_state.dart';
import 'package:oc_demo/screens/catalog_screen/widget/catalog_grid_view.dart';
import 'package:oc_demo/screens/catalog_screen/widget/catalog_listview.dart';
import 'package:oc_demo/screens/catalog_screen/widget/catalog_mobile_grid_view.dart';
import 'package:oc_demo/screens/catalog_screen/widget/filter_bottom_sheet.dart';
import 'package:oc_demo/screens/catalog_screen/widget/sort_bottom_sheet.dart';

import '../../common_widgets/common_empty_card.dart';
import '../../models/product_search/product_search_model.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen(this.arguments, {super.key});

  final Map<String, dynamic> arguments;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late bool _isGrid, _loading, _sortApplied, _filterApplied;
  CatalogScreenBloc? _bloc;
  CatalogModel? _model;
  AppLocalizations? _localizations;
  ManufactureModel? _manufactureModel;
  ProductSearchModel? _productSearchModel;
  late List<Product> _products;
  late final List<Product> _tempProductsList = [];
  int lsatDbListSize = 0;
  late List<Sort> _sorts;
  late List<FilterGroup> _filterGroups;
  late ScrollController _scrollController;
  late CatalogProductRequest _request;
  late int _page;
  Sort? _sort;
  String? _filter, catalogId, label, _productCategoryType;
  bool showFilterOption = true;
  bool isWishlistState = false;
  String? productId;
  int? index1;

  @override
  void initState() {
    catalogId = widget.arguments[categoryId];
    label = widget.arguments[labelKey];
    _productCategoryType = widget.arguments[productCategoryTypeKey];
    _isGrid = false;
    _loading = true;
    _sortApplied = false;
    _filterApplied = false;
    _page = 1;
    _products = [];
    _sorts = [];
    _filterGroups = [];
    _scrollController = ScrollController()..addListener(setupPagination);
    _bloc = context.read<CatalogScreenBloc>();
    productId = "-1";
    index1 = -1;
    print("catalog id $catalogId");
    _callAPI();
    super.initState();
  }

  setupPagination() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
      //if (hasMoreData()) {
      _page += 1;
      _callAPI();
      // }
    }
  }

  _callAPI() async {
    print("sdskfgthy");
    _loading = true;
    var home = widget.arguments[fromHomePageKey];
    var products = widget.arguments[productSearch];
    String currentToken = await AppSharedPref.getWkToken();
    AppSharedPref.getWkToken().then((value) {
      print("wefrfrg");
      _request = CatalogProductRequest(
        width: AppSizes.deviceWidth.toInt().toString(),
        limit: "15",
        path: home == true ? null : catalogId,
        page: _page.toString(),
        token: value,
        manufactureId: home == true ? catalogId : null,
      );

      if (_sort != null) {
        print(
            "selected sort2 ${_sort?.text} and value ${_sort?.value}and value ${_sort?.order}");
        _request.sort = _sort?.value;
        _request.order = _sort?.order;
      } else {
        print(
            "selected sort1 ${_sort?.text} and value ${_sort?.value}and value ${_sort?.order}");
        _request.sort = null;
        _request.order = null;
      }
      if (_filter != null) {
        _request.filter = _filter;
      } else {
        _request.filter = null;
      }
      /*     if (_productCategoryType == GlobalData.popular_products) {
        showFilterOption = false;
        _bloc?.add(FetchPopularEvent(_request));
      } else if (_productCategoryType == GlobalData.feature_products) {
        showFilterOption = false;
        _bloc?.add(FetchFeatureEvent(_request));
      } else if (_productCategoryType == GlobalData.best_products) {
        showFilterOption = false;
        _bloc?.add(FetchBestEvent(_request));
      } else if (_productCategoryType == GlobalData.latest_products) {
        showFilterOption = false;
        _bloc?.add(FetchLatestEvent(_request));
      } else if (_productCategoryType == GlobalData.custom_collection) {
        _bloc?.add(FetchCustomCollection(_request));
      } */
      if (_productCategoryType == GlobalData.home_page_carousel) {
        showFilterOption = false;
        _bloc?.add(FetchCarouselsEvent(_request));
      } else {
        if (home == true) {
          print("dftefefynb");
          showFilterOption = true;
          _bloc?.add(FetchCatalogBrandEvent(_request));
          //_bloc?.add(FetchProductSearchEvent("1", "10", "432","FA4362","","","","06079d9251add5856d6f729a3c",""));
        } else if (products == "fromProductSearch") {
          print("dftycdnb");
          showFilterOption = true;
          // _bloc?.add(FetchCatalogBrandEvent(_request));
          _bloc?.add(FetchProductSearchEvent(
              "${_page.toString()}",
              "15",
              AppSizes.deviceWidth.toInt().toString(),
              "$label",
              "",
              "",
              "",
              "$currentToken",
              ""));
        } else {
          print("dftdevrvrynb");
          _bloc?.add(FetchCatalogEvent(_request));
        }
      }
      _bloc?.add(LoadingEvent());
      label = widget.arguments[labelKey];
    });
  }

  bool hasMoreData() {
    var total = 0;
    if (_productCategoryType == GlobalData.popular_products ||
        _productCategoryType == GlobalData.feature_products ||
        _productCategoryType == GlobalData.latest_products ||
        _productCategoryType == GlobalData.best_products ||
        _productCategoryType == GlobalData.home_page_carousel) {
      total = int.parse(_model?.productTotal ?? "0");
      print("wde");
    } else if (_model == null ||
        _model?.categoryData == null ||
        _model?.categoryData?.productTotal == null) {
      print("wdeerty");
      total = int.tryParse(
              (_manufactureModel?.manufacturers?.productTotal ?? "0")) ??
          0;
    } else {
      print("wdeerdettty");
      print("productTotal${_model?.categoryData?.productTotal}");
      total = int.tryParse((_model?.categoryData?.productTotal ?? "0")) ?? 0;
      _page += 1;
      _callAPI();
    }
    // return (total > _products.length && !_loading);
    return (total > _tempProductsList.length && !_loading);
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("hhrhr -- ${widget.arguments}");
    return BlocBuilder<CatalogScreenBloc, CatalogScreenState>(
      builder: (ctx, currentState) {
        if (currentState is CatalogInitialState) {
          _loading = true;
        } else if (currentState is CatalogFetchState) {
          _model = currentState.model;
          if (_productCategoryType == GlobalData.home_page_carousel ||
              _productCategoryType == GlobalData.custom_collection) {
            processProductList(_model?.products ?? [], currentState.isFromDb);
            print("objectdsbfndmgh,j   ${_model?.byDefultSelected ?? ''}");
            _sorts = _model?.sorts ?? [];
            _filterGroups = _model?.filterGroups ?? [];
          } else {
            processProductList(
                _model?.categoryData?.products ?? [], currentState.isFromDb);
            _sorts = _model?.categoryData?.sorts ?? [];
            _filterGroups = _model?.moduleData?.filterGroups ?? [];
          }
          _loading = false;
        } else if (currentState is AddProductToCartStateSuccess) {
          print("AddProductToCartStateSuccess ................");
          _markProductAddedToCart(currentState.productId);
          ProductCartStatusController.markAdded(currentState.productId);
          AppSharedPref.setCartCount(currentState.baseModel.cartTotal);
          _bloc?.emit(WishlistIdleState());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
          });
        } else if (currentState is BrandFetchState) {
          _manufactureModel = currentState.manufactureModel;
          processProductList(
              _manufactureModel?.manufacturers?.products ?? <Product>[],
              currentState.isFromDb);
          _filterGroups = _manufactureModel?.moduleData?.filterGroups ?? [];
          _sorts = _manufactureModel?.manufacturers?.sort ?? [];
          _loading = false;
        } else if (currentState is ProductSearchModelState) {
          _productSearchModel = currentState.productSearchModel;
          processProductList(
              _productSearchModel?.products ?? <Product>[], false);
          _filterGroups = _productSearchModel?.filterGroups ?? [];
          _sorts = _productSearchModel?.sorts ?? [];
          _loading = false;
        } else if (currentState is ChangeViewState) {
          _isGrid = currentState.isGrid;
        } else if (currentState is AddProductToWishlistStateSuccess) {
          print("AddProductToWishlistStateSuccess ................");
          _loading = false;
          isWishlistState = true;
          _bloc?.emit(WishlistIdleState());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              if (productId != "-1" && index1 != -1) {
                _products[index1!].wishlistStatus =
                    currentState.wishListModel.wishliststatus;
                productId = "0";
                index1 = 0;
              }
            });
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
          });
        } else if (currentState is CatalogErrorState) {
          _loading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        }
        return Scaffold(
          appBar: commonAppBar(
              (_model?.title?.trim().isNotEmpty ?? false)
                  ? _model!.title!.trim()
                  : (label == null
                      ? AppStringConstant.products.localized()
                      : label ?? ""),
              isHomeEnable: false,
              isLeadingEnable: false,
              context),
          body: buildUI(),
        );
      },
    );
  }

  Widget buildUI() {
    print("hhrhr2wedwdedefe -- ${_model?.title?.trim()}");
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            if (_productCategoryType != GlobalData.custom_collection &&
                _products.isNotEmpty)
              Center(child: topContainer()),
            //widgetSpace(0, AppSizes.size8),
            Visibility(
              visible: _products.isNotEmpty,
              child: Expanded(child: getProductView()),
            ),
            Visibility(
              visible: _products.isEmpty && !_loading,
              child: Expanded(
                child: Center(
                  child: CommonEmptyCard(
                    imagePath: AppImages.noProduct,
                    title: _localizations
                            ?.translate(AppStringConstant.noProductFound) ??
                        '',
                    subtitle: _localizations
                            ?.translate(AppStringConstant.adjustingFilters) ??
                        '',
                    showButton: false,
                    showButtonText: true,
                    buttonText:
                        _localizations?.translate(AppStringConstant.goToHome) ??
                            '',
                    onButtonPressed: () {
                      if (widget.arguments[productSearch] ==
                          "fromProductSearch") {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pop();
                        //BottomTabController.check.countController?.sink.add(0);
                      }
                      // Navigator.of(context).pushNamedAndRemoveUntil(
                      //   /*MaterialPageRoute(
                      //       builder: (context) => const BottomTabbarWidget(),
                      //     ),*/
                      //   AppRoute.bottomTabBAr,
                      //       (route) => false,
                      // );
                    },
                  ),
                ),
              ),
            )
          ],
        ),
        Visibility(
          visible: _loading,
          child: const Loader(),
        ),
      ],
    );
  }

  Widget getProductView() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    if (isTablet) {
      return CatalogGridView(
        products: _products,
        controller: _scrollController,
        bloc: _bloc,
        localizations: _localizations,
        byDefultSelected: _model?.byDefultSelected ??
            _model?.categoryData?.byDefultSelected ??
            _manufactureModel?.manufacturers?.byDefultSelected ??
            _productSearchModel?.byDefultSelected ??
            "",
        addProductToWishList: (value, index) {
          productId = value;
          index1 = index;
          _bloc?.add(AddToWishlistEvent(value, "", ""));
        },
      );
    }

    if (_isGrid) {
      return CatalogMobileGridView(
        products: _products,
        controller: _scrollController,
        bloc: _bloc,
        localizations: _localizations,
        byDefultSelected: _model?.byDefultSelected ??
            _model?.categoryData?.byDefultSelected ??
            _manufactureModel?.manufacturers?.byDefultSelected ??
            _productSearchModel?.byDefultSelected ??
            "",
        addProductToWishList: (value, index) {
          productId = value;
          index1 = index;
          _bloc?.add(AddToWishlistEvent(value, "", ""));
        },
      );
    }

    return CatalogListView(
        products: _products,
        byDefultSelected: _model?.byDefultSelected ??
            _model?.categoryData?.byDefultSelected ??
            _manufactureModel?.manufacturers?.byDefultSelected ??
            _productSearchModel?.byDefultSelected ??
            "",
        bloc: _bloc,
        controller: _scrollController,
        localizations: _localizations,
        addProductToWishList: (value, index) {
          productId = value;
          index1 = index;
          _bloc?.add(AddToWishlistEvent(value, "", ""));
        });
  }

  Widget topContainer() {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final canShowCatalogActions =
        widget.arguments[productSearch] != "fromProductSearch";
    final showFilter = canShowCatalogActions && _filterGroups.isNotEmpty;
    final showSort = canShowCatalogActions && _sorts.isNotEmpty;
    final showFilterSort = showFilter || showSort;
    final showViewToggle = !isTablet;

    if (!showFilterSort && !showViewToggle) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
          color: AppColors.dividerColor, // Set your desired color
          width: 1.0, // Set border thickness
        )),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              if (showFilter)
                iconButton(
                  AppImages.filterIcon,
                  AppStringConstant.filter.localized(),
                  () {
                    if (_filterGroups.isEmpty == true) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        AlertMessage.showWarning(
                            AppStringConstant.filterOptionsNotAvailable
                                .localized(),
                            context);
                      });
                      return;
                    }
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(),
                        builder: (ctx) => DraggableScrollableSheet(
                            expand: true,
                            maxChildSize: 1,
                            initialChildSize: 0.968, // starts at 95% height
                            builder: (context, scrollController) {
                              return SafeArea(
                                child: FilterBottomSheet(
                                  _filterGroups,
                                  () {
                                    Navigator.of(context).pop();
                                    _filter = "";
                                    for (var element in _filterGroups) {
                                      element.filter?.forEach((filter) {
                                        if (filter.selected == true) {
                                          _filter =
                                              "$_filter,${filter.filterId}";
                                        }
                                      });
                                    }

                                    if (_filter?.isNotEmpty == true) {
                                      _filter = _filter?.substring(1);
                                    } else {
                                      _filter = null;
                                    }
                                    _page = 1;
                                    _products = [];
                                    _callAPI();

                                    _filter?.isNotEmpty == true
                                        ? _filterApplied = true
                                        : _filterApplied = false;
                                  },
                                  _filter,
                                ),
                              );
                            }));
                  },
                  _filterApplied,
                ),

              //sort
              if (showSort)
                iconButton(
                  AppImages.sortIcon,
                  _localizations?.translate(AppStringConstant.sort) ?? '',
                  () {
                    if (_sorts.isEmpty == true) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        AlertMessage.showWarning(
                            AppStringConstant.sortOptionsNotAvailable
                                .localized(),
                            context);
                      });
                      return;
                    }
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(),
                      builder: (ctx) => DraggableScrollableSheet(
                        expand: true,
                        initialChildSize: 0.97, // starts at 95% height
                        minChildSize: 0.5,
                        maxChildSize: 1,
                        builder: (context, scrollController) {
                          return SortBottomSheet(
                            _sorts,
                            (sort) {
                              Navigator.of(context).pop();
                              _sort = sort;
                              _page = 1;
                              _products = [];
                              _callAPI();

                              _sortApplied = true;
                            },
                            selected: _sort,
                          );
                        },
                      ),
                    );
                  },
                  _sortApplied,
                ),
              if (!showFilterSort) const Spacer(),
              if (showViewToggle)
                showFilterSort
                    ? viewButton()
                    : SizedBox(
                        width: AppSizes.size126, child: viewButton(false)),
            ],
          ),
          // widgetDivider(context, 0.5),
        ],
      ),
    );
  }

  Widget viewButton([bool expanded = true]) {
    final child = Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => _bloc?.add(ChangeViewEvent(!_isGrid)),
        child: Padding(
          padding: const EdgeInsets.only(
              top: AppSizes.size6,
              bottom: AppSizes.size6,
              left: AppSizes.size12,
              right: AppSizes.size12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                _isGrid ? Icons.view_list : Icons.grid_view,
                size: AppSizes.size24,
                color: AppColors.sortFiltercolor,
              ),
              const SizedBox(width: AppSizes.size8),
              Text(
                _isGrid
                    ? AppStringConstant.list.localized()
                    : AppStringConstant.grid.localized(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppSizes.size14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );

    return expanded ? Expanded(child: child) : child;
  }

  Widget iconButton(String icon, String title, VoidCallback onPressed,
          [bool optional = false]) =>
      Expanded(
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: AppSizes.size6,
                  bottom: AppSizes.size6,
                  left: AppSizes.size12,
                  right: AppSizes.size12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    icon,
                    width: AppSizes.size24,
                    height: AppSizes.size24,
                    color: AppColors.sortFiltercolor,
                  ),
                  const SizedBox(width: AppSizes.size8),
                  Text(title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontSize: AppSizes.size14,
                          fontWeight: FontWeight.w700)),
                  if (optional) const SizedBox(width: AppSizes.size4),
                  if (optional)
                    Container(
                      height: AppSizes.size8,
                      width: AppSizes.size8,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(AppSizes.size4),
                        ),
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );

  void processProductList(List<Product>? products, bool isFromDB) {
    if (_tempProductsList.isNotEmpty) {
      if (isFromDB) {
        _tempProductsList.addAll(products ?? []);
        lsatDbListSize = products?.length ?? 0;
      } else {
        if (lsatDbListSize > 0) {
          var limit = _tempProductsList.length - (lsatDbListSize + 1);
          for (var ins = (_tempProductsList.length - 1); ins > limit; ins--) {
            print(" else outer loop   $ins - $lsatDbListSize - $limit");
            if (ins > limit) {
              print(" else inner if   $ins  - $limit");
              _tempProductsList.removeAt(ins);
            } else {
              break;
            }
          }
        }
        print(products?.length);
        lsatDbListSize = 0;
        print("Page: $_page");
        if (_page == 1) {
          _tempProductsList.clear();
        }
        _tempProductsList.addAll(products ?? []);
      }

      //  processProductList(_model?.products ?? []);
    } else {
      print(" else add all  ");
      _tempProductsList.addAll(products ?? []);
      if (isFromDB) {
        lsatDbListSize = products?.length ?? 0;
      }
    }
    _products = _tempProductsList;
  }

  void _markProductAddedToCart(String productId) {
    if (productId.isEmpty) return;

    final index = _products.indexWhere(
      (product) => product.productId?.toString() == productId,
    );
    if (index == -1) return;

    _products[index].isCartAdded = true;
  }
}
