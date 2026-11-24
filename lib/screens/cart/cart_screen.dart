import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import 'package:oc_demo/screens/cart/cart_popup_logic.dart';
import 'package:oc_demo/screens/cart/widgets/cart_main_view.dart';
import 'package:oc_demo/screens/cart/widgets/cart_product_item.dart';
import 'package:oc_demo/screens/cart/widgets/guest_bottom_sheet.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_empty_card.dart';
import '../../common_widgets/common_order_button.dart';
import '../../common_widgets/loader.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../main.dart';
import '../../models/base_model.dart';
import '../../models/cart/cart_shipping_model.dart';
import '../../models/cart/country_data_model.dart';
import 'bloc/cart_screen_bloc.dart';

class CartScreen extends StatefulWidget {
  final bool isFromBottom;

  const CartScreen({super.key, required this.isFromBottom});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with RouteAware {
  AppLocalizations? _localizations;
  bool isLoading = true;
  CartModel? cartModel;
  CartScreenBloc? cartScreenBloc;
  BaseModel? baseModel;
  CountryDataModel? countryDataModel;
  List<ShippingMethod>? shippingMethodList;
  bool _isFirstLoad = true;
  @override
  void initState() {
    print("Init isdeefef runnig");
    cartScreenBloc = context.read<CartScreenBloc>();
    print("Init is runnig");
    _isFirstLoad = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });
    cartScreenBloc?.add(const CartScreenDataFetchEvent());
    cartScreenBloc?.add(const GetCountryDataEvent());
    BottomTabController.check.currentStateUpdateStream.stream.listen(
      (index) {
        if (index == 2) {
          cartScreenBloc?.add(const CartScreenDataFetchEvent());
        }
      },
    );

    AppSharedPref.getCartCount().then((value) {
      if (value != null) {
        TabbarController.countController.sink.add(int.parse(value) ?? 0);
      }
    });
    super.initState();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    print("sddfrt5t5tdefefgrgrg5tfhgfj");
    // This is called when coming back to this screen
    setState(() {
      isLoading = true;
      _isFirstLoad = false;
    });
    cartScreenBloc?.add(const CartScreenDataFetchEvent());
    // quickCartBloc?.add(WishlistDataFetchEvent());
  }

  @override
  void dispose() {
    print("sddfrt5t5t5tfhgfj");
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (cartActionDisableToQuote) {
      print("sdfhgfj $cartActionDisableToQuote");
    } else {
      print("addfgdsajfdjfgj $cartActionDisableToQuote");
      cartScreenBloc?.add(const CartScreenDataFetchEvent());
    }
    print(
        "Did Change Dependencies called in Cart Screen.............. ....................... .................");
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        _localizations?.translate(AppStringConstant.cartScreenTitle) ?? "",
        context,
        isLeadingEnable: true,
      ),
      body: SafeArea(
        child: BlocBuilder<CartScreenBloc, CartScreenState>(
          builder: (context, currentState) {
            if (currentState is CartScreenStateInitial) {
              isLoading = true;
            } else if (currentState is CartScreenSuccess) {
              isLoading = false;
              cartModel = currentState.data;
              /* var model = AppSharedPref().getUserData();
              model?.cartCount = cartModel?.cartCount;
              AppSharedPref().setUserData(model);*/

              // Update Cart Count
              TabbarController.countController.sink
                  .add(cartModel?.cart?.totalProducts ?? 0);
              AppSharedPref.setCartCount(
                  cartModel?.cart?.totalProducts?.toString() ?? "0");

              cartScreenBloc?.emit(const CompleteState());
            } else if (currentState is RemoveCartItemSuccess) {
              baseModel = currentState.data;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
              isLoading = true;
            } else if (currentState is EmptyCartSuccess) {
              isLoading = false;
              baseModel = currentState.data;
              //   AppSharedPref.setCartCount(currentState.data.cartTotal??'0');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is UpdateCartSuccess) {
              baseModel = currentState.data;
              // AppSharedPref.setCartCount(currentState.data.cartTotal??'0');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
              isLoading = true;
            } else if (currentState is ApplyVoucherSuccess) {
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is ApplyCouponSuccess) {
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is GetCountryDataStateSuccess) {
              isLoading = false;
              countryDataModel = currentState.data;
              // cartScreenBloc?.add(const GetCountryDataEvent());
              // cartScreenBloc?.emit(CartScreenStateInitial());
            } else if (currentState is GetShippingMethodStateSuccess) {
              isLoading = false;
              shippingMethodList = currentState.data.shippingMethod;
            } else if (currentState is ApplyShippingStateSuccess) {
              isLoading = false;
              print("rishabh apply shipping");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                (currentState.data.message?.isEmpty == true)
                    ? ""
                    : AlertMessage.showSuccess(
                        currentState.data.message ?? "", context);
                Navigator.pop(context);
              });
              cartScreenBloc?.add(const CartScreenDataFetchEvent());
            } else if (currentState is AddProductToWishlistStateSuccess) {
              /*
          * Success state call after adding product to wishlist
          * */
              //isLoading = false;
              print("rishabh add product to wishlist ${currentState.key}");
              cartScreenBloc
                  ?.add(CartScreenRemoveItemEvent(currentState.key ?? ""));
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    currentState.wishListModel.message ?? '', context);
              });
            } else if (currentState is CartScreenError) {
              isLoading = false;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showError(currentState.message ?? '', context);
              });
            }
            return buildCartUI();
          },
        ),
      ),
    );
  }

  Widget buildCartUI() {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: (cartModel != null),
          child: cartModel?.cart == 0 ||
                  (cartModel?.cart?.products ?? []).isEmpty
              ? CommonEmptyCard(
                  imagePath: AppImages.cartEmpty,
                  title: _localizations
                          ?.translate(AppStringConstant.cartEmptyTitle) ??
                      '',
                  subtitle: _localizations
                          ?.translate(AppStringConstant.cartEmptySubtitle) ??
                      '',
                  showButton: true,
                  showButtonText: false,
                  buttonText: _localizations
                          ?.translate(AppStringConstant.startShopping) ??
                      '',
                  onButtonPressed: () {
                    BottomTabController.check.countController?.sink.add(0);
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   AppRoute.bottomTabBAr,
                    // );
                  },
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          //color: Colors.red,
                          child: CartMainView(
                            countryDataModel,
                            cartModel,
                            _localizations,
                            cartScreenBloc,
                          ),
                        ),
                      ),
                    ),
                    commonOrderButton(
                        context,
                        _localizations,
                        getTotalAmount(),
                        _localizations
                                ?.translate(AppStringConstant.confirmOrder) ??
                            "", () async {
                      final outOfStockProducts = cartPopupOutOfStockProducts(
                          cartModel?.cart?.products);

                      if (outOfStockProducts.isNotEmpty) {
                        _showOutOfStockDialog(outOfStockProducts);
                        return;
                      }

                      GlobalData.cartTotal = getTotalAmount();
                      if (cartModel?.cart?.errorWarning?.isNotEmpty == true &&
                          (cartModel?.cart?.checkoutEligible ?? 0) == 0) {
                        AlertMessage.showWarning(
                            cartModel?.cart?.errorWarning ?? "", context);
                        return;
                      }
                      if (!(await AppSharedPref.isLogin())) {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => GuestBottomSheet(
                              AppStringConstant.checkoutAs, cartModel?.cart),
                        );
                        return;
                      }

                      Navigator.of(context).pushNamed(AppRoute.shipping,
                          arguments: getShippingPageArgument(
                              AddAddressRequest(), "", false));
                    })
                  ],
                ),
        ),
        Visibility(
          visible: isLoading,
          child: const Loader(),
        ),
      ],
    );
  }

  /*
  *
  * return total amount
  * */
  getTotalAmount() {
    String? total = "0";
    cartModel?.cart?.totals?.forEach((element) {
      if (element.title == "total" ||
          element.title == "Total" ||
          element.title == "الاجمالي النهائي") {
        total = element.text;
      }
    });
    return total;
  }

  void _showOutOfStockDialog(List<Products> outOfStockProducts) {
    var visibleProducts = List<Products>.from(outOfStockProducts);

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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Colors.red, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Out of Stock Items",
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
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
                            cartScreenBloc,
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
    final wishListModel =
        await cartScreenBloc?.repository?.addProductToWishList(
      product.productId ?? "",
      product.quantity ?? "1",
      product.UnitofSalenew?.toString() ?? "1",
    );

    if (wishListModel != null && wishListModel.error == 0) {
      await cartScreenBloc?.repository?.removeItemFromCart(product.key ?? "");
      showMessage(wishListModel.message);

      final latestCart = await cartScreenBloc?.repository?.getCartData();
      if (latestCart != null) {
        setState(() {
          cartModel = latestCart;
        });
        TabbarController.countController.sink
            .add(latestCart.cart?.totalProducts ?? 0);
        AppSharedPref.setCartCount(
            latestCart.cart?.totalProducts?.toString() ?? "0");
        return cartPopupOutOfStockProducts(latestCart.cart?.products);
      }
    } else if (wishListModel?.message?.isNotEmpty == true) {
      showMessage(wishListModel?.message, isError: true);
    }

    cartScreenBloc?.add(const CartScreenDataFetchEvent());
    return cartPopupOutOfStockProducts(cartModel?.cart?.products);
  }

  Future<List<Products>> _deleteFromOutOfStockDialog(Products product,
      void Function(String?, {bool isError}) showMessage) async {
    final removeModel =
        await cartScreenBloc?.repository?.removeItemFromCart(product.key ?? "");

    if (removeModel?.message?.isNotEmpty == true) {
      showMessage(removeModel?.message);
    }

    final latestCart = await cartScreenBloc?.repository?.getCartData();
    if (latestCart != null) {
      setState(() {
        cartModel = latestCart;
      });
      TabbarController.countController.sink
          .add(latestCart.cart?.totalProducts ?? 0);
      AppSharedPref.setCartCount(
          latestCart.cart?.totalProducts?.toString() ?? "0");
      return cartPopupOutOfStockProducts(latestCart.cart?.products);
    }

    cartScreenBloc?.add(const CartScreenDataFetchEvent());
    return cartPopupOutOfStockProducts(cartModel?.cart?.products);
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
      final latestCart = await cartScreenBloc?.repository?.getCartData();
      if (latestCart != null) {
        setState(() {
          cartModel = latestCart;
        });
        TabbarController.countController.sink
            .add(latestCart.cart?.totalProducts ?? 0);
        AppSharedPref.setCartCount(
            latestCart.cart?.totalProducts?.toString() ?? "0");
        return cartPopupOutOfStockProducts(latestCart.cart?.products);
      }
    }
    cartScreenBloc?.add(const CartScreenDataFetchEvent());
    return cartPopupOutOfStockProducts(cartModel?.cart?.products);
  }

  Map<String, int> _getCartQuantityJson() {
    final jsonMap = <String, int>{};
    cartModel?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] = int.tryParse(element.quantity ?? "0") ?? 0;
    });
    return jsonMap;
  }

  Map<String, int> _getCartUnitOfSalesJson() {
    final jsonMap = <String, int>{};
    cartModel?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] =
          int.tryParse(element.UnitofSalenew?.toString() ?? "0") ?? 0;
    });
    return jsonMap;
  }
}
