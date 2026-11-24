import 'package:flutter/material.dart';

import '../config/theme.dart';
import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';

Widget commonOrderButton(BuildContext context, AppLocalizations? localizations,
    String amount,String title, VoidCallback onPressed,
{Color color = MobikulTheme.accentColor,
    // String title = AppStringConstant.confirmOrder
 }) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      border:  const Border(
        top: BorderSide(
          color: AppColors.dividerColor,
          width: 1.0, // optional: change as needed
        ),
      ),
    ),
    padding: const EdgeInsets.only(left: AppSizes.size8, right: AppSizes.size8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                localizations?.translate(AppStringConstant.payableAmount) ??
                    "",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
              ),
              Text(amount,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: AppSizes.size126,
            height: AppSizes.size40,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MobikulTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    // shape: const RoundedRectangleBorder(
                    //
                    //     borderRadius: BorderRadius.zero
                  ),
                  elevation: 0,
                ),
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                )
                ),
          ),
        )
      ],
    ),
  );
}
