
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/common_widgets/image_view.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/wishlist/get_wish_list.dart';
import 'package:oc_demo/models/wishlist/wishlist_datum.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_bloc.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_event.dart';
import 'package:oc_demo/screens/wishlist/bloc/wishlist_state.dart';

import '../../common_widgets/CommonEmptyCard.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/widget_space.dart';
import '../../helper/app_shared_pref.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  AppLocalizations? _localizations;
  GetWishlist? wishlistModel;
  bool isLoading = true;
  bool isAction = false;
  WishlistScreenBloc? wishlistScreenBloc;
  int? cartCount = 0;
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    // controller = ScrollController()..addListener();
    AppSharedPref.getCartCount().then((value){
      cartCount=int.parse(value);
      TabbarController.countController.sink.add(cartCount??0);
      setState(() {

      });
    });
    wishlistScreenBloc = context.read<WishlistScreenBloc>();
    wishlistScreenBloc?.add(WishlistDataFetchEvent());
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(
            _localizations?.translate(AppStringConstant.backorders) ?? "",
            context,
        ),
        body: BlocBuilder<WishlistScreenBloc, WishlistState>(
            builder: (context, currentState) {
              if (currentState is WishlistInitialState) {
                isLoading = true;
              } else if (currentState is WishlistScreenSuccess) {
                isLoading = false;
                isAction = false;
                wishlistModel = currentState.wishlistModel;
              } else if (currentState is WishlistActionState) {
                isAction = true;
              } else if (currentState is MoveToCartSuccess) {
                isLoading = false;
                cartCount = int.parse(currentState.baseModel?.cartTotal??"0");
                AppSharedPref.setCartCount(currentState.baseModel?.cartTotal??"0");
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                  });
                  currentState.baseModel?.error!=1?
                  AlertMessage.showSuccess(
                      currentState.baseModel?.message ?? '', context):AlertMessage.showError(
                      currentState.baseModel?.message ?? '', context);
                });
                wishlistScreenBloc?.add(WishlistDataFetchEvent());
              } else if (currentState is RemoveItemSuccess) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertMessage.showSuccess(
                      currentState.baseModel?.message ?? '', context);
                });
                wishlistScreenBloc?.add(WishlistDataFetchEvent());
              } else if (currentState is WishlistShareCollectionSuccess) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertMessage.showSuccess(
                      currentState.baseModel?.message ?? '', context);
                });
              } else if (currentState is WishlistScreenError) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertMessage.showError(currentState.message ?? '', context);
                });
              }
              return SafeArea(child: buildUI(wishlistModel?.wishlistData, context));
            }));
  }

  Widget buildUI(List<WishlistDatum>? items, BuildContext context) {
    return isLoading
        ? const Loader()
        : Visibility(
        visible: wishlistModel != null,
            child: (wishlistModel?.wishlistData ?? []).isEmpty ||
                    wishlistModel?.wishlistData?.length == 0
                ? Center(
                    child: CommonEmptyCard(
                      imagePath: AppImages.noBackorder,
                      title: _localizations
                              ?.translate(AppStringConstant.noBackorderFound) ??
                          '',
                      subtitle: _localizations?.translate(
                              AppStringConstant.onceBackorderAvailable) ??
                          '',
                      showButton: false,
                      showButtonText: false,
                      buttonText: _localizations
                              ?.translate(AppStringConstant.goToHome) ??
                          '',
                      onButtonPressed: () {
                        BottomTabController.check.countController?.sink.add(0);
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //   /*MaterialPageRoute(
                        //             builder: (context) => const BottomTabbarWidget(),
                        //           ),*/
                        //   AppRoute.bottomTabBAr,
                        //       (route) => false,
                        // );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(AppSizes.size8),
                    child: buildWishlistViewCustomization(items, context),
                  ),
          );
  }

  Widget buildWishlistViewCustomization(List<WishlistDatum>? products, BuildContext context){

    return Container(
      // decoration: BoxDecoration(color: AppColors.white,/*border: Border.all(color: Colors.grey[350]!)*/),
      child: ListView.builder(
        controller: controller,
        shrinkWrap: true,
        itemCount: (products?.length ?? 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == products?.length) {
            return const Padding(
              padding:
              EdgeInsets.only(top: AppSizes.size4, bottom: AppSizes.size4
                //  ,left:AppSizes.size24,right:AppSizes.size24
              ),
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

          var product = products?[index];
          final matchingDiscount = product?.discounts?.firstWhere(
                (d) => d.price == product?.price,
            orElse: () => Discounts(price: '', quantity: ''),
          );

          return GestureDetector(
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
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: const Border(
                    bottom: BorderSide(
                      color: AppColors.dividerColor, // Set your desired color
                      width: 1.0, // Set border thickness
                    )),
              ),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () {
                        // Call your delete function
                        // onDeleteFromWishlist(product);
                        DialogHelper.confirmationDialog(
                            AppStringConstant.removeItemFromWishlist,
                            context,
                            _localizations, onConfirm: () {
                          wishlistScreenBloc?.emit(WishlistActionState());
                          wishlistScreenBloc?.add(
                              RemoveItemEvent(product?.productId ?? "0"));
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          AppImages.delete,
                          height: 25,
                          width: 25,
                        ),
                      ),
                    ),
                  ),
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
                            margin: const EdgeInsets.only(top: AppSizes.size8),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.all(AppSizes.size4),
                              // space between image and border
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
                          ),
                        ]),
                        const SizedBox(
                          width: AppSizes.size10,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 32),
                                child: Text(
                                  product?.name ?? "",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  softWrap: true,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColorDark),
                                ),
                              ),
                              const SizedBox(height: AppSizes.size10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: product?.stock!="Out Of Stock"? const Color(0xFF00C48C):const Color(0xFFE7000B),
                                      // Green background
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:  Text(
                                      "${product?.stock}",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400, color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible( // Makes the model text responsive
                                    child: Text(
                                      "${product?.model}",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSizes.size10),
                              product?.price != false
                                  ? Padding(
                                padding: const EdgeInsets.only(bottom: AppSizes.size4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              // product?.price ?? "",
                                              product?.quantity??"",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: TextStyle(
                                                fontSize: AppSizes.size14,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).textTheme.titleLarge?.color,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              //_localizations?.translate(AppStringConstant.perItem) ?? '',
                                              _localizations?.translate(AppStringConstant.quantity) ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: false,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge
                                                  ?.copyWith(fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if(product?.quantity!="0")
                                    const SizedBox(width: 8),
                                    // if(product?.stock!="Out Of Stock")
                                      Visibility(
                                        visible: product?.stock!="Out Of Stock",
                                        child: InkWell(
                                          onTap: () {
                                            var quantity = double.tryParse(product?.quantity ?? '0') ?? 0;
                                            var unitOfsales = double.tryParse(product?.UnitofSalenew ?? '0') ?? 0;

                                            int dividedQuantity = 0;

// safe check
                                            if (unitOfsales > 0) {
                                              dividedQuantity = (quantity / unitOfsales).floor();
                                            } else {
                                              dividedQuantity = 0; // ya koi default value jo aapko chahiye
                                            }

                                            print("dividedQuantity: $dividedQuantity");
                                            print("quantity: ${product?.quantity ?? '0'}");

                                            wishlistScreenBloc?.add(
                                              MoveToCartEvent(
                                                "${product?.productId ?? ""}",
                                                "$dividedQuantity",
                                                "",
                                                "${product?.UnitofSalenew ?? ''}",
                                              ),
                                            );

                                          },
                                          child: Image.asset(
                                            AppImages.cartButton,
                                            height: 35,
                                            width: 35,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                                  : const SizedBox(),
                              /*  Text(
                                product?.price ?? "",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimary),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey[200],
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
