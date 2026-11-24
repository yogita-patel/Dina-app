import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../../../helper/generic_methods.dart';

Widget viewAllButton(
    BuildContext context, var title, final Function onClickAction, int length) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        flex: 2,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 0.0, bottom: 0, right: 10, left: 16),
          child:
              Text(title ?? "", style: Theme.of(context).textTheme.headlineMedium),
        ),
      ),
      Expanded(
        flex: 0,
        child: Visibility(
          visible: true,
          child: Container(
              margin: const EdgeInsets.only(left:38),
              child: TextButton(
                onPressed: () {
                  onClickAction();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      GenericMethods.getStringValue(
                          context, AppStringConstant.viewAll),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF0D479C),
                      ),
                    ),
                    const SizedBox(width: 6,),
                    Image.asset(
                      AppImages.viewall, // Replace with your image path
                      width: 25,
                      height: 25,
                    ),
                  ],
                ),
                // style: OutlinedButton.styleFrom(
                //   side: const BorderSide(
                //       width: AppSizes.size2,
                //
                //       style: BorderStyle.solid),
                //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                // ),
              )),
        ),
      ),
    ],
  );
}
