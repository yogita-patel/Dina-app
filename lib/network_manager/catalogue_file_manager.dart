import 'package:flutter/services.dart';

class CatalogueFileManager {
  static const MethodChannel _channel =
      MethodChannel('com.webkul.oc.methodchannel');

  static Future<String> publish(String sourcePath, String fileName) async {
    final existingNames = await _channel.invokeListMethod<String>(
          'getExistingDownloadFileNames',
        ) ??
        const <String>[];
    final availableFileName = nextAvailableFileName(
      fileName,
      existingNames.toSet(),
    );
    final reference = await _channel.invokeMethod<String>(
      'publishPdfToDownloads',
      <String, String>{
        'sourcePath': sourcePath,
        'fileName': availableFileName,
      },
    );
    if (reference == null || reference.isEmpty) {
      throw PlatformException(
        code: 'PUBLISH_FAILED',
        message: 'The platform did not return a saved file reference.',
      );
    }
    return reference;
  }

  static String nextAvailableFileName(
    String requestedFileName,
    Set<String> existingNames,
  ) {
    if (!existingNames.contains(requestedFileName)) return requestedFileName;

    final extensionIndex = requestedFileName.lastIndexOf('.');
    final baseName = extensionIndex > 0
        ? requestedFileName.substring(0, extensionIndex)
        : requestedFileName;
    final extension =
        extensionIndex > 0 ? requestedFileName.substring(extensionIndex) : '';

    var number = 1;
    while (existingNames.contains('$baseName ($number)$extension')) {
      number++;
    }
    return '$baseName ($number)$extension';
  }

  static Future<bool> open(String fileReference) async {
    return await _channel.invokeMethod<bool>('fileviewer', fileReference) ??
        false;
  }
}
