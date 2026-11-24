import 'package:flutter/material.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class PriceDetails extends StatelessWidget {
  const PriceDetails({
    this.totals,
    super.key,
    this.localizations,
  });

  final List<Totals>? totals;
  final AppLocalizations? localizations;

  @override
  Widget build(BuildContext context) {
    return
    Container(
      color: Theme.of(context).cardColor,
      child: ExpansionTile(
          childrenPadding:
           const EdgeInsets.symmetric(horizontal: 8),
          backgroundColor:Theme.of(context).cardColor,
          initiallyExpanded: true,
          tilePadding:
          const EdgeInsets.symmetric(horizontal: AppSizes.size8),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          title: Text(
              localizations
                  ?.translate(AppStringConstant.summary) ??
                  '',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),),
          children: [
            Column(
              children: List.generate(totals!.length, (index) {
                final item = totals?[index];
                final isSecondLast = index == totals!.length - 2;

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
                    item?.title ?? "",
                    item?.text ?? "",
                    context,
                    index == totals!.length - 1,
                  ),
                );
              }),
            )
          ]),
    );
  }

  Widget orderPriceDetailsItem(String key, String value, BuildContext context,bool isSecondLast,) {
    return Padding(
      padding: isSecondLast?const EdgeInsets.only(top: AppSizes.size15):const EdgeInsets.symmetric(vertical: AppSizes.size8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Text(
              key,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

}
