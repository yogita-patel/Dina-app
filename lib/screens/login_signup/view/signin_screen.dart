import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_routes.dart';

import '../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/common_text_field.dart';
import '../../../common_widgets/common_tool_bar.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../common_widgets/loader.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';
import '../../../main.dart';
import '../../../utils/helper.dart';
import '../../login_signup/bloc/signin_signup_screen_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen(this.isComingFromCartPage, {super.key});
  final bool isComingFromCartPage;

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  SigninSignupScreenBloc? bloc;
  late TextEditingController _emailController, _passwordController;
  late AppLocalizations? _localizations;
  late GlobalKey<FormState> _formKey;
  bool _loading = false;
  bool isFingerprintAdded = false;
  bool loginFromFingerPrint = false;
  String? email = "";

  @override
  void initState() {
    _emailController = TextEditingController(text: AppConstant.demoEmail);
    _passwordController = TextEditingController(
      text: AppConstant.demoPassword,
    );
    bloc = context.read<SigninSignupScreenBloc>();
    _formKey = GlobalKey();
    AppSharedPref.getFingerprintData().then((value) {
      setState(() {
        isFingerprintAdded = value != null;
        email = value?["email"] ?? "";
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  void _validateForm() async {
    // Prevent multiple taps while loading
    if (_loading) return;
    
    if (_formKey.currentState?.validate() == true) {
      TextInput.finishAutofillContext();
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      loginFromFingerPrint = false;
      cartActionDisableToQuote = false;
      bloc?.add(LoginEvent(_emailController.text.trim(),
          _passwordController.text, fcmToken, wkToken));
      bloc?.emit(LoadingState());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
      builder: (context, state) {
        print("State is Raam kumar vakeel ${state}");
        if (state is LoadingState) {
          _loading = true;
        } else if (state is ForgotPasswordState) {
          _loading = false;
          var model = state.data;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(model.message ?? "", context);
          });
        } else if (state is LoginState) {
          _loading = false;

          var model = state.data;
          // Save user data before navigation to ensure it's available when profile screen loads
          AppSharedPref.setLoginUserData(model).then((_) {
            // Set login status AFTER user data is saved
            AppSharedPref.setLogin(true);
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (widget.isComingFromCartPage == true) {
                loginFromFingerPrint
                    ? Navigator.of(context)
                        .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false)
                    : checkFingerprint();
              } else {
                loginFromFingerPrint
                //?BottomTabController.check.countController?.sink.add(0)
                    ?
                Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoute.bottomTabBAr, (route) => false,
                )
                    : checkFingerprint();
              }
            });
          });
        } else if (state is SigninSignupScreenError) {
          _loading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(state.message ?? "", context);
          });
        }
        return Stack(
          children: <Widget>[
            _buildContent(),
            Visibility(
              visible: _loading,
              child: const Loader(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContent() {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: commonToolBar(
          (_localizations?.translate(AppStringConstant.signInWithEmail) ?? ""),
          context,
          isLeadingEnable: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size8, vertical: AppSizes.size26),
        child: Container(
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: AppSizes.size4),
                    CommonTextField(
                      controller: _emailController,
                      isRequired: true,
                      isPassword: false,
                      validationType: AppStringConstant.email,
                      inputType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      hintText: _localizations
                              ?.translate(AppStringConstant.emailAddress) ??
                          "",
                    ),

                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(

                        // isPassword: true,
                        controller: _passwordController,
                        isRequired: true,
                        isPassword: true,
                        validationType: AppStringConstant.password,
                        inputType: TextInputType.visiblePassword,
                        autofillHints: const [AutofillHints.password],
                        hintText: _localizations
                                ?.translate(AppStringConstant.password) ??
                            ""),
                    const SizedBox(height: AppSizes.size16 * 1.5),

                    /// Forgot password
                    GestureDetector(
                      child: Text(
                        _localizations
                                ?.translate(AppStringConstant.forgotPassword) ??
                            "",
                        style: TextStyle(
                            color: Theme.of(context).textTheme.titleLarge?.color,
                            fontSize: 13),
                      ),
                      onTap: () {
                        DialogHelper.forgotPasswordDialog(
                            context,
                            _localizations,
                            _localizations?.translate(
                                    AppStringConstant.forgotPassword) ??
                                '',
                            _localizations?.translate(
                                    AppStringConstant.forgotPasswordMessage) ??
                                '', onConfirm: (email) async {
                          bloc?.emit(LoadingState());
                          var wkToken = await AppSharedPref.getWkToken();
                          bloc?.add(ForgotPasswordEvent(email, wkToken));
                        }, email: _emailController.text);
                      },
                    ),
                    const SizedBox(height: AppSizes.size16 * 1.5),
                    commonButton(
                        context,
                        _validateForm,
                        (_localizations?.translate(AppStringConstant.signIn) ??
                                ""),
                          //  .toUpperCase(),
                        // backgroundColor: MobikulTheme.primaryColor,
                        backgroundColor: MobikulTheme.accentColor,

                        // textColor: Colors.white),
                        textColor: Theme.of(context).cardColor),

                    const SizedBox(height: AppSizes.size16),

                    /// Create account

                    commonButton(context, () {

                      Navigator.pop(context);
                        signInSignUpBottomModalSheet(context, true, false);
                      },
                      (_localizations?.translate(
                                  AppStringConstant.createAnAccount) ??
                              ""),
                         // .toUpperCase(),
                      textColor: AppColors.black
                      ,
                      //Theme.of(context).colorScheme.onPrimary
                      backgroundColor: MobikulTheme.iconColor,

                      //  backgroundColor: AppColors.white
                    ),

                    const SizedBox(height: AppSizes.size16),
                    if (isFingerprintAdded)
                      Center(
                        child: InkWell(
                          child: Lottie.asset(AppImages.fingerPrintLottie,
                              width: AppSizes.deviceWidth / 6,
                              height: AppSizes.deviceWidth / 6,
                              fit: BoxFit.fill,
                              repeat: true),
                          onTap: () {
                            startAuthentication(false);
                          },
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //================Handle Fingerprint Login==============//
  final LocalAuthentication auth = LocalAuthentication(); //----Initialization
  void checkFingerprint() {
    auth.isDeviceSupported().then((value) {
      if (value) {
        showFingerprintDialog();
      } else {
        if (widget.isComingFromCartPage == true) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.cart, (route) => false);
        } else {
          BottomTabController.check.countController?.sink.add(0);
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
        }
        /* Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);*/
      }
    });
  }

  void showFingerprintDialog() async {
    if (isFingerprintAdded && _emailController.text == email) {
      // While finger print is added and user is again login with same email
      // startAuthentication(true);
      BottomTabController.check.countController?.sink.add(0);
      // Navigator.of(context)
      //     .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
    } else if (isFingerprintAdded && _emailController.text != email) {
      DialogHelper.forgotPasswordDialog(
          context,
          _localizations,
          _localizations?.translate(AppStringConstant.fingerprintLogin) ?? "",
          _localizations
                  ?.translate(AppStringConstant.replaceFingerprintMessage) ??
              "", onConfirm: (data) {
        startAuthentication(true);
      }, onCancel: (value) {
        BottomTabController.check.countController?.sink.add(0);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
      }, isForgotPassword: false);
    } else {
      DialogHelper.forgotPasswordDialog(
          context,
          _localizations,
          _localizations?.translate(AppStringConstant.fingerprintLogin) ?? "",
          _localizations?.translate(AppStringConstant.fingerprintMessage) ?? "",
          onConfirm: (data) {
        startAuthentication(true);
      }, onCancel: (value) {
        BottomTabController.check.countController?.sink.add(0);
        // Navigator.of(context)
        //     .pushNamedAndRemoveUntil(AppRoute.bottomTabBAr, (route) => false);
      }, isForgotPassword: false);
    }
  }

  void startAuthentication(bool alreadyLogin) async {
    auth.isDeviceSupported().then((value) async {
      if (value) {
        bool didAuthenticate = await auth.authenticate(
            localizedReason:
                _localizations?.translate(AppStringConstant.fingerprintLogin) ??
                    '');
        if (didAuthenticate) {
          if (alreadyLogin) {
            Map<String, String> header = {};
            header["email"] = _emailController.text;
            header["password"] = _passwordController.text;
            AppSharedPref.setFingerprintData(header);
            BottomTabController.check.countController?.sink.add(0);
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     AppRoute.bottomTabBAr, (route) => false);
          } else {
            loginFromFingerPrint = true;
            bloc?.emit(LoadingState());
            var data = await AppSharedPref.getFingerprintData();
            var wkToken = await AppSharedPref.getWkToken();
            var fcmToken = await AppSharedPref.getFcmToken();
            bloc?.add(LoginEvent(data?["email"] ?? "", data?["password"] ?? "",
                fcmToken, wkToken));
          }
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(
                _localizations
                        ?.translate(AppStringConstant.authenticationFailed) ??
                    '',
                context);
          });
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertMessage.showError(
              _localizations
                      ?.translate(AppStringConstant.unableToAuthenticate) ??
                  '',
              context);
        });
      }
    });
  }
}
