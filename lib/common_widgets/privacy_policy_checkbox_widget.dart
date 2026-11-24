import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/dialog_helper.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';

class PrivacyPolicyCustomCheckbox extends StatefulWidget {
  final Function(bool) isCheckboxSelected;
  final String? title;
  final String? description;
  final bool? dark;

  const PrivacyPolicyCustomCheckbox(
      this.isCheckboxSelected, this.title, this.description,
      {super.key,this.dark});

  @override
  State<StatefulWidget> createState() {
    return _checkboxState();
  }
}

class _checkboxState extends State<PrivacyPolicyCustomCheckbox> {
  bool isSelected = false;
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.15,
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
        Expanded(
          child: Wrap(
            spacing: 4,
            runSpacing: 4,
            children: [
              Text(
                localizations?.translate(AppStringConstant.readAgreePrivacy) ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              InkWell(
                onTap: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    DialogHelper.termsAndPrivacyDialog(
                      context,
                      widget.title,
                      widget.description,
                    );
                  });
                },
                child: Text(
                  localizations?.translate(widget.title ?? "") ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: AppColors.bottomBarIconActiveColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
