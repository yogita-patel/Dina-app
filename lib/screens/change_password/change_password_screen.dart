import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/screens/change_password/bloc/change_password_bloc.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_text_field.dart';
import '../../config/theme.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/loginModel/login_model.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  AppLocalizations? _localizations;
  ChangePasswordBloc? _changePasswordBloc;
  LoginModel? userDefaultData;
  final _formKey = GlobalKey<FormState>();
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppSharedPref.getLoginUserData().then((value) => userDefaultData = value);
    _changePasswordBloc = context.read<ChangePasswordBloc>();
  }
  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(_localizations?.translate(AppStringConstant.changePassword)??"" , context),
      body: BlocBuilder<ChangePasswordBloc,ChangePasswordState>(
        builder:  (BuildContext context, ChangePasswordState currentState) {
          if(currentState is ChangePasswordSuccess){
            if(currentState.data.error!=1){
              WidgetsBinding.instance.addPostFrameCallback((_) {

                AlertMessage.showSuccess(
                    currentState.data.message ?? '', context);
              });
            }else{
              WidgetsBinding.instance.addPostFrameCallback((_) {

                AlertMessage.showError(
                    currentState.data.message ?? '', context);
              });
            }

          }
          return _buildUI();
        },
      )
    );
  }

  Widget _buildUI(){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( "${_localizations?.translate(AppStringConstant.yourpassword)}", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),),
                const SizedBox(height: AppSizes.size12,),
                CommonTextField(
                  maxLines: false,
                  maxLine: 1,
                  controller: oldpasswordController,
                  isRequired: true,
                  isPassword: true,
                  hintText: "Current Password",
                  validationType: AppStringConstant.password,
                  labelText: _localizations
                      ?.translate(AppStringConstant.newPassword) ??
                      '',
                  inputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: AppSizes.size16),
                CommonTextField(
                  maxLines: false,
                  maxLine: 1,
                  controller: passwordController,
                  isRequired: true,
                  isPassword: true,
                  hintText: "Password",
                  validationType: AppStringConstant.password,
                  labelText: _localizations
                      ?.translate(AppStringConstant.newPassword) ??
                      '',
                  inputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: AppSizes.size16),
                CommonTextField(
                  maxLines: false,
                  maxLine: 1,
                  labelText: _localizations?.translate(
                      AppStringConstant.confirmPassword) ??
                      "",
                  controller: confirmPasswordController,
                  isRequired: true,
                  isPassword: true,
                  hintText: "Password Confirm",
                  inputType: TextInputType.visiblePassword,
                  validationType: AppStringConstant.password,
                  validation: (value) {
                    if (confirmPasswordController.text !=
                        passwordController.text) {
                      return _localizations?.translate(
                          AppStringConstant.passwordNotMatch) ??
                          '';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: AppSizes.size16),
          
                commonButton(context, () async {
                 if( _formKey.currentState?.validate() == true){
                   _changePasswordBloc?.add(ChangePassword(oldpasswordController.text, passwordController.text));
                 }
                },
                    _localizations
                        ?.translate(AppStringConstant.save) ??
                        '',
                    backgroundColor: MobikulTheme.primaryColor,
                    textColor: Colors.white,
                    borderSideColor: AppColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
