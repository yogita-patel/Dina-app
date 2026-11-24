import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/cart/cart_model.dart';
import 'package:oc_demo/screens/cart/widgets/cart_screen_coupon_widget.dart';
import 'package:oc_demo/screens/cart/widgets/price_details.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../main.dart';
import '../../../models/cart/country_data_model.dart';
import '../bloc/cart_screen_bloc.dart';
import 'Order_notice_widget.dart';
import 'cart_product_item.dart';
import 'estimate_shipping_taxes_widget.dart';

class CartMainView extends StatelessWidget {
  const CartMainView(
      this.countryDataModel, this.model, this.localizations, this.bloc,
      {super.key});

  final CartModel? model;
  final CountryDataModel? countryDataModel;
  final AppLocalizations? localizations;
  final CartScreenBloc? bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OrderNoticeWidget(model),
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.size4),
              child: Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size8, vertical: AppSizes.size8),
                      child: Text(
                        "${(localizations?.translate(AppStringConstant.cartScreenTitle) ?? "")}  (${model?.cart?.weight}) ",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .color,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Cart product list view
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: model?.cart?.products?.length ?? 0,
              itemBuilder: (ctx, index) {
                final products = model?.cart?.products;
                final isLast = index == (products?.length ?? 1) - 1;
                cartActionDisableToQuote = true;
                return CartProductItem(
                  key: ObjectKey(products),
                  // : ObjectKey(cartActionDisableToQuote),
                  // key: ValueKey(products?[index].key ?? index),
                  // key: ValueKey('${products?[index].productId}_${products?[index].key ?? index}'),
                  products?[index],
                  localizations,
                  bloc!,
                  1,
                  () async {
                    final uri = Uri.parse(
                        'https://www.dinainternational.co.uk/index.php?route=api/wkrestapi/cart/updateCart');
                    // final uri = Uri.parse(
                    //     'https://www.dinainternational.com/index.php?route=api/wkrestapi/cart/updateCart');
                    final payload = {
                      "quantity": getQuantityJson(),
                      "UnitofSalenew": getUnitOfSalesJson(),
                      "wk_token": await AppSharedPref.getWkToken()
                    };
// Debug prints before sending

                    var request = Request('POST', uri)
                      ..headers['Content-Type'] = 'application/json'
                      ..body = json.encode(payload);

                    StreamedResponse response = await request.send();
// Get response body as string for debugging
                    String responseBody = await response.stream.bytesToString();
                    print("📌 API URL: $uri");
                    print("📌 Request Body: ${request.body}");
                    print("📌 Response Status Code: ${response.statusCode}");
                    print("📌 Response Body: $responseBody");
                    if (response.statusCode == 200) {
                      bloc?.add(const CartScreenDataFetchEvent());
                    }
                  },
                  () {
                    bloc?.add(
                        CartScreenRemoveItemEvent(products?[index].key ?? "0"));
                  },
                  () {
                    bloc?.add(AddProductToWishListEvent(
                      products?[index].productId ?? "0",
                      products?[index].key ?? "0",
                      products?[index].quantity ?? "1",
                      products?[index].UnitofSalenew ?? "1",
                    ));
                  },
                  (dataIndex) {},
                  index,
                  isLastItem: isLast,
                );
              },
            ),
          ],
        ),
        EstimateShippingAndTaxesWidget(countryDataModel, bloc),
        //Cart Voucher View
        // if (model?.cart?.voucherStatus == 1)
        //   CartScreenVoucherWidget(bloc, localizations),
        //cart coupon view
        if (model?.cart?.couponStatus == 1)
          CartScreenCouponWidget((coupen) {
            bloc?.add(ApplyCouponEvent(coupen));
          }, localizations),
        const Divider(thickness: 1),
        PriceDetails(
          totals: model?.cart?.totals,
          localizations: localizations,
        ),
      ],
    );
  }

  Map<String, int> getQuantityJson() {
    Map<String, int> jsonMap = {};
    model?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] = int.tryParse(element.quantity ?? "0") ?? 0;
    });
    return jsonMap;
  }

  Map<String, int> getUnitOfSalesJson() {
    Map<String, int> jsonMap = {};
    model?.cart?.products?.forEach((element) {
      jsonMap[element.key ?? "0"] =
          int.tryParse(element.UnitofSalenew ?? "0") ?? 0;
    });
    return jsonMap;
  }
}
