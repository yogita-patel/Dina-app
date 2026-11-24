import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../helper/app_shared_pref.dart';
import '../badge_icon.dart';
import 'bottom_tabbar.dart';

class BadgeIconUpdate extends StatefulWidget {
  final int? _selectedIndex;

  const BadgeIconUpdate(this._selectedIndex, {super.key});

  @override
  State<BadgeIconUpdate> createState() => _BadgeIconUpdateState();
}

class _BadgeIconUpdateState extends State<BadgeIconUpdate> {
  late int _badgeCount;

  @override
  void initState() {
    _badgeCount = 0;
    _loadInitialBadgeCount();
    _registerStreamListener();
    super.initState();
  }

  void _loadInitialBadgeCount() async {
    String countStr = await AppSharedPref.getCartCount();
    if (mounted) {
      setState(() {
        _badgeCount = int.tryParse(countStr) ?? 0;
      });
    }
  }

  void _registerStreamListener() {
    TabbarController.countController.stream.listen((event) {
      if (mounted) {
        setState(() {
          _badgeCount = event;
        });
      } else {
        _badgeCount = event;
      }
      print("badge count $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return BadgeIcon(
      icon: ColorFiltered(
        colorFilter: ColorFilter.mode(
          widget._selectedIndex == 2
              ? AppColors.bottomBarIconActiveColor
              : AppColors.bottomBarIconInActiveColor,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          AppImages.cartIcon,
          width: AppSizes.size24,
          height: AppSizes.size24,
        ),
      ),
      badgeCount: _badgeCount,
    );
  }
}
