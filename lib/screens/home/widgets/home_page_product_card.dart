import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_bloc.dart';
import 'package:oc_demo/screens/home/widgets/item_card_bloc/item_card_state.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/local_db/floor/database.dart';
import '../../../helper/local_db/floor/entities/recent_product_entitie.dart';
import '../../../helper/local_db/floor/recent_view_controller.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageProductCard extends StatefulWidget {
  double? imageSize;
  final Product? data;
  AppLocalizations? _localizations;
  Function(String)? wishlistCallBack;

  HomePageProductCard(
      {super.key, this.data, this.imageSize, this.wishlistCallBack});

  @override
  State<HomePageProductCard> createState() => _HomePageProductCardState();
}

class _HomePageProductCardState extends State<HomePageProductCard> {
  bool isWishlist = false;
  bool isLoading = true; // Var
  ItemCardBloc? itemCardBloc;

  @override
  Widget build(BuildContext ctx, {Function(String)? callback}) {
    itemCardBloc = ctx.read<ItemCardBloc>();
    widget.imageSize ??= (AppSizes.deviceWidth / 2.7);
    return BlocBuilder<ItemCardBloc, ItemCardState>(
      builder: (context, currentState) {
        if (currentState is ItemCardInitial) {
          isLoading = true;
        } else if (currentState is ItemCardErrorState) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        } else if (currentState is AddProductToWishlistStateSuccess) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
            itemCardBloc?.emit(WishlistIdleState());
          });
          if (widget.data?.productId == currentState.productId) {
            widget.data?.wishlistStatus =
                currentState.wishListModel.wishliststatus;
          }
        }
        return buildUi(ctx);
      },
    );
  }

  Widget buildUi(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppDatabase.getDatabase().then(
          (value) => value.recentProductDao
              .insertRecentProduct(
                RecentProduct(
                  productId: widget.data?.productId,
                  name: widget.data?.name,
                  price: widget.data?.price,
                  image: widget.data?.thumb,
                ),
              )
              .then(
                (value) => RecentViewController.controller.sink
                    .add(widget.data?.productId),
              ),
        );
        Navigator.of(context).pushNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
                widget.data?.name ?? '', widget.data?.productId ?? ''));
      },
      child: _buildProductCard(),
      // child: Card(
      //     color: Theme.of(context).cardColor,
      //     child: Container(
      //       width: AppSizes.deviceWidth / 2.1,
      //       child: Column(
      //         mainAxisSize: MainAxisSize.max,
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Stack(alignment: Alignment.topLeft, children: <Widget>[
      //             Container(
      //               margin: const EdgeInsets.only(top: AppSizes.size8),
      //               child: Center(
      //                 child: ImageView(
      //                   url: widget.data?.thumb.toString() ?? '',
      //                   width: widget.imageSize!,
      //                   height: widget.imageSize!,
      //                   fit: BoxFit.cover,
      //                 ),
      //               ),
      //             ),
      //             Positioned(
      //                 right: AppSizes.size6,
      //                 bottom: 115,
      //                 child: InkWell(
      //                   onTap: () async {
      //                     if (await AppSharedPref.isLogin()) {
      //                       itemCardBloc?.add(
      //                           AddToWishlistEvent(widget.data?.productId));
      //                     } else {
      //                       DialogHelper.wishlistConfirmationDialog(
      //                           "${AppLocalizations.of(context)?.translate(AppStringConstant.wishlistDesc)}",
      //                           "${AppLocalizations.of(context)?.translate(AppStringConstant.loginRequired)}",
      //                           context,
      //                           AppLocalizations.of(context),
      //                           onConfirm: () async {
      //                         Navigator.of(context).pushNamed(
      //                           AppRoute.login,
      //                           arguments:
      //                               getSignInSignUpPageArgument(false, false),
      //                         );
      //                       });
      //                     }
      //                   },
      //                   child: Container(
      //                     padding: const EdgeInsets.all(AppSizes.size8),
      //                     decoration: const BoxDecoration(
      //                       color: AppColors.white,
      //                       borderRadius: BorderRadius.all(
      //                           Radius.circular(AppSizes.size16)),
      //                       boxShadow: [
      //                         BoxShadow(
      //                           color: AppColors.background,
      //                           blurRadius: AppSizes.size4,
      //                           offset: Offset(
      //                               0, 1), // changes position of shadow
      //                         ),
      //                       ],
      //                     ),
      //                     child: Icon(
      //                       //  data!.wishlistStatus==isWishlist
      //                       widget.data!.wishlistStatus ?? false
      //                           ? Icons.favorite
      //                           : Icons.favorite_border_outlined,
      //                       color: widget.data?.wishlistStatus ?? false
      //                           ? AppColors.red
      //                           : AppColors.black,
      //                       size: AppSizes.size16,
      //                     ),
      //                   ),
      //                 )),
      //             if (widget.data?.special != 0)
      //               const Padding(
      //                 padding: EdgeInsets.only(
      //                   left: AppSizes.size4,
      //                   top: AppSizes.size4,
      //                 ),
      //                 child: Card(
      //                   color: Colors.black,
      //                   child: Padding(
      //                     padding: EdgeInsets.all(AppSizes.size4),
      //                     child: Text(
      //                       AppStringConstant.sale,
      //                       textDirection: TextDirection.ltr,
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                 ),
      //               ),
      //           ]),
      //           Visibility(
      //             visible: ((widget.data?.rating ?? 0) > 0),
      //             child: Padding(
      //               padding: const EdgeInsets.all(4.0),
      //               child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: List.generate(
      //                       5,
      //                       (index) => _buildStar(
      //                           context, index, (widget.data?.rating ?? 0)))),
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(
      //                 left: AppSizes.size4, top: AppSizes.size8),
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               mainAxisSize: MainAxisSize.max,
      //               children: <Widget>[
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   mainAxisSize: MainAxisSize.max,
      //                   children: [
      //                     const SizedBox(
      //                       width: AppSizes.size8,
      //                     ),
      //                     Expanded(
      //                         child: Text(widget.data?.name ?? '',
      //                             maxLines: 2,
      //                             overflow: TextOverflow.ellipsis,
      //                             style: Theme.of(context)
      //                                 .textTheme
      //                                 .bodyText2
      //                                 ?.copyWith(fontSize: AppSizes.size14)
      //
      //                           // TextStyle(fontSize: AppSizes.size14, /*fontWeight: FontWeight.bold*/),
      //                           // textAlign: TextAlign.center,
      //                           // style: Theme.of(context).textTheme.bodyMedium),
      //                         )),
      //                     const SizedBox(
      //                       width: AppSizes.size8,
      //                     ),
      //                   ],
      //                 ),
      //                 widgetSpace(0, 5),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   mainAxisSize: MainAxisSize.max,
      //                   children: <Widget>[
      //                     // if ((widget.data?.formattedSpecial ?? "") != "" &&
      //                     //     (widget.data?.formattedSpecial ?? "") !=
      //                     //         "0") ...[
      //                     //   // Text(
      //                     //   //   widget.data?.price.toString() ?? '',
      //                     //   //   style: TextStyle(
      //                     //   //     fontSize: AppSizes.size12,
      //                     //   //     color: Theme.of(context).textTheme.headline4!.color,
      //                     //   //     decoration: TextDecoration.lineThrough,
      //                     //   //   ),
      //                     //   // ),
      //                     //   const SizedBox(
      //                     //     width: AppSizes.size8,
      //                     //   ),
      //                     //
      //                     //   Text(
      //                     //     widget.data?.formattedSpecial.toString() ?? '',
      //                     //     style: Theme.of(context).textTheme.headline5,
      //                     //   ),
      //                     // ] else ...[
      //                     //   const SizedBox(
      //                     //     width: AppSizes.size8,
      //                     //   ),
      //                     widget.data?.price!=false?
      //                     Padding(
      //                       padding:
      //                           const EdgeInsets.only(left: AppSizes.size8),
      //                       child: Text(
      //                         widget.data?.price.toString() ?? '',
      //                         style: Theme.of(context).textTheme.headline6,
      //                       ),
      //                     ):SizedBox(),
      //                     if ((widget.data?.formattedSpecial ?? "") != "" &&
      //                         (widget.data?.formattedSpecial ?? "") !=
      //                             "0") ...[
      //                       // Text(
      //                       //   widget.data?.price.toString() ?? '',
      //                       //   style: TextStyle(
      //                       //     fontSize: AppSizes.size12,
      //                       //     color: Theme.of(context).textTheme.headline4!.color,
      //                       //     decoration: TextDecoration.lineThrough,
      //                       //   ),
      //                       // ),
      //                       const SizedBox(
      //                         width: AppSizes.size8,
      //                       ),
      //
      //                       Text(
      //                         widget.data?.formattedSpecial.toString() ?? '',
      //                         style: Theme.of(context).textTheme.headline5,
      //                       ),
      //                     ] else ...[
      //                       const SizedBox(
      //                         width: AppSizes.size8,
      //                       ),
      //                     ]
      //                   ],
      //                 ),
      //
      //                 //widgetSpace(),
      //               ],
      //             ),
      //           ),
      //         ],
      //       ),
      //     )
      // )
    );
  }

  Widget _buildProductCard() {
    return Container(
      width: AppSizes.deviceWidth / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppSizes.size8),
            width: widget.imageSize,
            height: widget.imageSize, // Ensures square shape
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              border: Border.all(
                color: AppColors.grey_border, // Customize border color
                width: 1, // Customize border width
              ),
              borderRadius:
                  BorderRadius.circular(10), // Optional rounded corners
            ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Match border radius if any
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageView(
                  url: widget.data?.thumb.toString() ?? '',
                  width: widget.imageSize ?? 0,
                  height: widget.imageSize ?? 0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              widget.data?.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.text_color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              widget.data?.price != false
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSizes.size0),
                      child: Text(
                        widget.data?.price.toString() ?? '',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  : const SizedBox(),
              if ((widget.data?.formattedSpecial ?? "") != "" &&
                  (widget.data?.formattedSpecial ?? "") != "0") ...[
                const SizedBox(
                  width: AppSizes.size8,
                ),
                Text(
                  widget.data?.formattedSpecial.toString() ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ] else ...[
                const SizedBox(
                  width: AppSizes.size8,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
