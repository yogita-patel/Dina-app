import 'package:flutter/material.dart';
import 'package:oc_demo/helper/app_localizations.dart';

import '../constants/app_constants.dart';
import '../constants/app_routes.dart';
import '../constants/app_string_constant.dart';
import '../constants/arguments_map.dart';
import '../helper/app_shared_pref.dart';
import 'dialog_helper.dart';


AppBar commonAppBar(String heading, BuildContext context,
    {bool isHomeEnable = false,
      bool isHomeHeadingEnable = true,
      bool isDividerEnable = true,
    bool isElevated = true,
    bool isLeadingEnable = false,
    List<Widget>? actions,
    bool hideSearch = false,
    bool hideNotification = false,
    bool hideCart = false,
    bool isCart = false,
    bool hideAll = false,
      crossIcon = true,
    VoidCallback? onPressed}) {
  if (hideAll) {
    hideCart = true;
    hideNotification = true;
    hideSearch = true;

  }
  AppLocalizations? localizations;
  Widget setAppLogoWidget() {
    return (Theme.of(context).brightness == Brightness.dark &&
            mAppStoragePref.getDarkThemeLogo().isNotEmpty)
        ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                mAppStoragePref.getDarkThemeLogo(),
              ),
              fit: BoxFit.fitWidth,
            )),
          )
        : (Theme.of(context).brightness == Brightness.light &&
                mAppStoragePref.getLightThemeLogo().isNotEmpty)
            ? Container(
                decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(9.0),
                    image: DecorationImage(
                  //  image: AssetImage("assets/images/ic_launcher.png"),
                  image: NetworkImage(
                    mAppStoragePref.getLightThemeLogo(),
                  ),
                  fit: BoxFit.fitWidth,
                )),
              )
            : Image.asset(
                "assets/images/app_logo.png", // Local fallback image
                fit: BoxFit.fitWidth,
              );
  }

  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    titleSpacing: 4,
    scrolledUnderElevation: 0,
    automaticallyImplyLeading: false,
    leading: isHomeEnable
        ? Padding(
      padding: const EdgeInsets.only(left: 4.0,bottom: 4.0),
      child: SizedBox(
        height: AppBar().preferredSize.height / 2,
        child: setAppLogoWidget(),
      ),
    )
        : isLeadingEnable
            ? const SizedBox()
            :  GestureDetector(onTap: (){Navigator.pop(context);},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
          child: Image.asset(AppImages.backArrow,color: Theme.of(context).iconTheme.color),
        )),
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        // if (isHomeEnable)
        //   if (isHomeEnable ?? false)
        //     Container(
        //       height: AppBar().preferredSize.height / 2,
        //       width: AppBar().preferredSize.height / 2,
        //       child: setAppLogoWidget(),
        //     ),
        if (isHomeHeadingEnable)
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isHomeEnable ? AppSizes.size8 : 0),
            child: SizedBox(
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.only(right: isHomeEnable?AppSizes.size0:AppSizes.size45),
                  child: Text(
                    heading,
                     style: Theme.of(context).textTheme.displaySmall,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hideSearch)
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(AppRoute.searchScreen);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.searchBackGroundColor, // Light grey background
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppLocalizations.of(context)?.translate(AppStringConstant.search) ?? '',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.searchText,)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.size2),
                        child: Icon(
                          Icons.search_rounded,
                          color: AppColors.searchText,
                          size: AppSizes.size16,
                        ),
                      ),
                      Padding(
                         padding: const EdgeInsets.symmetric(horizontal: AppSizes.size2),
                        child: Text('/',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.searchText,)),
                      ),
                      Text(AppLocalizations.of(context)?.translate(AppStringConstant.barcodeScanner) ?? '',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.searchText,)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size4),
                        child: Image.asset(
                          height: AppSizes.size12,width: AppSizes.size12,
                          AppImages.searchScanIcon,
                          color:AppColors.searchText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
              //CommonSearchBar(
            //               title:AppLocalizations.of(context)?.translate(AppStringConstant.search) ?? '',
            //               onScanTap: () {
            //                 Navigator.of(context).pushNamed(AppRoute.searchScreen);
            //               },
            //             ),
          )
      ],
    ),
    actions: actions ??
        <Widget>[
          if (isCart)
            IconButton(
                onPressed: () async {
                  //Navigator.of(context).pushNamed(AppRoute.wishlist);
                  /*
                    * WishList button functionality
                    *
                    * */

                  if (await AppSharedPref.isLogin() == true) {
                    Navigator.of(context).pushNamed(AppRoute.wishlist);
                  } else {
                    DialogHelper.confirmationDialog(
                        AppStringConstant.signInToContinue.localized(),
                        context,
                        localizations, onConfirm: () async {
                      Navigator.of(context).pushNamed(
                        AppRoute.login,
                        arguments: getSignInSignUpPageArgument(false, false),
                      );
                    });
                  }
                },
                icon:  Icon(
                  Icons.favorite_outline,
                    color: Theme.of(context).iconTheme.color
                )),

            // IconButton(
            //     onPressed: () async {
            //       //Navigator.of(context).pushNamed(AppRoute.wishlist);
            //       /*
            //         * WishList button functionality
            //         *
            //         * */
            //
            //       // if (await AppSharedPref.isLogin() == tr) {
            //         Navigator.of(context).pushNamed(AppRoute.quickCart);
            //     //   } else {
            //     //     DialogHelper.confirmationDialog(
            //     //         "${AppStringConstant.signInToContinue.localized()}",
            //     //         context,
            //     //         _localizations, onConfirm: () async {
            //     //       Navigator.of(context).pushNamed(
            //     //         AppRoute.login,
            //     //         arguments: getSignInSignUpPageArgument(false, false),
            //     //       );
            //     //     });
            //     //   }
            //     },
            //     icon: const Icon(
            //       Icons.add_shopping_cart,
            //       color: Colors.white,
            //     )),
            // IconButton(
            //   iconSize: 28,
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(AppRoute.searchScreen);
            //   },
            //   icon: const Icon(
            //     Icons.search,
            //     color: Colors.white,
            //   ),
            // ),
          // if (hideNotification)
          //   IconButton(
          //       onPressed: () {
          //         Navigator.of(context).push(
          //           MaterialPageRoute(builder: (context)=>PayPalPaymentPage())
          //         );
          //         // notificationBottomModelSheet(context);
          //       },
          //       icon: const Icon(
          //         Icons.notifications,
          //         color: Colors.white,
          //       )),
        ],

    bottom: isDividerEnable
        ? PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: Colors.grey.shade300,
        height: 1.0,
      ),
    )
        : null,
  );
}
