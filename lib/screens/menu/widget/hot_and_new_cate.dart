import 'package:flutter/material.dart';

import '../../../common_widgets/app_bar.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../constants/global_data.dart';
import '../../../models/homPage/home_screen_model.dart';

class HotAndNewCate extends StatelessWidget {
  String? title;
  HotAndNewCate({super.key,this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
          title??"Hot & New",
          isHomeEnable:false,
          isLeadingEnable:false,
          context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSizes.size12,
                AppSizes.size16, AppSizes.size12, AppSizes.size12),
            child: Text(
            AppStringConstant.categories?? "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          SizedBox(height: 10,),
          getSearchCategorySuggestion(GlobalData.subCategory),
        ],
      ),
    );
  }
}

Widget getSearchCategorySuggestion(List<SubCategory>? categories) {
  return GridView.builder(
    shrinkWrap: true,
    physics: const BouncingScrollPhysics(),
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
