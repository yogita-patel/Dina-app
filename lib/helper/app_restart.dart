import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';

class AppRestart extends StatefulWidget {
  final Widget child;

  const AppRestart({super.key, required this.child});

  @override
  _AppRestartState createState() => _AppRestartState();

  static rebirth(BuildContext context) {
    context.findAncestorStateOfType<_AppRestartState>()!.restartApp();
  }
}

class _AppRestartState extends State<AppRestart> {
  Key _key = UniqueKey();

  void restartApp() {
    // BottomTabController.check.dispose();
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }
}
