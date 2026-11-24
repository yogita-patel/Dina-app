import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/global_data.dart';

import '../bloc/categories_screen_bloc.dart';

class MainCategoryList extends StatefulWidget {
  const MainCategoryList(
      this.categoriesScreenBloc, this.onCategoryReselected, this.selectedIndex,
      {super.key});

  final int selectedIndex;
  final CategoriesScreenBloc? categoriesScreenBloc;
  final ValueChanged<String?> onCategoryReselected;

  @override
  State<MainCategoryList> createState() => _MainCategoryListState();
}

class _MainCategoryListState extends State<MainCategoryList> {
  late int _selectedIndex;
  late bool _darkMode;

  @override
  void initState() {

    _selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _darkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    return SizedBox(
      width: AppSizes.deviceWidth / 3,
      height: AppSizes.deviceHeight,
      child: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: GlobalData.rootCategories?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });

                widget
                    .onCategoryReselected(GlobalData.rootCategories?[index].path);
              },
              child: Container(
                // color: _darkMode
                //     ? Theme.of(context).cardColor
                //     : Colors.grey.shade100,
                decoration: BoxDecoration(
                  color: _selectedIndex == index
                      ? (_darkMode
                          ? AppColors.gray
                          : AppColors.white)
                      : (_darkMode ? AppColors.black :AppColors.backgroundColor),
                ),

                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.size16,
                    vertical: AppSizes.size12,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      GlobalData.rootCategories?[index].name ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _selectedIndex == index
                              ? (Theme.of(context).textTheme.titleLarge?.color)
                              : (AppColors.darkGray)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
