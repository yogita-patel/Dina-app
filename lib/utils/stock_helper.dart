import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class StockHelper {
  /// Determines the display text for stock status.
  /// - If [carton] parses to an int < 10 -> returns "Low Stock".
  /// - Else if [expected] is non-empty -> returns [expected] when quantity==0 else "In Stock".
  /// - Else returns "In Stock" when quantity != 0, otherwise "Out of Stock".
  static String stockText({String? expected, dynamic quantity, String? carton, String? stock}) {
    try {
      if (carton != null && carton.isNotEmpty) {
        final cartonInt = int.tryParse(carton.replaceAll(RegExp(r'[^0-9]'), ''));
        if (cartonInt != null && cartonInt < 10) {
          return 'Low Stock';
        }
      }
    } catch (_) {}

    // fallback to existing logic using expected/quantity/stock
    if (expected != null && expected.isNotEmpty) {
      if (quantity == 0 || quantity == '0' || (quantity is String && quantity == '0')) {
        return expected;
      }
      return 'In Stock';
    }

    if (quantity != null) {
      if (quantity == 0 || quantity == '0') return 'Out of Stock';
      return 'In Stock';
    }

    // if stock string provided use it
    if (stock != null && stock.isNotEmpty) return stock;

    return '';
  }

  /// Returns a color for the stock status text background.
  /// - Low Stock -> orange
  /// - In Stock -> green
  /// - Out of Stock or any other -> red
  static Color stockColorForText(String text) {
    final t = text.toLowerCase();
    if (t.contains('low')) return AppColors.orange;
    if (t.contains('in stock')) return const Color(0xFF00C48C); // keep existing green
    if (t.contains('out')) return const Color(0xFFE7000B); // existing red
    // default: green if non-empty
    return t.isNotEmpty ? const Color(0xFF00C48C) : AppColors.orange;
  }
}

