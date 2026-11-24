
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/catalog/sort.dart';

import '../../../constants/app_constants.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet(this.sort, this.onSort, {this.selected, super.key});
  final Sort? selected;
  final List<Sort>? sort;
  final ValueChanged<Sort?> onSort;

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late String? groupValue;

  @override
  void initState() {
    if (widget.selected != null) {
      groupValue = "${widget.selected?.value}-${widget.selected?.order}";
    } else {
      groupValue = "${widget.sort?.first.value}-${widget.sort?.first.order}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(groupValue);
    return Scaffold(
      appBar: AppBar( // Remove default back button
        centerTitle: true, // Center the title on all platforms
        backgroundColor: Colors.white,
        title: Text(
          "Sort",
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                AppImages.crossBackButton,
                height: AppSizes.size34,
                width: AppSizes.size34,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
        ),
      ),
        body: Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12.0,top: 8),
              child: Text(AppStringConstant.sortBy.localized(), style: Theme.of(context).textTheme.titleLarge,),
            ),
            // AppBar(
            //   backgroundColor: Colors.transparent,
            //   elevation: 0,
            //   title: Text(
            //     AppStringConstant.sortBy.localized().toUpperCase(),
            //     style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.black),
            //   ),
            //   automaticallyImplyLeading: false,
            //   // Uncomment this if you require a close button
            //   // leeading: const CloseButton()
            // ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevent scroll conflict if needed
              itemCount: widget.sort?.length ?? 0,
              itemBuilder: (ctx, index) {
                var sort = widget.sort?.elementAt(index);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: Transform.scale(
                    scale: 1,
                    child: RadioListTile<String?>(
                      activeColor: MobikulTheme.primaryColor,
                      dense: true,
                      contentPadding: const EdgeInsets.only(left: -16,top: 0),
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: "${sort?.value}-${sort?.order}",
                      groupValue: groupValue,
                      onChanged: (value) {
                        setState(() {
                          groupValue = value;
                        });
                        var arr = value?.split("-");
                        Sort? selectedSort;
                        widget.sort?.forEach((element) {
                          if (element.order == arr?.elementAt(1) &&
                              element.value == arr?.elementAt(0)) {
                            selectedSort = element;
                          }
                        });
                        widget.onSort(selectedSort);
                      },
                      title: Transform.translate(
                        offset: const Offset(-25, 0),
                        child: Html(
                          data: "${widget.sort![index].text}",
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
