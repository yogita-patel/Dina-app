import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_repository.dart';
import 'package:oc_demo/screens/profile/bloc/profile_repository.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_bloc.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../screens/home/bloc/home_screen_bloc.dart';
import '../../screens/home/bloc/home_screen_repository.dart';
import '../../screens/quick_cart/bloc/quick_cart_bloc.dart';
import '../../screens/quick_cart/bloc/quick_cart_repository.dart';
import 'badge_icon_update.dart';

class BottomTabController {
  BottomTabController._();

  static final check = BottomTabController._();
  StreamController<int>? countController = StreamController<int>.broadcast();

  StreamController<int> currentStateUpdateStream =
      StreamController<int>.broadcast();

  // StreamSubscription? loginStreamSubscription;

  StreamController<bool> updateLoginStreamController =
      StreamController<bool>.broadcast();

  StreamController<BottomTabNavigationCommand> navigationCommandStream =
      StreamController<BottomTabNavigationCommand>.broadcast();
}

class BottomTabNavigationCommand {
  const BottomTabNavigationCommand({
    required this.tabIndex,
    this.routeName,
    this.route,
    this.arguments,
    this.popToRootFirst = false,
    this.pushReplacement = false,
  });

  final int tabIndex;
  final String? routeName;
  final Route<dynamic>? route;
  final Object? arguments;
  final bool popToRootFirst;
  final bool pushReplacement;
}

class TabbarController {
  static StreamController<int> countController =
      StreamController<int>.broadcast();

  TabbarController._privateConstructor();

  static final TabbarController _instance =
      TabbarController._privateConstructor();

  factory TabbarController() {
    return _instance;
  }

  static void dispose() {}
}

class BottomTabbarWidget extends StatefulWidget {
  final int initialIndex;

  const BottomTabbarWidget({super.key, this.initialIndex = 0});

  @override
  _BottomTabbarWidgetState createState() => _BottomTabbarWidgetState();
}

class _BottomTabbarWidgetState extends State<BottomTabbarWidget> {
  AppLocalizations? _localizations;
  int _selectedIndex = 0;
  int categoryIndex = 0;
  StreamSubscription<int>? _tabIndexSubscription;
  StreamSubscription<BottomTabNavigationCommand>?
      _navigationCommandSubscription;

  @override
  void initState() {
    print("defhrrgg");
    _tabIndexSubscription =
        BottomTabController.check.countController?.stream.listen(
      (event) {
        print("listing.... $event");
        if (mounted) {
          setState(() {
            _selectedIndex = event;
          });
        }
      },
    );

    _navigationCommandSubscription = BottomTabController
        .check.navigationCommandStream.stream
        .listen(_handleNavigationCommand);

    _selectedIndex = widget.initialIndex;
    _setCartBadge();
    setState(() {});
    super.initState();
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
    (index) => GlobalKey<NavigatorState>(),
  );

  void _onTap(int index) {
    BottomTabController.check.currentStateUpdateStream.sink.add(index);

    print(
        "on tap invoked ................... ...................... .................... .");
    if (index == _selectedIndex) {
      print("_selectedIndex$_selectedIndex");
      _navigatorKeys[index].currentState!.popUntil((r) => r.isFirst);
    } else {
      setState(() {
        print("_selecte1qer45dIndex$index");
        _selectedIndex = index;
        _navigatorKeys[index].currentState!.popUntil((r) => r.isFirst);
      });
    }
    AppSharedPref.getCartCount().then((value) {
      print("cart count here is $value");
      TabbarController.countController.sink.add(int.tryParse(value) ?? 0);
    });
  }

  //to sync cart count on badge.
  void _setCartBadge() async {
    print("here");
    TabbarController.countController.sink
        .add(int.parse(await AppSharedPref.getCartCount()));
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabIndexSubscription?.cancel();
    _navigationCommandSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleNavigationCommand(
      BottomTabNavigationCommand command) async {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedIndex = command.tabIndex;
    });
    BottomTabController.check.currentStateUpdateStream.sink.add(
      command.tabIndex,
    );

    await Future.delayed(Duration.zero);

    final navigatorState = _navigatorKeys[command.tabIndex].currentState;
    if (navigatorState == null) {
      return;
    }

    if (command.popToRootFirst) {
      navigatorState.popUntil((route) => route.isFirst);
    }

    if (command.route != null) {
      navigatorState.push(command.route!);
      return;
    }

    if (command.routeName != null) {
      if (command.pushReplacement && navigatorState.canPop()) {
        navigatorState.pushReplacementNamed(
          command.routeName!,
          arguments: command.arguments,
        );
      } else {
        navigatorState.pushNamed(
          command.routeName!,
          arguments: command.arguments,
        );
      }
    }
  }

  // void moveToCategory(int index) {
  //   setState(() {
  //     _selectedIndex = 1;
  //     categoryIndex = index;
  //   });
  // }
  Future<bool> _onWillPop() async {
    final currentNavigatorState = _navigatorKeys[_selectedIndex].currentState!;
    if (await currentNavigatorState.maybePop()) {
      return false;
    } else if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print("dfhgngfjghjhj");
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            // body: widgetList.elementAt(_selectedIndex),
            body: Stack(
              children: [
                MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeScreenBloc>(
                      create: (context) => HomeScreenBloc(
                        repository: HomeScreenRepositoryImp(),
                      ),
                    ),
                  ],
                  child: _buildOffstageNavigator(0, AppRoute.homePage),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<ProfileScreenBloc>(
                        create: (context) => ProfileScreenBloc(
                            repository: ProfileRepositoryImp()))
                  ],
                  child: _buildOffstageNavigator(1, AppRoute.profile),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<CartScreenBloc>(
                        create: (context) => CartScreenBloc(
                            repository: CartScreenRepositoryImp()))
                  ],
                  child: _buildOffstageNavigator(2, AppRoute.cart),
                ),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<QuickCartBloc>(
                        create: (context) =>
                            QuickCartBloc(repository: QuickCartImpRepository()))
                  ],
                  child: _buildOffstageNavigator(3, AppRoute.quickCart),
                ),
                // (mAppStoragePref.getIsTabCategoryView() == "0")
                //     ? MultiBlocProvider(
                //         providers: [
                //           BlocProvider<CategoriesScreenBloc>(
                //             create: (context) => CategoriesScreenBloc(
                //               repository: CategoriesScreenRepositoryImp(),
                //             ),
                //           ),
                //         ],
                //         child: CategoriesScreen(
                //           selectedIndex: categoryIndex,
                //         ),
                //       )
                //     : const CategorySearchScreen(),
                MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeScreenBloc>(
                      create: (context) => HomeScreenBloc(
                        repository: HomeScreenRepositoryImp(),
                      ),
                    ),
                  ],
                  child: _buildOffstageNavigator(4, AppRoute.menu),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.dividerColor, // Set your desired color
                    width: 1.0, // Set border thickness
                  ),
                ),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory:
                      NoSplash.splashFactory, // completely removes animation
                ),
                child: BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  onTap: _onTap,
                  showSelectedLabels: false,
                  showUnselectedLabels: false,
                  type: BottomNavigationBarType.fixed,
                  items: List.generate(5, (index) {
                    final isSelected = _selectedIndex == index;
                    final iconPath = [
                      AppImages.homeIcon,
                      AppImages.accountIcon,
                      AppImages.cartIcon,
                      AppImages.quickOrderIcon,
                      AppImages.menuIcon,
                    ][index];
                    final labels = [
                      _localizations?.translate(AppStringConstant.home) ?? '',
                      _localizations?.translate(AppStringConstant.account) ??
                          '',
                      _localizations?.translate(AppStringConstant.cart) ?? '',
                      _localizations?.translate(AppStringConstant.quickOrder) ??
                          '',
                      _localizations?.translate(AppStringConstant.menu) ?? '',
                    ];
                    Widget iconWidget = index == 2
                        ? BadgeIconUpdate(_selectedIndex)
                        : Image.asset(
                            iconPath,
                            width: AppSizes.size20,
                            height: AppSizes.size20,
                            color: isSelected
                                ? AppColors.bottomBarIconActiveColor
                                : AppColors.bottomBarIconInActiveColor,
                          );
                    return BottomNavigationBarItem(
                      //label: labels[index],
                      label: "",
                      icon: Container(
                        width: MediaQuery.of(context).size.width / 5,
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size4,
                        ),
                        //padding: const EdgeInsets.only(left: AppSizes.size5,right: AppSizes.size5,bottom:AppSizes.size5,top: AppSizes.size5),// 1/5th of device width
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSizes.size8),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: AppColors.selectedBoxBackground,
                                borderRadius:
                                    BorderRadius.circular(AppSizes.size8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 0,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              )
                            : null,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   iconPath,
                            //   width: AppSizes.size24,
                            //   height: AppSizes.size24,
                            //   color: isSelected
                            //       ? AppColors.bottomBarIconActiveColor
                            //       : AppColors.bottomBarIconInActiveColor,
                            // ),
                            iconWidget,
                            const SizedBox(height: AppSizes.size2),
                            Text(
                              labels[index],
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppSizes.size12,
                                fontWeight: FontWeight.w400,
                                color: isSelected
                                    ? AppColors.bottomBarIconActiveColor
                                    : AppColors.bottomBarIconInActiveColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            )));
  }

  Widget _buildOffstageNavigator(int index, String initialRoute) {
    print("efefrgth6th${_navigatorKeys[index].currentState}");
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        // onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => child),
        initialRoute: initialRoute,
        onGenerateRoute: AppRoute.generateRoute,
      ),
    );
  }
}
