import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/common_order_button.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/checkout/checkout_payment_method_model.dart';
import 'package:oc_demo/models/checkout/checkout_review_order_model.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/order_complete.dart';
import 'package:oc_demo/screens/checkout/order_review/widget/order_review_view.dart';

import 'package:oc_demo/screens/checkout/order_review/widget/webview_payment.dart';
import 'package:oc_demo/screens/pay_pal_payment/pay_pal_payment.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/loader.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import 'bloc/order_review_screen_bloc.dart';
import 'bloc/order_review_screen_event.dart';
import 'bloc/order_review_screen_state.dart';

class OrderReview extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const OrderReview(this.arguments, {super.key});

  @override
  _OrderReviewState createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  late AppLocalizations? _localizations;
  late bool _loading;
  CheckoutPaymentMethodModel? _paymentMethods;
  CheckoutReviewOrderModel? checkoutReviewOrderModel;
  late OrderReviewScreenBloc _bloc;
  bool isPrivacyAccepted = false;
  String paymentComment = "";
  String shippingComment =
      ""; //shipping comment passing from shipping screen as argument
  bool isShippingRequired = true;
  bool _confirmOrderPressed = false;
  bool? isGuestCheckout;
  String? paymentMethode = "";
  String? redirectUrl;
  String? successUrl;
  String? failureUrl;

  @override
  void initState() {
    shippingComment = widget.arguments?[comment];
    isShippingRequired = widget.arguments?["isShippingRequired"];
    isGuestCheckout = widget.arguments?["isGuestCheckout"];
    // isGuestCheckout=widget.arguments?["isGuestCheckout"];
    _bloc = context.read<OrderReviewScreenBloc>();
    if (isShippingRequired == false && isGuestCheckout == true) {
      _paymentMethods = CheckoutPaymentMethodModel();
      _paymentMethods?.paymentMethods = PaymentMethods();
      _paymentMethods?.paymentMethods?.paymentMethodList =
          widget.arguments?["payment_method"];
      if ((_paymentMethods?.paymentMethods?.paymentMethodList?.length ?? 0) >
          0) {
        AppSharedPref.setSelectedPaymentId(
            _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ?? "");
        _bloc.add(const LoadingEvent());
        _bloc.add(OrderReviewEvent(
            _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ?? "",
            "",
            "0"));
      }
    } else if (isShippingRequired) {
      _bloc.add(PaymentMethodEvent(shippingComment));
    } else {
      _bloc.add(const PaymentMethodEventWhileShippingNotRequired());
    }
    _loading = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    _clearPaymentMethod();
    super.didChangeDependencies();
  }

  void _clearPaymentMethod() async {
    await AppSharedPref.setSelectedPaymentId("");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                AppImages.backArrow,
              )),
        ),
        title: Text(
          AppStringConstant.payment.localized(),
          style: Theme.of(context).textTheme.displaySmall,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
        ),
        centerTitle: true, // Center the title
      ),
      body: BlocBuilder<OrderReviewScreenBloc, OrderReviewScreenState>(
        builder: (context, currentState) {
          if (currentState is InitialState) {
          } else if (currentState is OrderReviewLoadingState) {
            print("OrderReviewLoadingState .........");
            _loading = true;
          } else if (currentState is OrderReviewState) {
            print("OrderReviewState .........");
            _loading = false;
            checkoutReviewOrderModel = currentState.model;
            print(
                "OrderReviewState PayPal redirectUrl: ${checkoutReviewOrderModel?.continu?.paypal?.redirectUrl}");
            print(
                "OrderReviewState WorldPay redirectUrl: ${checkoutReviewOrderModel?.continu?.worldpay?.redirectUrl}");

            redirectUrl =
                checkoutReviewOrderModel?.continu?.paypal?.redirectUrl ??
                    checkoutReviewOrderModel?.continu?.worldpay?.redirectUrl ??
                    checkoutReviewOrderModel?.continu?.worldpayBiz?.redirectUrl;

            successUrl =
                checkoutReviewOrderModel?.continu?.paypal?.successUrl ??
                    checkoutReviewOrderModel?.continu?.worldpay?.successUrl ??
                    checkoutReviewOrderModel?.continu?.worldpayBiz?.successUrl;

            failureUrl =
                checkoutReviewOrderModel?.continu?.paypal?.failureUrl ??
                    checkoutReviewOrderModel?.continu?.worldpay?.failureUrl ??
                    checkoutReviewOrderModel?.continu?.worldpayBiz?.failureUrl;

            print("✅ Final redirectUrl: $redirectUrl");
            print("✅ Final successUrl: $successUrl");
            print("✅ Final failureUrl: $failureUrl");

            if (_confirmOrderPressed) {
              _confirmOrderPressed = false;
              _bloc.add(const LoadingEvent());
              _bloc.add(OrderPlaceEvent("1"));
            }
          } else if (currentState is PaymentMethodState) {
            _loading = false;
            _paymentMethods = currentState.model;
            print(
                "PaymentMethodState${checkoutReviewOrderModel?.continu?.paypal?.redirectUrl}");

            if ((_paymentMethods?.paymentMethods?.paymentMethodList?.length ??
                    0) >
                0) {
              AppSharedPref.setSelectedPaymentId(
                  _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
                      "");
              _bloc.add(const LoadingEvent());
              _bloc.add(OrderReviewEvent(
                  _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
                      "",
                  "",
                  "0"));
            } else {
              // Agar payment methods empty hai ya null hai
              AppSharedPref.setSelectedPaymentId("");

              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showSuccess(
                    _localizations
                            ?.translate(AppStringConstant.notpaymentmethod) ??
                        "",
                    context);
                Navigator.pushNamedAndRemoveUntil(
                    context, AppRoute.cart, (route) => false);
              });
            }

            if (_paymentMethods?.paymentMethods?.errorWarning?.isNotEmpty ==
                true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showError(
                    _paymentMethods?.paymentMethods?.errorWarning ?? '',
                    context);
              });
            }
          }

          // else if (currentState is PaymentMethodState) {
          //   _loading = false;
          //   _paymentMethods = currentState.model;
          //   print(
          //       "PaymentMethodState${checkoutReviewOrderModel?.continu?.paypal?.redirectUrl}");
          //   if ((_paymentMethods?.paymentMethods?.paymentMethodList?.length ??
          //           0) >
          //       0) {
          //     AppSharedPref.setSelectedPaymentId(
          //         _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
          //             "");
          //     _bloc.add(const LoadingEvent());
          //     _bloc.add(OrderReviewEvent(
          //         _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
          //             "",
          //         "",
          //         "0"));
          //   } else {
          //     AppSharedPref.setSelectedPaymentId("");
          //   }
          //   if (_paymentMethods?.paymentMethods?.errorWarning?.isNotEmpty ==
          //       true) {
          //     WidgetsBinding.instance.addPostFrameCallback((_) {
          //       AlertMessage.showError(
          //           _paymentMethods?.paymentMethods?.errorWarning ?? '',
          //           context);
          //     });
          //   }
          // }
          else if (currentState is ApplyCouponSuccess) {
            _loading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.data.message ?? '', context);
            });
            _bloc.add(OrderReviewEvent(
                _paymentMethods?.paymentMethods?.paymentMethodList?[0].code ??
                    "",
                "",
                "0"));
          } else if (currentState is OrderPlaceState) {
            _loading = false;
            //AppSharedPref.setCartCount("0");
            print(
                "Callback value paypal ..................${AppSharedPref.getSelectedPaymentId()}");
            print(
                "Callback value paymentMethode ..................${paymentMethode}");
            print(
                "Callback value paymentMethode ..................${currentState.model.redirectUrl}");
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => OrderComplete(
                    currentState.model.success?.headingTitle,
                    currentState.model.success?.textMessage,
                    currentState.model.orderId.toString(),
                    currentState.model.shippingAddress?.address1,
                    currentState.model.shippingAddress?.address2,
                    currentState.model.shippingAddress?.country,
                    currentState.model.date,
                  ),
                ),
              );
            });
          } else if (currentState is OrderReviewScreenError) {
            _loading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(currentState.message ?? '', context);
            });
          }
          _bloc?.emit(const InitialState());
          return SafeArea(child: _buildUI());
        },
      ),
    );
  }

  Widget _buildUI() => Stack(
        children: <Widget>[
          Visibility(
            visible: _paymentMethods != null,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: OrderReviewView(
                      orderReviewModel: checkoutReviewOrderModel,
                      paymentMethod: _paymentMethods,
                      localizations: _localizations,
                      onPaymentMethodChange: () async {
                        _bloc.add(OrderReviewEvent(
                            await AppSharedPref.getSelectedPaymentId(),
                            paymentComment,
                            isPrivacyAccepted ? "1" : "0"));
                      },
                      isCheckboxSelected: (value) {
                        isPrivacyAccepted = value;
                      },
                      comment: (value) {
                        paymentComment = value;
                      },
                      isShippingRequired: isShippingRequired,
                      isGuestCheckout: isGuestCheckout,
                      coupon: (coupon) {
                        _bloc.add(ApplyCouponEvent(coupon));
                      },
                    ),
                  ),
                ),
                commonOrderButton(
                  context,
                  _localizations,
                  getTotalAmount(),
                  _localizations?.translate(AppStringConstant.confirm) ?? "",
                  () async {
                    List<Products> outOfStockProducts = checkoutReviewOrderModel
                            ?.continu?.orderDetails?.products
                            ?.where((product) =>
                                product.stock == false ||
                                product.totalQuantity == "0")
                            .toList() ??
                        [];

                    if (outOfStockProducts.isNotEmpty) {
                      _showOutOfStockDialog(outOfStockProducts);
                      return;
                    }

                    if (!isPrivacyAccepted) {
                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                        AlertMessage.showWarning(
                            AppStringConstant.youMustAgreeToTermsAndCondition
                                .localized(),
                            context);
                      });
                      return;
                    }
                    _paymentMethods?.paymentMethods?.paymentMethodList
                        ?.forEach((element) async {
                      if (element.code ==
                          (await AppSharedPref.getSelectedPaymentId())) {
                        print(
                            "paypal. notImplementPaymentmethod ${element.code}");
                        paymentMethode = element.code;
                        print(
                            "paypal. notImplementPaymentmethod ${paymentMethode}");
                        if (element.code == "paypal" ||
                            element.code == "access_worldpay_checkout" ||
                            element.code == "worldpaybiz") {
                          if (redirectUrl == null || redirectUrl!.isEmpty) {
                            print("❌ Redirect URL not available");
                            AlertMessage.showError(
                                "Payment redirect URL not available", context);
                            return;
                          }
                          print("✅ Button pressed redirectUrl: $redirectUrl");
                          print("✅ Button pressed successUrl: $successUrl");
                          print("✅ Button pressed failureUrl: $failureUrl");
                          Navigator.of(context).pushNamed(
                            AppRoute.webViewPaymentScreen,
                            arguments: {
                              "redirectUrl": redirectUrl,
                              "successUrl": successUrl,
                              "failureUrl": failureUrl,
                              "id": "0",
                            },
                          ).then((value) async {
                            print("Callback value------${value}-----");
                            if (value.toString().contains("SUCCESS")) {
                              print("dddegtjukik");

                              print("paypal. ImplementPaymentmethod");
                              _confirmOrderPressed = true;

                              _bloc.add(const LoadingEvent());
                              _bloc.add(OrderReviewEvent(
                                  await AppSharedPref.getSelectedPaymentId(),
                                  paymentComment,
                                  "1"));
                            } else if (value.toString().contains("failure")) {
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                AlertMessage.showError(
                                    AppStringConstant.cancelPaymentMessage
                                            .localized() ??
                                        '',
                                    context);
                              });
                              print(
                                  "Back button pressed ............................................");
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            } else {
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                AlertMessage.showError(
                                    AppStringConstant.cancelPaymentMessage
                                            .localized() ??
                                        '',
                                    context);
                                //   AlertMessage.showError(Utils.getStringValue(
                                //       context, AppStringConstant.cancelPaymentMessage), context);
                                // });
                                print(
                                    "Back button pressed ............................................");
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              });
                            }
                          });
                        } else if (element.code == "cod") {
                          print("cod. ImplementPaymentmethod");
                          _confirmOrderPressed = true;

                          _bloc.add(const LoadingEvent());
                          _bloc.add(OrderReviewEvent(
                              await AppSharedPref.getSelectedPaymentId(),
                              paymentComment,
                              "1"));
                        } else if (element.code == "bank_transfer") {
                          print("cod. ImplementPaymentmethod");
                          _confirmOrderPressed = true;

                          _bloc.add(const LoadingEvent());
                          _bloc.add(OrderReviewEvent(
                              await AppSharedPref.getSelectedPaymentId(),
                              paymentComment,
                              "1"));
                        } else {
                          print("paypal. notImplementPaymentmethod");

                          WidgetsBinding.instance
                              .addPostFrameCallback((timeStamp) {
                            AlertMessage.showWarning(
                                AppStringConstant.notImplementPaymentmethod
                                    .localized(),
                                context);
                          });
                        }
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Visibility(
            visible: _loading,
            child: const Loader(),
          ),
        ],
      );

  /*
  *
  * return total amount
  * */
  getTotalAmount() {
    String? total = (checkoutReviewOrderModel?.continu?.totals?.length ?? 0) > 2
        ? (checkoutReviewOrderModel?.continu?.totals?[2].text ?? "0")
        : checkoutReviewOrderModel?.continu?.totals?[1].text ?? "0";
    checkoutReviewOrderModel?.continu?.totals?.forEach((element) {
      if (element.title == "total" ||
          element.title == "Total" ||
          element.title == "value") {
        total = element.text;
      }
    });
    return total;
  }

  void _showOutOfStockDialog(List<Products> outOfStockProducts) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Out of Stock Items",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                "The following products are currently out of stock. Please resolve them to continue.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: outOfStockProducts.map((product) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: ImageView(
                                    url: product.image ?? "",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Model: ${product.model ?? ""}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      _bloc.add(AddToBackorderEvent(
                                          product.productId ?? "",
                                          product.quantity ?? "1",
                                          product.inner ?? "1",
                                          product.key ??
                                              product.productId ??
                                              ""));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF914D),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: const Text(
                                      "Backorder",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      _bloc.add(RemoveItemEvent(product.key ??
                                          product.productId ??
                                          ""));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                    ),
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: Text(
                  _localizations?.translate(AppStringConstant.cancel) ??
                      "Cancel",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
