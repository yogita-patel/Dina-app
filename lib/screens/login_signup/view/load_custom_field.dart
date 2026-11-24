import 'package:flutter/material.dart';
import 'package:oc_demo/screens/login_signup/view/options_checkbox_widget.dart';
import '../../../constants/app_constants.dart';
import '../../../models/registerAccountModel/register_account_model.dart';
import '../../productDetail/widget/customOptions/options_edit_text_widget.dart';
import 'options_drop_down_widget.dart';

class LoadCustomInputField extends StatefulWidget {
  List<CustomField>? options;
  ValueChanged<Map<String, dynamic>>? inputOptionsSelectedByUser;
  LoadCustomInputField({super.key,this.options,this.inputOptionsSelectedByUser});

  @override
  State<LoadCustomInputField> createState() => _LoadCustomInputFieldState();
}

class _LoadCustomInputFieldState extends State<LoadCustomInputField> {
  Map<String, dynamic> inputOptions = {};
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Theme.of(context).cardColor,
        child: ListView.builder(
        itemBuilder: (BuildContext context, int i){
      Widget variationWidget = Container();
      switch (widget.options?[i].type) {
        case "select":
          final variantData = widget.options?[i].custom_field_value;
          final safeVariants = (variantData is List<CustomFieldValue>)
              ? variantData
              : null;

          variationWidget = OptionsDropDownWidget(
            variants: safeVariants,
            selectedOption: (String val) {
              setState(() {
                inputOptions["${widget.options?[i].custom_field_id}"] = val;
                widget.inputOptionsSelectedByUser!(inputOptions);
              });
            },
            isRequired: widget.options?[i].required ?? false,
            selectCustomerOption: widget.options?[i].customerValue,
          );
          break;
        case "text":
          print("RIshabh in select");
          variationWidget = OptionsEditTextWidget(
              selectedText: (value) {
                print("enter value in text field is : $value");
                inputOptions["${widget.options?[i].custom_field_id}"] =
                    value;
                widget.inputOptionsSelectedByUser!(inputOptions);
              },
            optionDefaultValue: widget.options?[i],
            isRequired: widget.options?[i].required ?? true,  // <-- new
          );
          break;
        case "checkbox":
          final variantData = widget.options?[i].custom_field_value;
          final safeVariants = (variantData is List<CustomFieldValue>)
              ? variantData
              : null;
          List<dynamic>? safeSelectedIds;

          final customerVal = widget.options?[i].customerValue;

          if (customerVal is List) {
            safeSelectedIds = customerVal;
          } else if (customerVal is String && customerVal.isNotEmpty) {
            safeSelectedIds = [customerVal];
          } else {
            safeSelectedIds = [];
          }
          variationWidget = OptionsCheckBoxWidget(
            variants: safeVariants,
            selectedOption: (selectedVal) {
              setState(() {
                inputOptions["${widget.options?[i].custom_field_id}"] = selectedVal;
                widget.inputOptionsSelectedByUser?.call(inputOptions);
              });
            },
            isRequired: widget.options?[i].required ?? true,
            fieldLabel: widget.options?[i].name ?? '',
            selectedIds: safeSelectedIds,
          );
          break;
        }
        var name = widget.options?[i].name??"";
      widget.options?[i].required??false? name+="*":name=name;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            if(widget.options?[i].type!='checkbox')...[
              const SizedBox(height: AppSizes.size8),
              RichText(
                text: TextSpan(
                  text: name,
                  style:Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.size8),
            ],
            variationWidget,
            const SizedBox(height: AppSizes.size8),
          ],
        );
        },

          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: widget.options?.length,
        ),
    );
  }
}
