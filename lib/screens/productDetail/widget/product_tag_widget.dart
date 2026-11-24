// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';

class ProductTagWidget extends StatefulWidget {
  List<Tag>? tagList;

  ProductTagWidget(this.tagList, {super.key});

  @override
  State<StatefulWidget> createState() => _ProductDiscountWidgetState();
}

class _ProductDiscountWidgetState
    extends State<ProductTagWidget> {
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final List<String?>? tags = widget.tagList?.map((t) => t.tag).toList();
    return ExpansionTile(
      title: Text(
        'Tags',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppColors.text_color,
          fontSize: 16
        )
      ),
      initiallyExpanded: true,
      shape: Border.all(color: Colors.transparent),
      collapsedShape: Border.all(color: Colors.transparent),
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: tags?.map((tag) {
                return InkWell(
                  onTap: (){
                    final formattedTag = tag != null && tag.isNotEmpty
                        ? '${tag[0].toUpperCase()}${tag.substring(1)}'
                        : '';
                    Navigator.of(context).pushNamed(
                      AppRoute.catalog,
                      arguments: categoryMap(
                        tag??"",
                        formattedTag??"",
                        "",
                        "fromProductSearch"
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey_border,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      tag??"",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.text_color,
                      )
                    ),
                  ),
                );
              }).toList()??[],
            ),
          ),
        ),
      ],
    );
    // return Container(
    //   color: Theme.of(context).cardColor,
    //   margin: const EdgeInsets.only(top: AppSizes.size8),
    //   child: ExpansionTile(
    //       initiallyExpanded: false,
    //       title: Text(
    //         _localizations?.translate(AppStringConstant.discount) ?? '',
    //         style: Theme
    //             .of(context)
    //             .textTheme
    //             .subtitle2?.copyWith(color: AppColors.darkGray),),
    //       children: [
    //         const Divider(height:0.5,thickness:2,color: AppColors.dividerColor,),
    //         ListView.separated(
    //             shrinkWrap: true,
    //             physics: const ClampingScrollPhysics(),
    //             itemBuilder: (context, index) {
    //               return Table(
    //                   children: [ productDiscountTableRowList(widget.discountList![index].quantity!,
    //                       widget.discountList![index].price!)]);
    //             },
    //             separatorBuilder: (BuildContext context, int index) =>
    //                 widgetSpace(1, 8),
    //             itemCount:widget.discountList?.length??0),
    //       ]),
    // );
  }

  /*
  * Discount table view.
  * */
  TableRow productDiscountTableRowList(String title, String priceValue) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(AppSizes.size8),
        child: Text(
            "$title ${_localizations?.translate(AppStringConstant.qty) ?? ""}",
            textAlign: TextAlign.start,
            softWrap: true,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            )
        ),
      ),

      /*const Padding(
          padding: EdgeInsets.all(AppSizes.size8),
          child: Text(
            ":",
            textAlign: TextAlign.start,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          )),*/
      Padding(
          padding: const EdgeInsets.all(AppSizes.size8),
          child: Text(
            priceValue,
            textAlign: TextAlign.end,

            softWrap: true,
          )),
    ]);
  }
}
