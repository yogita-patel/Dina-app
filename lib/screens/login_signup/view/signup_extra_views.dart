import 'package:flutter/material.dart';

import '../../../config/theme.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class Newsletter extends StatefulWidget {
  Function(String) newsletter;
  String selectedId; //-----Pass 1 for yes -------- Pass 0 for no--------//
  bool? showHeading;
  String translationKey;

  Newsletter(this.newsletter, this.translationKey,
      {super.key, this.selectedId = "3", this.showHeading});

  @override
  State<StatefulWidget> createState() {
    return _NewsletterState();
  }
}

class _NewsletterState extends State<Newsletter> {
  AppLocalizations? localizations;

  //var selectedId = "2";

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    //selectedId = widget.selectedId;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeading == true) ...[
          Text(
            localizations?.translate(widget.translationKey) ?? "",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          RadioListTile(
            visualDensity: VisualDensity.compact,
             activeColor: MobikulTheme.primaryColor,
            title: Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(
                localizations?.translate(AppStringConstant.yes) ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            value: "1",
            groupValue: widget.selectedId,
            onChanged: (value) {
              setState(() {
                widget.selectedId = "1";
                print("huiuihi---$value");
                widget.newsletter(value as String);
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile(
            // activeColor: AppColors.black,
            title: Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(
                localizations?.translate(AppStringConstant.no) ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            value: "0",
            groupValue: widget.selectedId,
            onChanged: (value) {
              setState(() {
                widget.selectedId = "0";
                print("huiuihi---$value");
                widget.newsletter(value as String);
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          // const Expanded(child: SizedBox())
        ] else ...[
          RadioListTile(
            visualDensity: VisualDensity.compact,
            // activeColor: AppColors.black,
            title: Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(
                localizations?.translate(AppStringConstant.yes) ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            value: "1",
            groupValue: widget.selectedId,
            onChanged: (value) {
              setState(() {
                widget.selectedId = "1";
                print("huiuihi---$value");
                widget.newsletter(value as String);
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          RadioListTile(
            // activeColor: AppColors.black,
            title: Transform.translate(
              offset: const Offset(-16, 0),
              child: Text(
                localizations?.translate(AppStringConstant.no) ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            value: "0",
            groupValue: widget.selectedId,
            onChanged: (value) {
              setState(() {
                widget.selectedId = "0";
                print("huiuihi---$value");
                widget.newsletter(value as String);
              });
            },
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(),
        ]
      ],
    );
  }
}
