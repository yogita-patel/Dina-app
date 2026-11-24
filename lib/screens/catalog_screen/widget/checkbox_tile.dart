import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/catalog/filter.dart';

import '../../../config/theme.dart';

class CheckboxTile extends StatelessWidget {
  const CheckboxTile(this.filter, this.callback, {super.key});

  final Filter? filter;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          filter?.selected = filter?.selected == true ? false : true;
          callback();
        },
        child: Row(
          children: <Widget>[
            Checkbox(
              side:  const BorderSide(color: AppColors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // ← radius here
              ),
              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return MobikulTheme.primaryColor; // Change color based on dark mode
                }
                return Colors.transparent;
              }),
              value: filter?.selected ?? false,
              onChanged: (value) {
                filter?.selected = value;
                callback();
              },
            ),
            const SizedBox(width: AppSizes.size8),
            Text(
              "${filter?.name}",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: AppSizes.size14,
                    fontWeight: FontWeight.w400
                )
            )
          ],
        ),
      ),
    );
  }
}
