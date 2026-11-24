import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';


Widget orderPriceDetails(
    OrderDetailModel model,
    BuildContext context,
    AppLocalizations? localizations,
    ) {
  final totals = model.totals ?? [];

  return orderHeaderLayout(
    context,
    localizations?.translate(AppStringConstant.summary) ?? "",
    Column(
      children: List.generate(totals.length, (index) {
        final item = totals[index];
        final isSecondLast = index == totals.length - 2;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: isSecondLast
                ? const Border(
              bottom: BorderSide(
                color: AppColors.dividerColor,
                width: 1.0,
              ),
            )
                : null,
          ),
          child: orderPriceDetailsItem(
            item.title ?? "",
            item.text ?? "",
            item.subtitle ?? "",
            context,
              index == totals.length - 1,
              index ==  0,
          ),
        );
      }),
    ),
  );
}


Widget orderPriceDetailsItem(String key, String value,String subtitle, BuildContext context,bool isSecondLast,bool isFirst,) {
  return Padding(
    padding: isSecondLast?const EdgeInsets.only(top: AppSizes.size15):const EdgeInsets.symmetric(vertical: AppSizes.size8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            SizedBox(
              width: AppSizes.deviceWidth/1.5,
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: AppColors.summaryTitle),
              ),
            ),
            if(isFirst == false && isSecondLast == false)
            SizedBox(
              width: AppSizes.deviceWidth/1.5,
              child: Text(
                key,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
        Flexible(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    ),
  );
}
