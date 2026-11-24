import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/models/catalog/filter.dart';
import 'package:oc_demo/models/catalog/filter_group.dart';
import 'package:oc_demo/screens/catalog_screen/widget/checkbox_tile.dart';
import 'package:oc_demo/screens/catalog_screen/widget/radio_tile.dart';

import '../../../helper/generic_methods.dart';


class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet(this.filters, this.onFilter, this.selectedFilters, {super.key});

  final List<FilterGroup>? filters;
  final VoidCallback onFilter;
  final String? selectedFilters;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late List<FilterGroup>? _filters;
  Map<String, String?> _selectedRadioIds = {}; // key = group.name or group.id

  @override
  void initState() {
    super.initState();
    _filters = widget.filters;
    _applySelectedFilters();
    print("erdhfgnhm==> ${widget.selectedFilters}");
   // print(_filters?[1].filter?[1].selected ?? "");
  }

  void _applySelectedFilters() {
    if (widget.selectedFilters != null) {
      final selectedIds = widget.selectedFilters!.split(",");
      _filters?.forEach((group) {
        group.filter?.forEach((f) {
          f.selected = selectedIds.contains(f.filterId);
          print("gdfhmj");
          print(f.name);
        });
      });
    }
  }


  void _clearAll() {
    setState(() {
      _filters?.forEach((group) {
        group.filter?.forEach((f) {
          f.selected = false;
        });
      });

      _selectedRadioIds.clear();

      widget.onFilter(); // Call onFilter to apply changes
    });
  }

  void _clearAllData() {
    setState(() {
      _filters?.forEach((group) {
        group.filter?.forEach((f) {
          f.selected = false;
        });
      });

      _selectedRadioIds.clear();

     // Call onFilter to apply changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        backgroundColor: Colors.white,
        centerTitle: true, // Center the title
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              onTap: _clearAll,
              child: Center(
                child: Text(
                  "Clear All",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF0D479C),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filters?.length ?? 0,
              itemBuilder: (ctx, idx) {
                final group = _filters?[idx];
                if (group == null) return const SizedBox.shrink();

                return group.type == "radio"
                    ? _radioListElement(
                  group.name ?? "",
                  group.filter,
                  context,
                )
                    : _listElement(
                  group.name ?? "",
                  group.filter,
                  context,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: commonButton(
            context,
            widget.onFilter,
            backgroundColor: MobikulTheme.accentColor,
            textColor: MobikulTheme.primaryColor,
            "Apply Filter",
          ),
        ),
      ),
    );
  }

  /// This method creates a list element for the filter bottom sheet.
  Widget _listElement(
      String title,
      List<Filter>? filter,
      BuildContext context,
      ) {
    // if (widget.selectedFilters != null) {
    //   var filters = widget.selectedFilters!.split(",");
    //   filter?.forEach((element) {
    //     if (filters.contains(element.filterId)) element.selected = true;
    //   });
    // }
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: StatefulBuilder(
        builder: (ctx, localSetState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: "Inter",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      filter?.forEach((f) {
                        f.selected = false;
                      });
                      setState(() {

                      });
                    },
                    child: Text(
                      GenericMethods.getStringValue(
                          context, AppStringConstant.clear),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filter?.length ?? 0,
              itemBuilder: (ctx, index) {
                return CheckboxTile(filter?.elementAt(index), () {
                  setState(() {
                    _filters?.forEach((group) {
                      if (group.type == "radio") {
                        group.filter?.forEach((f) => f.selected = false);
                      }
                    });
                    _selectedRadioIds = {};
                  });
                  localSetState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }


  /// This method creates a radio list element for the filter bottom sheet.
  Widget _radioListElement(
      String title,
      List<Filter>? filter,
      BuildContext context,
      ) {
    final visibleFilters = filter?.where((f) => f.visibility != 0).toList() ?? [];

    // Pick the selectedId dynamically from visible filters
    final selected = visibleFilters.firstWhere(
          (f) => f.selected == true,
      orElse: () => Filter(filterId: "", name: ""),
    );

    _selectedRadioIds[title] =
    selected.filterId!.isNotEmpty ? selected.filterId : null;

    String? selectedId = _selectedRadioIds[title];

    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: StatefulBuilder(
        builder: (ctx, localSetState) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                      fontFamily: "Inter",
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRadioIds[title] = null;
                        filter?.forEach((f) => f.selected = false);
                      });
                      localSetState(() {});
                    },
                    child: Text(
                      GenericMethods.getStringValue(context, AppStringConstant.clear),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleFilters.length,
              itemBuilder: (ctx, index) {
                final item = visibleFilters[index];
                return RadioTile(
                  item,
                  selectedId,
                      (value) {
                    setState(() {
                      _selectedRadioIds[title] = value;

                      // Clear all list filters
                      _filters?.forEach((group) {
                        if (group.type != "radio") {
                          group.filter?.forEach((f) => f.selected = false);
                        }
                      });

                      // Select current radio item
                      filter?.forEach((f) {
                        f.selected = (f.filterId == value);
                      });
                    });

                    localSetState(() {});
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
