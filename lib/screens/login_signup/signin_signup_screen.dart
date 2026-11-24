// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/remember_me_custom_checkbox.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_text_field.dart';
import '../../common_widgets/dialog_helper.dart';
import '../../common_widgets/loader.dart';
import '../../config/theme.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_restart.dart';
import '../../helper/open_bottom_model_sheet_helper.dart';
import '../../utils/helper.dart';
import '../login_signup/bloc/signin_signup_screen_bloc.dart';

class SignInSignUpScreen extends StatefulWidget {
  Map<String, dynamic> arguments;
  SignInSignUpScreen(this.arguments, {super.key});

  @override
  _SignInSignUpScreenState createState() => _SignInSignUpScreenState();
}

class _SignInSignUpScreenState extends State<SignInSignUpScreen> {
  bool isFromCartForLogin = false;
  bool isFromCartForSignup = false;
  AppLocalizations? _localizations;
  SigninSignupScreenBloc? bloc;
  late bool _loading;
  late TextEditingController _emailController, _passwordController;
  late GlobalKey<FormState> _formKey;
  bool isRememberMe = false;

  @override
  void initState() {
    isFromCartForLogin = widget.arguments["isFromCartForLogin"];
    isFromCartForSignup = widget.arguments["isFromCartForSignup"];
    _emailController = TextEditingController(text: AppConstant.demoEmail);
    _passwordController = TextEditingController(
      text: AppConstant.demoPassword,
    );
    _formKey = GlobalKey();
    bloc = context.read<SigninSignupScreenBloc>();
    _loading = false;

    // Load last-saved credentials (if any) and prefill fields
    AppSharedPref.getLastLoginCredentials().then((creds) {
      if (creds != null) {
        setState(() {
          _emailController.text = creds['email'] ?? '';
          _passwordController.text = creds['password'] ?? '';
          isRememberMe = true;
        });
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }
  void _validateForm() async {
    if (_formKey.currentState?.validate() == true) {
      TextInput.finishAutofillContext();
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      bloc?.add(LoginEvent(_emailController.text.trim(),
          _passwordController.text, fcmToken, wkToken));
      bloc?.emit(LoadingState());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
        builder: (context, state) {
      print(state);
      if (state is LoadingState) {
        _loading = true;
      }else if (state is ForgotPasswordState) {
        _loading = false;
        var model = state.data;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(model.message ?? "", context);
        });
      }
      else if (state is LoginState) {
        _loading = false;
        var model = state.data;
        AppSharedPref.setLoginUserData(model).then((_) {
          // Save or clear credentials depending on 'Remember me'
          if (isRememberMe) {
            AppSharedPref.setLastLoginCredentials(_emailController.text.trim(), _passwordController.text);
          } else {
            AppSharedPref.setLastLoginCredentials("", "");
          }
          
          // Set login status AFTER user data is saved
          AppSharedPref.setLogin(true);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });
        });
      }
      else if (state is SigninSignupScreenError) {
        _loading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(state.message ?? "", context);
        });
      }

      else if (state is SigninSignupScreenError) {
        _loading = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showSuccess(state.message ?? "", context);
        });
      }

      return Stack(
        children: <Widget>[
          buildUI(),
          Visibility(
            visible: _loading,
            child: Loader(),
          ),
        ],
      );
    });
  }

  Widget buildUI(){
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(
            AppStringConstant.login,
          ) ??
              '',
          context,
          isLeadingEnable: false, onPressed: () {
        Navigator.pop(context);
      }),
      body: Container(
        width: AppSizes.deviceWidth,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: AppSizes.deviceWidth / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${_localizations?.translate(AppStringConstant.welcomeBack)}",
                        style: Theme.of(context).textTheme.displayLarge),
                    Text(
                      "${_localizations?.translate(AppStringConstant.logintocontinueshopping)}",
                      style: Theme.of(context).textTheme.displayLarge,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.size8, vertical: AppSizes.size26),
                child: Container(
                  child: AutofillGroup(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: AppSizes.size4),
                          CommonTextField(
                            controller: _emailController,
                            isRequired: true,
                            isPassword: false,
                            validationType: AppStringConstant.email,
                            inputType: TextInputType.emailAddress,
                            hintText: _localizations
                                    ?.translate(AppStringConstant.emailAddress) ??
                                "",
                            autofillHints: const [AutofillHints.email],
                          ),
                          const SizedBox(height: AppSizes.size16),
                          CommonTextField(
                              maxLines: false,
                              maxLine: 1,
                              controller: _passwordController,
                              isRequired: true,
                              isPassword: true,
                              validationType: AppStringConstant.password,
                              hintText: _localizations
                                      ?.translate(AppStringConstant.password) ??
                                  "",
                              autofillHints: const [AutofillHints.password]
                              ),
                          const SizedBox(height: AppSizes.size16),
                          Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                              onTap: () {
                                DialogHelper.forgotPasswordDialog(
                                    context,
                                    _localizations,
                                    _localizations?.translate(
                                            AppStringConstant.forgotPassword) ??
                                        '',
                                    _localizations?.translate(AppStringConstant
                                            .forgotPasswordMessage) ??
                                        '', onConfirm: (email) async {
                                  bloc?.emit(LoadingState());
                                  var wkToken = await AppSharedPref.getWkToken();
                                  bloc?.add(ForgotPasswordEvent(email, wkToken));
                                }, email: _emailController.text,);
                              },
                              child: Text(
                                _localizations?.translate(
                                        AppStringConstant.forgotPassword) ??
                                    "",
                                style: TextStyle(
                                    color: Color(0xFF0D479C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.size16),
                          CustomCheckbox(
                            (value) {
                              isRememberMe = value;
                            },
                            _localizations
                                ?.translate(AppStringConstant.rememberme),
                            isRememberMe
                          ),
                          const SizedBox(height: AppSizes.size16 *2),
                          commonButton(
                            context,
                            _validateForm,
                            (_localizations?.translate(AppStringConstant.login) ??
                                ""),
                              backgroundColor: MobikulTheme.primaryColor,
                              textColor: Colors.white
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: AppSizes.deviceWidth / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "${_localizations?.translate(AppStringConstant.donthaveanaccount)}",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w400
                        )),
                    SizedBox(width: 4,),
                    InkWell(
                      onTap: (){
                          Navigator.pop(context);
                          signInSignUpBottomModalSheet(context, true, false);
                        },
                      child: Text(
                        "${_localizations?.translate(AppStringConstant.signup)}",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Color(0xFF0D479C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),),
      ),
    );
  }
}
