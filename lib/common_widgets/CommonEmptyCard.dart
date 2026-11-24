import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

class CommonEmptyCard extends StatelessWidget {
  final String imagePath; // Asset path or network URL
  final String title;
  final String subtitle;
  final bool showButton;
  final bool showButtonText;
  final String buttonText;
  final VoidCallback? onButtonPressed;

  const CommonEmptyCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showButton = false,
    this.showButtonText = false,
    this.buttonText = 'Try Again',
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset( // You can replace with Image.network if needed
            imagePath,
            height: AppSizes.size100,
            width: AppSizes.size100,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: AppSizes.size24,),
          Text(
            title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.size8,),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.size24),
          if (showButton)
            ElevatedButton(
              onPressed: onButtonPressed,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.size24, vertical: AppSizes.size10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.size6),
                ),
              ),
              child: Text(
                buttonText,
              ),
            ),
          if (showButtonText)
            GestureDetector(
              onTap: onButtonPressed,
              child: Text(
                buttonText,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColorDark),
              ),
            ),
        ],
      ),
    );
  }
}
