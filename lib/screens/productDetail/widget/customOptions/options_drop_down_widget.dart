import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/productDetail/product_detail_screen_model.dart';

import '../../../../common_widgets/common_text_field.dart';
import '../../../../constants/app_constants.dart';

class OptionsDropDownWidget extends StatefulWidget {
  OptionsDropDownWidget({super.key, this.variants, this.selectedOption});
  List<ProductOptionValue>? variants;
  ValueChanged<String>? selectedOption = (test) {};
  @override
  _OptionsDropDownWidgetState createState() => _OptionsDropDownWidgetState();
}

class _OptionsDropDownWidgetState extends State<OptionsDropDownWidget> {
  String selectedVariant = AppStringConstant.select.localized();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 6.0, right: 8.0, left: 8.0, bottom: 6.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: formFieldDecoration(
            context,
            "",
            "",
            isRequired: true,
          ),
          dropdownColor: Theme.of(context).cardColor,// Set dropdown color based on theme
          items: widget.variants?.map((ProductOptionValue value) {
            String optionString = value.name ?? "";
            if (value.price != "") {
              optionString +=
                  "  (${value.price_prefix ?? ""}${value.price ?? ""})";
            }
            return DropdownMenuItem(
              value: value.productOptionValueId,
              child: Text(optionString),
            );
          }).toList(),
          // isExpanded: true,
          hint: Text(
            selectedVariant,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: AppColors.gray),
          ),
          style: Theme.of(context).textTheme.bodyLarge,
          onChanged: (newValue) async {
            widget.variants?.forEach((element) {
              if (newValue == element.productOptionValueId) {
                setState(() {
                  if (element.price != "") {
                    var t = element.name ?? "";
                    t += "  (${element.price_prefix ?? ""}${element.price ?? ""})";
                    selectedVariant = t;
                  } else {
                    selectedVariant = element.name ?? "";
                  }

                  widget.selectedOption!(newValue as String);
                });
              }
            });
          },
        ),
      ),
    );
  }
}
