import 'package:flutter/material.dart';

import '../helper/app_localizations.dart';

class CustomCheckbox extends StatefulWidget {
  final Function(bool) isCheckboxSelected;
  final String? title;
  final bool? dark;
  final bool? initialValue;

  const CustomCheckbox(
      this.isCheckboxSelected, this.title,
      this.initialValue,
      {super.key,this.dark});

  @override
  State<StatefulWidget> createState() {
    return _checkboxState();
  }
}

class _checkboxState extends State<CustomCheckbox> {
  late bool isSelected;
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();
    isSelected = widget.initialValue ?? false; // Initialize from initialValue
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the parent changed the initialValue, update internal state to match
    if ((oldWidget.initialValue ?? false) != (widget.initialValue ?? false)) {
      setState(() {
        isSelected = widget.initialValue ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(
              side: const BorderSide(color: Colors.grey),
              fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    // Active/checked state
                    return const Color(0xFF0D479C); // or any other active color
                  }
                  return Colors.white; // Inactive/unchecked background
                },
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)), // Simulates a circle
              ),
              checkColor:(MediaQuery.of(context).platformBrightness==Brightness.dark ?? false)? Colors.black : Colors.white,
              value: isSelected,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              onChanged: (value) {
                setState(() {
                  isSelected = value ?? false;
                });
                widget.isCheckboxSelected(isSelected);
              }),
        ),
        Flexible(
          child: Text(
            widget.title ?? "",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w400,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
