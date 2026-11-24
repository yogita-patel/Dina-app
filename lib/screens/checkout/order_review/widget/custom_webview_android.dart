import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWebViewAndroid extends StatelessWidget {
  final String initialUrl;
  final Function(String) onPageFinished;

  const CustomWebViewAndroid({
    required this.initialUrl,
    required this.onPageFinished,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("swqdfewgthy5hj23h4f23 Initial URL: $initialUrl");
    // This is used in the platform side to register the view.
    const String viewType = 'custom-webview';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{
      "url": initialUrl,
    };

    return AndroidView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        // Initialize method channel for this view
        final channel = MethodChannel('custom_webview_$id');
        channel.setMethodCallHandler((call) async {
          if (call.method == 'onPageFinished') {
            final String url = call.arguments;
            onPageFinished(url);
          }
        });
      },
    );
  }
}
