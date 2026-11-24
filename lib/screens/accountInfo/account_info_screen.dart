import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/models/accountInfoModel/account_info_model.dart';
import 'package:oc_demo/screens/accountInfo/bloc/account_info_events.dart';

import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_text_field.dart';
import '../../common_widgets/loader.dart';
import '../../config/theme.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_restart.dart';
import '../../helper/app_shared_pref.dart';
import '../../models/loginModel/login_model.dart';
import '../../utils/helper.dart';
import '../../utils/validator.dart';
import '../login_signup/view/load_custom_field.dart';
import '../../hive/hive_service.dart';
import '../../hive/hive_constant.dart';
import 'bloc/account_info_bloc.dart';
import 'bloc/account_info_state.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({super.key});

  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool changePassword = false;
  bool changeEmail = false;
  bool isLoading = false;
  bool isEmailVerified = false;
  String? emailErrorMessage;
  bool isCallfromDina = false;
  bool _isObscure = true;
  int? _selectedSectorId;
  String? _selectedSectorName;
  final _formKey = GlobalKey<FormState>();
  final _deleteDialogFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController telephoneController = TextEditingController();
  final TextEditingController _monthlySpendController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController deletePasswordController = TextEditingController();
  AppLocalizations? _localizations;
  AccountInfoBloc? _accountInfoBloc;
  AccountInfoModel? _accountInfoModel;
  late FocusNode _emailFocusNode,
      _lastnameFocusNode,
      _firstnameFocusNode,
      _telephoneFocusNode,
      _monthlySpendFocusNode;

  LoginModel? userDefaultData;
  var userEmail = "";
  Map<String, dynamic>? selectedInputOptions = {};
  final _customInputFormKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    AppSharedPref.getLoginUserData().then((value) => userDefaultData = value);
    _accountInfoBloc = context.read<AccountInfoBloc>();
    AppSharedPref.getWkToken()
        .then((value) => _accountInfoBloc?.add(AccountDetailEvent(value)));
    _emailFocusNode = FocusNode();
    _lastnameFocusNode = FocusNode();
    _firstnameFocusNode = FocusNode();
    _telephoneFocusNode = FocusNode();
    _monthlySpendFocusNode = FocusNode();
    super.initState();
  }

  void _validateForm() async {
    print('''
First Name: $selectedInputOptions
''');
    // Ensure selected sector is added to the custom account payload if user selected one
    if (_selectedSectorId != null) {
      selectedInputOptions ??= {};
      // Send only the sector id (as requested): e.g., "sector": 1
      selectedInputOptions!['sector'] = _selectedSectorId;
    }
    final Map<String, Map<String, dynamic>?> accountDetails = {
      "account": selectedInputOptions
    };
    final String customFieldJson = jsonEncode(accountDetails);
    // print("Type of business: $customFieldJson");
    // if (_customInputFormKey.currentState?.validate() ?? false) {
    //   print("Form Valide");
    //   // ✅ All fields valid
    //   print("Validated Data: $selectedInputOptions");
    // } else {
    //   print("Form Invalid");
    //   // ❌ Form invalid
    // }
    if (_formKey.currentState?.validate() == true) {
      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();
      var fcmToken = await AppSharedPref.getFcmToken();
      _accountInfoBloc?.add(SaveAccountInfoEvent(
          wkToken,
          firstNameController.text,
          lastNameController.text,
          changeEmail ? emailController.text : userDefaultData!.email ?? "",
          telephoneController.text,
          faxController.text,
          changePassword,
          changePassword ? passwordController.text : null,
          customFieldJson,
          _selectedSectorId != null ? _selectedSectorId.toString() : ""));
    } else {
      _focusErrorNode();
    }
  }

  void _focusErrorNode() {
    if (firstNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_firstnameFocusNode);
    } else if (lastNameController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_lastnameFocusNode);
    } else if (emailController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_emailFocusNode);
    } else if (telephoneController.text.isEmpty && emailErrorMessage != null) {
      FocusScope.of(context).requestFocus(_telephoneFocusNode);
    } else if (_monthlySpendController.text.isEmpty) {
      FocusScope.of(context).requestFocus(_monthlySpendFocusNode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountInfoBloc, AccountInfoState>(
      listener: (BuildContext context, AccountInfoState state) {
        // handle loading state
        if (state is AccountInfoLoadingState) {
          setState(() {
            isLoading = true;
          });
          return;
        }

        // any other state should stop loading
        setState(() {
          isLoading = false;
        });

        if (state is AccountInfoSuccessState) {
          final model = state.data;
          if (model.error == 0) {
            // update cached user defaults if present
            if (userDefaultData != null) {
              userDefaultData!.firstname = firstNameController.text;
              userDefaultData!.lastname = lastNameController.text;
              userDefaultData!.email = emailController.text;
              userDefaultData!.phone = telephoneController.text;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(model.message ?? "", context);
              Navigator.of(context).pop();
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(model.message ?? "", context);
            });
          }
        } else if (state is AccountDetailSuccessState) {
          // populate form fields and selected sector based on payload
          _accountInfoModel = state.data;
          print("qdada--${(_accountInfoModel?.customField?[0].toJson())}");
          if (_accountInfoModel?.error == null) {
            setState(() {
              firstNameController.text = _accountInfoModel?.firstname ?? "";
              lastNameController.text = _accountInfoModel?.lastname ?? "";
              emailController.text = _accountInfoModel?.email ?? "";
              telephoneController.text = _accountInfoModel?.telephone ?? "";
              faxController.text = _accountInfoModel?.fax ?? "";
              userEmail = _accountInfoModel?.email ?? "";
              // Initialize selected sector only if API provided a non-zero id that matches an option
              final sector = _accountInfoModel?.sector;
              final selId = sector?.selectedSector ?? 0;
              if (selId != 0) {
                final opts = sector?.options ?? <SectorOption>[];
                final match = opts.firstWhere((o) => o.id == selId,
                    orElse: () => SectorOption(id: null, name: null));
                if (match.id != null) {
                  _selectedSectorId = match.id;
                  _selectedSectorName = match.name;
                }
              }
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(_accountInfoModel?.message ?? "", context);
            });
          }
        } else if (state is LoginState) {
          final loginModel = state.data;
          if (loginModel.error != 1) {
            _accountInfoBloc?.add(const DeleteAccountEvent());
            _accountInfoBloc?.emit(AccountInfoLoadingState());
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(loginModel.message ?? "", context);
            });
          }
        } else if (state is DeleteAccountState) {
          if (state.data.error == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              AlertMessage.showSuccess(state.data.message ?? "", context);
              HiveService.getHive().deleteBox(HiveConstant.getAddress);
              await AppSharedPref.logoutUser();
              BottomTabController.check.countController?.sink.add(0);
              // BottomTabController.check.updateLoginStreamController.sink
              //     .add(false);
              AppRestart.rebirth(context);
            });
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(state.data.message ?? "", context);
            });
          }
        } else if (state is AccountInfoErrorState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(state.message, context);
          });
        }
      },
      child: BlocBuilder<AccountInfoBloc, AccountInfoState>(
        builder: (BuildContext context, AccountInfoState currentState) {
          // Keep builder pure: UI rendering only, no setState calls
          return _buildUI();
        },
      ),
    );
  }

  Widget _buildUI() {
    return Scaffold(
      appBar: commonAppBar(
          _localizations?.translate(AppStringConstant.accountInfo) ?? '',
          context),
      body: Stack(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: AppSizes.size8,
                        ),
                        Text(
                          "${_localizations?.translate(AppStringConstant.yourpersonaldetails)}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: AppSizes.size16,
                        ),
                        CommonTextField(
                          focusNode: _firstnameFocusNode,
                          controller: firstNameController,
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
                          controller: lastNameController,
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
                          controller: emailController,
                          isPassword: false,
                          hintText: _localizations
                                  ?.translate(AppStringConstant.emailAddress) ??
                              "",
                          isRequired: true,
                          inputType: TextInputType.text,
                          validation: (value) {
                            return Validator.isEmailValid(value ?? '', context);
                          },
                          onChange: (value) async {
                            if (Validator.isEmailValid(value, context) ==
                                null) {
                              var wkToken = await AppSharedPref.getWkToken();
                              // bloc?.add(CheckEmailEvent(value, wkToken));
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
                          controller: telephoneController,
                          isPassword: false,
                          hintText: _localizations
                                  ?.translate(AppStringConstant.telephone) ??
                              "",
                          isRequired: true,
                          inputType: TextInputType.phone,
                        ),
                        const SizedBox(height: AppSizes.size8),
                        // Text(
                        //     ( _localizations
                        //         ?.translate(AppStringConstant.typeofbusiness) ??
                        //         "" ?? '') +
                        //         ((true) ? "*":""),
                        //     style:Theme.of(context).textTheme.titleLarge?.copyWith(
                        //       fontWeight: FontWeight.w400,
                        //     )
                        // ),
                        // const SizedBox(height: AppSizes.size8),
                        // CommonDropdownWidget(
                        //   items: List<String>.generate(5, (index) => '${index + 1}'), // ['1', '2', '3', '4', '5']
                        //   hint:  _localizations
                        //       ?.translate(AppStringConstant.pleaseselect) ??
                        //       "",
                        //   isRequired: true,
                        //   onChanged: (value) {
                        //     print("Selected value: $value");
                        //   },
                        // ),
                        // const SizedBox(height: AppSizes.size16),
                        // CommonTextField(
                        //   focusNode: _monthlySpendFocusNode,
                        //   controller: _monthlySpendController,
                        //   isPassword: false,
                        //   hintText: _localizations
                        //       ?.translate(AppStringConstant.monthlySpend) ??
                        //       "",
                        //   isRequired: false,
                        //   inputType: TextInputType.text,
                        // ),
                        // const SizedBox(height: AppSizes.size16),
                        // Text(
                        //     ( _localizations
                        //         ?.translate(AppStringConstant.howyoufoundus) ??
                        //         "" ?? '') +
                        //         ((true) ? "*":""),
                        //     style:Theme.of(context).textTheme.titleLarge?.copyWith(
                        //       fontWeight: FontWeight.w400,
                        //     )
                        // ),
                        // const SizedBox(height: AppSizes.size8),
                        // CommonDropdownWidget(
                        //   items: List<String>.generate(5, (index) => '${index + 1}'), // ['1', '2', '3', '4', '5']
                        //   hint:  _localizations
                        //       ?.translate(AppStringConstant.pleaseselect) ??
                        //       "",
                        //   isRequired: true,
                        //   onChanged: (value) {
                        //     print("Selected value: $value");
                        //   },
                        // ),
                        // const SizedBox(height: AppSizes.size16),
                        // Text(
                        //     ( _localizations
                        //         ?.translate(AppStringConstant.whichCategory) ??
                        //         "" ?? '') +
                        //         ((true) ? "*":""),
                        //     style:Theme.of(context).textTheme.titleLarge?.copyWith(
                        //       fontWeight: FontWeight.w400,
                        //     )
                        // ),
                        // const SizedBox(height: AppSizes.size8),
                        // CommonDropdownWidget(
                        //   items: List<String>.generate(5, (index) => '${index + 1}'), // ['1', '2', '3', '4', '5']
                        //   hint:  _localizations
                        //       ?.translate(AppStringConstant.pleaseselect) ??
                        //       "",
                        //   isRequired: true,
                        //   onChanged: (value) {
                        //     print("Selected value: $value");
                        //   },
                        // ),
                        // const SizedBox(height: AppSizes.size16),
                        // CustomCheckbox(
                        //       (value) {
                        //     isCallfromDina = value;
                        //   },
                        //   _localizations
                        //       ?.translate(AppStringConstant.callFromDina),
                        // ),
                        (_accountInfoModel?.customField != null)
                            ? Form(
                                key: _customInputFormKey,
                                child: LoadCustomInputField(
                                    options: _accountInfoModel?.customField,
                                    inputOptionsSelectedByUser:
                                        (Map<String, dynamic> map) {
                                      setState(() {
                                        selectedInputOptions = map;
                                      });
                                    }),
                              )
                            : const SizedBox(),
                        if (_accountInfoModel?.sector != null) ...[
                          const SizedBox(height: AppSizes.size8),
                          Text(_accountInfoModel?.sector?.fieldname ?? 'Select',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  )),
                          const SizedBox(height: AppSizes.size8),
                          Builder(builder: (context) {
                            // create a local non-nullable list for convenience
                            final options =
                                _accountInfoModel?.sector?.options ??
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
                                  final opt = options.firstWhere(
                                      (o) => o.id == val,
                                      orElse: () =>
                                          SectorOption(id: val, name: ''));
                                  setState(() {
                                    _selectedSectorId = val;
                                    _selectedSectorName = opt.name;
                                  });
                                },
                                hint: Text(
                                  _accountInfoModel?.sector?.fieldname ?? '',
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
                        const SizedBox(height: AppSizes.size30),
                        commonButton(
                          context,
                          _validateForm,
                          _localizations?.translate(AppStringConstant.save) ??
                              "",
                            backgroundColor: MobikulTheme.primaryColor,
                            textColor: Colors.white
                        ),
                        const SizedBox(height: AppSizes.size30),
                        commonButton(
                          context,
                          backgroundColor:AppColors.red,
                          textColor: Colors.white,
                          () {
                            displayPasswordAuthenticationDialog(context);
                          },
                          _localizations?.translate(
                                  AppStringConstant.deleteAccount) ??
                              "",
                        ),
                        const SizedBox(height: AppSizes.size30 * 2),
                      ],
                    )),
              ],
            ),
          ),
        ),
        Visibility(visible: isLoading, child: const Loader())
      ]),
    );
  }

  Future<void> displayPasswordAuthenticationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      _localizations
                              ?.translate(AppStringConstant.deleteAccount) ??
                          "",
                      style: const TextStyle(fontWeight: FontWeight.w700),
                      // maxLines: 4,
                    ),
                  ),
                  Text(
                    _localizations?.translate(AppStringConstant
                            .pleaseEnterPasswordToDeleteAccount) ??
                        "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: AppSizes.size14),
                  ),
                  Text(
                    _localizations?.translate(AppStringConstant
                            .pleaseEnterPasswordToDeleteAccount2) ??
                        "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: AppSizes.size14),
                  )
                  // Html(
                  //   data: "${_localizations?.translate(AppStringConstant
                  //       .pleaseEnterPasswordToDeleteAccount) ?? "" }" +
                  //       userEmail+" "+"${_localizations?.translate(AppStringConstant
                  //       .pleaseEnterPasswordToDeleteAccount2) ?? "" }",
                  //   // maxLines: 4,
                  // ),
                ],
              ),
              content: Form(
                  key: _deleteDialogFormKey,
                  child: TextFormField(
                      controller: deletePasswordController,
                      obscureText: _isObscure,
                      decoration: formFieldDecoration(
                          context,
                          "",
                          _localizations
                                  ?.translate(AppStringConstant.password) ??
                              "",
                          isRequired: true,
                          suffix: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: suffixIconColor(context),
                              ),
                              onPressed: () => setState(
                                    () {
                                      _isObscure = !_isObscure;
                                    },
                                  ))),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        return (deletePasswordController.text.isNotEmpty)
                            ? null
                            : (_localizations
                                    ?.translate(AppStringConstant.required) ??
                                "");
                      })),
              actions: <Widget>[
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.red,
                      ),
                      backgroundColor: AppColors.red),
                  child: Text(
                    _localizations?.translate(AppStringConstant.cancel) ??
                        "Cancel",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    if (_deleteDialogFormKey.currentState?.validate() ==
                        true /*deletePasswordController.text.isNotEmpty==true*/) {
                      _accountInfoBloc?.add(LoginEvent(
                          userEmail,
                          deletePasswordController.text,
                          "",
                          await AppSharedPref.getWkToken()));
                      _accountInfoBloc?.emit(AccountInfoLoadingState());
                      Navigator.pop(context);
                    }

                    /* if (userDefaultData!.email?.isNotEmpty == true && userDefaultData!.email != "demo@webkul.com") {
                        DialogHelper.confirmationDialog(
                            AppStringConstant.deleteAccount, context, _localizations,
                            onConfirm: () async {
                              var wkToken = await AppSharedPref.getWkToken();
                              await ApiClient().deleteUser(wkToken).then((value) async {
                                if (value.message?.isNotEmpty == true)
                                  AlertMessage.showSuccess(value.message ?? '', context);
                                if (value.error == 0) {
                                  await AppSharedPref.logoutUser();
                                  Navigator.of(context).pushNamed(AppRoute.bottomTabBAr);
                                } else {
                                  //show error message
                                  AlertMessage.showError( _localizations?.translate(AppStringConstant.accountCannotbeDeleted)??"", context);
                                }
                              });

                            });
                      } else {
                        AlertMessage.showError( _localizations?.translate(AppStringConstant.youAreNotAuthriseToDeleteAccount)??"", context);
                        // show authrosize warnign message
                      }*/
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.red,
                      ),
                      backgroundColor: AppColors.red),
                  child: Text(
                    _localizations
                            ?.translate(AppStringConstant.deleteAccount) ??
                        "Delete Account",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                )
                /*  TextButton(

                    child: Text('CANCEL'),
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                  ),*/
                /*  TextButton(

                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        //codeDialog = valueText;
                        Navigator.pop(context);
                      });
                    },
                  ),*/
              ],
            );
          });
        });
  }
}
