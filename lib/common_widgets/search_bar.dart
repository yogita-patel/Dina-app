import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';



class CommonSearchBar extends StatelessWidget {
  final VoidCallback? onScanTap;
   String title;
   CommonSearchBar({super.key, this.onScanTap,required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onScanTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.searchBackGroundColor, // Light grey background
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.searchText,)),
            Image.asset(
              height: AppSizes.size24,width: AppSizes.size24,
              AppImages.searchScanIcon,
              color: AppColors.searchText,
            ),
          ],
        ),
      ),
    );
  }
}
