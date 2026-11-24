import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/product/product.dart';

import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';

class AddToBasketAndSubtotalpriceCard extends StatelessWidget {
  final double totalAmount;
  final int quantity;
  final VoidCallback onAddToBasket;
  final AppLocalizations? localizations;
  final Product? product;
  final String? previousScreen;
  final String? stockQuantity;
  const AddToBasketAndSubtotalpriceCard({
    super.key,
    required this.totalAmount,
    required this.quantity,
    required this.onAddToBasket,
    required this.localizations,
    this.product
    ,this.previousScreen,
    this.stockQuantity
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: AppSizes.size45,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(AppSizes.size6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12,),
          // Light grey background
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total
              Row(
                children: [
                   Text(
                    'Total ',
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400,),
                  ),
                  Text(
                    '£${totalAmount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
              const SizedBox(
                width: AppSizes.size4,),
              // Quantity
              Row(
                children: [
                   Text(
                    'Qty ',
                     style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w400,),
                  ),
                  Text(
                    '$quantity',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
        width: AppSizes.size20,),
        // Add to Basket Button
        Expanded(
          child: SizedBox(
            height: AppSizes.size45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppSizes.size6),
                  ),

                ),
                backgroundColor: previousScreen == "true"?(stockQuantity == "0"?const Color(0xFFFF914D) // For backorders
                    : const Color(0xFF0D479C)):
                     product?.quantity == "0"
                    ? const Color(0xFFFF914D) // For backorders
                    : const Color(0xFF0D479C),  // For in-stock items
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
              ),
              onPressed: onAddToBasket,
              child:   Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  maxLines: 2,
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                     previousScreen == "true"?(stockQuantity == "0"?(localizations?.translate(AppStringConstant.addToBackorders) ?? ""):(localizations?.translate(AppStringConstant.addToBasket) ?? "")):
                    product?.quantity=="0"?(localizations?.translate(AppStringConstant.addToBackorders) ?? ""):(localizations?.translate(AppStringConstant.addToBasket) ?? ""),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
