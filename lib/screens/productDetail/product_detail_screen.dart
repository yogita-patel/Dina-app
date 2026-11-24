import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';
import 'package:oc_demo/screens/home/widgets/home_page_product_collection_view.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_bloc.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
import 'package:oc_demo/screens/productDetail/Bloc/product_detail_state.dart';
import 'package:oc_demo/screens/productDetail/widget/product_basic_details_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_description_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_detail_image_widget.dart';
import 'package:oc_demo/screens/productDetail/widget/product_tag_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/image_view.dart';
import '../../common_widgets/loader.dart';
import '../../common_widgets/product_status_badges.dart';
import '../../common_widgets/widget_space.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../helper/local_db/floor/database.dart';
import '../../helper/local_db/floor/entities/recent_product_entitie.dart';
import '../../helper/local_db/floor/recent_view_controller.dart';
import '../../hive/hive_constant.dart';
import '../../hive/hive_service.dart';
import '../../models/homPage/home_screen_model.dart';
import '../../utils/helper.dart';
import '../home/widgets/recent_view.dart';
import '../menu/contact_form/contact_form.dart';

class ProductDetailScreen extends StatefulWidget {
  Map<String, dynamic> arguments;
  bool fromQuickCart = false;

  ProductDetailScreen(this.arguments, this.fromQuickCart, {super.key});

  // final ProductDetailScreenModel? product;
  // bool addedToWishlist = false;
  // ProductDetailBloc? productPageBloc;

  // ProductPageBasicDetailsWidget(this.addedToWishlist, this.productPageBloc,
  //     {Key? key, this.product})
  //     : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  ScrollController? _scrollController;
  ProductDetailBloc? productPageBloc; //Product page bloc
  ProductDetailScreenModel? productPageData; //Product detail model reference
  AppLocalizations? _localizations; //
  bool isLoading = false; // Use to show loader
  int? quantityCounter =
  1; // Counter use to increment and decrement product quantity
  int? minimumeCount =
  1; // Counter use to increment and decrement product quantity
  bool? addedToWishlist = false; // variable used to change wishlist icon.
  Map<String, dynamic>?
  selectedProductOptions; // used to store selected custom options data if product have custom options.
  int? cartCount = 0;
  bool isUserLogin = false;
  String? productID;
  bool isScrollingAddToCartButtonVisible = false;
  double visibilityOffset = 0;
  double bottomBarButtonVisibilityOffset = 0;
  String? productId1;
  int? index1;
  String? minipack;
  String? UpdateTempPricevalue = "";
  String? productLoadErrorMessage;
  bool _isCartAddedLocally = false;
  // ignore: cancel_subscriptions
  StreamSubscription? _loginStreamSubscription;
  bool _disposed = false; // Guard against async callbacks after dispose

  @override
  void initState() {
    AppSharedPref.getCartCount().then((value) {
      cartCount = int.parse(value);
      TabbarController.countController.sink.add(cartCount ?? 0);
    });

    productID = widget.arguments[productIdKey];
    productPageBloc = context.read<ProductDetailBloc>();
    //call product detail api
    productPageBloc?.add(GetProductDetailEvent(widget.arguments[productIdKey]));
    _scrollController = ScrollController()..addListener(_scrollListener);

    // Read login state first, THEN set up listener to avoid race condition.
    // _disposed guard prevents a dangling listener if screen is popped before isLogin() resolves.
    AppSharedPref.isLogin().then((loggedIn) {
      if (_disposed || !mounted) return;
      if (loggedIn) {
        setState(() => isUserLogin = true);
      }

      // Set up login stream listener only AFTER we know the current login state
      _loginStreamSubscription = BottomTabController
          .check.updateLoginStreamController.stream
          .listen((event) {
        if (_disposed || !mounted) return;
        if (event && !isUserLogin) {
          // User just logged in from logged-out state — update UI & re-fetch
          setState(() => isUserLogin = true);
          productPageBloc
              ?.add(GetProductDetailEvent(widget.arguments[productIdKey]));
        } else if (event && isUserLogin) {
          // Token refresh fired but user already logged in — no re-fetch needed
          setState(() => isUserLogin = true);
        }
      });
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  void _scrollListener() {
    if (_scrollController?.position.userScrollDirection ==
        ScrollDirection.reverse) {
      print("reveres  $visibilityOffset");
      if (visibilityOffset > 0.0) {
        setState(() {
          isScrollingAddToCartButtonVisible = true;
        });
      }
    }
    if (_scrollController?.position.userScrollDirection ==
        ScrollDirection.forward) {
      print("forward  $visibilityOffset");
      if (visibilityOffset < 1.0) {
        setState(() {
          isScrollingAddToCartButtonVisible = false;
        });
      } /*else if(){

      }*/
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _loginStreamSubscription?.cancel();
    _loginStreamSubscription = null;
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Tags:- ${productPageData?.tags}");
    return Scaffold(
      body: BlocBuilder<ProductDetailBloc, ProductDetailScreenState>(
          builder: (context, currentState) {
            if (currentState is ProductDetailStateInitial) {
              // Initial state to show loader
              isLoading = true;
            } else if (currentState is ProductDetailStateSuccess) {
              /*
            * Success state call when successfully get product detail from server.
            * */
              isLoading = false;
              productLoadErrorMessage = null;
              productPageData = currentState.productDetailScreenModel;
              if (_isCartAddedLocally) {
                productPageData?.isCartAdded = true;
              }
              // final rawPrice = productPageData?.price;
              // final priceString =
              //     rawPrice is String ? rawPrice : rawPrice?.toString();
              // UpdateTempPricevalue =
              //     priceString?.replaceAll(RegExp(r'[^\d.]'), '') ?? "";
              AppSharedPref.setProductId(productPageData?.productId ?? 0);
              AppSharedPref.setProductHasOption(
                  (productPageData?.options?.length ?? 0) > 0);
              addedToWishlist = productPageData?.wishlistStatus;
              if (productPageData?.minimum?.toString().isNotEmpty ?? false) {
                minimumeCount =
                    int.tryParse(productPageData?.minimum.toString() ?? "0") ?? 0;
              }
              // addProductToRecentView(productPageData!);
              AppDatabase.getDatabase().then(
                    (value) => value.recentProductDao
                    .insertRecentProduct(
                  RecentProduct(
                    productId: productPageData?.productId.toString(),
                    name: productPageData?.name,
                    price: isUserLogin ? productPageData?.price : "",
                    image: productPageData?.thumb,
                  ),
                )
                    .then(
                      (value) => RecentViewController.controller.sink
                      .add(productPageData?.productId.toString()),
                ),
              );
            } else if (currentState is AddProductToWishlistStateSuccess) {
              /*
            * Success state call after adding product to wishlist
            * */
              isLoading = false;
              addedToWishlist = currentState.wishListModel.wishliststatus;
              productPageData?.wishlistStatus =
                  currentState.wishListModel.wishliststatus;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.wishListModel.message ?? '', context);
              });
              productPageBloc?.emit(CompleteState());
            } else if (currentState is AddProductCompareSuccessState) {
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(currentState.model.message ?? '', context);
              });
              productPageBloc?.emit(CompleteState());
            } else if (currentState is AddProductToCartStateSuccess) {
              /*
            * Success state call when add product to cart.
            * */
              //  selectedProductOptions?.clear();
              clearDefaultSelectedValue();
              _isCartAddedLocally = true;
              productPageData?.isCartAdded = true;
              ProductCartStatusController.markAdded(
                productPageData?.productId ?? widget.arguments[productIdKey],
              );
              isLoading = false;
              cartCount = int.parse(currentState.baseModel.cartTotal!);
              /*
            * ToDo: currently used this to resolve below issue need to change once get appropriate solution
            *  https://git.webkul.com/pankajtyagi.mobikul528/mobikul_opencart_flutter_demo/-/issues/65
            * */
              productPageBloc?.add(GetProductDetailEvent(
                widget.arguments[productIdKey], /*productPageData?.reserveTag??*/
              ));
              AppSharedPref.setCartCount(currentState.baseModel.cartTotal ?? '0');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.baseModel.message ?? '', context);
              });
              //selectedProductOptions?.clear();
              productPageBloc?.emit(CompleteState());
            } else if (currentState is AddListProductToWishlistStateSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  if (productId1 != "-1" && index1 != -1) {
                    productPageData?.relatedProducts?[index1!].wishlistStatus =
                        currentState.wishListModel.wishliststatus;
                    productId1 = "0";
                    index1 = 0;
                  }
                });
                AlertMessage.showSuccess(
                    currentState.wishListModel.message ?? '', context);
              });
              productPageBloc?.emit(CompleteState());
            } else if (currentState is BuyProductStateSuccess) {
              /*
            * Success state call when when buy product
            * */
              // selectedProductOptions?.clear();
              clearDefaultSelectedValue();
              isLoading = false;
              cartCount = int.parse(currentState.baseModel.cartTotal ?? '0');
              AppSharedPref.setCartCount(currentState.baseModel.cartTotal ?? '0');
              /*
            * ToDo: currently used this to resolve below issue need to change once get appropriate solution
            *  https://git.webkul.com/pankajtyagi.mobikul528/mobikul_opencart_flutter_demo/-/issues/65
            * */
              productPageBloc?.add(GetProductDetailEvent(
                widget.arguments[productIdKey], /*productPageData?.reserveTag??*/
              ));
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.baseModel.message ?? '', context);
                Navigator.pushNamed(context, AppRoute.cart).then((value) {
                  AppSharedPref.getCartCount().then((value) {
                    cartCount = int.parse(value);
                    TabbarController.countController.sink.add(cartCount ?? 0);
                  });
                  setState(() {});
                });
              });
              //selectedProductOptions?.clear();
            } else if (currentState is AddProductReviewStateSuccess) {
              /*
            * Success state call after adding review for the product on server
            * */
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.baseModel.message ?? '', context);
              });
              Navigator.pop(context);
            } else if (currentState is ProductDetailStateError) {
              /*
            * Error state if there is error in api.
            * */
              isLoading = false;
              productPageData = null;
              productLoadErrorMessage =
              (currentState.message?.trim().isNotEmpty ?? false)
                  ? currentState.message?.trim()
                  : 'No product Found';
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showError(productLoadErrorMessage ?? '', context);
              });
            } else if (currentState is UpdateTempPriceState) {
              /*
            * Error state if there is error in api.
            * */
              isLoading = false;
              UpdateTempPricevalue = currentState.formattedPrice ?? "";
              print("defgrgr122 ${productPageData?.price}");
              print("dfgrgrgggh${UpdateTempPricevalue}");

              //if (productPageData?.price != false) {
              //             print("defgrgr122 ${productPageData?.price}");
              //             print("defgrgr1225 ${UpdateTempPricevalue}");
              //             UpdateTempPricevalue = (productPageData?.price ?? "")
              //                 .toString()
              //                 .replaceAll("£", "")
              //                 .replaceAll(",", "")
              //                 .trim();
              //           } else {
              //             print("defgrgr${UpdateTempPricevalue}");
              //             UpdateTempPricevalue = "";
              //           }
            } else if (currentState is CompleteState) {}
            return buildProductDetailUI();
          }),
      // bottomNavigationBar: /*Visibility(
      //   visible:isScrollingAddToCartButtonVisible==false ,
      //   child:ProductDetailAddToCartButtonWidget(
      //     productPageBloc,
      //     productID ?? "0",
      //     quantityCounter ?? 0,
      //     selectedProductOptions,
      //     productPageData?.options,
      //   ),
      // )*/
      //     SafeArea(
      //   child: AnimatedContainer(
      //     duration: const Duration(milliseconds: 0),
      //     height: isScrollingAddToCartButtonVisible
      //         ? 0
      //         : AppSizes.deviceHeight / 11,
      //     child: ProductDetailAddToCartButtonWidget(
      //       productPageBloc,
      //       productID ?? "0",
      //       quantityCounter ?? 0,
      //       selectedProductOptions,
      //       productPageData?.options,
      //       isUserLogin
      //
      //     ),
      //   ),
      // ),
    );
  }

/*
* Method will validate the product page data and render the view accordingly
*
*
* */
  Widget buildProductDetailUI() {
    print("Rishabh mini_pack: ${productPageData?.mini_pack}");
    minipack == productPageData?.mini_pack;
    print("Rishabh carousel: ${productPageData?.carousel?.length}");
    if ((productLoadErrorMessage?.isNotEmpty ?? false) &&
        productPageData == null) {
      return Scaffold(
        appBar: commonAppBar(
          toTitleCase(widget.arguments[productNameKey] ?? " "),
          context,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size24),
              child: Text(
                productLoadErrorMessage ?? 'No product Found',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ),
      );
    }

    // ✅ Guard clause: Don’t show anything if product data not loaded yet
    if (productPageData == null) {
      return Scaffold(
        appBar: commonAppBar(
          toTitleCase(
              productPageData?.name ?? widget.arguments[productNameKey] ?? " "),
          context,
        ),
        body: const SafeArea(
          child: Center(
            child: Loader(), // 👈 Your custom loader widget
          ),
        ),
      );
    }
    final rawData = [
      ['Barcode', '${productPageData?.barcode}'],
      ['Category', '${productPageData?.manufacturer}'],
      ['Carton Per Layer', '${productPageData?.qty_per_layer}'],
      ['Carton Per Pallet', '${productPageData?.qty_per_pallet}'],
      ['Expected', '${productPageData?.expected}'],
      ['Carton Qty', '${productPageData?.carton}'],
      ['Inner Qty', '${productPageData?.inner}'],
      ['Mini Pack', '${productPageData?.mini_pack}'],
      [
        'Approx. Weight',
        productPageData?.weight != null &&
            productPageData!.weight!.isNotEmpty &&
            productPageData!.weight != 'null'
            ? '${double.tryParse(productPageData!.weight!)?.toStringAsFixed(2)} kg'
            : ''
      ],
    ];
    final data =
    rawData.where((item) => (item[1] != '' && item[1] != 'null')).toList();
    const optionItems = [
      "30+ Yrs Experience",
      "1–2 Day Delivery",
      "No Minimum Order",
      "Direct To Trade",
    ];
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: commonAppBar(
        toTitleCase(
            productPageData?.name ?? widget.arguments[productNameKey] ?? " "),
        context,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Stack(
            children: [
              Visibility(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                            child: Column(
                              children: [
                                widget.fromQuickCart
                                    ? const SizedBox()
                                    : Stack(
                                  children: [
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(AppSizes.size0),
                                      child: ProductDetailsImageWidget(
                                          productPageData?.images ?? [],
                                          productPageData?.name ?? "",
                                          bought: productPageData?.bought),
                                    ),
                                    if (getArStatus())
                                      InkWell(
                                        child: const Icon(
                                            Icons.border_clear_rounded),
                                        onTap: () => startArActivity(),
                                      )
                                  ],
                                ),
                                widget.fromQuickCart
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: AppSizes.size16),
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: AppSizes.size8),
                                        padding:
                                        const EdgeInsets.all(AppSizes.size4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                            width: AppSizes.size1,
                                          ),
                                        ),
                                        child: ImageView(
                                          url: productPageData?.thumb ?? '',
                                          height: AppSizes.size88,
                                          width: AppSizes.size88,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: AppSizes.size10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: AppSizes.size4),
                                              child: Text(
                                                productPageData?.name ?? "",
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
                                            const SizedBox(
                                                height: AppSizes.size10),
                                            Row(
                                              children: [
                                                if (productPageData?.price !=
                                                    false)
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: (productPageData
                                                          ?.stock ==
                                                          "Low Stock")
                                                          ? const Color(
                                                          0xFFFFA500)
                                                          : productPageData
                                                          ?.expected !=
                                                          ""
                                                          ? productPageData
                                                          ?.quantity ==
                                                          0
                                                          ? const Color(
                                                          0xFFE7000B)
                                                          : Color(
                                                          0xFF00C48C)
                                                          : productPageData
                                                          ?.quantity !=
                                                          0
                                                          ? Color(
                                                          0xFF00C48C)
                                                          : const Color(
                                                          0xFFE7000B),
                                                      // ? const Color(0xFFE7000B)
                                                      // : const Color(0xFF00C48C),//0xFF00C48C
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          4),
                                                    ),
                                                    child: Text(
                                                      (productPageData?.stock ==
                                                          "Low Stock")
                                                          ? "${productPageData?.stock ?? ''}"
                                                          : productPageData
                                                          ?.expected !=
                                                          ""
                                                          ? productPageData
                                                          ?.quantity ==
                                                          0
                                                          ? productPageData
                                                          ?.expected ??
                                                          ''
                                                          : "In Stock"
                                                          : productPageData
                                                          ?.quantity !=
                                                          0
                                                          ? "In Stock"
                                                          : "Out of Stock",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge
                                                          ?.copyWith(
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color:
                                                          Colors.white),
                                                    ),
                                                  ),
                                                if (productPageData?.price !=
                                                    false)
                                                  const SizedBox(width: 8),
                                                Text(
                                                  productPageData?.model ?? "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                      fontWeight:
                                                      FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                                height: AppSizes.size10),
                                            productPageData?.price != false
                                                ? Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                  bottom:
                                                  AppSizes.size4),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Text(
                                                        //"${productPageData?.price ?? ""}",
                                                        "£$UpdateTempPricevalue",
                                                        style: TextStyle(
                                                          decoration: productPageData
                                                              ?.special ==
                                                              null ||
                                                              productPageData
                                                                  ?.special ==
                                                                  0
                                                              ? TextDecoration
                                                              .none
                                                              : TextDecoration
                                                              .lineThrough,
                                                          fontSize: AppSizes
                                                              .size14,
                                                          fontWeight: (productPageData
                                                              ?.special !=
                                                              null &&
                                                              (productPageData
                                                                  ?.special ??
                                                                  0) >
                                                                  0)
                                                              ? FontWeight
                                                              .w400
                                                              : FontWeight
                                                              .w700,
                                                          color: (productPageData
                                                              ?.special !=
                                                              null &&
                                                              (productPageData?.special ??
                                                                  0) >
                                                                  0)
                                                              ? AppColors
                                                              .darkGray
                                                              : Theme.of(
                                                              context)
                                                              .textTheme
                                                              .titleLarge
                                                              ?.color,
                                                        ),
                                                      ),
                                                      widgetSpace(1,
                                                          AppSizes.size8),
                                                      Text(
                                                        _localizations?.translate(
                                                            AppStringConstant
                                                                .perItem) ??
                                                            '',
                                                        style: Theme.of(
                                                            context)
                                                            .textTheme
                                                            .titleLarge
                                                            ?.copyWith(
                                                            fontWeight:
                                                            FontWeight
                                                                .w400),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                                : const SizedBox(),
                                            // Visibility(
                                            //   visible: ((product?.rating ?? 0) > 0),
                                            //   child: Padding(
                                            //     padding: const EdgeInsets.all(4.0),
                                            //     child: Row(
                                            //       children: List.generate(
                                            //         5,
                                            //             (i) => _buildStar(context, i, (product?.rating ?? 0)),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                    : const SizedBox(),
                                widget.fromQuickCart
                                    ? const SizedBox(
                                  height: 0,
                                )
                                    : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, top: 14.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: (productPageData?.stock ==
                                              "Low Stock")
                                              ? const Color(0xFFFFA500) // Orange
                                              : productPageData?.stock !=
                                              "In Stock"
                                              ? const Color(0xFFE7000B) // Red
                                              : const Color(0xFF00C48C),
                                          // Green
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(productPageData?.stock ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(color: AppColors.white)
                                          // SizedBox(height: AppSizes.size8),

                                        ),
                                      ),
                                      ValueListenableBuilder<Set<String>>(
                                        valueListenable:
                                        ProductCartStatusController
                                            .addedProductIds,
                                        builder: (context, addedProductIds, _) {
                                          if (!ProductCartStatusController.isAdded(
                                            productPageData?.productId,
                                            productPageData?.isCartAdded,
                                            addedProductIds,
                                          )) {
                                            return const SizedBox.shrink();
                                          }

                                          return const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(width: AppSizes.size12),
                                              ProductAddedBadge(
                                                iconSize: AppSizes.size22,
                                                fontSize: AppSizes.size18,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      const SizedBox(width: AppSizes.size8),
                                      Flexible(
                                        child: Text(
                                          "Product Code: ${productPageData?.model}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.end,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                isUserLogin
                                    ? ProductPageBasicDetailsWidget(
                                    addedToWishlist: addedToWishlist ?? false,
                                    productPageBloc: productPageBloc,
                                    product: productPageData,
                                    miniPack: productPageData?.mini_pack ?? "",
                                    carton: productPageData?.carton ?? "",
                                    inner: productPageData?.inner ?? "",
                                    productId: productPageData?.productId ?? 0,
                                    isFromQuickCart: widget.fromQuickCart)
                                    : GestureDetector(
                                  onTap: () async {
                                    await Navigator.of(context).pushNamed(
                                      AppRoute.login,
                                      arguments: getSignInSignUpPageArgument(
                                          false, false),
                                    );

                                    final isLoggedIn =
                                    await AppSharedPref.isLogin();
                                    if (isLoggedIn) {
                                      setState(() {
                                        isUserLogin = true;
                                      });

                                      productPageBloc?.add(GetProductDetailEvent(
                                          widget.arguments[productIdKey]));
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text("LOG IN TO BUY",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(color: AppColors.white)),
                                  ),
                                ),

                                // ProductQuantityDetailsWidget(
                                //     productPageBloc: productPageBloc
                                //   // addedToWishlist ?? false,
                                //   // productPageBloc,
                                //   // product: productPageData,
                                // ),
                                widget.fromQuickCart
                                    ? const SizedBox()
                                    : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: data.map((item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item[0],
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                  AppColors.text_color),
                                            ),
                                            const SizedBox(width: 8),
                                            InkWell(
                                              onTap: () {
                                                item[0] == 'Category'
                                                    ? Navigator.of(context)
                                                    .pushNamed(
                                                  AppRoute.catalog,
                                                  arguments: categoryMap(
                                                    productPageData
                                                        ?.manufacturerId ??
                                                        "",
                                                    productPageData
                                                        ?.manufacturer ??
                                                        "",
                                                    "",
                                                    "",
                                                    true,
                                                  ),
                                                )
                                                    : null;
                                              },
                                              child: Text(
                                                item[1],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                    color: item[0] ==
                                                        'Category'
                                                        ? AppColors
                                                        .bottomBarIconActiveColor
                                                        : AppColors
                                                        .text_color,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            )),
                        widget.fromQuickCart
                            ? const SizedBox()
                            : InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const ContactForm()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.size16,
                                vertical: AppSizes.size16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  AppImages.askQuestion,
                                  height: AppSizes.size20,
                                  width: AppSizes.size20,
                                ),
                                const SizedBox(
                                  width: AppSizes.size10,
                                ),
                                Text(
                                    _localizations
                                        ?.translate("Ask Question") ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                        color: AppColors.text_color,
                                        fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                        widget.fromQuickCart
                            ? const SizedBox()
                            : ProductTagWidget(productPageData?.tags),
                        widget.fromQuickCart
                            ? const SizedBox()
                            : ProductDetailsDescriptionWidget(
                            productPageData?.description),
                        const SizedBox(
                          height: 10,
                        ),
                        if (!widget.fromQuickCart) ...[
                          if (productPageData?.carousel != null &&
                              productPageData!.carousel!.isNotEmpty) ...[
                            for (int i = 0;
                            i < productPageData!.carousel!.length;
                            i++) ...[
                              if (productPageData!.carousel?[i].type ==
                                  "Product") ...[
                                if (productPageData!.carousel![i].product?.length !=
                                    0) ...[
                                  homePageProductCollection(
                                      context,
                                      productPageData!.carousel![i].product,
                                      productPageData!.carousel?[i].title ?? "",
                                      productPageData!
                                          .carousel?[i].homeSequenceId ??
                                          "",
                                      i % 2 == 0 ? true : false),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ]
                              ]
                            ]
                          ],
                        ],
                        const SizedBox(
                          height: AppSizes.size8,
                        ),
                        widget.fromQuickCart
                            ? const SizedBox(
                          height: 0,
                        )
                            : (productPageData!.carousel!.length / 2 == 0
                            ? RecentView(background: false)
                            : RecentView(background: true)),
                        const SizedBox(
                          height: AppSizes.size8,
                        ),
                        widget.fromQuickCart
                            ? const SizedBox()
                            : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Calculate responsive childAspectRatio based on screen width
                              // This ensures consistent height across Android and iPad
                              final double availableWidth =
                                  constraints.maxWidth;
                              final double columnWidth =
                                  (availableWidth - 8) /
                                      2; // 2 columns with 8 spacing
                              const double desiredHeight =
                              45.0; // Fixed height for consistency
                              final double responsiveAspectRatio =
                                  columnWidth / desiredHeight;

                              return GridView.count(
                                shrinkWrap: true,
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: responsiveAspectRatio,
                                // Controls row height
                                children: optionItems.map((item) {
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const Text("• ",
                                          style: TextStyle(fontSize: 16)),
                                      Expanded(
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
              Visibility(visible: isLoading, child: const Loader())
            ],
          ),
        ),
      ),
    );
  }

/*
* Review tile will show if product have review more than 0
*
* */
  Widget reviewTile() {
    return GestureDetector(
      onTap: () {
        //To show all reviews on next screen
        Navigator.of(context).pushNamed(AppRoute.reviewDetails,
            arguments:
            reviewAttributeDataMap(productPageData!, productPageBloc!));
      },
      child: Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(
              vertical: AppSizes.size16, horizontal: AppSizes.size14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_localizations?.translate(AppStringConstant.reviews)}",
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: AppColors.darkGray),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.darkGray,
                size: AppSizes.size18,
              )
            ],
          )),
    );
  }

  /*
  * For Ar Products
  * */

  var methodChannel = const MethodChannel(AppConstant.channelName);

  Future startArActivity() async {
    if (Platform.isIOS) {
      Helper().downloadArData(context, productPageData?.ios_ar ?? "");

      //  Helper().downloadPersonalData(context, productPageData?.arUrl ?? "");
    } else {
      var isGranted = await Permission.storage.isGranted;
      if (isGranted) {
        try {
          var data = await methodChannel.invokeMethod("showAr", {
            "name": productPageData?.name,
            "url": productPageData?.android_ar
          });
          return data;
        } on PlatformException catch (e) {
          return "Failed to Invoke: '${e.message}'.";
        }
      } else {
        Permission.storage.request();
      }
    }

    //print("${productPageData?.isAr}");
  }

  bool getArStatus() {
    if (Platform.isAndroid &&
        (productPageData?.isAr == true) &&
        (productPageData?.android_ar ?? "").isNotEmpty) {
      return true;
    } else if (Platform.isIOS &&
        (productPageData?.isAr == true) &&
        (productPageData?.ios_ar ?? "").isNotEmpty) {
      return true;
    }
    return false;
  }

  clearDefaultSelectedValue() {
    if ((productPageData?.options?.length ?? 0) > 0) {
      if (selectedProductOptions != null &&
          (selectedProductOptions?.length ?? 0) > 0) {
        productPageData?.options?.forEach((element) {
          if ((element.value?.isEmpty ?? "" == true) &&
              (selectedProductOptions?.keys
                  .contains(element.product_option_id)) ==
                  true) {
            selectedProductOptions
                ?.remove(element.product_option_id); //clear unselected value
          }
        });
      }
    }
  }

  Future<void> addProductToRecentView(
      ProductDetailScreenModel productPageData) async {
    List<Product>? recentProductList = [];
    Product product = Product(
        productId: productPageData.productId.toString(),
        thumb: productPageData.thumb,
        dominantColor: productPageData.dominantColor,
        name: productPageData.name,
        price: productPageData.price,
        quantity: productPageData.quantity.toString(),
        special: productPageData.special,
        formattedSpecial: productPageData.formattedSpecial,
        tax: productPageData.tax,
        //rating:productPageData.rating,
        //reviews:pr,
        //hasOption:productPageData.h,
        wishlistStatus: productPageData.wishlistStatus);
    recentProductList.add(product);
    await HiveService.getHive()
        .isExists(boxName: HiveConstant.recentProduct)
        .then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(HiveConstant.recentProduct)
            .then((value) {
          //  var  recentProductList = value ;/*as List<Product>;*/

          for (var element in (value as List)) {
            if ((element as Product).productId !=
                productPageData.productId.toString()) {
              recentProductList.add(element);
            }
          }
          HiveService.getHive()
              .addBoxes(recentProductList, HiveConstant.recentProduct);
          //print("pankaj save recent view product()-- " + "${value}");
          //  subCategoryModel = value as SubCategoryModel;
        });
      } else {
        // recentProductList.add(product);
        await HiveService.getHive()
            .addBoxes(recentProductList, HiveConstant.recentProduct);
      }
    });
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
