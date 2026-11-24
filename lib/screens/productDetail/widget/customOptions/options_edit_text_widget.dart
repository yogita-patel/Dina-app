import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../models/registerAccountModel/register_account_model.dart';

class OptionsEditTextWidget extends StatefulWidget {
  ValueChanged<String>? selectedText = (test) {};
  CustomField? optionDefaultValue;
  final bool isRequired;
  OptionsEditTextWidget({super.key, this.selectedText, this.optionDefaultValue, this.isRequired =true});

  @override
  _OptionsEditTextWidgetState createState() => _OptionsEditTextWidgetState();
}

class _OptionsEditTextWidgetState extends State<OptionsEditTextWidget> {
  TextEditingController? optionController;
  AppLocalizations? _localizations;

  @override
  void initState() {
    super.initState();

    // Load initial customer value into the controller
    print("Rishabh edit text ${widget.optionDefaultValue?.customerValue}");
    optionController = TextEditingController(
      text: widget.optionDefaultValue?.customerValue ?? "",
    );

    // If there's an initial value, send it to the callback
    if ((widget.optionDefaultValue?.customerValue ?? "").isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.selectedText?.call(widget.optionDefaultValue!.customerValue!);
        }
      });
    }
  }

  @override
  void dispose() {
    optionController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    optionController = TextEditingController();
    optionController?.text= "${widget.optionDefaultValue?.customerValue??""}";
    if (optionController?.text.isNotEmpty == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.selectedText!(optionController?.text ?? "");
      }); // print("test   "+(optionController?.text)!);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 0.0,),
      child: Container(
        color: Theme.of(context).cardColor,
        child: TextFormField(
            cursorColor:
            AppColors.black,
            enabled: true,
            readOnly: false,
            maxLines: 1,
            obscureText: false,
            keyboardType: TextInputType.number,
            controller: optionController,
            style:Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
          validator: (value) {
            if (widget.isRequired && (value == null || value.trim().isEmpty)) {
              return "Please enter ${widget.optionDefaultValue?.name ?? 'this field'}";
            }
            return null;
          },
            onChanged: widget.selectedText,
            decoration: formFieldDecoration(
              context,
              widget.optionDefaultValue?.name,
              widget.optionDefaultValue?.name,
              isRequired: widget.optionDefaultValue?.required,
            ),
      ),
    ),);
  }
}
