import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ProductStatusBadges extends StatelessWidget {
  const ProductStatusBadges({
    super.key,
    this.productId,
    this.isCartAdded,
    this.bought,
    this.showAdded = true,
    this.showBought = true,
  });

  final dynamic productId;
  final dynamic isCartAdded;
  final dynamic bought;
  final bool showAdded;
  final bool showBought;

  static bool shouldShowAdded(dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'added' || normalized == 'true' || normalized == '1';
    }
    return false;
  }

  static bool shouldHideAdded(dynamic value) {
    if (value is bool) {
      return !value;
    }
    if (value is num) {
      return value == 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'false' ||
          normalized == '0' ||
          normalized == 'not_added';
    }
    return false;
  }

  static bool shouldShowBought(dynamic value) {
    if (value == null) {
      return false;
    }
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized.isNotEmpty &&
          normalized != '0' &&
          normalized != 'false' &&
          normalized != 'null';
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: ProductCartStatusController.addedProductIds,
      builder: (context, addedProductIds, _) {
        final showAddedBadge = showAdded &&
            ProductCartStatusController.isAdded(
              productId,
              isCartAdded,
              addedProductIds,
            );
        final showBoughtBadge = showBought && shouldShowBought(bought);

        if (!showAddedBadge && !showBoughtBadge) {
          return const SizedBox.shrink();
        }

        return IgnorePointer(
          child: Stack(
            children: [
              if (showBoughtBadge)
                const Positioned(
                  top: AppSizes.size4,
                  right: AppSizes.size4,
                  child: ProductBoughtBadge(),
                ),
              if (showAddedBadge)
                const Positioned(
                  right: AppSizes.size4,
                  bottom: AppSizes.size4,
                  child: ProductAddedBadge(),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ProductCartStatusController {
  static final ValueNotifier<Set<String>> addedProductIds =
      ValueNotifier<Set<String>>(<String>{});

  static bool isAdded(
    dynamic productId,
    dynamic isCartAdded, [
    Set<String>? addedProductIds,
  ]) {
    final productIdValue = productId?.toString() ?? '';
    if (ProductStatusBadges.shouldShowAdded(isCartAdded)) {
      return true;
    }
    if (ProductStatusBadges.shouldHideAdded(isCartAdded)) {
      return false;
    }
    return productIdValue.isNotEmpty &&
        (addedProductIds ?? ProductCartStatusController.addedProductIds.value)
            .contains(productIdValue);
  }

  static void markAdded(dynamic productId) {
    final productIdValue = productId?.toString() ?? '';
    if (productIdValue.isEmpty) return;

    addedProductIds.value = <String>{
      ...addedProductIds.value,
      productIdValue,
    };
  }
}

class ProductBoughtBadge extends StatelessWidget {
  const ProductBoughtBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: AppSizes.size24,
        height: AppSizes.size24,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF007600),
          shape: BoxShape.circle,
        ),
        child: const Text(
          'H',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.size12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class ProductAddedBadge extends StatelessWidget {
  const ProductAddedBadge({
    super.key,
    this.iconSize = AppSizes.size18,
    this.fontSize = AppSizes.size14,
    this.horizontalPadding = AppSizes.size4,
    this.verticalPadding = AppSizes.size2,
  });

  final double iconSize;
  final double fontSize;
  final double horizontalPadding;
  final double verticalPadding;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(AppSizes.size4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart,
              color: const Color(0xFF007600),
              size: iconSize,
            ),
            const SizedBox(width: AppSizes.size2),
            Text(
              'Added',
              style: TextStyle(
                color: const Color(0xFF007600),
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
