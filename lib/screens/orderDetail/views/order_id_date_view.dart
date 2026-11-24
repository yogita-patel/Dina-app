import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';

import '../../../constants/app_constants.dart';


Widget orderIDPlaceDateContainer(BuildContext context, OrderDetailModel? orderModel, AppLocalizations? localization) {
  return Container(
      color: Theme.of(context).cardColor,
      width: AppSizes.deviceWidth,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSizes.mediumPadding,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localization?.translate(AppStringConstant.orderId)}',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w400)
              ),
              statusContainer(context, orderModel?.histories?[ (((orderModel.histories?.length??0) > 1 ) ? (orderModel.histories?.length??1)-1 : 0) ].status ?? "".toUpperCase(),),
              Text(
                localization?.translate(AppStringConstant.placedOn)??"",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w400)
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.linePadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${orderModel?.orderId ?? ""}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                orderModel?.dateAdded ?? "",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ));
}

Widget statusContainer(BuildContext context, String status) {
  return Container(
    decoration: BoxDecoration(
      color: containerColor(status), // background color
      borderRadius: BorderRadius.circular(6), // rounded corners
    ),
    padding: const EdgeInsets.symmetric(
        vertical: AppSizes.size6, horizontal: AppSizes.size12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
              status,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge?.copyWith(color: textColor(status)),
            )),
      ],
    ),
  );
}
Color containerColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.completedColor;
    case 'PROCESSING':
      return AppColors.processingColor;
    case 'PENDING':
      return AppColors.pendingColor;
    default:
      return AppColors.pendingColor;
  }
}

Color textColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.white;
    case 'PROCESSING':
      return AppColors.white;
    case 'PENDING':
      return AppColors.black;
    default:
      return AppColors.black;
  }
}