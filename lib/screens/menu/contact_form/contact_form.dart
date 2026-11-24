import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_outlined_button.dart';
import 'package:oc_demo/common_widgets/common_text_field.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/utils/helper.dart';
import 'package:oc_demo/utils/validator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../config/theme.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  AppLocalizations? _localizations;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  late FocusNode _emailFocusNode,
      _firstnameFocusNode,
      _telephoneFocusNode,
      _messageFocusNode;

  late GlobalKey<FormState> _formKey;
  String? emailErrorMessage;
  String? selectedId;
  bool _isSubmitting = false;

  void _validateForm() async {
    // Prevent multiple submissions
    if (_isSubmitting) return;

    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isSubmitting = true;
      });

      Helper.hideSoftKeyBoard();
      var wkToken = await AppSharedPref.getWkToken();

      try {
        final success = await ApiClient().contactUsForm(
          wkToken,
          _firstNameController.text,
          _emailController.text,
          _messageController.text,
        );

        if (success.error != 1) {
          AlertMessage.showSuccess(success.message ?? '', context);
          // Check if the widget is still mounted before popping
          if (mounted) {
            Navigator.pop(context);
          }
        }
      } finally {
        // Reset the flag after completion
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
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
    } else if (_messageController.text.isEmpty ||
        _messageController.text.length < 20) {
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
    _messageFocusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Social Links ${GlobalData.socialLink}");
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.contactForm) ?? "",
          context,
          isElevated: false),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.size16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    contactForm(),
                    const Divider(),
                    getAddressCard(),
                    const Divider(),
                    getContactCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contactForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: AppSizes.size8,
        ),
        CommonTextField(
          focusNode: _firstnameFocusNode,
          controller: _firstNameController,
          isRequired: true,
          isPassword: false,
          hintText:
          _localizations?.translate(AppStringConstant.firstName) ?? '',
          inputType: TextInputType.name,
        ),
        const SizedBox(height: AppSizes.size16),
        CommonTextField(
          focusNode: _emailFocusNode,
          controller: _emailController,
          isPassword: false,
          hintText:
          _localizations?.translate(AppStringConstant.emailAddress) ?? "",
          isRequired: true,
          inputType: TextInputType.emailAddress,
          validation: (value) {
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
          focusNode: _messageFocusNode,
          controller: _messageController,
          isPassword: false,
          hintText: _localizations?.translate(AppStringConstant.message) ?? "",
          isRequired: true,
          inputType: TextInputType.text,
          maxLine: 6,
          validation: (value) {
            final text = value?.trim() ?? '';

            if (text.length < 20) {
              return "Message must be at least 20 characters long";
            }

            // If you still want to validate it as an email (though it looks like a message box),
            // keep this check. Otherwise, you can remove it.

            return null;
          },
        ),
        const SizedBox(height: AppSizes.size30 + AppSizes.size16),
        commonButton(
          context,
          _validateForm,
          _localizations?.translate(AppStringConstant.submit) ?? "",
            backgroundColor: MobikulTheme.primaryColor,
            textColor: Colors.white
        ),
        const SizedBox(height: AppSizes.size16),
      ],
    );
  }

  Widget getContactCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.size20,
        vertical: AppSizes.size4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Follow us on Social Media',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.size12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: GlobalData.socialLink?.map((social) {
              Widget? iconWidget;

              // Match icon based on social name
              switch (social.name?.toLowerCase()) {
                case 'facebook':
                  iconWidget = socialIcon(AppImages.facebookIcons);
                  break;
                case 'instagram':
                  iconWidget = socialIcon(AppImages.instagramIcon);
                  break;
                case 'linkedin':
                  iconWidget = socialIcon(AppImages.linkdineIcon);
                  break;
                default:
                  iconWidget = null;
              }

              if (iconWidget == null) return const SizedBox();

              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                child: GestureDetector(
                  onTap: () async {
                    final url = social.url ?? "";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint('Could not launch $url');
                    }
                  },
                  child: iconWidget,
                ),
              );
            }).toList() ??
                [],
          ),
          const SizedBox(height: AppSizes.size20),
          contactRow(AppImages.timerIcon, GlobalData.getIntouch?.open),
          const SizedBox(height: AppSizes.size16),
          contactRow(AppImages.locationIcon, GlobalData.getIntouch?.address),
          const SizedBox(height: AppSizes.size16),
          contactRow(AppImages.callIcon, GlobalData.getIntouch?.telephone),
          const SizedBox(height: AppSizes.size16),
        ],
      ),
    );
  }

  Widget getAddressCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.size8,
        vertical: AppSizes.size4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Dina International Ltd - Import | Wholesale | Distribution | UK',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: AppSizes.size12),
          contactRow("", GlobalData.getIntouch?.address),
          const SizedBox(height: AppSizes.size14),
          viewGoogleMap('View on Google Map'),
          const SizedBox(height: AppSizes.size10),
        ],
      ),
    );
  }

  Widget socialIcon(String iconData) {
    return CircleAvatar(
        backgroundColor: const Color(0xFFFFD464),
        child: Image.asset(
          iconData,
          height: AppSizes.size40,
          width: AppSizes.size40,
        ));
  }

  Widget contactRow(String iconData, String? text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        iconData != ""
            ? Image.asset(
          iconData,
          height: AppSizes.size20,
          width: AppSizes.size20,
        )
            : const SizedBox(),
        const SizedBox(width: AppSizes.size12),
        Expanded(
          child: Text(
            text ?? "",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Widget addressRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Widget viewGoogleMap(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final url = Uri.parse(
                "https://www.google.com/maps/place/52%C2%B038'14.5%22N+1%C2%B007'13.3%22W/@52.637363,-1.1229419,17z/data=!3m1!4b1!4m4!3m3!8m2!3d52.637363!4d-1.120367?hl=en-gb&entry=ttu&g_ep=EgoyMDI1MDcwOS4wIKXMDSoASAFQAw%3D%3D");

            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          },
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: MobikulTheme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
