import 'package:flutter/material.dart';
import 'package:oc_demo/main.dart';
import '../../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_restart.dart';

class OrderComplete extends StatefulWidget {
  const OrderComplete(this.headingTitle, this.data, this.orderId, this.address1,
      this.address2, this.country, this.date,
      {super.key});

  final String? headingTitle, data, orderId, address1, address2, country, date;

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  AppLocalizations? localizations;

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        print(
            "Back button pressed ............................................");
            cartActionDisableToQuote = false;
        Navigator.of(context).popUntil((route) => route.isFirst);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.size16, vertical: AppSizes.size88),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.successIcon,
                    height: AppSizes.size65,
                    width: AppSizes.size65,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    widget.headingTitle ?? '',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.data ?? '',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _infoRow(
                      title: "Order Placed",
                      value: widget.date ?? '',
                      linkLabel: "Order #${widget.orderId}",
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          AppRoute.orderDetail,
                          arguments: widget.orderId ?? "",
                        );
                      }),
                  const SizedBox(height: 20),
                  // ✅ Address Info
                  _infoRow(
                    title: "Address",
                    value:
                        "${widget.address1},${widget.address2},${widget.country}",
                    linkLabel: "Shipping Address",
                    onTap: () {}, // Replace with your address handler
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: AppSizes.size45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD166),
                        foregroundColor: const Color(0xFF0F4AA1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        print(
                            "dwndcdbvvmv,v ............................................");
                        // AppRestart.rebirth(context);
                        cartActionDisableToQuote = false;
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);

                        // Navigator.of(context).pushAndRemoveUntil(
                        //   MaterialPageRoute(builder: (context) =>  BottomTabbarWidget()),
                        //       (route) => false,
                        // );
                      },
                      child: Text(localizations
                              ?.translate(AppStringConstant.goToHome) ??
                          ""),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required String title,
    required String value,
    required String linkLabel,
    required VoidCallback onTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  linkLabel,
                  style: const TextStyle(
                    color: Color(0xFF0F4AA1),
                    //decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: AppSizes.deviceWidth/2,
            child: Text(value,textAlign: TextAlign.end,)),
      ],
    );
  }
}
