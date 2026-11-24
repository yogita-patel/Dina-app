import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:oc_demo/common_widgets/Tabbar/bottom_tabbar.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/main.dart';
import 'package:oc_demo/network_manager/catalogue_file_manager.dart';
import 'package:oc_demo/screens/notifications/views/other_notifications_widget.dart';

import '../constants/app_string_constant.dart';
import '../constants/arguments_map.dart';
import 'app_localizations.dart';

class Notifications with WidgetsBindingObserver {
  final _flutterPlugin = FlutterLocalNotificationsPlugin();

  final CHANNEL_ID = "CHANNEL_ID_OC";
  final CHANNEL_NAME = "NOTIFICATION_CHANNEL_OC";
  final CHANNEL_DESCRIPTION = "NOTIFICATION_CHANNEL_DESC_OC";

  Map<String, dynamic>? _pendingNotificationData;
  String? _pendingCatalogueFileReference;
  bool _hasCheckedInitialMessage = false;
  bool _isDispatchScheduled = false;
  bool _isCatalogueDispatchScheduled = false;
  bool _isLifecycleObserverRegistered = false;
  AppLifecycleState? _appLifecycleState =
      WidgetsBinding.instance.lifecycleState;

  static String cataloguePayload(String fileReference) => jsonEncode({
        'type': 'pdf_catalogue',
        'fileReference': fileReference,
      });

  bool _isBottomTabShellReady() {
    return BottomTabController.check.navigationCommandStream.hasListener;
  }

  Map<String, dynamic>? _normalizeNotificationData(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return null;
    }

    return Map<String, dynamic>.from(data);
  }

  void _queueNotificationTap(Map<String, dynamic>? data) {
    final normalizedData = _normalizeNotificationData(data);
    if (normalizedData == null) {
      return;
    }

    _pendingNotificationData = normalizedData;
  }

  void _dispatchPendingNotification([BuildContext? context]) {
    if (_pendingNotificationData == null || _isDispatchScheduled) {
      return;
    }

    _isDispatchScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _isDispatchScheduled = false;

      final navContext = context ?? navigatorKey.currentContext;
      if (navContext == null || _pendingNotificationData == null) {
        return;
      }

      final data = _pendingNotificationData;
      _pendingNotificationData = null;
      handleNotificationCLick(data, navContext);
    });
  }

  void _dispatchPendingCatalogue() {
    if (_pendingCatalogueFileReference == null ||
        _isCatalogueDispatchScheduled ||
        _appLifecycleState != AppLifecycleState.resumed) {
      return;
    }

    _isCatalogueDispatchScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isCatalogueDispatchScheduled = false;
      if (_appLifecycleState != AppLifecycleState.resumed) {
        return;
      }
      final reference = _pendingCatalogueFileReference;
      if (reference == null) return;
      _pendingCatalogueFileReference = null;
      try {
        await CatalogueFileManager.open(reference);
      } catch (error) {
        debugPrint('Unable to open downloaded PDF Catalogue: $error');
      }
    });
    WidgetsBinding.instance.scheduleFrame();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    if (state == AppLifecycleState.resumed) {
      _dispatchPendingCatalogue();
    }
  }

  Future<void> _cacheInitialMessage() async {
    if (_hasCheckedInitialMessage) {
      return;
    }

    _hasCheckedInitialMessage = true;
    final message = await FirebaseMessaging.instance.getInitialMessage();
    _queueNotificationTap(message?.data);
  }

  void _openCartInBottomTab() {
    if (_isBottomTabShellReady()) {
      navigatorKey.currentState?.popUntil((route) => route.isFirst);
      BottomTabController.check.navigationCommandStream.sink.add(
        const BottomTabNavigationCommand(
          tabIndex: 2,
          popToRootFirst: true,
        ),
      );
      return;
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoute.bottomTabBAr,
      (route) => false,
      arguments: 2,
    );
  }

  NavigatorState? _navigator() {
    return navigatorKey.currentState;
  }

  Future<void> _navigateWithinTab({
    required int tabIndex,
    String? routeName,
    Object? arguments,
    bool popToRootFirst = false,
  }) async {
    if (_isBottomTabShellReady()) {
      _navigator()?.popUntil((route) => route.isFirst);
      await Future.delayed(Duration.zero);

      BottomTabController.check.navigationCommandStream.sink.add(
        BottomTabNavigationCommand(
          tabIndex: tabIndex,
          routeName: routeName,
          arguments: arguments,
          popToRootFirst: popToRootFirst,
        ),
      );
      return;
    }

    if (routeName != null) {
      _navigator()?.pushNamed(routeName, arguments: arguments);
    }
  }

  Future<void> _navigateToHome() async {
    if (_isBottomTabShellReady()) {
      BottomTabController.check.navigationCommandStream.sink.add(
        const BottomTabNavigationCommand(
          tabIndex: 0,
          popToRootFirst: true,
        ),
      );
      return;
    }

    _navigator()?.pushNamedAndRemoveUntil(
      AppRoute.bottomTabBAr,
      (route) => false,
      arguments: 0,
    );
  }

  Future<void> _requireLoginAndNavigate(
    Future<void> Function() onLoggedIn,
  ) async {
    final isLoggedIn = await AppSharedPref.isLogin();
    if (isLoggedIn) {
      await onLoggedIn();
      return;
    }

    await _navigateToHome();
  }

  Future<void> init() async {
    if (!_isLifecycleObserverRegistered) {
      WidgetsBinding.instance.addObserver(this);
      _isLifecycleObserverRegistered = true;
    }
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    const android = AndroidInitializationSettings("@drawable/ic_status");

    // final ios = IOSInitializationSettings(
    //   onDidReceiveLocalNotification: onDidReceiveNotification,
    // );
    final ios = const DarwinInitializationSettings();
    final setting = InitializationSettings(android: android, iOS: ios);
    await _flutterPlugin.initialize(
      setting,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        handleNotificationPayload(response.payload);
      },
    );
    final launchDetails =
        await _flutterPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      final data = _decodePayload(payload);
      if (data?['type'] == 'pdf_catalogue') {
        _pendingCatalogueFileReference = data?['fileReference']?.toString();
      } else {
        _queueNotificationTap(data);
      }
    }
    await _cacheInitialMessage();
    // Register a global listener for notification taps when the app is opened from background or terminated state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      _queueNotificationTap(event.data);
      _dispatchPendingNotification();
    });
  }

  Future<void> onDidReceiveNotification(
      int id, String? title, String? body, String? payload) async {}

  Map<String, dynamic>? _decodePayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      return decoded is Map<String, dynamic> ? decoded : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> handleNotificationPayload(String? payload) async {
    final data = _decodePayload(payload);
    if (data == null) return;

    if (data['type'] == 'pdf_catalogue') {
      final reference = data['fileReference']?.toString();
      if (reference == null || reference.isEmpty) return;
      _pendingCatalogueFileReference = reference;
      _dispatchPendingCatalogue();
      return;
    }

    try {
      _queueNotificationTap(data);
      _dispatchPendingNotification();
      // Navigator.of(navigatorKey.currentContext!).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (ctx) => BottomTabbarWidget()),
      //   (route) => false,
      // );
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<bool> _requestNotificationPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return await _flutterPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          true;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return await _flutterPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          true;
    }
    return true;
  }

  Future<bool> showCatalogueDownloadNotification(String fileReference) async {
    if (!await _requestNotificationPermission()) return false;

    await _flutterPlugin.show(
      102,
      AppStringConstant.pdfCatalogueDownloaded.localized(),
      AppStringConstant.tapToOpenPdfCatalogue.localized(),
      NotificationDetails(
        android: AndroidNotificationDetails(
          CHANNEL_ID,
          CHANNEL_NAME,
          channelDescription: CHANNEL_DESCRIPTION,
          priority: Priority.high,
          importance: Importance.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: cataloguePayload(fileReference),
    );
    return true;
  }

  Future<StyleInformation?> getNotificationStyle(String? image) async {
    if (image != null) {
      try {
        final ByteData imageData =
            await NetworkAssetBundle(Uri.parse(image)).load("");
        return BigPictureStyleInformation(
            ByteArrayAndroidBitmap(imageData.buffer.asUint8List()));
      } catch (e, stk) {
        print(stk);
      }
    } else {
      return null;
    }
    return null;
  }

  Future<void> showNotification(
      String? title, String? message, String? payload, String? image) async {
    print("pankaj showNotification");
    var notificationStyle = await getNotificationStyle(image);
    await _flutterPlugin.show(
      101,
      title,
      message,
      NotificationDetails(
        android: AndroidNotificationDetails(
          CHANNEL_ID,
          CHANNEL_NAME,
          // CHANNEL_DESCRIPTION,
          priority: Priority.high,
          importance: Importance.max,
          styleInformation: notificationStyle,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void checkInitialMessage(BuildContext context) {
    FirebaseMessaging.instance.subscribeToTopic("OpenCart");
    _dispatchPendingCatalogue();
    _dispatchPendingNotification(context);
  }

  Future<void> handleNotificationCLick(
      Map<String, dynamic>? data, BuildContext context) async {
    if (data != null) {
      if (data['type'] == "product") {
        Navigator.of(context).pushNamed(AppRoute.productPage,
            arguments: getProductDataAttributeMap(
              data["title"] ?? "",
              data["id"] ?? "",
            ));
      } else if (data['type'] == "cart") {
        _openCartInBottomTab();
      } else if (data['type'] == "backorder") {
        await _requireLoginAndNavigate(
          () => _navigateWithinTab(
            tabIndex: 1,
            routeName: AppRoute.wishlist,
          ),
        );
        return;
      } else if (data['type'] == "category") {
        Navigator.of(context).pushNamed(
          AppRoute.catalog,
          arguments: categoryMap(data["id"] ?? "", data["title"] ?? "", "", ""),
        );
      } else if (data['type'] == "Custom") {
        Navigator.of(context).pushNamed(
          AppRoute.catalog,
          arguments: categoryMap(data["id"] ?? "", data["title"] ?? "",
              GlobalData.custom_collection, ""),
        );
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (ctx) => OtherNotificationWidget(data["title"] ?? "",
                  (data["content"] ?? "") + "\n" + data["comment"] ?? "")),
        );
      }
    }

    // Listener moved to init() to avoid multiple registrations.
    // No onMessageOpenedApp listener here.
  }
}

final notification = Notifications();
