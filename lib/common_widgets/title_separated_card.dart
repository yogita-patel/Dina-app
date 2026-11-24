import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

class TitleSeparatedCard extends StatelessWidget {
  const TitleSeparatedCard(this.title, this.child,
      {this.showDivider = true, this.asCard = true, super.key});

  final String title;
  final Widget child;
  final bool showDivider;
  final bool asCard;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.searchBackGroundColor, // Light grey background
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size10, vertical: AppSizes.size10),
            child: Text(title,
            style: Theme.of(context).textTheme.titleLarge),
          ),
          child
        ],
      ),
    );
  }
}
