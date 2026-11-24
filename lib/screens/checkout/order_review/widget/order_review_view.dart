import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/paymentReviewPriceDetails.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/payment_methods_list.dart';

import '../../../../common_widgets/image_view.dart';
import '../../../../common_widgets/privacy_policy_checkbox_widget.dart';
import '../../../../common_widgets/title_separated_card.dart';
import '../../../../common_widgets/widget_space.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../constants/arguments_map.dart';
import '../../../../helper/app_localizations.dart';
import '../../../cart/widgets/cart_screen_coupon_widget.dart';



class OrderReviewView extends StatelessWidget {
  OrderReviewView(
      {this.onPaymentMethodChange,
      this.orderReviewModel,
      this.paymentMethod,
      this.localizations,
      this.isCheckboxSelected,
      this.comment,
      this.isShippingRequired,
      this.isGuestCheckout,
        this.coupon,
      super.key});
  final VoidCallback? onPaymentMethodChange;
  final CheckoutReviewOrderModel? orderReviewModel;
  final CheckoutPaymentMethodModel? paymentMethod;
  final AppLocalizations? localizations;
  final Function(bool)? isCheckboxSelected;
  final Function(String)? comment;
  final Function(String)? coupon;
  final bool? isShippingRequired;
  bool? isGuestCheckout;

  @override
  Widget build(BuildContext context) {
    bool darkMode =  SchedulerBinding.instance.window.platformBrightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isGuestCheckout == false /*paymentMethod?.account!="guest"*/) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.searchBackGroundColor, // Light grey background
                borderRadius: BorderRadius.circular(6),
              ),
              child: TitleSeparatedCard(
                  (localizations?.translate(AppStringConstant.shippingInfo) ?? ""),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (isShippingRequired ?? false)
                        SizedBox(
                          width: AppSizes.deviceWidth,
                          child: TitleSeparatedCard(
                            (localizations
                                    ?.translate(AppStringConstant.shippingAddress) ??
                                ""),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: AppSizes.size10, right: AppSizes.size10),
                                child: _getFormattedShippingAddress(
                                    orderReviewModel?.continu?.orderDetails ??
                                        OrderDetails())),
                            showDivider: false,
                            asCard: false,
                          ),
                        ),
                      SizedBox(
                        width: AppSizes.deviceWidth,
                        child: TitleSeparatedCard(
                          (localizations
                                  ?.translate(AppStringConstant.billingAddress) ??
                              ""),
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: AppSizes.size10, right: AppSizes.size10),
                              child: _getFormattedBillingAddress(
                                  orderReviewModel?.continu?.orderDetails ??
                                      OrderDetails())),
                          showDivider: false,
                          asCard: false,
                        ),
                      ),
                      if (isShippingRequired ?? false)
                        SizedBox(
                          width: AppSizes.deviceWidth,
                          child: TitleSeparatedCard(
                            (localizations
                                    ?.translate(AppStringConstant.shippingMethod) ??
                                ""),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal:AppSizes.size10),
                              child: Text(orderReviewModel
                                      ?.continu?.orderDetails?.shippingMethod ??
                                  ""),
                            ),
                            showDivider: false,
                            asCard: false,
                          ),
                        ),
                      if (isShippingRequired ?? false)
                      const SizedBox(height: AppSizes.size10,),
                    ],
                  )),
            ),
          ),
        ],
        const SizedBox(height: AppSizes.size10,),
        // payments methods
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.searchBackGroundColor, // Light grey background
              borderRadius: BorderRadius.circular(6),
            ),
            child: TitleSeparatedCard(
                (localizations?.translate(AppStringConstant.paymentMethods) ?? ""),
                PaymentMethodsList(
                  paymentMethod?.paymentMethods?.paymentMethodList ?? [],
                  onPaymentMethodChange: () {
                    onPaymentMethodChange!();
                  },
                )),
          ),
        ),
        const SizedBox(height: AppSizes.size10,),
        CartScreenCouponWidget((coupen){
          coupon!(coupen);
        }, localizations),
        Padding(
          padding:  const EdgeInsets.symmetric(horizontal: AppSizes.size12),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.searchBackGroundColor, // Light grey background
              borderRadius: BorderRadius.circular(6),
            ),
            child: TitleSeparatedCard(
              (localizations?.translate(AppStringConstant.paymentComment) ?? ""),
              Padding(
                padding:  const EdgeInsets.only(bottom: 10.0,right: 10,left: 10),
                child: TextField(
                  onChanged: comment,
                  maxLines: 4,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: AppSizes.size4,
                      horizontal: AppSizes.size8,
                    ),
                      filled: true, // 👈 Enable background fill
                      fillColor: Colors.white, // 👈 Set background color to white
                    hintText:
                        localizations?.translate(AppStringConstant.comment) ?? "",
                    hintStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                        ?
                    AppColors.white :
                    AppColors.black,),
                    border:  OutlineInputBorder(

                        gapPadding: AppSizes.size0,
                      borderSide: BorderSide(
                        color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                      ?
                      AppColors.white :
                      AppColors.black,

                      )
                    ),
                    focusedBorder: OutlineInputBorder(

                        gapPadding: AppSizes.size0,
                        borderSide: BorderSide(
                          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ?
                          AppColors.white :
                          AppColors.black,

                        )
                    ),
                    enabledBorder: OutlineInputBorder(

                        gapPadding: AppSizes.size0,
                        borderSide: BorderSide(
                          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ?
                          AppColors.white :
                          AppColors.borderGray,

                        )
                    ),
                    disabledBorder: OutlineInputBorder(
                        gapPadding: AppSizes.size0,
                        borderSide: BorderSide(
                          color: SchedulerBinding.instance.window.platformBrightness == Brightness.dark
                              ?
                          AppColors.white :
                          AppColors.gray,

                        )
                    )

                  ),
                ),
              ),
              showDivider: false,
              asCard: false,
            ),
          ),
        ),

        //agree field
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0,right: 10,left: 8,top: 4),
          child: PrivacyPolicyCustomCheckbox(
            (value) {
              isCheckboxSelected!(value);
            },
            AppStringConstant.termAndCondition.localized(),
            paymentMethod?.paymentMethods?.textAgreeInfo,
            dark: darkMode,
          ),
        ),

        // order summary

        const Divider(thickness: 1,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text((localizations?.translate(AppStringConstant.items) ??
                  ""),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: orderReviewModel?.continu?.orderDetails?.products?.length ?? 0,
                itemBuilder: (ctx, index) {
                  final items = orderReviewModel?.continu?.orderDetails?.products;
                  return itemCard(
                    items?[index],
                    localizations,
                    index,
                    items?.length ?? 0,
                    context
                  );
                },
              ),

            ],
          ),
        ),
        PaymentReviewPriceDetails(orderReviewModel, context,
            localizations),
        const Divider(thickness:1.5),

        // // price details
        // TitleSeparatedCard(
        //     (localizations?.translate(AppStringConstant.priceDetails) ?? ""),
        //     ListView.separated(
        //         shrinkWrap: true,
        //         physics: const ClampingScrollPhysics(),
        //         itemBuilder: (context, index) {
        //           return _priceItem(
        //               orderReviewModel?.continu?.totals?[index].title ?? "",
        //               orderReviewModel?.continu?.totals?[index].text
        //                       .toString() ??
        //                   "",
        //               context);
        //         },
        //         separatorBuilder: (BuildContext context, int index) =>
        //             widgetSpace(1, AppSizes.size8),
        //         itemCount: orderReviewModel?.continu?.totals?.length ?? 0)),
      ],
    );
  }

  /*
*
* Method to format the Shipping address
* */
  _getFormattedShippingAddress(OrderDetails orderDetails) {
    try {
      return Text(
        "${(orderDetails.shippingFirstname != null &&
                    orderDetails.shippingFirstname.toString().isNotEmpty)
                ? orderDetails.shippingFirstname ?? ""
                : ""} ${(orderDetails.shippingLastname != null &&
                    orderDetails.shippingLastname.toString().isNotEmpty)
                ? orderDetails.shippingLastname ?? ""
                : ""}\n${(orderDetails.shippingCompany != null && orderDetails.shippingCompany.toString().isNotEmpty) ? "${orderDetails.shippingCompany ?? ""}, \n" : ""}${(orderDetails.shippingAddress1 != null && orderDetails.shippingAddress1.toString().isNotEmpty) ? "${orderDetails.shippingAddress1 ?? ""}, \n" : ""}${(orderDetails.shippingAddress2 != null && orderDetails.shippingAddress2.toString().isNotEmpty) ? "${orderDetails.shippingAddress2 ?? ""}, \n" : ""}${(orderDetails.shippingCity != null && orderDetails.shippingCity.toString().isNotEmpty) ? "${orderDetails.shippingCity ?? ""}, \n" : ""}${(orderDetails.shippingZone != null && orderDetails.shippingZone.toString().isNotEmpty) ? "${orderDetails.shippingZone ?? ""}, \n" : ""}${(orderDetails.shippingPostcode != null && orderDetails.shippingPostcode.toString().isNotEmpty) ? "${orderDetails.shippingPostcode ?? ""}, \n" : ""}${(orderDetails.shippingCountry != null && orderDetails.shippingCountry.toString().isNotEmpty) ? "${orderDetails.shippingCountry ?? ""}, \n" : ""}${(orderDetails.telephone != null && orderDetails.telephone.toString().isNotEmpty) ? (orderDetails.telephone ?? "" ", \n") : ""}",
        style: const TextStyle(fontSize: AppSizes.size14),
      );
    } catch (e) {
      return const Text("");
    }
  }

  /*
  * Method to format the Shipping address
  * */
  _getFormattedBillingAddress(OrderDetails orderDetails) {
    try {
      return Text(
        "${(orderDetails.paymentFirstname != null &&
                    orderDetails.paymentFirstname.toString().isNotEmpty)
                ? orderDetails.paymentFirstname ?? ""
                : ""} ${(orderDetails.paymentLastname != null &&
                    orderDetails.paymentLastname.toString().isNotEmpty)
                ? orderDetails.paymentLastname ?? ""
                : ""}\n${(orderDetails.paymentCompany != null && orderDetails.paymentCompany.toString().isNotEmpty) ? "${orderDetails.paymentCompany ?? ""}, \n" : ""}${(orderDetails.paymentAddress1 != null && orderDetails.paymentAddress1.toString().isNotEmpty) ? "${orderDetails.paymentAddress1 ?? ""}, \n" : ""}${(orderDetails.paymentAddress2 != null && orderDetails.paymentAddress2.toString().isNotEmpty) ? "${orderDetails.paymentAddress2 ?? ""}, \n" : ""}${(orderDetails.paymentCity != null && orderDetails.paymentCity.toString().isNotEmpty) ? "${orderDetails.paymentCity ?? ""}, \n" : ""}${(orderDetails.paymentZone != null && orderDetails.paymentZone.toString().isNotEmpty) ? "${orderDetails.paymentZone ?? ""}, \n" : ""}${(orderDetails.paymentPostcode != null && orderDetails.paymentPostcode.toString().isNotEmpty) ? "${orderDetails.paymentPostcode ?? ""}, \n" : ""}${(orderDetails.paymentCountry != null && orderDetails.paymentCountry.toString().isNotEmpty) ? "${orderDetails.paymentCountry ?? ""}, \n" : ""}${(orderDetails.telephone != null && orderDetails.telephone.toString().isNotEmpty) ? "${orderDetails.telephone ?? ""}, \n" : ""}",
        style: const TextStyle(fontSize: AppSizes.size14),
      );
    } catch (e) {
      return const Text("");
    }
    /*} else {

    }*/
  }


  Widget itemCard(Products? product, AppLocalizations? localizations, int index, int totalLength,BuildContext context){
    double total = double.tryParse(product?.total?.toString() ?? "0") ?? 0;
    double quantity =
        double.tryParse(product?.quantity?.toString() ?? "1") ?? 1;

    String pricePerUnit =
    quantity != 0 ? (total / quantity).toStringAsFixed(2) : "0.00";

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
          border: index != totalLength - 1
              ? const Border(
            bottom: BorderSide(
              color: AppColors.dividerColor,
              width: 1.0,
            ),
          )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric( vertical: AppSizes.size8),
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
                        border: Border.all(color: Colors.grey.shade300, width: AppSizes.size1),
                      ),
                      child: ImageView(
                        url: product?.image ?? '',
                        height: AppSizes.size88,
                        width: AppSizes.size88,
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
                          padding: const EdgeInsets.only(bottom: AppSizes.size4),
                          child: Text(
                            product?.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        const SizedBox(height: AppSizes.size10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: (product?.stock ?? false) ? (( (int.tryParse(product?.carton ?? "0") ?? 0) * 10 > (int.tryParse(product?.totalQuantity ?? "0") ?? 0) )
                                      ? const Color(0xFFFFA500):product?.totalQuantity=="0"?const Color(0xFFE7000B):const Color(0xFF00C48C)) : const Color(0xFFE7000B),
                                  //const Color(0xFF00C48C),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                  (product?.stock ?? false) ?
                                  (( (int.tryParse(product?.carton ?? "0") ?? 0) * 10 > (int.tryParse(product?.totalQuantity ?? "0") ?? 0) )
                                      ? "Low Stock":product?.totalQuantity=="0"?"Out Of Stock":"In Stock") :
                                  //localizations?.translate(AppStringConstant.inStock) ?? '' :
                                  localizations?.translate(AppStringConstant.outStock) ?? '',
                                 // localizations?.translate(AppStringConstant.inStock) ?? '',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400,color:Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Text(product?.model ?? "", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const SizedBox(height: AppSizes.size10),
                        if (product?.price != false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSizes.size4),
                            child: Row(
                              children: [
                                Text( "£${pricePerUnit}", style: Theme.of(context).textTheme.headlineSmall),
                                widgetSpace(1, AppSizes.size8),
                                Text(localizations?.translate(AppStringConstant.perItem) ?? '', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:AppSizes.size8 ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSizes.size45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(AppSizes.size6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Qty ',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${product?.quantity}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          // Total Price
                          Row(
                            children: [
                              Text(
                                'Total ',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '£${product?.total.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
