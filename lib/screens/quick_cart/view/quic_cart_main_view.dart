import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../cart/widgets/cart_product_item.dart';
import '../bloc/quick_cart_bloc.dart';
import '../bloc/quick_cart_event.dart';
import '../bloc/quick_cart_state.dart';

class QuickCartMainView extends StatelessWidget {
  const QuickCartMainView(this.model, this.localizations, this.bloc,
      {super.key});

  final CartModel? model;
  final AppLocalizations? localizations;
  final QuickCartBloc? bloc;

  @override
  Widget build(BuildContext context) {
    final products = model?.cart?.products ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (ctx, index) {
            final product = products[index];
            //final product = products[index];
            final isLast = index == products.length - 1;

            return CartProductItem(
              key: ObjectKey(product ?? index), // ✅ unique per-item key
              //key: ValueKey(product.key ?? index), // ✅ unique per-item key
              product,
              localizations,
              bloc,
              1,
              () async {
                // final uri = Uri.parse(
                //     'https://www.dinainternational.com/index.php?route=api/wkrestapi/cart/updateCart');
                    final uri = Uri.parse(
                        'https://www.dinainternational.co.uk/index.php?route=api/wkrestapi/cart/updateCart');
                final payload = {
                  "quantity": getQuantityJson(),
                  "UnitofSalenew": getUnitOfSalesJson(),
                  "wk_token": await AppSharedPref.getWkToken()
                };

                print("🔸 Request Body:\n${json.encode(payload)}");

                var request = Request('POST', uri)
                  ..headers['Content-Type'] = 'application/json'
                  ..body = json.encode(payload);

                StreamedResponse response = await request.send();

                if (response.statusCode == 200) {
                  String responseBody = await response.stream.bytesToString();
                  print("✅ Response Status: 200 OK");
                  print("✅ Response Body:\n$responseBody");
                  bloc?.add(const FetchCartEvent());
                } else {
                  print("❌ Response Status: ${response.statusCode}");
                  print("❌ Reason: ${response.reasonPhrase}");
                }

                bloc?.emit(QuickCartInitialState());
              },
              () {
                bloc?.add(CartScreenRemoveItemEvent(product.key ?? "0"));
                bloc?.emit(QuickCartInitialState());
              },
              () {
                bloc?.add(AddProductToWishListEvent(
                  product.productId ?? "0",
                  product.key ?? "0",
                  product.quantity ?? "1",
                  product.UnitofSalenew ?? "1",
                ));
              },
              (indexValue) {},
              index,
              isLastItem: isLast,
            );
          },
        ),
      ],
    );
  }

  /// Build quantity JSON map for updateCart API
  Map<String, int> getQuantityJson() {
    final jsonMap = <String, int>{};
    model?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] = int.tryParse(element.quantity ?? "0") ?? 0;
    });
    return jsonMap;
  }

  /// Build unit-of-sale JSON map for updateCart API
  Map<String, int> getUnitOfSalesJson() {
    final jsonMap = <String, int>{};
    model?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] =
          int.tryParse(element.UnitofSalenew ?? "0") ?? 0;
    });
    return jsonMap;
  }

  /// Reusable confirmation dialog
  confirmationDialog(
    String text,
    BuildContext context,
    AppLocalizations? localizations,
    String subText, {
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations?.translate(text) ?? "",
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: AppSizes.size16)),
            const SizedBox(height: AppSizes.size2),
            Text(localizations?.translate(subText) ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppSizes.size14)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppStringConstant.cancel.localized().toUpperCase()),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onConfirm?.call();
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: MobikulTheme.primaryColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppStringConstant.ok.localized().toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: AppSizes.size14,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
