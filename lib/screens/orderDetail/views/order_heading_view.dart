import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';

Widget orderHeaderLayout(BuildContext context, String heading, Widget child) {
  return Container(
    color: Theme.of(context).cardColor,
    width: AppSizes.deviceWidth,
    padding: const EdgeInsets.symmetric(vertical: AppSizes.mediumPadding,horizontal:AppSizes.size16 ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              heading.toUpperCase(),
              style:  Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        child
      ],
    ),
  );
}