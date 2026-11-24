import 'package:flutter/material.dart';

import '../../../common_widgets/common_outlined_button.dart';
import '../../../config/theme.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';

class LoggedOutHeader extends StatefulWidget {
  const LoggedOutHeader({super.key});

  @override
  State<LoggedOutHeader> createState() => _LoggedOutHeaderState();
}

class _LoggedOutHeaderState extends State<LoggedOutHeader> {
  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Text(
              "${_localizations?.translate(AppStringConstant.welcomeToDina)}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                letterSpacing: 0.2,
                height: 1.2,
              )),
        ),
        const SizedBox(height: 15,),
        commonButton(
          context,
          (){
            // Navigator.pop(context);
            signInSignUpBottomModalSheet(context, true, false);
          },
          (_localizations?.translate(AppStringConstant.register) ??
              ""),
            backgroundColor: MobikulTheme.accentColor,
            textColor: MobikulTheme.primaryColor
        ),
        const SizedBox(height: 15,),
        commonButton(
          context,
              (){
                Navigator.of(context).pushNamed(AppRoute.login,
                    arguments: getSignInSignUpPageArgument(false, false));
              },
          (_localizations?.translate(AppStringConstant.signIn) ??
              ""),
              backgroundColor: MobikulTheme.primaryColor,
            textColor: Colors.white
            //textColor: MobikulTheme.primaryColor
        ),
      ],),
    );
  }
}
