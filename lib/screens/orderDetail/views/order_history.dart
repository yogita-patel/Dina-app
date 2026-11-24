import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';


Widget orderHistoryDetails(
    OrderDetailModel model,
    BuildContext context,
    AppLocalizations? localizations,
    ) {
  final histories = model.histories ?? [];

  return orderHeaderLayout(
    context,
    localizations?.translate(AppStringConstant.orderHistory) ?? "",
    Column(
      children: List.generate(histories.length, (index) {
        final e = histories[index];
        return orderHistoryDetailsItem(
          e.dateAdded ?? "",
          e.status ?? "",
          e.comment ?? "",
          context,
          index == histories.length - 1, // Pass isLast true for last item
        );
      }),
    ),
  );
}


Widget orderHistoryDetailsItem(
    String dateAdded,
    String status,
    String comment,
    BuildContext context,
    bool isLast,
    ) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border: isLast
          ? null
          : const Border(
        bottom: BorderSide(
          color: AppColors.dividerColor,
          width: 1.0,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: AppSizes.deviceWidth / 1.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: AppSizes.deviceWidth/1.35,
                  child: Text(
                    dateAdded,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: AppColors.summaryTitle),
                  ),
                ),
                  if(comment!="")
                  SizedBox(
                    width: AppSizes.deviceWidth/1.35,
                    child: Text(
                      comment,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
              width: AppSizes.deviceWidth/6.7,
              child: Text(status, style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis,maxLines: 2,)),
        ],
      ),
    ),
  );
}

