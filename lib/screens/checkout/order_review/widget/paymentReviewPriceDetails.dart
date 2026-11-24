
import 'package:flutter/material.dart';


import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../models/checkout/checkout_payment_method_model.dart';
import '../../../../models/checkout/checkout_review_order_model.dart';




Widget PaymentReviewPriceDetails(
    CheckoutReviewOrderModel? orderReviewModel,
    BuildContext context,
    AppLocalizations? localizations,
    ) {
  final totals = orderReviewModel?.continu?.totals ?? [];
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
    child: Column(
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
  print("dnfbrgnmt$subtitle");
  return Padding(
    padding: isSecondLast?const EdgeInsets.only(top: AppSizes.size15):const EdgeInsets.symmetric(vertical: AppSizes.size8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                key,
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.summaryTitle,
                ),
              ),
              if (!isFirst && !isSecondLast)
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
          ),
        ),
      ],
    ),

  );
}
