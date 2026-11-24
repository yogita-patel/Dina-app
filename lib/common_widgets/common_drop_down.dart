import 'package:flutter/material.dart';
import '../common_widgets/common_text_field.dart';
import '../constants/app_constants.dart'; // If you're using a common InputDecoration

class CommonDropdownWidget extends StatefulWidget {
  final List<String> items;
  final String? hint;
  final ValueChanged<String> onChanged;
  final String? selectedValue;
  final bool isRequired;

  const CommonDropdownWidget({
    super.key,
    required this.items,
    required this.onChanged,
    this.hint,
    this.selectedValue,
    this.isRequired = false,
  });

  @override
  State<CommonDropdownWidget> createState() => _CommonDropdownWidgetState();
}

class _CommonDropdownWidgetState extends State<CommonDropdownWidget> {
  late String? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        decoration: formFieldDecoration(
          context,
          "",
          "",
          isRequired: widget.isRequired,
        ).copyWith(
          contentPadding: const EdgeInsets.symmetric(
            vertical: AppSizes.size12 , // Adjust this value for height
            horizontal: AppSizes.size12,
          ),
        ),
        dropdownColor: Theme.of(context).cardColor,
        value: _currentValue,
        hint: Text(
          widget.hint ?? "Select",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.gray,
          ),
        ),

        items: widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item,style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400
            ),),
          );
        }).toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _currentValue = newValue;
            });
            widget.onChanged(newValue);
          }
        },
      ),
    );
  }
}
