import 'package:flutter/material.dart';

import '../../config/theme.dart';

class Loader extends StatelessWidget {
  final String? loadingMessage;

  const Loader({super.key, this.loadingMessage});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            loadingMessage ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: MobikulTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
