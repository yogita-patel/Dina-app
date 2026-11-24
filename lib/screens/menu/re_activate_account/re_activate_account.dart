import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/utils/helper.dart';
import 'package:oc_demo/utils/validator.dart';

import '../../../config/theme.dart';


class ReActivateAccount extends StatefulWidget {
  const ReActivateAccount({super.key});

  @override
  State<ReActivateAccount> createState() => _ReActivateAccountState();
}

class _ReActivateAccountState extends State<ReActivateAccount> {

  AppLocalizations? _localizations;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late FocusNode _emailFocusNode,
      _firstnameFocusNode,
      _subjectFocusNode,
      _messageFocusNode;

  late GlobalKey<FormState> _formKey;
  String? emailErrorMessage;
  String? selectedId;

  void _validateForm() async {
    print("_formKey.currentState?.validate()--> ${_formKey.currentState?.validate()}");
    if (_formKey.currentState?.validate() == true) {
      Helper.hideSoftKeyBoard();
      try {
        var wkToken = await AppSharedPref.getWkToken();
        var fcmToken = await AppSharedPref.getFcmToken();

        final result = await ApiClient().reactivateAccount(
          wkToken,
          _firstNameController.text,
          _emailController.text,
          _subjectController.text,
          _messageController.text,
        );

        if(result.message!=null){
          AlertMessage.showSuccess(result.message ?? "", context);
          Navigator.pop(context);
        }

      } catch (e) {
        // Handle API error
        AlertMessage.showError(e.toString() ?? "", context);
      }
    } else {
      _focusErrorNode();
    }
  }

  void _focusErrorNode() {
    if (_firstNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_firstnameFocusNode);
    } else if (_emailController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    }else if (_messageController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_messageFocusNode);
    }
  }


  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _formKey = GlobalKey();
    _emailFocusNode = FocusNode();
    _firstnameFocusNode = FocusNode();
    _subjectFocusNode = FocusNode();
    _messageFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.reActivateAccount) ?? "",
          context,
          isElevated: false),

      body: SingleChildScrollView(
        child:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.size16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child:
                      Text(
                              "Already registered and can't log in to your Trade Account? To reactivate your account, please fill in the form below and a member of our team will contact you via email. Please leave your contact number in the message section.",
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.labelLarge),
                    ),
                    contactForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contactForm(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: AppSizes.size8,
        ),

        const SizedBox(height: AppSizes.size16,),
        CommonTextField(
          focusNode: _firstnameFocusNode,
          controller: _firstNameController,
          // isRequired: true,
          isPassword: false,
          hintText: _localizations
              ?.translate(AppStringConstant.firstName) ??
              '',
          inputType: TextInputType.name,
          validation: (value) {
            String? ans = Validator.isValidName(value ?? '', context);
            if (ans == null) {
              return null; // ✅ VALID
            }
            return _localizations?.translate(ans) ?? ans;
          },
        ),

        const SizedBox(height: AppSizes.size16),

        CommonTextField(
          focusNode: _emailFocusNode,
          controller: _emailController,
          isPassword: false,
          hintText: _localizations
              ?.translate(AppStringConstant.emailAddress) ??
              "",
          isRequired: true,
          inputType: TextInputType.emailAddress,
          validation: (value) {
            print("ans--> ${Validator.isEmailValid(value ?? '', context)}");
            return Validator.isEmailValid(value ?? '', context);
          },
          onChange: (value) async {
            if (Validator.isEmailValid(value, context) == null) {
              var wkToken = await AppSharedPref.getWkToken();

            } else {
              emailErrorMessage = null;
            }
          },
        ),
        if (emailErrorMessage != null)
          Padding(
            padding: const EdgeInsets.all(AppSizes.size4),
            child: Text(
              emailErrorMessage!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.red),
            ),
          ),
        const SizedBox(height: AppSizes.size16),

        CommonTextField(
          focusNode: _subjectFocusNode,
          controller: _subjectController,
          // isRequired: true,
          isPassword: false,
          hintText: _localizations
              ?.translate(AppStringConstant.subject) ??
              '',
          inputType: TextInputType.name,
          validation: (value) {
            String? ans = Validator.isValidSubject(value ?? '', context);
            if (ans == null) {
              return null; // ✅ VALID
            }
            return _localizations?.translate(ans) ?? ans;
          },
        ),
        const SizedBox(height: AppSizes.size16),

        CommonTextField(
          focusNode: _messageFocusNode,
          controller: _messageController,
          isPassword: false,
          hintText: _localizations
              ?.translate(AppStringConstant.message) ??
              "",
          isRequired: false,
          inputType: TextInputType.text,
          maxLine: 6,
          validation: (value) {
            String? ans = Validator.isValidMessage(value ?? '', context);
            if (ans == null) {
              return null; // ✅ VALID
            }
            return _localizations?.translate(ans) ?? ans;
          },
        ),


        const SizedBox(height: AppSizes.size30+AppSizes.size16),

        commonButton(
          context,
          _validateForm,
          _localizations?.translate(AppStringConstant.sendMessage) ?? "",
            backgroundColor: MobikulTheme.primaryColor,
            textColor: Colors.white
        ),

        const SizedBox(height: AppSizes.size16),
      ],
    );
  }


}
