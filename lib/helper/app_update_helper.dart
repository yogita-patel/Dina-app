import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

class AppUpdateHelper {
  static bool _dialogShownThisLaunch = false;

  static Future<void> showUpdateDialogIfNeeded(BuildContext context) async {
    if (_dialogShownThisLaunch) {
      return;
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      print('Current app version: ${packageInfo.version}');
      print('Current app version: ${packageInfo.buildNumber}');
      final versionStatus = await NewVersionPlus(
        androidId: packageInfo.packageName,
        iOSId: packageInfo.packageName,
        //forceAppVersion: "1.0.1",
      ).getVersionStatus();
      print('Store live app version: ${versionStatus?.storeVersion}');
      print('Store original app version: ${versionStatus?.originalStoreVersion}');
      print('Store app link: ${versionStatus?.appStoreLink}');
      if (versionStatus == null ||
          _compareVersions(versionStatus.storeVersion, packageInfo.version) <=
              0) {
        return;
      }

      _dialogShownThisLaunch = true;
      if (!context.mounted) {
        return;
      }

      await _showUpdateDialog(context, versionStatus.appStoreLink);
    } catch (e) {
      debugPrint('App update check failed: $e');
    }
  }

  static Future<void> _showUpdateDialog(
    BuildContext context,
    String storeUrl,
  ) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.size8),
          ),
          title: const Text('Update Available'),
          content: const Text(
            'A new version of the app is available. Please update for a better experience.',
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MobikulTheme.primaryColor,
                foregroundColor: Theme.of(context).cardColor,
              ) ,
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Later'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MobikulTheme.primaryColor,
                foregroundColor: Theme.of(context).cardColor,
              ) ,
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                await _openStore(storeUrl);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> _openStore(String storeUrl) async {
    final uri = Uri.tryParse(storeUrl.trim());
    if (uri == null) {
      return;
    }

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Unable to open app store link: $e');
    }
  }

  static int _compareVersions(String latest, String current) {
    final latestParts = _versionParts(latest);
    final currentParts = _versionParts(current);
    final length = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (var i = 0; i < length; i++) {
      final latestPart = i < latestParts.length ? latestParts[i] : 0;
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      if (latestPart != currentPart) {
        return latestPart.compareTo(currentPart);
      }
    }
    return 0;
  }

  static List<int> _versionParts(String version) {
    return version
        .split('+')
        .first
        .split('.')
        .map(
            (part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }
}
