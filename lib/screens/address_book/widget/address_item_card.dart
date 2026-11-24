import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/constants/app_constants.dart';

class AddressItemCard extends StatelessWidget {
  const AddressItemCard({
    required this.address,
    this.onTap,
    this.actions,
    super.key,
  });

  final String address;
  final Widget? actions;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom:AppSizes.size2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Theme
            .of(context)
            .cardColor,
        margin: const EdgeInsets.only(top: AppSizes.size8),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.size8),
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                /// Address Text
                Expanded(
                  child: Html(
                    data: address,
                  ),
                ),

                /// Actions Widget (like a button or icon)
                if (actions != null) actions!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

