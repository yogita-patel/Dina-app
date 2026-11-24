import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/models/registerAccountModel/register_account_model.dart';
import 'package:oc_demo/utils/validator.dart';
import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/common_text_field.dart';
import '../../../common_widgets/loader.dart';
import '../../../common_widgets/privacy_policy_checkbox_widget.dart';
import '../../../common_widgets/remember_me_custom_checkbox.dart';
import '../../../config/theme.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../utils/helper.dart';
import '../../login_signup/bloc/signin_signup_screen_bloc.dart';
import 'load_custom_field.dart';

class CreateAnAccount extends StatefulWidget {
  const CreateAnAccount(this.isComingFromCartPage, {super.key});
  final bool isComingFromCartPage;

  @override
  _CreateAnAccountState createState() => _CreateAnAccountState();
}

class _CreateAnAccountState extends State<CreateAnAccount> {
  SigninSignupScreenBloc? bloc;
  RegisterAccountModel? registerDataModel;
  Map<String, dynamic>? selectedInputOptions;
  int? _selectedSectorId;
  String? _selectedSectorName;
  final _customInputFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _monthlySpendController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postCodeController = TextEditingController();
  late FocusNode _emailFocusNode,
      _passwordFocusNode,
      _lastnameFocusNode,
      _confirmPasswordFocusNode,
      _firstnameFocusNode,
      _telephoneFocusNode,
      _shopNameFocusNode,
      _companyFocusNode,
      _address1FocusNode,
      _address2FocusNode,
      _cityFocusNode,
      _postCodeFocusNode,
      _monthlySpendFocusNode;

  late AppLocalizations? _localizations;
  late bool _loading;
  String isNewsletter = "0";
  bool isPrivacyAccepted = false;
  bool toBecomeSellerSelected = false;
  bool isCallfromDina = false;
  late GlobalKey<FormState> _formKey;
  String? emailErrorMessage;
  String? selectedId;
  // CountryData? filterCountry;
  String? _selectedCountry;
  String? _selectedCountryName;

  String? _selectedZone;
  String? _selectedZoneName;
  String? _default;

  CountryData? selectedCountry;
  bool showState = false;

  void _validateForm() async {
    print('''
First Name: ${_firstNameController.text}
Last Name: ${_lastNameController.text}
Email: ${_emailController.text}
Telephone: ${_telephoneController.text}
Password: ${_passwordController.text}
Newsletter: $isNewsletter
Privacy Accepted: ${isPrivacyAccepted ? "1" : "0"}
Become Seller: ${toBecomeSellerSelected ? "1" : "0"}
Shop Name: ${_shopNameController.text}
Company: ${_companyController.text}
Address 1: ${_address1Controller.text}
Address 2: ${_address2Controller.text}
City: ${_cityController.text}
Postcode: ${_postCodeController.text}
Country: $_selectedCountry
Zone: $_selectedZone
''');

    // Prepare account map (merge selected custom inputs and optional sector)
    final Map<String, dynamic> accountMap = selectedInputOptions != null
        ? Map<String, dynamic>.from(selectedInputOptions!)
        : <String, dynamic>{};

    // We must send sector as a simple id (e.g. "sector": 1) in the saved
    // custom_field payload. Prefer the explicit dropdown selection (_selectedSectorId).
    if (_selectedSectorId != null) {
      accountMap['sector'] = _selectedSectorId;
    } else if (accountMap.containsKey('sector')) {
      // If LoadCustomInputField already put a nested sector object, normalize it
      final existing = accountMap['sector'];
      if (existing is Map && existing['id'] != null) {
        accountMap['sector'] = existing['id'];
      } else if (existing is String) {
        final parsed = int.tryParse(existing);
        if (parsed != null) accountMap['sector'] = parsed;
      }
    }

    final Map<String, dynamic> accountDetails = {
      'account': accountMap,
    };
    final String customFieldJson = jsonEncode(accountDetails);
    print("Type of business: $customFieldJson");
    if (_customInputFormKey.currentState?.validate() ?? false) {
      print("Form Valide");
      // ✅ All fields valid
      print("Validated Data: $selectedInputOptions");
    } else {
      print("Form Invalid");
      // ❌ Form invalid
    }
    if (_formKey.currentState?.validate() == true &&
        _customInputFormKey.currentState?.validate() == true) {
      TextInput.finishAutofillContext();
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      if (!isPrivacyAccepted) {
        AlertMessage.showError(
            _localizations?.translate(AppStringConstant.privacyError) ?? "",
            context);
      } else {
        AppSharedPref.setLastLoginCredentials(
            _emailController.text.trim(), _passwordController.text);
        bloc?.add(SignUpEvent(
          wkToken,
          "0",
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          _telephoneController.text,
          _passwordController.text,
          isNewsletter,
          isPrivacyAccepted ? "1" : "0",
          toBecomeSellerSelected ? "1" : "0",
          _shopNameController.text,
          fcmToken,
          _companyController.text,
          _address1Controller.text,
          _address2Controller.text,
          _postCodeController.text,
          _cityController.text,
          _selectedCountry,
          _selectedZone,
          customFieldJson,
          _selectedSectorId?.toString(),
        ));
        bloc?.emit(LoadingState());
      }
    } else {
      _focusErrorNode();
    }
  }

  void _focusErrorNode() {
    if (_firstNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_firstnameFocusNode);
    } else if (_lastNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_lastnameFocusNode);
    } else if (_emailController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    } else if (_telephoneController.text.isEmpty && emailErrorMessage != null) {
      FocusScope.of(context).requestFocus(_telephoneFocusNode);
    } else if (_passwordController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_passwordFocusNode);
    } else if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text != _passwordController.text) {
      FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
    } else if (toBecomeSellerSelected && _shopNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_shopNameFocusNode);
    } else if (_monthlySpendController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_monthlySpendFocusNode);
    } else if (_companyController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_companyFocusNode);
    } else if (_address1Controller.text.isEmpty) {
      FocusScope.of(context).requestFocus(_address1FocusNode);
    } else if (_address2Controller.text.isEmpty) {
      FocusScope.of(context).requestFocus(_address2FocusNode);
    } else if (_postCodeController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_postCodeFocusNode);
    } else if (_cityController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_cityFocusNode);
    }
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _loading = true;
    _formKey = GlobalKey();
    bloc = context.read<SigninSignupScreenBloc>();
    AppSharedPref.getWkToken()
        .then((value) => bloc?.add(GetRegisterDataEvent(value)));

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _lastnameFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
    _firstnameFocusNode = FocusNode();
    _telephoneFocusNode = FocusNode();
    _shopNameFocusNode = FocusNode();
    _monthlySpendFocusNode = FocusNode();
    _companyFocusNode = FocusNode();
    _address1FocusNode = FocusNode();
    _address2FocusNode = FocusNode();
    _postCodeFocusNode = FocusNode();
    _cityFocusNode = FocusNode();
    _selectedCountryName = "";
    _selectedZoneName = "";
    // For United Kingdom
    _selectedCountry = "222";
    _selectedZone = "3513";
    _default = "0";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SigninSignupScreenBloc, SigninSignupScreenState>(
      builder: (context, state) {
        if (state is LoadingState) {
          _loading = true;
        } else if (state is SigninSignupScreenError) {
          _loading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(state.message ?? "", context);
          });
        } else if (state is RegisterDataSuccess) {
          registerDataModel = state.model;
          print(
              "RIshabh register Data Model ${registerDataModel?.customField?[0].type}");
          _loading = false;
        } else if (state is CheckEmailStateSuccess) {
          emailErrorMessage = null;
        } else if (state is CheckEmailStateError) {
          emailErrorMessage =
              _localizations?.translate(AppStringConstant.emailAlreadyExist) ??
                  "Email Already Exist";
        } else if (state is SignupScreenFormSuccess) {
          _loading = false;
          var model = state.data;
          print("pankaj , ${model.firstname},${model.lastname},${model.email}");
          // AppSharedPref.setLoginUserData(model);
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            AlertMessage.showWarning(state.data.message ?? "", context,
                duration: const Duration(seconds: 5));
            Navigator.of(context).pushReplacementNamed(AppRoute.login,
                arguments: getSignInSignUpPageArgument(
                    widget.isComingFromCartPage, false));
            // if (widget.isComingFromCartPage == true) {
            //   Navigator.pushNamedAndRemoveUntil(
            //       context, AppRoute.cart, (route) => false);
            // } else {
            //   Navigator.pushNamedAndRemoveUntil(
            //       context, AppRoute.bottomTabBAr, (route) => false);
            // }
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
    print("RIshabhb ${registerDataModel?.customField?.length}");
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.createAnAccount) ?? "",
          context,
          isLeadingEnable: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.size16),
          child: AutofillGroup(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: AppSizes.size8,
                    ),
                    Text(
                      "${_localizations?.translate(AppStringConstant.yourpersonaldetails)}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: AppSizes.size8,
                    ),
                    // Text( "${_localizations?.translate(AppStringConstant.alreadyHaveAccount)}",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    //   fontWeight: FontWeight.w400,
                    //   fontSize: 12
                    // ),
                    // maxLines: 2,
                    // overflow: TextOverflow.ellipsis,),
                    Text.rich(
                      TextSpan(
                        text:
                            "${_localizations?.translate(AppStringConstant.alreadyHaveAccount)}",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: ' Login Page',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context)
                                  .pushReplacementNamed(AppRoute.login,
                                      arguments: getSignInSignUpPageArgument(
                                          widget.isComingFromCartPage, false)),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: const Color(0xFF0D479C)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: AppSizes.size16,
                    ),
                    CommonTextField(
                      focusNode: _firstnameFocusNode,
                      controller: _firstNameController,
                      isRequired: true,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.firstName) ??
                          '',
                      inputType: TextInputType.name,
                    ),

                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      focusNode: _lastnameFocusNode,
                      controller: _lastNameController,
                      isRequired: true,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.lastName) ??
                          '',
                      inputType: TextInputType.name,
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
                      autofillHints: const [AutofillHints.email],
                      validation: (value) {
                        return Validator.isEmailValid(value ?? '', context);
                      },
                      onChange: (value) async {
                        if (Validator.isEmailValid(value, context) == null) {
                          var wkToken = await AppSharedPref.getWkToken();
                          bloc?.add(CheckEmailEvent(value, wkToken));
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
                      focusNode: _telephoneFocusNode,
                      controller: _telephoneController,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.telephone) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSizes.size8),

                    ///Custom Option UI
                    registerDataModel?.customField != null
                        ? Form(
                            key: _customInputFormKey,
                            child: LoadCustomInputField(
                                options: registerDataModel?.customField,
                                inputOptionsSelectedByUser:
                                    (Map<String, dynamic> map) {
                                  setState(() {
                                    selectedInputOptions = map;
                                  });
                                }),
                          )
                        : const SizedBox(),

                    // Sector dropdown (appears under custom fields)
                    if (registerDataModel?.sector != null) ...[
                      const SizedBox(height: AppSizes.size8),
                      Text(registerDataModel?.sector?.fieldname ?? 'Select',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                      const SizedBox(height: AppSizes.size8),
                      Builder(builder: (context) {
                        // create a local non-nullable list for convenience
                        final options = registerDataModel?.sector?.options ??
                            <SectorOption>[];
                        return DropdownButtonHideUnderline(
                          child: DropdownButtonFormField<int>(
                            value: _selectedSectorId,
                            decoration: formFieldDecoration(
                              context,
                              "",
                              "",
                              isRequired: false,
                            ).copyWith(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: AppSizes.size12,
                                horizontal: AppSizes.size12,
                              ),
                            ),
                            dropdownColor: Theme.of(context).cardColor,
                            isExpanded: true,
                            items: options
                                .map((opt) => DropdownMenuItem<int>(
                                      value: opt.id,
                                      child: Text(opt.name ?? ''),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val == null) {
                                setState(() {
                                  _selectedSectorId = null;
                                  _selectedSectorName = null;
                                });
                                return;
                              }
                              final opt = options.firstWhere((o) => o.id == val,
                                  orElse: () =>
                                      SectorOption(id: val, name: ''));
                              setState(() {
                                _selectedSectorId = val;
                                _selectedSectorName = opt.name;
                              });
                            },
                            hint: Text(
                              registerDataModel?.sector?.fieldname ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey,
                                  ),
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        );
                      }),
                      const SizedBox(height: AppSizes.size12),
                    ],

                    Text(
                      "${_localizations?.translate(AppStringConstant.youraddress)}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(
                      height: AppSizes.size16,
                    ),

                    CommonTextField(
                      focusNode: _companyFocusNode,
                      controller: _companyController,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.company) ??
                          "",
                      isRequired: false,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      focusNode: _address1FocusNode,
                      controller: _address1Controller,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.address1) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      focusNode: _address2FocusNode,
                      controller: _address2Controller,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.address2) ??
                          "",
                      isRequired: false,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      focusNode: _cityFocusNode,
                      controller: _cityController,
                      isPassword: false,
                      hintText:
                          _localizations?.translate(AppStringConstant.city) ??
                              "",
                      isRequired: true,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      focusNode: _postCodeFocusNode,
                      controller: _postCodeController,
                      isPassword: false,
                      hintText: _localizations
                              ?.translate(AppStringConstant.postCode) ??
                          "",
                      isRequired: true,
                      inputType: TextInputType.text,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    countryAndStateSpinner(registerDataModel?.countryData),
                    const SizedBox(height: AppSizes.size16 + AppSizes.size16),
                    Text(
                      "${_localizations?.translate(AppStringConstant.yourpassword)}",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      maxLines: false,
                      maxLine: 1,
                      focusNode: _passwordFocusNode,
                      hintText: _localizations
                              ?.translate(AppStringConstant.password) ??
                          "",
                      controller: _passwordController,
                      isRequired: true,
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.password],
                      validationType: AppStringConstant.password,
                    ),
                    const SizedBox(height: AppSizes.size16),
                    CommonTextField(
                      maxLines: false,
                      maxLine: 1,
                      focusNode: _confirmPasswordFocusNode,
                      hintText: _localizations
                              ?.translate(AppStringConstant.confirmPassword) ??
                          "",
                      controller: _confirmPasswordController,
                      isRequired: true,
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                      validation: (value) {
                        if (_confirmPasswordController.text !=
                            _passwordController.text) {
                          return _localizations?.translate(
                                  AppStringConstant.passwordMismatch) ??
                              '';
                        } else {
                          return null;
                        }
                      },
                    ),

                    const SizedBox(height: AppSizes.size16),
                    CustomCheckbox((value) {
                      value ? isNewsletter = "1" : isNewsletter = "0";
                    },
                        _localizations
                            ?.translate(AppStringConstant.isNewsletters),
                        false),

                    const SizedBox(height: AppSizes.size16),
                    PrivacyPolicyCustomCheckbox(
                      (value) {
                        isPrivacyAccepted = value;
                      },
                      _localizations
                          ?.translate(AppStringConstant.privacyPolicyTitle),
                      registerDataModel?.agreeInfo?.data?.description,
                    ),
                    const SizedBox(height: AppSizes.size16 + AppSizes.size16),
                    commonButton(
                      context,
                      _validateForm,
                      _localizations?.translate(AppStringConstant.continues) ??
                          "",
                        backgroundColor: MobikulTheme.primaryColor,
                        textColor: Colors.white
                    ),

                    const SizedBox(height: AppSizes.size16),

                    const SizedBox(height: AppSizes.size16 * 4),
                    Text.rich(
                      TextSpan(
                        text:
                            "Already registered and can't log in to your Trade Account? ",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                            text: 'Reactivate Account',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).pushNamed(
                                    AppRoute.reActivateAccount,
                                    arguments: {},
                                  ),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: const Color(0xFF0D479C)),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSizes.size16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget countryAndStateSpinner(List<CountryData?>? countryData) {
    CountryData? selectedCountry;
    selectedCountry = getCountryById(_selectedCountry);
    bool showState = true;
    // if (selected != null) {
    //   selectedCountry = selected;
    //   if (selected.zone?.isEmpty == false) {
    //     showState = true;
    //   } else {
    //     showState = false;
    //   }
    // }
    return StatefulBuilder(
      builder: (context, setState) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                AppStringConstant.country.localized(),
                style: const TextStyle(color: AppColors.black),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.size8),
          SizedBox(
            // height: 58,
            child: DropdownButtonFormField<CountryData>(
              value: selectedCountry,
              isExpanded: true,
              decoration: formFieldDecoration(
                context,
                "",
                "",
                isRequired: true,
              ).copyWith(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: AppSizes.size12, // Adjust this value for height
                  horizontal: AppSizes.size12,
                ),
              ),
              iconEnabledColor: Colors.black,
              hint: Text(
                AppStringConstant.country.localized(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.normal, color: AppColors.darkGray),
              ),
              items: countryData
                  ?.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e?.name ?? "",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                )),
                      ))
                  .toList(),
              onChanged: (value) {
                selectedCountry = value;
                _selectedCountry = value?.countryId;
                _selectedCountryName = value?.name;

                // ✅ Set default zone only when country changes
                if (value?.zone?.isNotEmpty == true) {
                  _selectedZone = value!.zone!.first.zone_id;
                  _selectedZoneName = value.zone!.first.name;
                  showState = true;
                } else {
                  _selectedZone = null;
                  showState = false;
                }

                setState(() {});
              },
            ),
          ),
          const SizedBox(height: AppSizes.size8),
          if (showState)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppStringConstant.state.localized(),
                  style: const TextStyle(color: AppColors.black),
                ),
              ],
            ),
          if (showState) const SizedBox(height: AppSizes.size8),
          if (showState)
            SizedBox(
              // height: 58,
              child: DropdownButtonFormField<Zone>(
                value: selectedCountry?.zone
                            ?.any((zone) => zone.zone_id == _selectedZone) ==
                        true
                    ? selectedCountry!.zone!
                        .firstWhere((zone) => zone.zone_id == _selectedZone)
                    : null,
                isExpanded: true,
                decoration: formFieldDecoration(
                  context,
                  "",
                  "",
                  isRequired: true,
                ),
                items: selectedCountry?.zone
                    ?.map((e) => DropdownMenuItem<Zone>(
                          value: e,
                          child: Text(e.name ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  )),
                        ))
                    .toList(),
                onChanged: (value) {
                  _selectedZone = value?.zone_id; // ✅ id store
                  _selectedZoneName = value?.name;

                  setState(() {});
                },
              ),
            ),
        ],
      ),
    );
  }

  CountryData? getCountryById(String? id) {
    for (var country in (registerDataModel?.countryData ?? <CountryData?>[])) {
      if (country?.countryId == id) {
        return country;
      }
    }

    return registerDataModel?.countryData?.isNotEmpty == true
        ? registerDataModel?.countryData?.first
        : null;
  }
}
