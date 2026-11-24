
import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';

import '../../../common_widgets/common_outlined_button.dart';
import '../../../config/theme.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';

class CartScreenCouponWidget extends StatefulWidget {
  const CartScreenCouponWidget(this.onSubmitClick, this.localizations, {super.key});

  final AppLocalizations? localizations;
  final void Function(String couponText) onSubmitClick;

  @override
  State<CartScreenCouponWidget> createState() => _CartScreenCouponWidgetState();
}

class _CartScreenCouponWidgetState extends State<CartScreenCouponWidget> {
  late TextEditingController couponTextController;
  double buttonPadding = 16.0;

  @override
  void initState() {
    couponTextController = TextEditingController(text: "");
    AppSharedPref.getLanguage().then((value) {
      if (value == "ar") {
        buttonPadding = 11.0;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left:AppSizes.size16,right: AppSizes.size16,bottom: AppSizes.size16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSizes.size6),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,
          ),
        ),
        child: ExpansionTile(
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: AppSizes.size16),
          initiallyExpanded: true,
          title: Text(
            widget.localizations?.translate(AppStringConstant.discountCode) ?? "",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.localizations?.translate(AppStringConstant.useDiscountCode) ?? "Country",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: AppSizes.size8),
                Container(
                  height: 40,
                  color: Theme.of(context).cardColor,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: couponTextController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                                AppSizes.size16,
                                AppSizes.size4,
                                AppSizes.size4,
                                AppSizes.size4),
                            hintText: widget.localizations?.translate(
                                AppStringConstant.enterCoupanCode) ??
                                "",
                            hintStyle: TextStyle(
                              fontSize: AppSizes.size12,
                              color: Theme.of(context).textTheme.headlineMedium!.color,
                            ),
                            border: const OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.darkGray,
                                )),
                            focusedBorder: const OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.darkGray,
                                )),
                            disabledBorder: const OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.darkGray,
                                )),
                            enabledBorder: const OutlineInputBorder(
                              //   borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.darkGray,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSizes.size16),
                commonButton(
                  width: AppSizes.size126,
                  height: AppSizes.size40,
                  context,
                      () {
                    var coupon = couponTextController.text.trim();
                    widget.onSubmitClick(coupon);
                    couponTextController.text = "";
                  },
                      // () async {
                      //   var coupon = couponTextController.text;
                      //   if (coupon != "") {
                      //     Helper.hideSoftKeyBoard();
                      //     widget.bloc?.add(ApplyCouponEvent(coupon));
                      //     widget.bloc?.emit(CartScreenStateInitial());
                      //     couponTextController.text = "";
                      //   } else {
                      //     AlertMessage.showError(
                      //         widget.localizations?.translate(AppStringConstant
                      //             .pleaseEnterCouponCode) ??
                      //             "",
                      //         context);
                      //   }
                      // },
                  (widget.localizations?.translate(AppStringConstant.applyCoupon) ?? "")
                  ,
                  backgroundColor: MobikulTheme.accentColor,
                  textColor: Theme.of(context).primaryColorDark,
                ),
                const SizedBox(height: AppSizes.size8),
              ],
            )
          ],
        ),
      ),
    );
  }
}
