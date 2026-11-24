import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';

import '../../../constants/arguments_map.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget getSearchCategorySuggestion(List<SubCategory>? categories) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: categories?.length ?? 0,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 6,
      crossAxisSpacing: 0,
      childAspectRatio: 0.95,
    ),
    itemBuilder: (context, index) {
      final category = categories![index];
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            AppRoute.catalog,
            arguments: categoryMap(
                category.path ?? '',
                category.name ?? '',
                "",""),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                height: AppSizes.deviceWidth / 4,
                width: AppSizes.deviceWidth / 4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(category.image ?? ''),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              category.name ?? '',
              textAlign: TextAlign.center,
              style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: AppSizes.size12),
            ),
          ],
        ),
      );
    },
  );
}



