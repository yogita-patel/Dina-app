import 'package:flutter/material.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/open_bottom_model_sheet_helper.dart';
import '../../../models/cart/cart_model.dart';

class GuestBottomSheet extends StatelessWidget {
 const  GuestBottomSheet(this.message, this.cart, {super.key});
   final String message;
 final Cart? cart;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.size8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSizes.size16),
              child: Text(
                (message.localized()),
                style:Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      signInSignUpBottomModalSheet(context, true, true);
                      //  Navigator.of(context).pushNamed(AppRoute.login,arguments: getSignInSignUpPageArgument(false,true));
                      //signup
                      /*  Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => SignupBloc(
                                  repository: SignupRepositoryImp(),
                                ),
                              )
                            ],
                            child: const Signup(guest: true,),
                          ),
                        ),
                      );*/
                    },

                    style: OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      side: const BorderSide(color: Colors.black),
                      // shape: const RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(AppSizes.size40 / 2),
                      // ),
                      minimumSize: Size(AppSizes.deviceWidth, AppSizes.size40),
                    ),
                    child: Text(AppStringConstant.signup.localized(),
                    style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                const SizedBox(width: AppSizes.size16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      signInSignUpBottomModalSheet(context, false, true);
                      // Navigator.of(context).pushNamed(AppRoute.login,arguments: getSignInSignUpPageArgument(true,false));
                      /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => SigninBloc(
                              repository: SigninRepositoryImp(),
                            ),
                            child: const Signin(),
                          ),
                        ),
                      );*/
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.black,
                      // shape: const RoundedRectangleBorder(
                      //   // borderRadius: BorderRadius.circular(AppSizes.size40 / 2),
                      // ),
                      minimumSize: Size(AppSizes.deviceWidth, AppSizes.size40),
                    ),
                    child: Text(AppStringConstant.login.localized(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).cardColor)),
                  ),
                )
              ],
            ),
            if (cart?.guestStatus == true && cart?.downloadStatus == 0)
              Container(
                margin:const EdgeInsets.only(bottom: AppSizes.size18),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoute
                        .guestCheckout /*,arguments: getGuestCheckoutArguments(false)*/);
                    //Navigator.pushNamed(context, );
                    /*Navigator.of(context).push(
                  */ /*  MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => SignupBloc(
                              repository: SignupRepositoryImp(),
                            ),
                          )
                        ],
                        child: const Signup(guest: true,),
                      ),
                    ),
                  );*/
                  },
                  style: OutlinedButton.styleFrom(
                    // shape: const RoundedRectangleBorder(
                    //
                    // ),

                    minimumSize: Size(AppSizes.deviceWidth, AppSizes.size40),
                  ),
                  child: Text(AppStringConstant.continueAsGuest.localized(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).cardColor)),
                ),
              )
          ],
        ),
      ),
    );
  }
}
