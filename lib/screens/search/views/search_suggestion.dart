import 'package:flutter/material.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/searchModel/search_model.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';

Widget suggestionList(
  BuildContext context,
  AppLocalizations? localizations,
  List<SearchData>? searchData, {
  VoidCallback? onViewAllSearchResults,
}) {
  final suggestions = (searchData ?? []).take(4).toList();
  final showViewAllButton = (searchData?.length ?? 0) > suggestions.length;

  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: AppSizes.size26, bottom: AppSizes.size8),
            child: Text(
              "Search Results",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                var data = suggestions[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoute.productPage,
                        arguments: getProductDataAttributeMap(
                            data.name ?? "", data.productId ?? ""));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: const Border(
                          bottom: BorderSide(
                        color: AppColors.dividerColor, // Set your desired color
                        width: 1.0, // Set border thickness
                      )),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: AppSizes.size2,
                              bottom: AppSizes.size8,
                              left: AppSizes.size8,
                              right: AppSizes.size8),
                          child: Row(
                            children: <Widget>[
                              Stack(children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: AppSizes.size8),
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding:
                                        const EdgeInsets.all(AppSizes.size4),
                                    // space between image and border
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: AppSizes.size1,
                                      ),
                                    ),
                                    child: ImageView(
                                      url: data.thumb ?? '',
                                      height: AppSizes.size88,
                                      width: AppSizes.size88,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(
                                width: AppSizes.size10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSizes.size4,
                                      ),
                                      child: Text(
                                        data.name ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSizes.size4,
                                      ),
                                      child: Text(
                                        data.productCode ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          if (showViewAllButton && onViewAllSearchResults != null) ...[
            const SizedBox(height: AppSizes.size24),
            SizedBox(
              width: double.infinity,
              height: AppSizes.size48,
              child: ElevatedButton(
                onPressed: onViewAllSearchResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: MobikulTheme.primaryColor,
                  foregroundColor: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.size8),
                  ),
                ),
                child: const Text(
                  "View All Search Results",
                  style: TextStyle(
                    fontSize: AppSizes.size16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.size24),
          ],
        ],
      ));
}
