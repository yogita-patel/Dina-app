import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import 'package:oc_demo/models/orderDetailModel/return_order_request.dart';
import 'package:oc_demo/screens/login_signup/view/signup_extra_views.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_bloc.dart';
import 'package:intl/intl.dart';
import 'package:oc_demo/screens/returnOrderForm/bloc/return_order_event.dart';

import '../../../common_widgets/dialog_helper.dart';
import '../bloc/return_order_state.dart';

class ReturnOrderForm extends StatefulWidget {
  const ReturnOrderForm(
      this.model, this.productId, this.orderQuantity, this.bloc,
      {super.key});
  final ReturnOrderRequest? model;
  final String? productId;
  final String? orderQuantity;
  final ReturnOrderBloc? bloc;

  @override
  State<ReturnOrderForm> createState() => _ReturnOrderFormState();
}

class _ReturnOrderFormState extends State<ReturnOrderForm> {
  AppLocalizations? _localizations;
  ReturnReasons? returnReason;
  String opened = "0";

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telephone = TextEditingController();
  final TextEditingController _orderId = TextEditingController();
  final TextEditingController _orderDate = TextEditingController();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  final TextEditingController _productQuantity = TextEditingController();
  final TextEditingController _comment = TextEditingController();
  bool _agreedToPolicy = false;

  @override
  void initState() {
    print("----< Return page");
    super.initState();
    _firstName.text = widget.model?.firstname ?? "";
    _lastName.text = widget.model?.lastname ?? "";
    _email.text = widget.model?.email ?? "";
    _telephone.text = widget.model?.telephone ?? "";
    _orderId.text = widget.model?.orderId ?? "";
    _orderDate.text = widget.model?.dateOrdered ?? "";
    _productName.text = widget.model?.product ?? "";
    _productCode.text = widget.model?.model ?? "";
    _productQuantity.text = "1";
    /* returnReason = widget.model?.returnReasons?[0];*/
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size16, vertical: AppSizes.size8),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                (widget.model?.firstname != null)
                    ? const SizedBox.shrink()
                    : Text(AppStringConstant.haveAccount.localized(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                            )),
                Text(
                    "If you already have an account with us, please login at the login page.",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400,
                        )),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.size16),
                  child: Text(
                    AppStringConstant.orderInformation.localized(),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                fieldItem(_firstName, AppStringConstant.firstName.localized(),
                    true, false, false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_lastName, AppStringConstant.lastName.localized(),
                    true, false, false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_email, AppStringConstant.emailAddress.localized(),
                    false, false, false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_telephone, AppStringConstant.telephone.localized(),
                    true, false, false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_orderId, AppStringConstant.orderID.localized(),
                    false, false, false),
                const SizedBox(height: AppSizes.size16),
                InkWell(
                  onTap: () {
                    DateTime selectedDate =
                        DateFormat("yyyy-MM-dd").parse(_orderDate.text);
                    _selectDate(context, selectedDate);
                  },
                  child: fieldItem(
                      //_orderDate, AppStringConstant.dateOrdered.localized(), true,
                      _orderDate,
                      AppStringConstant.orderDate.localized(),
                      true,
                      isEnabled: false,
                      false,
                      false),
                ),
                const SizedBox(height: AppSizes.size16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
                  child: Text(
                    _localizations
                            ?.translate(AppStringConstant.productInformation) ??
                        "",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                fieldItem(
                    _productName,
                    AppStringConstant.productName.localized(),
                    true,
                    false,
                    false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    _productCode,
                    AppStringConstant.productCode.localized(),
                    true,
                    false,
                    false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(_productQuantity,
                    AppStringConstant.quantity.localized(), true, false, false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    null,
                    AppStringConstant.reasonForReturn.localized(),
                    true,
                    //    data: dropDown(widget.model?.returnReasons ?? [])
                    data: radioReasons(
                      widget.model?.returnReasons ?? [],
                    ),
                    true,
                    false),
                const SizedBox(height: AppSizes.size16),
                fieldItem(
                    null,
                    AppStringConstant.productOpened.localized(),
                    true,
                    data: Newsletter(
                      (value) {},
                      "",
                      showHeading: false,
                      selectedId: opened,
                    ),
                    true,
                    false),
                // Text Area

                fieldItem(
                    _comment,
                    AppStringConstant.faultyOrOtherDetails.localized(),
                    false,
                    false,
                    true),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            Colors.white, // border color when unchecked
                      ),
                      child: Checkbox(
                        value: _agreedToPolicy,
                        onChanged: (bool? value) {
                          setState(() {
                            _agreedToPolicy = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: Colors.grey.shade600,
                          width: 1.5,
                        ),
                        checkColor: Colors.white,
                        activeColor: const Color(0xFF0F4AA1),
                        fillColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Color(
                                0xFF0F4AA1); // Checked fill color
                          }
                          return Colors.white; // Unchecked fill color
                        }),
                        // fill color when checked
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(
                              text: 'I have read and agree to the ',
                            ),
                            TextSpan(
                              text: 'Returns Policy',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0XFF0D479C),
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                setState(() {

                                });
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    DialogHelper.termsAndPrivacyDialog(
                                      context,
                                      widget.model?.agree?.data?.title,
                                      widget.model?.agree?.data?.description,
                                    );
                                  });
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.size16),
                const SizedBox(height: AppSizes.size16),
                commonButton(
                  context,
                  () async {
                    var validate = _formKey.currentState?.validate();
                    if (validate == true) {
                      if (!_agreedToPolicy) {
                        AlertMessage.showError(
                            "You must agree to the Returns Policy before continuing.",
                            context);
                        return;
                      }
                      widget.bloc?.emit(ReturnOrderInitial());
                      widget.bloc?.add(ReturnOrderSubmitEvent(
                          widget.model?.orderId,
                          widget.productId,
                          _firstName.text,
                          _lastName.text,
                          _email.text,
                          _telephone.text,
                          _orderDate.text,
                          _productName.text,
                          _productCode.text,
                          widget.orderQuantity,
                          returnReason?.returnReasonId,
                          opened,
                          _comment.text));
                    }
                  },
                  AppStringConstant.submit.localized(),
                  backgroundColor: Theme.of(context).colorScheme.onPrimary,
                  textColor: AppColors.white,
                ),
                //fieldItem(_controller, "First Name", true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget dropDown(List<ReturnReasons> list) {
    return DropdownButtonFormField<ReturnReasons>(
      value: returnReason ?? (list.isNotEmpty ? list.first : null),
      dropdownColor: Theme.of(context).cardColor,
      decoration:
          formFieldDecoration(context, "", "", isDense: true, isRequired: true),
      onChanged: (ReturnReasons? value) {
        returnReason = value;
      },
      items: list
          .map((e) => DropdownMenuItem<ReturnReasons>(
                value: e,
                child: Text(
                  e.name ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: AppSizes.size16),
                ),
              ))
          .toList(),
    );
  }

  Widget radioReasons(List<ReturnReasons> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((item) {
        return RadioListTile<ReturnReasons>(
          value: item,
          groupValue: returnReason,
          title: Text(
            item.name ?? "",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          onChanged: (value) {
            setState(() {
              returnReason = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget fieldItem(
    TextEditingController? controller,
    String label,
    bool isRequired,
    bool title,
    bool maxLine, {
    Widget? data,
    bool isEnabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              _localizations?.translate(label) ?? "",
              style: title
                  ? Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600)
                  : const TextStyle(),
            ),
            if (isRequired)
              const Text(
                "*",
                style: TextStyle(color: Colors.red),
              )
          ],
        ),
        const SizedBox(height: AppSizes.size8),
        data ??
            CommonTextField(
              maxLines: maxLine ? true : false,
              maxLine: maxLine ? 4 : 1,
              controller: controller!,
              isPassword: false,
              helperText: label,
              isRequired: isRequired,
              enable: isEnabled,
              suffix: isEnabled
                  ? null
                  : const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.black,
                    ),
            ),
      ],
    );
  }

  _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      _orderDate.text = DateFormat("yyyy-MM-dd").format(selected);
    }
  }
}
