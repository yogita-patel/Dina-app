
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class ProductDetailsDescriptionWidget extends StatefulWidget {
  String? description;

  ProductDetailsDescriptionWidget(this.description, {super.key});

  @override
  State<StatefulWidget> createState() => _ProductDetailsDescriptionWidgetState();
}

class _ProductDetailsDescriptionWidgetState extends State<ProductDetailsDescriptionWidget> {
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("Rishabh: ${widget.description}");
    return Container(
      color: Theme.of(context).cardColor,
      child: Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
          initiallyExpanded: true,
          iconColor: Theme.of(context).textTheme.headlineMedium!.color,
          collapsedIconColor: Theme.of(context).textTheme.headlineMedium!.color,
          title:  Text(
              _localizations?.translate(AppStringConstant.description) ?? '',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.text_color,
                  fontSize: 16
              )),
          children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal:  AppSizes.size16),
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HtmlWidget(widget.description??"",
                    textStyle: TextStyle(fontSize: 15, color: Theme.of(context).textTheme.headlineMedium!.color),),
                    // Html(
                    //   data: widget.description ?? '',
                    //   style: {
                    //     "*": Style(
                    //       fontSize: FontSize(15.0),
                    //       // width:MediaQuery.of(context).size.w,
                    //       color: Theme.of(context).textTheme.headline4!.color
                    //
                    //     ),
                    //   },
                    // )
                  ],
                )),
          ]),),
    );
  }

}
