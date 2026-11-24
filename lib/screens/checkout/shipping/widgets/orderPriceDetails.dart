import 'package:flutter/material.dart';


import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../models/checkout/checkout_payment_address_model.dart';




Widget ShippingPriceDetails(
   CheckoutPaymentAddressModel? checkoutBillingAddressModel,
    BuildContext context,
    AppLocalizations? localizations,
    ) {
  final totals = checkoutBillingAddressModel?.cartTotal ?? [];

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
  return Padding(
    padding: isSecondLast?const EdgeInsets.only(top: AppSizes.size15):const EdgeInsets.symmetric(vertical: AppSizes.size8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: [
            SizedBox(
              width: AppSizes.deviceWidth/3,
              child: Text(
                subtitle,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: AppColors.summaryTitle),
              ),
            ),
            if(isFirst == false && isSecondLast == false)
              SizedBox(
                width: AppSizes.deviceWidth/3,
                child: Text(
                  key,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400,color: Colors.grey.shade600),
                ),
              ),
          ],
        ),
        Text(value, style: Theme.of(context).textTheme.bodyMedium),
      ],
    ),
  );
}
