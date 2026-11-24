// /*
// * Webkul Software.
// *
// @package Mobikul Application Code.
// * @Category Mobikul
// * @author Webkul <support@webkul.com>
// * @Copyright (c) Webkul Software Private Limited (https://webkul.com)
// * @license https://store.webkul.com/license.html
// * @link https://store.webkul.com/license.html
// *
// */

import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/address/add_address_request.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:oc_demo/screens/menu/contact_form/contact_form.dart';

import 'common_widgets/Tabbar/bottom_tabbar.dart';
import 'network_manager/download_file.dart';
import 'screens/cmsPage/catalogue_link_handler.dart';

/// Routes that should NOT be handled in-app.
/// These will be opened in the external browser instead.
const _excludedRoutes = [
  'extension/module/email_verification',
  'account/forgotten',
  'account/reset',
];

const _findCategoryCarouselId = 'carousel_1';

class _ResolvedDeepLink {
  const _ResolvedDeepLink({
    required this.error,
    this.route,
    this.id,
    this.keyword,
    this.title,
  });

  final int error;
  final String? route;
  final String? id;
  final String? keyword;
  final String? title;

  factory _ResolvedDeepLink.fromJson(Map<String, dynamic> json) {
    return _ResolvedDeepLink(
      error: (json['error'] as num?)?.toInt() ?? 1,
      route: json['route']?.toString(),
      id: json['id']?.toString(),
      keyword: json['keyword']?.toString(),
      title: json['title']?.toString(),
    );
  }
}

class DeepLinkHandler {
  static bool _catalogueDownloadInProgress = false;

  /// Preserve homepage navigation while downloading direct catalogue links.
  static Future<bool> handleCatalogueDeepLink(
    String url,
    GlobalKey<NavigatorState> navigatorKey, {
    Future<void> Function()? navigateToHome,
    Download? downloader,
  }) async {
    final handler = CatalogueLinkHandler(() async {
      await (navigateToHome?.call() ?? _navigateToHome(navigatorKey));
      if (_catalogueDownloadInProgress) return;
      final overlay = navigatorKey.currentState?.overlay;
      if (overlay == null || !overlay.mounted) return;
      _catalogueDownloadInProgress = true;
      final finished = Completer<void>();
      var started = false;
      final entry = OverlayEntry(builder: (context) {
        if (!started) {
          started = true;
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              if (context.mounted) {
                await (downloader ?? Download()).downloadCatalogue(context);
              }
              finished.complete();
            } catch (error, stackTrace) {
              finished.completeError(error, stackTrace);
            }
          });
        }
        return const SizedBox.shrink();
      });
      try {
        overlay.insert(entry);
        await finished.future;
      } finally {
        entry.remove();
        entry.dispose();
        _catalogueDownloadInProgress = false;
      }
    });
    return handler.handle(url);
  }

  static const MethodChannel _channel =
      MethodChannel("com.webkul.oc.methodchannel");
  static String? _lastHandledDeepLink;
  static DateTime? _lastHandledDeepLinkAt;
  static bool _initialLinkRequested = false;

  /// Initialize DeepLinkHandler
  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _channel.setMethodCallHandler((call) async {
      print("DeepLink Handler Method Called: ${call.method}");
      if (call.method == "handleDeepLink") {
        final deepLink = call.arguments as String;
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await _dispatchDeepLink(deepLink, navigatorKey);
        });
      }
    });

    // Check for initial link on cold start
    _checkInitialLink(navigatorKey);
  }

  static Future<void> _checkInitialLink(
      GlobalKey<NavigatorState> navigatorKey) async {
    // Logout rebuilds the widget tree, but Android retains the launch intent.
    // Read it once per Dart session; new taps still arrive via handleDeepLink.
    if (_initialLinkRequested) return;
    _initialLinkRequested = true;
    try {
      final String? initialLink = await _channel.invokeMethod('initialLink');
      if (initialLink != null) {
        await _dispatchDeepLink(initialLink, navigatorKey);
      }
    } catch (e) {
      print("Failed to get initial link: $e");
    }
  }

  static Future<void> _dispatchDeepLink(
    String deepLink,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final normalizedLink = deepLink.trim();
    if (normalizedLink.isEmpty) {
      return;
    }

    final now = DateTime.now();
    final isRecentDuplicate = _lastHandledDeepLink == normalizedLink &&
        _lastHandledDeepLinkAt != null &&
        now.difference(_lastHandledDeepLinkAt!) < const Duration(seconds: 3);
    if (isRecentDuplicate) {
      print("Skipping duplicate deep link: $normalizedLink");
      return;
    }

    _lastHandledDeepLink = normalizedLink;
    _lastHandledDeepLinkAt = now;
    await _waitForBottomTabShell();
    await _handleDeepLink(normalizedLink, navigatorKey);
  }

  /// Check if the deep link route is in the exclusion list
  static bool _isExcludedRoute(String? route) {
    if (route == null) return false;
    return _excludedRoutes.any((excluded) => route.startsWith(excluded));
  }

  /// Open a URL in the external browser
  static Future<void> _openInBrowser(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print("Could not launch URL in browser: $e");
    }
  }

  static bool _looksLikeSeoUrl(Uri uri) {
    if (uri.queryParameters.containsKey('route')) {
      return false;
    }

    final normalizedPath = uri.path.trim();
    if (normalizedPath.isEmpty || normalizedPath == '/') {
      return false;
    }

    final firstSegment =
        uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '';
    if (firstSegment == 'index.php') {
      return false;
    }

    return true;
  }

  static String? _extractSeoKeyword(Uri uri) {
    final keyword = uri.pathSegments
        .where((segment) => segment.trim().isNotEmpty)
        .join('/')
        .trim();
    if (keyword.isEmpty) {
      return null;
    }
    return keyword;
  }

  static Future<bool> _handleStaticSeoKeyword(
    String keyword,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final normalizedKeyword = keyword.trim().toLowerCase();

    // Some SEO slugs are not resolved by the API, so map them directly.
    if (normalizedKeyword == 'find-category') {
      await _navigateWithinTab(
        navigatorKey,
        tabIndex: 0,
        routeName: AppRoute.brand,
        arguments: _findCategoryCarouselId,
      );
      return true;
    }

    if (normalizedKeyword == 'dina-pdf-catalogue') {
      print(
          "Matched PDF Catalogue deep link keyword: $keyword. Opening URL: ${ApiConstant.pdfCatalogueLandingUrl}");
      await _navigateWithinTab(
        navigatorKey,
        tabIndex: 0,
        routeName: AppRoute.cmsPage,
        arguments: {
          'cmsPageTitle': 'PDF Catalogue',
          'cmsPageUrl': ApiConstant.pdfCatalogueLandingUrl,
        },
        pushReplacement: true,
      );
      return true;
    }

    return false;
  }

  static String? _buildResolvedRouteUrl(_ResolvedDeepLink resolvedLink) {
    final route = resolvedLink.route?.trim();
    if (route == null || route.isEmpty) {
      return null;
    }

    final id = resolvedLink.id?.trim();
    final queryParameters = <String, String>{
      'route': route,
    };

    switch (route) {
      case 'product/product':
        if (id != null && id.isNotEmpty) {
          queryParameters['product_id'] = id;
        }
        break;
      case 'product/category':
        if (id != null && id.isNotEmpty) {
          queryParameters['path'] = id;
        }
        break;
      case 'product/manufacturer/info':
        if (id != null && id.isNotEmpty) {
          queryParameters['manufacturer_id'] = id;
        }
        break;
      case 'information/information':
      case 'extension/maza/page':
        if (id != null && id.isNotEmpty) {
          queryParameters[route == 'extension/maza/page'
              ? 'page_id'
              : 'information_id'] = id;
        }
        break;
    }

    final title = resolvedLink.title?.trim();
    if (title != null && title.isNotEmpty) {
      queryParameters['title'] = title;
    }

    return Uri(
      path: 'index.php',
      queryParameters: queryParameters,
    ).toString();
  }

  static Future<void> _ensureHomeReferenceDataLoaded() async {
    final hasCachedReferenceData =
        (GlobalData.shopCatergory?.isNotEmpty ?? false) ||
            (GlobalData.sideMenu != null) ||
            (GlobalData.homeCarousels?.isNotEmpty ?? false);
    if (hasCachedReferenceData) {
      return;
    }

    try {
      final box = await Hive.openBox('homeBox');
      final cachedJson = box.get('homeData');
      if (cachedJson is! String || cachedJson.isEmpty) {
        return;
      }

      final cachedModel = HomePageData.fromJson(jsonDecode(cachedJson));
      GlobalData.rootCategories ??= cachedModel.categories;
      GlobalData.homeCarousels ??= cachedModel.carousels;
      GlobalData.shopCatergory ??= cachedModel.shopCatergory;
      GlobalData.subCategory ??= cachedModel.subcategory;
      GlobalData.cmsPageData ??= cachedModel.footerMenu;
      GlobalData.sideMenu ??= cachedModel.sidemenu;
      GlobalData.mainMenu ??= cachedModel.mainMenu;
      GlobalData.socialLink ??= cachedModel.social_links;
      GlobalData.getIntouch ??= cachedModel.getIntouch;
    } catch (e) {
      print('Error loading cached home reference data: $e');
    }
  }

  static String _deepLinkTitle(Uri uri) {
    return uri.queryParameters['title']?.trim() ?? "";
  }

  static String _resolveManufacturerTitle(
      String manufacturerId, String fallback) {
    final matchedCategory = GlobalData.shopCatergory?.firstWhere(
      (item) => item.manufacturerId == manufacturerId,
      orElse: () => ShopCatergory(),
    );

    return matchedCategory?.name?.trim().isNotEmpty == true
        ? matchedCategory!.name!.trim()
        : fallback;
  }

  static String _resolveCategoryTitle(String path, String fallback) {
    for (final carousel in GlobalData.homeCarousels ?? <Carousels>[]) {
      for (final slider in carousel.slider ?? <SliderImages>[]) {
        if (slider.link == path && (slider.title?.trim().isNotEmpty ?? false)) {
          return slider.title!.trim();
        }
      }
    }

    return fallback;
  }

  static String _resolveInformationTitle(
      String informationId, String fallback) {
    final sideMenuItems = <AbautUs>[
      ...?GlobalData.sideMenu?.abaut_us,
      ...?GlobalData.sideMenu?.quick_link,
    ];

    final matchedItem = sideMenuItems.firstWhere(
      (item) => item.information_id == informationId,
      orElse: () => AbautUs(),
    );

    return matchedItem.name?.trim().isNotEmpty == true
        ? matchedItem.name!.trim()
        : fallback;
  }

  /// Resolve CMS URLs using the same mapping used for incoming app links.
  static Future<String?> resolveCmsPageId(String url) async {
    if (url.contains('dina-pdf-catalogue')) {
      return '38';
    }
    final resolved = await _resolveSeoDeepLink(url);
    if (resolved == null) return null;
    final query = Uri.parse(resolved).queryParameters;
    switch (query['route']) {
      case 'information/information':
        return query['information_id'];
      case 'extension/maza/page':
        return query['page_id'];
      default:
        return null;
    }
  }

  static Future<String?> _resolveSeoDeepLink(String deepLink) async {
    try {
      final uri = Uri.parse(deepLink);
      final keyword = _extractSeoKeyword(uri);
      if (keyword == null) {
        return null;
      }

      final wkToken = await AppSharedPref.getWkToken();
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          headers: const {
            'Accept': 'application/json',
          },
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: const Duration(milliseconds: 50000),
          connectTimeout: const Duration(milliseconds: 50000),
        ),
      );

      Response response;
      try {
        response = await dio.post(
          'index.php?route=api/wkrestapi/common/resolveDeepLink',
          data: {
            'wk_token': wkToken,
            'url': keyword,
          },
        );
      } catch (e) {
        print(
            'Initial resolveDeepLink failed, forcefully refreshing token via apiLogin: $e');
        var res = await AppSharedPref.getLoginUserData();
        var loginResult = await Dio().post(
          ApiConstant.baseUrl + "index.php?route=api/wkrestapi/common/apiLogin",
          data: FormData.fromMap({
            'apiKey': ApiConstant.apiKey,
            'apiPassword': ApiConstant.apiPassword,
            'customer_id': res?.customerId ?? "",
            'language': await AppSharedPref.getLanguage(),
            'currency': await AppSharedPref.getCurrency()
          }),
          options: Options(
            headers: {'Accept': 'application/json'},
            responseType: ResponseType.json,
          ),
        );

        String newWkToken = wkToken;
        var responseData = loginResult.data;
        if (responseData is Map<String, dynamic> &&
            responseData['wk_token'] != null) {
          newWkToken = responseData['wk_token'];
          await AppSharedPref.setWkToken(newWkToken);
        }

        response = await dio.post(
          'index.php?route=api/wkrestapi/common/resolveDeepLink',
          data: {
            'wk_token': newWkToken,
            'url': keyword,
          },
        );
      }

      if (response.data is! Map<String, dynamic>) {
        throw Exception(
            'Invalid API Response: Expected JSON Map but got ${response.data.runtimeType}. Content: ${response.data}');
      }

      final resolvedLink =
          _ResolvedDeepLink.fromJson(response.data as Map<String, dynamic>);
      if (resolvedLink.error != 0) {
        throw Exception(
            'API Error: ${resolvedLink.error}. Response: ${response.data}');
      }

      return _buildResolvedRouteUrl(resolvedLink);
    } catch (e) {
      print('Error resolving SEO deep link: $e');
      throw Exception('DeepLink Resolution Error: $e');
    }
  }

  static NavigatorState? _navigator(GlobalKey<NavigatorState> navigatorKey) {
    return navigatorKey.currentState;
  }

  static bool _isBottomTabShellReady() {
    return BottomTabController.check.navigationCommandStream.hasListener;
  }

  static Future<void> _waitForBottomTabShell() async {
    const maxAttempts = 100;
    var attempt = 0;

    while (!_isBottomTabShellReady() && attempt < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 100));
      attempt++;
    }
  }

  static Future<void> _navigateWithinTab(
    GlobalKey<NavigatorState> navigatorKey, {
    required int tabIndex,
    String? routeName,
    Route<dynamic>? route,
    Object? arguments,
    bool popToRootFirst = false,
    bool pushReplacement = false,
  }) async {
    if (_isBottomTabShellReady()) {
      _navigator(navigatorKey)?.popUntil((route) => route.isFirst);
      await Future.delayed(Duration.zero);

      BottomTabController.check.navigationCommandStream.sink.add(
        BottomTabNavigationCommand(
          tabIndex: tabIndex,
          routeName: routeName,
          route: route,
          arguments: arguments,
          popToRootFirst: popToRootFirst,
          pushReplacement: pushReplacement,
        ),
      );
      return;
    }

    if (route != null) {
      _navigator(navigatorKey)?.push(route);
      return;
    }

    if (routeName != null) {
      await _pushNamed(
        navigatorKey,
        routeName,
        arguments: arguments,
      );
    }
  }

  static Future<void> _pushNamed(
    GlobalKey<NavigatorState> navigatorKey,
    String routeName, {
    Object? arguments,
  }) async {
    _navigator(navigatorKey)?.pushNamed(routeName, arguments: arguments);
  }

  static Future<void> _pushContactForm(
      GlobalKey<NavigatorState> navigatorKey) async {
    await _navigateWithinTab(
      navigatorKey,
      tabIndex: 4,
      route: MaterialPageRoute(builder: (_) => const ContactForm()),
    );
  }

  static Future<void> _navigateToHome(
      GlobalKey<NavigatorState> navigatorKey) async {
    if (_isBottomTabShellReady()) {
      BottomTabController.check.navigationCommandStream.sink.add(
        const BottomTabNavigationCommand(
          tabIndex: 0,
          popToRootFirst: true,
        ),
      );
      return;
    }

    BottomTabController.check.countController?.sink.add(0);
  }

  static Future<void> _navigateToLogin(
      GlobalKey<NavigatorState> navigatorKey) async {
    final isLoggedIn = await AppSharedPref.isLogin();
    if (isLoggedIn) {
      await _navigateToHome(navigatorKey);
      return;
    }

    await _navigateWithinTab(
      navigatorKey,
      tabIndex: 1,
      routeName: AppRoute.login,
      arguments: getSignInSignUpPageArgument(false, false),
    );
  }

  static Future<void> _requireLoginAndNavigate(
    GlobalKey<NavigatorState> navigatorKey,
    Future<void> Function() onLoggedIn,
  ) async {
    final isLoggedIn = await AppSharedPref.isLogin();
    if (isLoggedIn) {
      await onLoggedIn();
      return;
    }

    await _navigateToHome(navigatorKey);
  }

  /// Handle deep links
  static Future<void> _handleDeepLink(
      String deepLink, GlobalKey<NavigatorState> navigatorKey) async {
    print("Deep Link received in Flutter: $deepLink");

    try {
      final uri = Uri.parse(deepLink);
      //if (uri.path.contains('/admin')) { return; }
      // Normal deep links already contain route data, so we can navigate directly.
      if (await handleCatalogueDeepLink(deepLink, navigatorKey)) {
        return;
      }

      if (uri.queryParameters.containsKey('route')) {
        final route = uri.queryParameters['route'];
        final suppliedTitle = _deepLinkTitle(uri);

        // Skip excluded routes – open them in the browser instead
        if (_isExcludedRoute(route)) {
          print("Excluded deep link route: $route – opening in browser");
          await _openInBrowser(deepLink);
          return;
        }

        log(' deeplink route |$route');
        switch (route) {
          case 'common/home':
            await _navigateToHome(navigatorKey);
            return;
          case 'account/login':
            final loginToken = uri.queryParameters['token'];
            print('logintoken : $loginToken');
            if (loginToken != null && loginToken.isNotEmpty) {
              final ok = await _loginWithToken(loginToken);
              if (ok) {
                await _navigateToHome(navigatorKey);
                return;
              }
            }
            await _navigateToLogin(navigatorKey);
            return;
          case 'account/account':
          case 'account/edit':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.accountInfo,
              ),
            );
            return;
          case 'product/product':
            final productId = uri.queryParameters['product_id'];
            if (productId != null && productId.isNotEmpty) {
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 0,
                routeName: AppRoute.productPage,
                arguments: getProductDataAttributeMap("", productId),
              );
              return;
            }
            break;
          case 'product/category':
            final path = uri.queryParameters['path'];
            if (path != null && path.isNotEmpty) {
              await _ensureHomeReferenceDataLoaded();
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 0,
                routeName: AppRoute.catalog,
                arguments: categoryMap(
                  path,
                  _resolveCategoryTitle(path, suppliedTitle),
                  "",
                  "",
                ),
              );
              return;
            }
            break;
          case 'extension/maza/page':
            final pageId = uri.queryParameters['page_id'];
            if (pageId != null && pageId.isNotEmpty) {
              if (pageId == '12') {
                await _navigateWithinTab(
                  navigatorKey,
                  tabIndex: 0,
                  routeName: AppRoute.brand,
                  arguments: _findCategoryCarouselId,
                );
              } else {
                await _navigateWithinTab(
                  navigatorKey,
                  tabIndex: 0,
                  routeName: AppRoute.cmsPage,
                  arguments: getCmsPageArguments(pageId, suppliedTitle),
                );
              }
              return;
            }
            break;
          case 'product/manufacturer/info':
            final manufacturerId = uri.queryParameters['manufacturer_id'];
            if (manufacturerId != null && manufacturerId.isNotEmpty) {
              await _ensureHomeReferenceDataLoaded();
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 0,
                routeName: AppRoute.catalog,
                arguments: categoryMap(
                  manufacturerId,
                  _resolveManufacturerTitle(manufacturerId, suppliedTitle),
                  "",
                  "",
                  true,
                ),
              );
              return;
            }
            break;
          case 'information/information':
            final informationId = uri.queryParameters['information_id'];
            if (informationId != null && informationId.isNotEmpty) {
              await _ensureHomeReferenceDataLoaded();
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 0,
                routeName: AppRoute.cmsPage,
                arguments: getCmsPageArguments(
                  informationId,
                  _resolveInformationTitle(informationId, suppliedTitle),
                ),
              );
              return;
            }
            break;
          case 'information/contact':
            await _pushContactForm(navigatorKey);
            return;
          case 'account/wishlist':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.wishlist,
              ),
            );
            return;
          case 'extension/eb_quick_order':
            await _navigateWithinTab(
              navigatorKey,
              tabIndex: 3,
              routeName: AppRoute.quickCart,
              popToRootFirst: true,
            );
            return;
          case 'checkout/cart':
            await _navigateWithinTab(
              navigatorKey,
              tabIndex: 2,
              routeName: AppRoute.cart,
              popToRootFirst: true,
            );
            return;
          case 'checkout/checkout':
            final isLoggedIn = await AppSharedPref.isLogin();
            if (isLoggedIn) {
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 2,
                routeName: AppRoute.shipping,
                arguments: getShippingPageArgument(
                  AddAddressRequest(),
                  "",
                  false,
                ),
              );
            } else {
              await _navigateWithinTab(
                navigatorKey,
                tabIndex: 2,
                routeName: AppRoute.guestCheckout,
              );
            }
            return;
          case 'account/order':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.orderList,
                arguments: false,
              ),
            );
            return;
          case 'account/order/info':
            final orderId = uri.queryParameters['order_id'];
            await _requireLoginAndNavigate(
              navigatorKey,
              () async {
                if (orderId != null && orderId.isNotEmpty) {
                  await _navigateWithinTab(
                    navigatorKey,
                    tabIndex: 1,
                    routeName: AppRoute.orderDetail,
                    arguments: orderId,
                  );
                } else {
                  await _navigateWithinTab(
                    navigatorKey,
                    tabIndex: 1,
                    routeName: AppRoute.orderList,
                    arguments: false,
                  );
                }
              },
            );
            return;
          case 'account/order_products':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.previouslyOrderedScreen,
                arguments: false,
              ),
            );
            return;
          case 'account/password':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.changePassword,
              ),
            );
            return;
          case 'account/address':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.addressBook,
              ),
            );
            return;
          case 'account/address/add':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.addEditAddress,
              ),
            );
            return;
          case 'account/address/edit':
            final addressId = uri.queryParameters['address_id'];
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.addEditAddress,
                arguments: addressId == null || addressId.isEmpty
                    ? null
                    : {"addressId": addressId},
              ),
            );
            return;
          case 'account/newsletter':
            await _requireLoginAndNavigate(
              navigatorKey,
              () => _navigateWithinTab(
                navigatorKey,
                tabIndex: 1,
                routeName: AppRoute.newsLetter,
              ),
            );
            return;
        }
      }

      // SEO links do not contain route/id values, so resolve them first via API
      // and then pass the resolved route back through the same navigation flow.
      if (_looksLikeSeoUrl(uri)) {
        final seoKeyword = _extractSeoKeyword(uri);
        if (seoKeyword != null &&
            await _handleStaticSeoKeyword(seoKeyword, navigatorKey)) {
          return;
        }

        final resolvedDeepLink = await _resolveSeoDeepLink(deepLink);
        if (resolvedDeepLink != null) {
          print('Resolved SEO deep link: $deepLink -> $resolvedDeepLink');
          await _handleDeepLink(resolvedDeepLink, navigatorKey);
          return;
        }
      }

      print(
          "Unrecognized deep link pattern: $deepLink - Redirecting to home page");
      await _navigateToHome(navigatorKey);
    } catch (e) {
      print("Error parsing deep link: $e - Redirecting to home page");
      await _navigateToHome(navigatorKey);
    }
  }

  static Future<bool> _loginWithToken(String loginToken) async {
    try {
      final wkToken = await AppSharedPref.getWkToken();
      final dio = Dio(
        BaseOptions(
          baseUrl: ApiConstant.baseUrl,
          headers: const {'Accept': 'application/json'},
          contentType: Headers.formUrlEncodedContentType,
          receiveTimeout: const Duration(milliseconds: 50000),
          connectTimeout: const Duration(milliseconds: 50000),
        ),
      );

      final response = await dio.post(
        'index.php?route=api/wkrestapi/customer/tokenLogin',
        data: {'wk_token': wkToken, 'token': loginToken},
      );

      final data = response.data;
      if (data is! Map<String, dynamic> ||
          data['error'] != null ||
          data['fault'] != null) {
        return false;
      }

      // TODO: save the login exactly as the normal login does (see below)
      return true;
    } catch (e) {
      print('Token login failed: $e');
      return false;
    }
  }
}
