import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

class PayPalPaymentPage extends StatelessWidget {
  const PayPalPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with PayPal')),
      body: Center(
        child: ElevatedButton(
          child: const Text("Pay Now"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PaypalCheckoutView(
                  sandboxMode: false,
                  clientId: "AUg5YLccyxUn77m76GxB7uB-D41zHh_D6NRd-r4xaqUHcNurm7vqapoi_xlLg1SZVVOk0omFh53yVQ7n",
                  secretKey: "EAz_nAfTDD4xdBMlaVobNUJf0d8hrhi4J-L6SLyGAnkuzH1RqfjOUhKHreqPbwJbmiSiOsTLdYwKG9ak",
                  transactions: const [
                    {
                      "amount": {
                        "total": '10.00',
                        "currency": "USD",
                        "details": {
                          "subtotal": '10.00',
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "Payment for product/services",
                      "item_list": {
                        "items": [
                          {
                            "name": "Test Product",
                            "quantity": 1,
                            "price": '10.00',
                            "currency": "USD"
                          }
                        ],
                      }
                    }
                  ],
                  note: "Contact us for any questions on your order.",
                  onSuccess: (Map params) async {
                    // Handle successful payment here
                    print("Rishabh Success: $params");
                    Navigator.pop(context);
                  },
                  onError: (error) {
                    // Handle payment error here
                    print("Rishabh error: $error");
                    Navigator.pop(context);
                  },
                  onCancel: () {
                    // Handle payment cancellation here
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
