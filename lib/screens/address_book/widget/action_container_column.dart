import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

class ActionContainerColumn extends StatelessWidget {
  const ActionContainerColumn({
    this.imageTop,
    this.imageBottom,
    this.topCallback,
    this.bottomCallback,
     this.titleTop,
     this.titleBottom,
    super.key,
  });

  final String? imageTop;     // Path to top image (e.g., 'assets/images/edit.png')
  final String? imageBottom;  // Path to bottom image
  final String? titleTop, titleBottom;
  final VoidCallback? topCallback, bottomCallback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: topCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (imageTop != null)
                  Image.asset(
                    imageTop!,
                    height: AppSizes.size30,
                    width: AppSizes.size30,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(width: AppSizes.size4),
                Text(
                  titleTop?.toUpperCase()??"",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),

        const Divider(thickness: 5, height: 0),

        InkWell(
          onTap: bottomCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (imageBottom != null)
                  Image.asset(
                    imageBottom!,
                    height: AppSizes.size30,
                    width: AppSizes.size30,
                    fit: BoxFit.contain,
                  ),
                const SizedBox(width: AppSizes.size4),
                Text(
                  titleBottom?.toUpperCase()??"",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
