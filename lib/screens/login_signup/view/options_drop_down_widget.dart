import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../../../../common_widgets/common_text_field.dart';
import '../../../../constants/app_constants.dart';
import '../../../models/registerAccountModel/register_account_model.dart';

class OptionsDropDownWidget extends StatefulWidget {
  OptionsDropDownWidget({
    super.key,
    this.variants,
    this.selectedOption,
    this.selectCustomerOption,
    this.isRequired = true,
  });

  final List<CustomFieldValue>? variants;
  final ValueChanged<String>? selectedOption;
  final String? selectCustomerOption;
  final bool isRequired;

  @override
  _OptionsDropDownWidgetState createState() => _OptionsDropDownWidgetState();
}

class _OptionsDropDownWidgetState extends State<OptionsDropDownWidget> {
  String? selectedVariant = AppStringConstant.select.localized();
  String? _selectedValue;

  @override
  void initState() {
    super.initState();

    // only set value if it actually exists in list
    if (widget.selectCustomerOption != null &&
        (widget.variants?.any((e) =>
        e.custom_field_value_id == widget.selectCustomerOption) ??
            false)) {
      _selectedValue = widget.selectCustomerOption;
      selectedVariant = findVariantName(widget.variants, _selectedValue!);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.selectedOption?.call(_selectedValue!);
        }
      });
    } else {
      _selectedValue = null; // safe default
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedValue, // safe
          validator: (value) {
            if (widget.isRequired && (value == null || value.isEmpty)) {
              return "Please select an option";
            }
            return null;
          },
          decoration: formFieldDecoration(
            context,
            "",
            "",
            isRequired: false,
          ).copyWith(
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSizes.size12,
              horizontal: AppSizes.size12,
            ),
          ),
          dropdownColor: Theme.of(context).cardColor,
          items: widget.variants?.map((CustomFieldValue value) {
            return DropdownMenuItem<String>(
              value: value.custom_field_value_id,
              child: Text(value.name ?? ""),
            );
          }).toList() ??
              [],
          hint: Text(
            selectedVariant ?? AppStringConstant.select.localized(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedValue = newValue;
              selectedVariant =
                  findVariantName(widget.variants, _selectedValue ?? "");
              if (_selectedValue != null) {
                widget.selectedOption?.call(_selectedValue!);
              }
            });
          },
        ),
      ),
    );
  }

  String? findVariantName(
      List<CustomFieldValue>? fields, String customFieldValueId) {
    for (var field in fields ?? []) {
      if (field.custom_field_value_id == customFieldValueId) {
        return field.name;
      }
    }
    return null;
  }
}
