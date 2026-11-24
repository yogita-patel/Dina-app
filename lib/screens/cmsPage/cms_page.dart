import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/loader.dart';
import '../../models/cmsDetailModel/cms_detail_model.dart';
import '../../constants/app_constants.dart';
import '../../network_manager/download_file.dart';
import 'catalogue_link_handler.dart';
import 'bloc/cms_page_bloc.dart';
import 'bloc/cms_page_event.dart';
import 'bloc/cms_screen_state.dart';

// class CMSPageView extends StatefulWidget {
//   Map<String, dynamic> arguments;
//
//   CMSPageView(this.arguments, {super.key});
//
//   @override
//   State<CMSPageView> createState() => _CMSPageViewState();
// }
//
// class _CMSPageViewState extends State<CMSPageView> {
//   CMSScreenBloc? _cmsScreenBloc;
//
//   bool isLoading = true;
//   double opacity = 0;
//   CmsDetailModel? cmsPageDetail;
//   WebViewController? _webViewController;
//
// @override
//   void didChangeDependencies() {
//   _webViewController=WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor( Theme.of(context).cardColor)
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {},
//         onPageFinished: (String url) {},
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.dataFromString("", mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
//
//
//
// }
//
//   @override
//   initState() {
//     _cmsScreenBloc = context.read<CMSScreenBloc>();
//     _cmsScreenBloc
//         ?.add(CMSScreenDataFetchEvent(widget.arguments[cmsPageId] ?? "1"));
//
//
//     cmsPageDetail = null;
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     cmsPageDetail = null;
//     _cmsScreenBloc = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).cardColor,
//         appBar: commonAppBar(widget.arguments[cmsPageTitle] ?? "", context),
//         body: BlocBuilder<CMSScreenBloc, CMSScreenState>(
//           builder: (context, currentState) {
//             if (currentState is CMSScreenInitial) {
//               isLoading = true;
//               cmsPageDetail = null;
//             } else if (currentState is CMSScreenSuccess) {
//               cmsPageDetail = currentState.cmsPageDetail;
//               isLoading = false;
//               _loadHtmlFromAssets(_webViewController);
//             } else if (currentState is CMSScreenError) {
//               isLoading = false;
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 AlertMessage.showError(currentState.message ?? '', context);
//               });
//             }
//             //test
//             return _buildUI(cmsPageDetail);
//           },
//         ));
//   }
//
//   Widget _buildUI(CmsDetailModel? cmsPageDetail) {
//     return Stack(
//       children: [
//         Visibility(
//           visible: !isLoading,
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 70.0),
//             child: WebViewWidget(
//               controller: _webViewController!,
//             ),
//           ),
//         ),
//         Visibility(visible: isLoading, child: const Loader())
//       ],
//     );
//   }
//
//   _loadHtmlFromAssets(controller) async {
//     String fileText = cmsPageDetail?.description ?? "";
//     controller.loadRequest(Uri.dataFromString("""<!DOCTYPE html>
//     <html>
//       <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
//       <body style='"margin: 20; padding: 20;'>
//         <div>
//           $fileText
//         </div>
//       </body>
//     </html>""", mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         );
//     super.didChangeDependencies();
//   }}

class CMSPageView extends StatefulWidget {
  final Map<String, dynamic> arguments;
  final Download? catalogueDownloader;

  const CMSPageView(this.arguments, {this.catalogueDownloader, super.key});

  @override
  State<CMSPageView> createState() => _CmsPageState();
}

class _CmsPageState extends State<CMSPageView> {
  late final CMSScreenBloc _cmsPageBloc;
  late final WebViewController _controller;
  late final CatalogueLinkHandler _catalogueLinks;
  var apiHitTrue = false;
  CmsDetailModel? _model;
  bool isPageLoaded = false; // Prevents duplicate load

  @override
  void initState() {
    super.initState();
    _catalogueLinks = CatalogueLinkHandler(() async {
      if (mounted) {
        await (widget.catalogueDownloader ?? Download())
            .downloadCatalogue(context);
      }
    });
    _cmsPageBloc = context.read<CMSScreenBloc>();
    final pageUrl = widget.arguments[cmsPageUrl] as String?;
    if (pageUrl != null) {
      _cmsPageBloc.add(CMSScreenUrlFetchEvent(pageUrl));
    } else {
      _cmsPageBloc.add(CMSScreenDataFetchEvent(widget.arguments[cmsPageId]));
    }
  }

  void _initializeController() {
    apiHitTrue = true;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('DinaCatalogue', onMessageReceived: (message) {
        _catalogueLinks.handle(message.message);
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) {
          if (mounted) setState(() => isPageLoaded = false);
        },
        onPageFinished: (_) async {
          try {
            await _controller.runJavaScript(CatalogueLinkHandler.clickScript);
          } finally {
            if (mounted) setState(() => isPageLoaded = true);
          }
        },
        onNavigationRequest: (request) async {
          final url = request.url;
          if (_catalogueLinks.matches(url)) {
            // Return immediately so WebView cannot navigate to a PDF response.
            _catalogueLinks.handle(url);
            return NavigationDecision.prevent;
          }
          final uri = Uri.tryParse(url);
          final landing = Uri.parse(ApiConstant.pdfCatalogueLandingUrl);
          if (uri != null &&
              uri.host == landing.host &&
              uri.path == landing.path &&
              uri.scheme == landing.scheme) {
            return NavigationDecision.navigate;
          }
          if (url.startsWith('http')) {
            if (Platform.isIOS) return NavigationDecision.navigate;
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url),
                  mode: LaunchMode.externalApplication);
            }
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CMSScreenBloc, CMSScreenState>(
      listener: (context, currentState) {
        if (currentState is CMSScreenSuccess && !apiHitTrue) {
          _model = currentState.cmsPageDetail;
          final url = _model?.description;
          if (url != null && url.isNotEmpty) {
            final htmlContent = _model?.description ?? "";
            _initializeController();
            if (Platform.isIOS) {
              _loadHtmlFromAssets(_controller);
            } else {
              _loadHtmlWithClickableMaps(_controller, htmlContent);
            }
          }
        } else if (currentState is CMSScreenError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
          setState(() => isPageLoaded = false);
          apiHitTrue = false;
        }
      },
      builder: (context, currentState) {
        return Scaffold(
          // backgroundColor: Theme.of(context).colorScheme.background,
          backgroundColor: Theme.of(context).cardColor,
          appBar: commonAppBar(widget.arguments[cmsPageTitle] ?? "", context),
          body: _buildUI(), // Use a method to build the body
        );
      },
    );
  }

  Widget _buildUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Stack(
        children: [
          if (apiHitTrue) WebViewWidget(controller: _controller),
          if (!isPageLoaded || !apiHitTrue) const Loader(),
        ],
      ),
    );
  }

  Future<void> _loadHtmlFromAssets(WebViewController controller) async {
    String fileText = _model?.description ?? "";
    controller.loadRequest(Uri.dataFromString("""<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <body style='"margin: 20; padding: 20;'>
        <div>
          $fileText
        </div>
      </body>
    </html>""", mimeType: 'text/html', encoding: Encoding.getByName('utf-8')));
  }

  void _loadHtmlWithClickableMaps(WebViewController controller, String html) {
    final processedHtml = html.replaceAllMapped(
      RegExp(
          r'<iframe.*?src="(https://www\.google\.com/maps/embed.*?)".*?</iframe>'),
      (match) => '<a href="${match[1]}" target="_blank">${match[0]}</a>',
    );

    final finalHtml = """
    <!DOCTYPE html>
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
      </head>
      <body style="margin: 20px; padding: 20px;">
        $processedHtml
      </body>
    </html>
    """;

    controller.loadRequest(
      Uri.dataFromString(
        finalHtml,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
  }
}
