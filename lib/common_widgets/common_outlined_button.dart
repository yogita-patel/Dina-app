import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

Widget commonButton(BuildContext context, VoidCallback onPressed, String text,
    {double? width,
      double? height,
      Color? textColor,
      Color? backgroundColor,
      Color? borderSideColor}) {
  borderSideColor ??= Theme.of(context).colorScheme.onPrimary;
  return SizedBox(
    height: AppSizes.size45,
    child: ElevatedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),


          minimumSize: Size((width != null) ? width : AppSizes.deviceWidth,
              (height != null) ? height : AppSizes.deviceHeight / 20),
          backgroundColor: backgroundColor
        //   Theme.of(context).colorScheme.onPrimary

      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(text,
          // style: Theme.of(context).textTheme.headline6?.copyWith(color: textColor
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textColor,fontSize: 16,fontWeight: FontWeight.w600,letterSpacing: -0.21),
        ),
      ),
    ),
  );
}
