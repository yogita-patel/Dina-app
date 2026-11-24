import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

import '../../models/checkout/checkout_review_order_model.dart';

typedef PayPalSuccessCallback = void Function(Map params);
typedef PayPalErrorCallback = void Function(Object error);
typedef PayPalCancelCallback = void Function();

class DinaPaypal {
  // Singleton pattern
  DinaPaypal._privateConstructor();
  static final DinaPaypal instance = DinaPaypal._privateConstructor();

  void initPayPalPayment({
    required BuildContext context,
    required String? clientId,
    required String? secretKey,
    required PaypalData? payPalData,
    required Paypal? paypal,
    String note = "",
    required PayPalSuccessCallback onSuccess,
    required PayPalErrorCallback onError,
    required PayPalCancelCallback onCancel,
    bool sandboxMode = false,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaypalCheckoutView(
          sandboxMode: sandboxMode,
          clientId: clientId,
          secretKey: secretKey,
          transactions:  [
            {
              "amount": {
                "total": payPalData?.total?? '1.0',
                "currency": "USD",
                "details": {
                  "subtotal": payPalData?.subTotal ??'1.0',
                  "shipping": '0',
                  'tax':payPalData?.tax ??"0.0",
                  "shipping_discount": 0
                }
              },
            }
          ],
          note: note,
          onSuccess: (params) async {
            onSuccess(params);
            Navigator.pop(context);
          },
          onError: (error) {
            onError(error);
            Navigator.pop(context);
          },
          onCancel: () {
            onCancel();
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
