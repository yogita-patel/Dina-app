import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/screens/quick_cart/bloc/quick_cart_bloc.dart';
import 'package:oc_demo/screens/quick_cart/bloc/quick_cart_state.dart';
import 'package:oc_demo/screens/quick_cart/view/quic_cart_main_view.dart';
import 'package:oc_demo/screens/quick_cart/view/quick_cart_backorder_view.dart';

import '../../common_widgets/CommonEmptyCard.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_order_button.dart';
import '../../common_widgets/image_view.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../main.dart';
import '../../models/address/add_address_request.dart';
import '../../models/base_model.dart';
import '../../models/cart/cart_model.dart';
import '../../models/productDetail/product_detail_screen_model.dart';
import '../../models/searchModel/search_model.dart';
import '../../models/wishlist/get_wish_list.dart';
import '../cart/cart_popup_logic.dart';
import '../cart/widgets/price_details.dart';
import '../cart/widgets/cart_product_item.dart';
import '../productDetail/Bloc/product_detail_bloc.dart';
import '../productDetail/Bloc/product_detail_repository.dart';
import '../productDetail/product_detail_screen.dart';
import 'bloc/quick_cart_event.dart';
import '../barcode/barcode_scan_screen.dart';

class QuickCartScreen extends StatefulWidget {
  const QuickCartScreen({super.key});

  @override
  State<QuickCartScreen> createState() => _QuickCartScreenState();
}

class _QuickCartScreenState extends State<QuickCartScreen> with RouteAware {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();
  QuickCartBloc? quickCartBloc;
  bool isLoading = true;
  SearchModel? searchData;
  CartModel? _cartModel;
  ProductDetailScreenModel? productPageData;
  AppLocalizations? _localizations;
  SearchData? selectedProduct;
  int? quantityCounter = 1;
  Map<String, dynamic>? selectedProductOptions;
  bool showOptions = false;
  int? cartCount = 0;
  GetWishlist? wishlistModel;
  late FocusNode _searchFocusNode;
  BaseModel? baseModel;
  Timer? timer;
  bool isUserLogin = false;

  @override
  void initState() {
    super.initState();
    quickCartBloc = context.read<QuickCartBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    _initData();

    // AppSharedPref.getCartCount().then((value) {
    //   cartCount = int.parse(value);
    //   TabbarController.countController.sink.add(cartCount ?? 0);
    // });
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
    BottomTabController.check.currentStateUpdateStream.stream.listen(
      (index) {
        if (index == 3) {
          _initData();
        }
      },
    );
  }

  void _initData() {
    AppSharedPref.isLogin().then((value) {
      if (value != isUserLogin) {
        setState(() {
          isUserLogin = value;
        });
      }
    });

    quickCartBloc?.add(const FetchCartEvent());
    AppSharedPref.getCartCount().then((value) {
      cartCount = int.parse(value);
      TabbarController.countController.sink.add(cartCount ?? 0);
    });
  }

  @override
  void dispose() {
    print("Initial Rishabh in pop dispose");
    _searchFocusNode.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    print("Initial Rishabh in pop next");
    super.didPopNext();
    _searchController.clear();
    _searchFocusNode.unfocus();
    // This is called when coming back to this screen
    isLoading = true;
    searchData = null;
    _initData();
    // quickCartBloc?.add(WishlistDataFetchEvent());
  }

  List<SearchData> get _visibleSearchSuggestions =>
      (searchData?.searchData ?? []).take(4).toList();

  bool get _showViewAllSearchResults =>
      (searchData?.searchData?.length ?? 0) > _visibleSearchSuggestions.length;

  void _openSearchResults(String searchKey) {
    final trimmedSearchKey = searchKey.trim();
    if (trimmedSearchKey.isEmpty) {
      return;
    }

    final formattedTag =
        '${trimmedSearchKey[0].toUpperCase()}${trimmedSearchKey.substring(1)}';
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushNamed(
      AppRoute.catalog,
      arguments: categoryMap(
        trimmedSearchKey,
        formattedTag,
        "",
        "fromProductSearch",
        false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Initial Rishabh${isUserLogin}");
    return BlocBuilder<QuickCartBloc, QuickCartState>(
        builder: (context, currentState) {
      print(currentState);
      if (currentState is QuickCartInitialState) {
        isLoading = true;
        print("Initial Rishabh");
      } else if (currentState is QuickCartScreenSuccess) {
        searchData = currentState.model;
        isLoading = false;
        // quickCartBloc?.emit(QuickCartActionState());
      } else if (currentState is ProductDetailStateSuccess) {
        print("Rosuabh ${productPageData?.name}");
        showOptions = true;
        isLoading = false;
        productPageData = currentState.productDetailScreenModel;
      } else if (currentState is AddProductToCartStateSuccess) {
        AppSharedPref.setCartCount(currentState.baseModel.cartTotal ?? '0');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              currentState.baseModel.message ?? '', context);
        });
        quickCartBloc?.emit(QuickCartEmptyState());
        AppSharedPref.getCartCount().then((value) {
          if (value != null) {
            TabbarController.countController.sink.add(int.parse(value) ?? 0);
          }
        });
      } else if (currentState is CartScreenSuccess) {
        isLoading = false;
        _cartModel = currentState.data;
        AppSharedPref.setCartCount(
            (_cartModel?.cart?.totalProducts ?? 0).toString());
        quickCartBloc?.add(WishlistDataFetchEvent());
      } else if (currentState is WishlistScreenSuccess) {
        isLoading = false;
        wishlistModel = currentState.wishlistModel;
      } else if (currentState is UpdateCartSuccess) {
        baseModel = currentState.data;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(currentState.data.message ?? '', context);
        });
        quickCartBloc?.add(const FetchCartEvent());
      } else if (currentState is RemoveItemSuccess) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              currentState.baseModel?.message ?? '', context);
        });
        quickCartBloc?.add(WishlistDataFetchEvent());
      } else if (currentState is RemoveCartItemSuccess) {
        baseModel = currentState.data;
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(currentState.data.message ?? '', context);
        });
        quickCartBloc?.add(const FetchCartEvent());
      } else if (currentState is AddProductToWishlistStateSuccess) {
        quickCartBloc?.add(CartScreenRemoveItemEvent(currentState.key ?? ""));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(
              currentState.wishListModel.message ?? '', context);
        });
      } else if (currentState is QuickCartScreenError) {
        isLoading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(currentState.message, context);
        });
      } else if (currentState is MoveToCartSuccess) {
        isLoading = true;
        quickCartBloc?.add(const FetchCartEvent());
      }
      return _buildUi();
    });
  }

  Widget _buildUi() {
    print(selectedProduct?.productId);
    return Scaffold(
        appBar: commonAppBar(
            _localizations?.translate(AppStringConstant.quickOrder) ?? '',
            context,
            isLeadingEnable: true),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size8, vertical: AppSizes.size4),
                    height: AppSizes.size40,
                    decoration: BoxDecoration(
                      color: AppColors.searchBackGroundColor,
                      // Light grey background
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            readOnly: false,
                            focusNode: _searchFocusNode,
                            controller: _searchController,
                            maxLines: 1,
                            onTap: () {
                              if ((searchData?.searchData ?? []).isEmpty) {
                                quickCartBloc
                                    ?.add(const QuickCartSuggestionEvent(""));
                              }
                            },
                            onChanged: (searchKey) {
                              if (searchKey.isEmpty) {
                                (searchData?.searchData ?? []).clear;
                                _searchFocusNode.unfocus();
                                _searchController.clear();
                                return;
                              }
                              if ((timer?.isActive ?? false)) {
                                timer?.cancel();
                              }
                              timer = Timer(
                                const Duration(milliseconds: 500),
                                () {
                                  quickCartBloc?.add(
                                      QuickCartSuggestionEvent(searchKey));
                                },
                              );
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: _localizations?.translate(
                                      AppStringConstant.addProduct) ??
                                  '',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.searchText),
                            ),
                            style: Theme.of(context).textTheme.bodyLarge,
                            cursorColor:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            startBarcodeRecognition();
                            // DialogHelper.searchDialog(
                            //   context,
                            //   _localizations,
                            //   () => startImageRecognition(searchImage),
                            //   () => startImageRecognition(searchText),
                            //   onBarcodeTap: () =>
                            //       startBarcodeRecognition(),
                            // );
                          },
                          icon: Image.asset(
                              height: AppSizes.size24,
                              width: AppSizes.size24,
                              AppImages.searchScanIcon,
                              color: AppColors.searchText),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _searchController.text.isNotEmpty,
                    child: (!isLoading &&
                            (searchData?.searchData ?? []).isNotEmpty)
                        ? Column(
                            children: [
                              ListView.builder(
                                itemCount: _visibleSearchSuggestions.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                // ? 10
                                // : searchData!.searchData?.leng
                                itemBuilder: (context, index) {
                                  final data = _visibleSearchSuggestions[index];
                                  return InkWell(
                                    // onTap: () {
                                    //   _searchController.clear();
                                    //   FocusScope.of(context).unfocus();
                                    //   showModalBottomSheet(
                                    //     context: context,
                                    //     backgroundColor: Colors.white,
                                    //     shape: const RoundedRectangleBorder(
                                    //       borderRadius: BorderRadius.vertical(
                                    //           top: Radius.circular(16)),
                                    //     ),
                                    //     builder: (context) => BlocProvider(
                                    //       create: (context) => ProductDetailBloc(
                                    //           repository:
                                    //               ProductDetailRepositoryImp()),
                                    //       child: ProductDetailScreen({
                                    //         "productId":
                                    //             data?.productId ?? "",
                                    //       }, true),
                                    //     ),
                                    //   );
                                    // },
                                    onTap: () {
                                      _searchController.clear();
                                      FocusScope.of(context).unfocus();
                                      showModalBottomSheet(
                                        context: context,
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16)),
                                        ),
                                        builder: (context) => BlocProvider(
                                          create: (context) => ProductDetailBloc(
                                              repository:
                                                  ProductDetailRepositoryImp()),
                                          child: ProductDetailScreen({
                                            "productId": data.productId ?? "",
                                          }, true),
                                        ),
                                      ).then((value) {
                                        // Modal close hone ke baad chalega
                                        // setState(() {
                                        //   isLoading = true;
                                        //   searchData = null;
                                        // });
                                        print("defmfgrthy");
                                        quickCartBloc
                                            ?.add(const FetchCartEvent());
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        border: const Border(
                                            bottom: BorderSide(
                                          color: AppColors.dividerColor,
                                          // Set your desired color
                                          width: 1.0, // Set border thickness
                                        )),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: AppSizes.size2,
                                                bottom: AppSizes.size8,
                                                left: AppSizes.size8,
                                                right: AppSizes.size8),
                                            child: Row(
                                              children: <Widget>[
                                                Stack(children: <Widget>[
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top:
                                                                AppSizes.size8),
                                                    alignment: Alignment.center,
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              AppSizes.size4),
                                                      // space between image and border
                                                      decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        border: Border.all(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: AppSizes.size1,
                                                        ),
                                                      ),
                                                      child: ImageView(
                                                        url: data.thumb ?? '',
                                                        height: AppSizes.size88,
                                                        width: AppSizes.size88,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                                const SizedBox(
                                                  width: AppSizes.size10,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom:
                                                              AppSizes.size4,
                                                        ),
                                                        child: Text(
                                                          data.name ?? "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColorDark),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          bottom:
                                                              AppSizes.size4,
                                                        ),
                                                        child: Text(
                                                          data.productCode ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          softWrap: true,
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge
                                                                  ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (_showViewAllSearchResults) ...[
                                const SizedBox(height: AppSizes.size24),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.size16),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: AppSizes.size48,
                                    child: ElevatedButton(
                                      onPressed: () => _openSearchResults(
                                          _searchController.text),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            MobikulTheme.primaryColor,
                                        foregroundColor:
                                            Theme.of(context).cardColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.size8),
                                        ),
                                      ),
                                      child: const Text(
                                        "View All Search Results",
                                        style: TextStyle(
                                          fontSize: AppSizes.size16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSizes.size24),
                              ],
                            ],
                          )
                        : const SizedBox(),
                  ),
                  if (_cartModel?.cart?.products == null &&
                      wishlistModel?.wishlistData == null)
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      alignment: Alignment.center,
                      child: CommonEmptyCard(
                        imagePath: AppImages.quick_empty,
                        title: _localizations?.translate(
                                AppStringConstant.noItemInQuickOrder) ??
                            '',
                        subtitle: _localizations?.translate(
                                AppStringConstant.quickSubHeading) ??
                            '',
                        showButton: false,
                        showButtonText: false,
                        // buttonText: _localizations?.translate(
                        //         AppStringConstant.startAddingProdcut) ??
                        //     '',
                        onButtonPressed: () {
                          // if (!isUserLogin) {
                          //   await Navigator.of(context)
                          //       .pushNamed(
                          //     AppRoute.login,
                          //     arguments:
                          //         getSignInSignUpPageArgument(false, false),
                          //   )
                          //       .then((value) async {
                          //     if (!mounted) return;
                          //     print("wdergrhtghyt");
                          //     final isLoggedIn = await AppSharedPref.isLogin();
                          //     if (isLoggedIn) {
                          //       setState(() {
                          //         isUserLogin = true;
                          //       });
                          //     }
                          //     quickCartBloc?.add(const FetchCartEvent());
                          //   });
                          // } else {
                          //   BottomTabController.check.countController?.sink
                          //       .add(0);
                          // }
                          // BottomTabController.check.countController?.sink.add(0);
                          // Navigator.of(context).pushNamedAndRemoveUntil(
                          //   AppRoute.bottomTabBAr,
                          //       (route) => false,
                          // );
                        },
                      ),
                    )
                  else ...[
                    _cartModel?.cart?.products != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSizes.size4),
                            child: Container(
                              color: Theme.of(context).cardColor,
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide.none,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none,
                                ),
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.size8),
                                title: Text(
                                  "${(_localizations?.translate(AppStringConstant.quickOrderBasket) ?? "")} (${_cartModel?.cart?.weight})",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    child: QuickCartMainView(
                                      _cartModel,
                                      _localizations,
                                      quickCartBloc,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : CommonEmptyCard(
                            imagePath: AppImages.cartEmpty,
                            title: _localizations?.translate(
                                    AppStringConstant.cartEmptyTitle) ??
                                '',
                            subtitle: _localizations?.translate(
                                    AppStringConstant.cartEmptySubtitle) ??
                                '',
                            showButton: true,
                            showButtonText: false,
                            buttonText: _localizations?.translate(
                                    AppStringConstant.startShopping) ??
                                '',
                            onButtonPressed: () {
                              BottomTabController.check.countController?.sink
                                  .add(0);
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   AppRoute.bottomTabBAr,
                              //       (route) => false,
                              // );
                            },
                          ),
                    if (_cartModel?.cart?.products != null)
                      const Divider(
                        thickness: 1,
                      ),
                    if (_cartModel?.cart?.totals != null) ...[
                      PriceDetails(
                        totals: _cartModel?.cart?.totals,
                        localizations: _localizations,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: commonOrderButton(
                            context,
                            _localizations,
                            getTotalAmount().toStringAsFixed(2),
                            _localizations?.translate(
                                    AppStringConstant.confirmOrder) ??
                                "", () async {
                          GlobalData.cartTotal =
                              getTotalAmount().toStringAsFixed(2);

                          // Check for out of stock items
                          final outOfStockItems = cartPopupOutOfStockProducts(
                              _cartModel?.cart?.products);

                          if (outOfStockItems.isNotEmpty) {
                            _showOutOfStockDialog(context, outOfStockItems);
                            return;
                          }

                          if (_cartModel?.cart?.errorWarning?.isNotEmpty ==
                                  true &&
                              (_cartModel?.cart?.checkoutEligible ?? 0) == 0) {
                            AlertMessage.showWarning(
                                _cartModel?.cart?.errorWarning ?? "", context);
                            return;
                          }

                          Navigator.of(context).pushNamed(AppRoute.shipping,
                              arguments: getShippingPageArgument(
                                  AddAddressRequest(), "", false));
                        }),
                      ),
                    ],
                    const Divider(
                      thickness: 1,
                    ),
                    wishlistModel?.wishlistData != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: AppSizes.size4),
                            child: Container(
                              color: Theme.of(context).cardColor,
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                shape: const RoundedRectangleBorder(
                                  side: BorderSide.none,
                                ),
                                collapsedShape: const RoundedRectangleBorder(
                                  side: BorderSide.none,
                                ),
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.size16),
                                title: Text(
                                  "${(_localizations?.translate(AppStringConstant.backorders) ?? "")} ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .color,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                children: [
                                  WishListView(
                                      products: wishlistModel?.wishlistData,
                                      localizations: _localizations,
                                      onDeleteClick: (productId) {
                                        quickCartBloc?.add(
                                            RemoveItemEvent(productId ?? ""));
                                      },
                                      onMoveToCartClick:
                                          (productId, quantity, UnitofSale) {
                                        quickCartBloc?.add(MoveToCartEvent(
                                            productId ?? "",
                                            quantity ?? "",
                                            "",
                                            UnitofSale ?? ""));
                                      })
                                ],
                              ),
                            ),
                          )
                        : CommonEmptyCard(
                            imagePath: AppImages.noBackorder,
                            title: _localizations?.translate(
                                    AppStringConstant.noBackorderFound) ??
                                '',
                            subtitle: _localizations?.translate(
                                    AppStringConstant.onceBackorderAvailable) ??
                                '',
                            showButton: false,
                            showButtonText: false,
                            buttonText: _localizations?.translate(
                                    AppStringConstant.startShopping) ??
                                '',
                            onButtonPressed: () {
                              BottomTabController.check.countController?.sink
                                  .add(0);
                              // Navigator.of(context).pushNamedAndRemoveUntil(
                              //   AppRoute.bottomTabBAr,
                              //       (route) => false,
                              // );
                            },
                          ),
                  ],
                ],
              ),
            ),
            Visibility(visible: isLoading, child: const Loader()),
          ],
        ));
  }

  void _showOutOfStockDialog(BuildContext context, List<Products> items) {
    var visibleProducts = List<Products>.from(items);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setDialogState) {
          void showPopupMessage(String? message, {bool isError = false}) {
            if (message?.isNotEmpty != true) return;
            if (isError) {
              AlertMessage.showError(message ?? "", dialogContext);
            } else {
              AlertMessage.showSuccess(message ?? "", dialogContext);
            }
          }

          Future<void> refreshVisibleProducts(
              Future<List<Products>> latestProductsFuture) async {
            final latestProducts = await latestProductsFuture;
            if (!mounted || !ctx.mounted) return;
            if (latestProducts.isEmpty) {
              Navigator.pop(ctx);
              return;
            }
            final remainingProducts = cartPopupRetainedOutOfStockProducts(
              visibleProducts,
              latestProducts,
            );
            if (remainingProducts.isEmpty) {
              Navigator.pop(ctx);
              return;
            }
            setDialogState(() {
              visibleProducts = remainingProducts;
            });
          }

          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.red, size: 28),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Out of Stock Items",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close, color: Colors.black54),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "The following products below are out of stock. Please either remove them or add them to your Backorder to be notified once they arrive in stock.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: visibleProducts.asMap().entries.map((entry) {
                          final index = entry.key;
                          final product = entry.value;
                          final isLast = index == visibleProducts.length - 1;

                          return CartProductItem(
                            key: ObjectKey(product),
                            product,
                            _localizations,
                            quickCartBloc,
                            1,
                            () => refreshVisibleProducts(
                                _updateCartFromOutOfStockDialog()),
                            () => refreshVisibleProducts(
                                _deleteFromOutOfStockDialog(
                                    product, showPopupMessage)),
                            () => refreshVisibleProducts(
                                _addBackorderFromOutOfStockDialog(
                                    product, showPopupMessage)),
                            (_) {},
                            index,
                            isLastItem: isLast,
                            forceShowBackorderButton: true,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Products>> _addBackorderFromOutOfStockDialog(Products product,
      void Function(String?, {bool isError}) showMessage) async {
    final wishListModel = await quickCartBloc?.repository?.addProductToWishList(
      product.productId ?? "",
      product.quantity ?? "1",
      product.UnitofSalenew?.toString() ?? "1",
    );

    if (wishListModel != null && wishListModel.error != 1) {
      await quickCartBloc?.repository?.removeItemFromCart(product.key ?? "");
      showMessage(wishListModel.message);

      final latestCart = await quickCartBloc?.repository?.getCartData();
      if (latestCart != null) {
        setState(() {
          _cartModel = latestCart;
        });
        AppSharedPref.setCartCount(
            (latestCart.cart?.totalProducts ?? 0).toString());
        TabbarController.countController.sink
            .add(latestCart.cart?.totalProducts ?? 0);
        quickCartBloc?.add(WishlistDataFetchEvent());
        return cartPopupOutOfStockProducts(latestCart.cart?.products);
      }
    } else if (wishListModel?.message?.isNotEmpty == true) {
      showMessage(wishListModel?.message, isError: true);
    }

    quickCartBloc?.add(const FetchCartEvent());
    return cartPopupOutOfStockProducts(_cartModel?.cart?.products);
  }

  Future<List<Products>> _deleteFromOutOfStockDialog(Products product,
      void Function(String?, {bool isError}) showMessage) async {
    final removeModel =
        await quickCartBloc?.repository?.removeItemFromCart(product.key ?? "");

    if (removeModel?.message?.isNotEmpty == true) {
      showMessage(removeModel?.message);
    }

    final latestCart = await quickCartBloc?.repository?.getCartData();
    if (latestCart != null) {
      setState(() {
        _cartModel = latestCart;
      });
      AppSharedPref.setCartCount(
          (latestCart.cart?.totalProducts ?? 0).toString());
      TabbarController.countController.sink
          .add(latestCart.cart?.totalProducts ?? 0);
      return cartPopupOutOfStockProducts(latestCart.cart?.products);
    }

    quickCartBloc?.add(const FetchCartEvent());
    return cartPopupOutOfStockProducts(_cartModel?.cart?.products);
  }

  Future<List<Products>> _updateCartFromOutOfStockDialog() async {
    final uri = Uri.parse(
        'https://www.dinainternational.co.uk/index.php?route=api/wkrestapi/cart/updateCart');
    final payload = {
      "quantity": _getCartQuantityJson(),
      "UnitofSalenew": _getCartUnitOfSalesJson(),
      "wk_token": await AppSharedPref.getWkToken()
    };

    final request = Request('POST', uri)
      ..headers['Content-Type'] = 'application/json'
      ..body = json.encode(payload);

    final response = await request.send();
    if (response.statusCode == 200) {
      final latestCart = await quickCartBloc?.repository?.getCartData();
      if (latestCart != null) {
        setState(() {
          _cartModel = latestCart;
        });
        AppSharedPref.setCartCount(
            (latestCart.cart?.totalProducts ?? 0).toString());
        TabbarController.countController.sink
            .add(latestCart.cart?.totalProducts ?? 0);
        return cartPopupOutOfStockProducts(latestCart.cart?.products);
      }
    }
    quickCartBloc?.add(const FetchCartEvent());
    return cartPopupOutOfStockProducts(_cartModel?.cart?.products);
  }

  Map<String, int> _getCartQuantityJson() {
    final jsonMap = <String, int>{};
    _cartModel?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] = int.tryParse(element.quantity ?? "0") ?? 0;
    });
    return jsonMap;
  }

  Map<String, int> _getCartUnitOfSalesJson() {
    final jsonMap = <String, int>{};
    _cartModel?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] =
          int.tryParse(element.UnitofSalenew?.toString() ?? "0") ?? 0;
    });
    return jsonMap;
  }

  void startBarcodeRecognition() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const BarcodeScanScreen()),
    );
    if (result != null && result is String) {
      _searchController.text = result;
      quickCartBloc?.add(QuickCartSuggestionEvent(result));
    }
  }

  double getTotalAmount() {
    double total = 0.0;
    _cartModel?.cart?.totals?.forEach((element) {
      if (element.title?.toLowerCase().contains("total") == true) {
        String text = element.text ?? "0";
        text = text.replaceAll(RegExp(r'[^0-9.]'), '');
        total = double.tryParse(text) ?? 0.0;
      }
    });
    return total;
  }

  String searchImage = "imageSearch";
  String searchText = "textSearch";
  var methodChannel = const MethodChannel(AppConstant.channelName);

  Future<String> startImageRecognition(String type) async {
    try {
      String data = await methodChannel.invokeMethod(type);
      if (!mounted) return data;
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      textEditingController.text = data;
      isLoading = true;
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(data, data, "", "fromProductSearch", false),
      );
      return data;
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }
  //
  //   try {
  //     final wk = await AppSharedPref.getWkToken();
  //     final client = ApiClient();
  //     final resp = await client.barcodeSearch(result, wk);
  //     final items = resp.searchData ?? [];
  //     if (items.isEmpty) {
  //       AlertMessage.showError(_localizations?.translate("noProductFound") ?? "No product found", context);
  //       return;
  //     }
  //
  //     if (items.length == 1) {
  //       final data = items.first;
  //       Navigator.of(context).pushNamed(
  //         AppRoute.productPage,
  //         arguments: getProductDataAttributeMap(data.name ?? "", data.productId ?? ""),
  //       );
  //       return;
  //     }
  //
  //     // multiple results -> go to catalog
  //     _searchController.text = result;
  //     isLoading = true;
  //     quickCartBloc?.add(QuickCartSuggestionEvent(result));
  //     Navigator.of(context).pushNamed(
  //       AppRoute.catalog,
  //       arguments: categoryMap(
  //         result,
  //         result,
  //         "",
  //         "fromProductSearch",
  //         false,
  //       ),
  //     );
  //   } catch (e) {
  //     AlertMessage.showError(e.toString(), context);
  //   }
  // }
}
