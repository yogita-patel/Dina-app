import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../common_widgets/alert_message.dart';
import '../constants/app_constants.dart';
import '../constants/app_string_constant.dart';
import '../helper/app_localizations.dart';
import '../helper/app_shared_pref.dart';
import '../helper/push_notifications_manager.dart';
import '../models/downloadProductModel/download_product_model.dart';
import 'catalogue_file_manager.dart';

typedef CataloguePathProvider = Future<String> Function();
typedef CatalogueTokenProvider = Future<String> Function();
typedef CatalogueLogger = void Function(String message);
typedef CatalogueDownloader = Future<void> Function(
    String url, String path, String wkToken);
typedef CataloguePublisher = Future<String> Function(
    String sourcePath, String fileName);
typedef CatalogueNotifier = Future<bool> Function(String fileReference);

class Download {
  Download({
    CataloguePathProvider? cataloguePathProvider,
    CatalogueTokenProvider? catalogueTokenProvider,
    CatalogueLogger? catalogueLogger,
    CatalogueDownloader? catalogueDownloader,
    CataloguePublisher? cataloguePublisher,
    CatalogueNotifier? catalogueNotifier,
  })  : _cataloguePathProvider = cataloguePathProvider,
        _catalogueTokenProvider = catalogueTokenProvider,
        _catalogueLogger = catalogueLogger,
        _catalogueDownloader = catalogueDownloader,
        _cataloguePublisher = cataloguePublisher,
        _catalogueNotifier = catalogueNotifier;

  static const String catalogueFileName = 'Dina_International_Catalogue.pdf';

  final CataloguePathProvider? _cataloguePathProvider;
  final CatalogueTokenProvider? _catalogueTokenProvider;
  final CatalogueLogger? _catalogueLogger;
  final CatalogueDownloader? _catalogueDownloader;
  final CataloguePublisher? _cataloguePublisher;
  final CatalogueNotifier? _catalogueNotifier;

  var tag = "DownloadInvoice ";
  String savePath = "";

  void _logCatalogue(String message) {
    final formattedMessage = '[PDF Catalogue] $message';
    if (_catalogueLogger != null) {
      _catalogueLogger(formattedMessage);
    } else {
      debugPrint(formattedMessage);
    }
  }

  Future<String> saveCatalogue() async {
    final wkToken =
        await (_catalogueTokenProvider?.call() ?? AppSharedPref.getWkToken());
    final path = await (_cataloguePathProvider?.call() ??
        getTemporaryDirectory().then(
          (directory) => '${directory.path}/$catalogueFileName',
        ));

    try {
      _logCatalogue('Starting download: ${ApiConstant.pdfCatalogueUrl}');
      try {
        if (_catalogueDownloader != null) {
          await _catalogueDownloader(
            ApiConstant.pdfCatalogueUrl,
            path,
            wkToken,
          );
        } else {
          await Dio().download(
            ApiConstant.pdfCatalogueUrl,
            path,
            options: Options(headers: {'wk_token': wkToken}),
          );
        }
      } catch (e) {
        _logCatalogue('Initial download failed (likely due to cold start token expiration), fetching new token directly... Error: $e');
        
        try {
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
          
          if (responseData is Map<String, dynamic> && responseData['wk_token'] != null) {
             newWkToken = responseData['wk_token'];
             await AppSharedPref.setWkToken(newWkToken);
          } else {
             await Future.delayed(const Duration(seconds: 3));
             newWkToken = await AppSharedPref.getWkToken();
          }

          if (_catalogueDownloader != null) {
            await _catalogueDownloader(
              ApiConstant.pdfCatalogueUrl,
              path,
              newWkToken,
            );
          } else {
            await Dio().download(
              ApiConstant.pdfCatalogueUrl,
              path,
              options: Options(headers: {'wk_token': newWkToken}),
            );
          }
        } catch (retryError) {
          _logCatalogue('Retry failed: $retryError');
          rethrow;
        }
      }
      _logCatalogue('Download transfer completed: $path');

      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      final reference = _cataloguePublisher != null
          ? await _cataloguePublisher(path, catalogueFileName)
          : await CatalogueFileManager.publish(path, catalogueFileName);
      _logCatalogue('Published file: $reference');

      if (_catalogueNotifier != null) {
        await _catalogueNotifier(reference);
      } else {
        await notification.showCatalogueDownloadNotification(reference);
      }
      _logCatalogue('Download notification created');
      return reference;
    } catch (error, stackTrace) {
      _logCatalogue('Download failed: $error');
      _logCatalogue(stackTrace.toString());
      final temporaryFile = File(path);
      if (await temporaryFile.exists()) {
        await temporaryFile.delete();
      }
      rethrow;
    }
  }

  Future<bool> downloadCatalogue(BuildContext context) async {
    try {
      _logCatalogue('Download requested');
      AlertMessage.showSuccess(
        AppLocalizations.of(context)?.translate('downloading') ?? 'Downloading',
        context,
      );
      await saveCatalogue();

      if (!context.mounted) return true;
      AlertMessage.showSuccess(
        AppLocalizations.of(context)?.translate('download_complete') ??
            'Download completed',
        context,
      );
      return true;
    } catch (e) {
      if (context.mounted) {
        AlertMessage.showError(
          (AppLocalizations.of(context)
                  ?.translate(AppStringConstant.downloadFailed) ??
              'Unable to download PDF Catalogue') + '\nDEBUG: ${e.toString()}',
          context,
        );
      }
      return false;
    }
  }

  Future downloadProduct(
      DownloadData? downloadItem, BuildContext context) async {
    //  if (fileType.isNotEmpty) {
    // var url =" ";
    //print(tag + url);
    try {
      Dio dio = Dio();
      var status = await Permission.storage.status;
      if (status.isGranted) {
        print("${tag}permission is granted");
        String fileName = downloadItem?.file ?? "product";
        savePath = await getFilePath(fileName);

        AlertMessage.showSuccess(
            AppLocalizations.of(context)?.translate("downloading") ??
                "Downloading",
            context);
        await dio.download(downloadItem?.url ?? "", savePath,
            onReceiveProgress: (received, total) {
          print("$tag Download started received$received total $total");
        });
        const platform = MethodChannel('com.webkul.oc.methodchannel');
        try {
          if (Platform.isAndroid) {
            await platform.invokeMethod('fileviewer', savePath);
          } else {
            await platform.invokeMethod('fileviewer', fileName);
          }
        } on PlatformException {}
        AlertMessage.showSuccess(
            AppLocalizations.of(context)?.translate("download_complete") ??
                "Download completed",
            context);
      } else if (status.isDenied) {
        Permission.storage.request();
        print("${tag}permission is denied ->requesting");
      }
    } catch (e) {
      print("${tag}exception while downloading invoice $e");
    }
    // }
  }

  /*
  * Will return the directory path at which invoice will save.
  * it will not return the external directory path
  * ToDo: Need to check it to save it in external directory like Download
  * */
  Future<String> getFilePath(fileName) async {
    String path = '';
    // var pat_h = await ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
    // Directory dir = await getApplicationDocumentsDirectory();
    Directory? dir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory();
    path = '${dir?.path}/$fileName';
    return path;
  }
/*
  Future downloadInvoice(String invoiceId, BuildContext context) async {
    if (invoiceId.isNotEmpty) {
      var url = ApiConstant.baseUrl +
          Apis.getpdf +
          "id_order=" +
          invoiceId +
          "&id_lang=" +
          await AppSharedPref.getLanguage() +
          "&id_currency=" +
          await AppSharedPref.getCurrency() +
          "&id_customer=" +
          await AppSharedPref.getCustomerId() +
          "&ws_key=" +
          ApiConstant.wsKey +
          "&object=invoice";
      print(tag + url);
      try {
        Dio dio = Dio();
        var status = await Permission.storage.status;
        if (status.isGranted) {
          print(tag + "permission is granted");
          String fileName = "invoice" + invoiceId + ".pdf";
          savePath = await getFilePath(fileName);
          print(tag + "permission is granted  and path is: " + savePath);
          AlertMessage.showSuccess(
              AppLocalizations.of(context)?.translate("downloading") ??
                  "Downloading",
              context);
          await dio.download(url, savePath,
              onReceiveProgress: (received, total) {
            print(tag +
                " Download started received" +
                received.toString() +
                " total " +
                total.toString());
          });
          const platform = MethodChannel('com.mlkit');
          try {
            if (Platform.isAndroid) {
              await platform.invokeMethod('fileviewer', savePath);
            } else {
              await platform.invokeMethod('fileviewer', fileName);
            }
          } on PlatformException catch (e) {
          }
          AlertMessage.showSuccess(
              AppLocalizations.of(context)?.translate("download_complete") ??
                  "Download completed",
              context);
        } else if (status.isDenied) {
          Permission.storage.request();
          print(tag + "permission is denied ->requesting");
        }
      } catch (e) {
        print(tag + "exception while downloading invoice " + e.toString());
      }
    }
  }

  Future downloadCreditSlip(String slipId, BuildContext context) async {
    if (slipId.isNotEmpty) {
      var url = ApiConstant.baseUrl +
          Apis.getpdf +
          "id_order_slip=" +
          slipId +
          "&id_lang=" +
          await AppSharedPref.getLanguage() +
          "&id_currency=" +
          await AppSharedPref.getCurrency() +
          "&id_customer=" +
          await AppSharedPref.getCustomerId() +
          "&ws_key=" +
          ApiConstant.wsKey +
          "&object=credit_slips";
      print(tag + url);
      try {
        Dio dio = Dio();
        var status = await Permission.storage.status;
        if (status.isGranted) {
          print(tag + "permission is granted");
          String fileName = "creditSlip" + slipId + ".pdf";
          savePath = await getFilePath(fileName);

          AlertMessage.showSuccess(
              AppLocalizations.of(context)?.translate("downloading") ??
                  "Downloading",
              context);
          await dio.download(url, savePath,
              onReceiveProgress: (received, total) {
            print(tag +
                " Download started received" +
                received.toString() +
                " total " +
                total.toString());
          });

          const platform = MethodChannel('com.mlkit');
          try {
            if (Platform.isAndroid) {
              await platform.invokeMethod('fileviewer', savePath);
            } else {
              await platform.invokeMethod('fileviewer', fileName);
            }
          } on PlatformException catch (e) {
          }
          AlertMessage.showSuccess(
              AppLocalizations.of(context)?.translate("download_complete") ??
                  "Download completed",
              context);
        } else if (status.isDenied) {
          Permission.storage.request();
          print(tag + "permission is denied ->requesting");
        }
      } catch (e) {
        print(tag + "exception while downloading invoice " + e.toString());
      }
    }
  }*/
}
