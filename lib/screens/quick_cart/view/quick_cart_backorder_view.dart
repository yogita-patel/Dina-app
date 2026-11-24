import 'package:flutter/material.dart';

import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/wishlist/wishlist_datum.dart';

class WishListView extends StatefulWidget {
  List<WishlistDatum>? products;
  final AppLocalizations? localizations;
  final void Function(String? productId)? onDeleteClick;
  final void Function(String? productId,String? quantity, String? UnitOfSaleNew)? onMoveToCartClick;
  WishListView({super.key,this.products, this.localizations, this.onDeleteClick,this.onMoveToCartClick});

  @override
  State<WishListView> createState() => _WishListViewState();
}

class _WishListViewState extends State<WishListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(color: AppColors.white,/*border: Border.all(color: Colors.grey[350]!)*/),
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: (widget.products?.length ?? 0),
        itemBuilder: (BuildContext context, int index) {
          if (index == widget.products?.length) {
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

          var product = widget.products?[index];
          final matchingDiscount = product?.discounts?.firstWhere(
                (d) => d.price == product?.price,
            orElse: () => Discounts(price: '', quantity: ''),
          );
          // Color _getStockColor(product) {
          //   int quantity = int.tryParse(product?.quantity ?? "0") ?? 0;
          //   int carton = int.tryParse(product?.carton ?? "0") ?? 0;
          //
          //   // 1. Out of Stock → RED
          //   if (quantity == 0) {
          //     return const Color(0xFFE7000B);
          //   }
          //
          //   // 2. Low Stock (carton * 10 <= quantity) → ORANGE
          //   if ((carton * 10) >= quantity) {
          //     return const Color(0xFFFFA500); // Orange
          //   }
          //
          //   // 3. In Stock → GREEN
          //   return const Color(0xFF00BC7D);
          // }
          print("matchingDiscount${matchingDiscount?.quantity}");
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
                        widget.onDeleteClick!(product?.productId);
                        // Call your delete function
                        // onDeleteFromWishlist(product);
                        // DialogHelper.confirmationDialog(
                        //     AppStringConstant.removeItemFromWishlist,
                        //     context,
                        //     _localizations, onConfirm: () {
                        //   wishlistScreenBloc?.emit(WishlistActionState());
                        //   wishlistScreenBloc?.add(
                        //       RemoveItemEvent(product?.productId ?? "0"));
                        // });
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
                                      //_getStockColor(product),
                                      // Green background
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:  Text(
                                      product?.expected!=""?product?.stock == "Out Of Stock"?product?.expected??'':product?.stock??"":product?.stock !="Out Of Stock"?"In Stock":"Out of Stock",
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
                                              (AppStringConstant.quantity) ?? '',
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
                                          print("Quantity ${product?.quantity ?? '0'}");
                                          print("Unit of sales ${product?.UnitofSalenew ?? '0'}");

                                          final quantity = int.tryParse(product?.quantity ?? '0') ?? 0;
                                          final unitOfsales = int.tryParse(product?.UnitofSalenew ?? '0') ?? 0;

                                          int dividedQuantity = 0;

                                          if (unitOfsales > 0) {
                                            dividedQuantity = (quantity / unitOfsales).floor();
                                          }

                                          print("dividedQuantity: $dividedQuantity");

                                          widget.onMoveToCartClick!(
                                            product?.productId,
                                            "$dividedQuantity",
                                            "$unitOfsales",
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
