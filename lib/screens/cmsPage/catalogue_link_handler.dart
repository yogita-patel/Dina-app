import '../../constants/app_constants.dart';

/// Keeps catalogue downloads out of platform URL/deep-link dispatch.
class CatalogueLinkHandler {
  CatalogueLinkHandler(this.download);

  final Future<void> Function() download;
  bool _downloading = false;

  bool matches(String url) {
    final parsed = Uri.tryParse(url);
    if (parsed == null) return false;
    final uri = Uri.parse(ApiConstant.baseUrl).resolveUri(parsed);
    return (uri.scheme == 'https' || uri.scheme == 'http') &&
        const {
          'dinainternational.co.uk',
          'www.dinainternational.co.uk',
          'dinainternational.com',
          'www.dinainternational.com',
        }.contains(uri.host) &&
        uri.path == '/index.php' &&
        const {
          'catalogue/pdf',
          'api/wkrestapi/pdf_catalogue/download',
        }.contains(uri.queryParameters['route']);
  }

  Future<bool> handle(String url) async {
    if (!matches(url)) return false;
    if (_downloading) return true;
    _downloading = true;
    try {
      await download();
    } finally {
      _downloading = false;
    }
    return true;
  }

  /// Capture links before target="_blank" requests an unsupported new window.
  /// Dart validates the URL again before starting a download.
  static const clickScript = '''
    if (!window.dinaCatalogueListenerInstalled) {
      window.dinaCatalogueListenerInstalled = true;
      document.addEventListener('click', function(event) {
        var link = event.target.closest('a[href]');
        if (!link) return;
        var url = new URL(link.getAttribute('href'), '${ApiConstant.baseUrl}');
        var route = url.searchParams.get('route');
        var hosts = ['dinainternational.co.uk', 'www.dinainternational.co.uk',
                     'dinainternational.com', 'www.dinainternational.com'];
        if ((url.protocol === 'https:' || url.protocol === 'http:') &&
            hosts.indexOf(url.hostname) !== -1 && url.pathname === '/index.php' &&
            (route === 'catalogue/pdf' || route === 'api/wkrestapi/pdf_catalogue/download')) {
          event.preventDefault();
          event.stopImmediatePropagation();
          DinaCatalogue.postMessage(url.href);
        }
      }, true);
    }
  ''';
}
