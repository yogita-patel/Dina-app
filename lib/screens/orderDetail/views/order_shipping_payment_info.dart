import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/address_item_card.dart';


import 'order_heading_view.dart';

Widget shippingPaymentInfo(BuildContext context,
    AppLocalizations? localizations, OrderDetailModel? orderModel) {
  return orderHeaderLayout(
      context,
      localizations?.translate(AppStringConstant.shippingPaymentInfo) ?? "",
      Column(
        children: [
          if(orderModel?.shippingAddress?.isNotEmpty==true)...[
          addressItemWithHeading(
              context,
              localizations?.translate(AppStringConstant.shippingAddress) ??
                  "",
              orderModel?.shippingAddress ?? "",
              isElevated: false),
          const SizedBox(
            height: AppSizes.size16,
          ),],
          if(orderModel?.paymentAddress?.isNotEmpty==true)
          addressItemWithHeading(
              context,
              localizations?.translate(AppStringConstant.billingAddress) ?? "",
              orderModel?.paymentAddress ?? "",
              isElevated: false),
        ],
      ));
}
