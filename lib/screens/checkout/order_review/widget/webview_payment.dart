import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common_widgets/app_bar.dart';
import '../../../../common_widgets/loader.dart';
import 'custom_webview_android.dart';

class WebViewPayment extends StatefulWidget {
  final String? redirectUrl;
  final String? successUrl;
  final String? failureUrl;
  final String? id;

  const WebViewPayment({
    Key? key,
    this.redirectUrl,
    this.successUrl,
    this.failureUrl,
    this.id,
  }) : super(key: key);

  @override
  State<WebViewPayment> createState() => _WebViewPaymentState();
}

class _WebViewPaymentState extends State<WebViewPayment> {
  bool isLoading = true;
  Timer? _timer;

  late final WebViewController controller;

  bool get isAndroid => Platform.isAndroid;

  @override
  void initState() {
    super.initState();
    if (!isAndroid) {
      _initializeIOSWebView();
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {});
  }

  void _initializeIOSWebView() {
    final redirectUrl = widget.redirectUrl ?? "";

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            debugPrint('WebView loading: $progress%');
          },
          onPageStarted: (url) {
            debugPrint('Page started: $url');
          },
          onPageFinished: _handlePageFinished,
          onWebResourceError: (error) {
            debugPrint(
              "WebView Error: ${error.description}, type: ${error.errorType}",
            );
          },
          onNavigationRequest: (request) {
            final url = request.url;
            debugPrint("Navigate to: $url");

            if (!isAndroid && _isLoginUrl(url)) {
              _openInSafari(url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    if (redirectUrl.isNotEmpty) {
      final uri = Uri.tryParse(redirectUrl);
      if (uri != null && (uri.isScheme("http") || uri.isScheme("https"))) {
        controller.loadRequest(uri);
      } else {
        setState(() => isLoading = false);
      }
    } else {
      setState(() => isLoading = false);
    }
  }


  bool _isLoginUrl(String url) {
    return url.contains('/login') ||
        url.contains('/customer/account/login') ||
        url.contains('/signin');
  }


  Future<void> _openInSafari(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(
      uri,
      mode: LaunchMode.inAppBrowserView, // SafariViewController
    );
  }

  void _handlePageFinished(String url) {
    debugPrint("Page finished: $url");
    _timer?.cancel();

    if (mounted) {
      setState(() => isLoading = false);
    }

    final successUrl = widget.successUrl ?? "";
    final failureUrl = widget.failureUrl ?? "";

    if (successUrl.isNotEmpty && url.contains(successUrl)) {
      Navigator.of(context).pop("SUCCESS");
    } else if (failureUrl.isNotEmpty && url.contains(failureUrl)) {
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pop("failure");
      });
    } else if (url.contains("checkout/cart/")) {
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pop("cancel");
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: commonAppBar(
        "",
        context,
        onPressed: () => Navigator.of(context).pop("cancel"),
      ),
      body: Stack(
        children: [
          if (isAndroid)
            CustomWebViewAndroid(
              initialUrl: widget.redirectUrl ?? "",
              onPageFinished: _handlePageFinished,
            )
          else
            WebViewWidget(controller: controller),
          if (isLoading) const Loader(),
        ],
      ),
    );
  }
}
