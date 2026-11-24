import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/constants/global_data.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:oc_demo/screens/profile/views/language_selection_bottomsheet.dart';
import 'package:oc_demo/screens/profile/views/profile_menu_items.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../../common_widgets/dialog_helper.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_restart.dart';
import '../../../network_manager/api_client.dart';
import '../../menu/contact_form/contact_form.dart';
import 'currencies_selection_bottomsheet.dart';

Widget profileMenu(
    Function logoutFunction,
    AppLocalizations? localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool isUserLogin,
    bool isSeller,
    bool partnerApproveRequired) {
  List<ProfileMenuItems> menuItems = [];
  menuItems.clear();
  if (isUserLogin) {
    menuItems.add(ProfileMenuItems(
        id: 4,
        title: localizations?.translate(AppStringConstant.orderHistory) ?? '',
        icon: AppImages.order_history));
    menuItems.add(ProfileMenuItems(
        id: 5,
        title: localizations?.translate(AppStringConstant.backorders) ?? '',
        icon: AppImages.returnIcon));
    menuItems.add(ProfileMenuItems(
      id: 32,
      title:
          localizations?.translate(AppStringConstant.previouslyOrderProducts) ??
              '',
      icon: AppImages.previous_ordered,
    ));
    menuItems.add(ProfileMenuItems(
        id: 2,
        title: localizations?.translate(AppStringConstant.accountInfo) ?? '',
        icon: AppImages.infoIcon));
    menuItems.add(ProfileMenuItems(
        id: 3,
        title: localizations?.translate(AppStringConstant.addressBook) ?? '',
        icon: AppImages.address_book_));
    menuItems.add(ProfileMenuItems(
        id: 33,
        title: localizations?.translate(AppStringConstant.changePassword) ?? '',
        icon: AppImages.changePassword));
    menuItems.add(ProfileMenuItems(
        id: 7,
        title: localizations?.translate(localizations
                .translate(AppStringConstant.subscribeNewsletters)) ??
            '',
        icon: AppImages.newsletter_icon));
    // menuItems.add(ProfileMenuItems(
    //     id: 1,
    //     title: _localizations?.translate(AppStringConstant.dashboard) ?? '',
    //     icon: AppImages.dashboardIcon));
    // menuItems.add(ProfileMenuItems(
    //     id: 2,
    //     title: _localizations?.translate(AppStringConstant.accountInfo) ?? '',
    //     icon: AppImages.accountInfoIcon));
    // menuItems.add(ProfileMenuItems(
    //     id: 33,
    //     title: _localizations?.translate(AppStringConstant.changePassword) ?? '',
    //     icon: AppImages.changePassword));
    // menuItems.add(ProfileMenuItems(
    //     id: 3,
    //     title: _localizations?.translate(AppStringConstant.addressBook) ?? '',
    //     icon: AppImages.addressIcon));
    // menuItems.add(ProfileMenuItems(
    //     id: 4,
    //     title: _localizations?.translate(AppStringConstant.allOrders) ?? '',
    //     icon: AppImages.ordersIcon));
    // menuItems.add(ProfileMenuItems(
    //   id: 32,
    //   title: _localizations?.translate(AppStringConstant.reviews) ?? '',
    //   icon: AppImages.reviewIcon,
    // ));
    // menuItems.add(ProfileMenuItems(
    //     id: 5,
    //     title: _localizations?.translate(AppStringConstant.myWishlist) ?? '',
    //     icon: AppImages.wishlistsIcon));
    //
    // menuItems.add(ProfileMenuItems(
    //     id: 6,
    //     title: _localizations?.translate(AppStringConstant.loginUSingQr) ?? '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.qr_code));
    // menuItems.add(ProfileMenuItems(
    //     id: 7,
    //     title: _localizations?.translate(
    //             _localizations.translate(AppStringConstant.newsLetter)) ??
    //         '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.email));
    // menuItems.add(ProfileMenuItems(
    //     id: 9,
    //     title: _localizations
    //             ?.translate(AppStringConstant.myDownloadableProducts) ??
    //         '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.download_rounded));
    // menuItems.add(ProfileMenuItems(
    //     id: 10,
    //     title:
    //         _localizations?.translate(AppStringConstant.yourRewardPoints) ?? '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.star));
    // menuItems.add(ProfileMenuItems(
    //     id: 11,
    //     title:
    //         _localizations?.translate(AppStringConstant.yourTransactions) ?? '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.local_atm));
    // menuItems.add(ProfileMenuItems(
    //     id: 12,
    //     title: _localizations?.translate(AppStringConstant.returnn) ?? '',
    //     icon: AppImages.wishlistsIcon,
    //     iconData: Icons.reply));
    // menuItems.add(ProfileMenuItems(
    //     id: 5,
    //     title: _localizations?.translate(AppStringConstant.myWishlist) ?? '',
    //     icon: AppImages.wishlistsIcon));
    //
    //
    // menuItems.add(ProfileMenuItems(
    //   id: 26,
    //   title: _localizations?.translate(AppStringConstant.compare_product) ?? '',
    //   icon: AppImages.compare,
    // ));

    ///*partner menu*/

    /*if(partnerApproveRequired){
      menuItems.add(ProfileMenuItems(
          id: 13,
          title: _localizations?.translate(AppStringConstant.becomeASeller) ?? '',
          icon: AppImages.sellerDashboard));
    }*/

    /*partner menu end*/
  }
  menuItems.add(ProfileMenuItems(
      id: 112345, title: "Options", icon: '' // need to change icon
      ));

  menuItems.add(ProfileMenuItems(
      id: 14,
      title: localizations?.translate(AppStringConstant.settings) ?? '',
      icon: AppImages.settingIcon // need to change icon
      ));
  menuItems.add(ProfileMenuItems(
      id: 15,
      title: localizations?.translate(AppStringConstant.about) ?? '',
      icon: AppImages.accountInfoIcon // need to change icon
      ));
  menuItems.add(ProfileMenuItems(
      id: 16,
      title: localizations?.translate(AppStringConstant.quickLinks) ?? '',
      icon: AppImages.accountInfoIcon // need to change icon
      ));
  menuItems.add(ProfileMenuItems(
    id: 41,
    title: localizations?.translate(AppStringConstant.pdfCatalogue) ?? '',
    icon: '',
    iconData: Icons.picture_as_pdf_outlined,
  ));
  if (isUserLogin) {
    // menuItems.add(ProfileMenuItems(
    //     id: 31,
    //     title: (localizations?.translate(AppStringConstant.ordersAndReturns) ??
    //         ''),
    //     icon: AppImages.returnIcon,
    //     iconData: null));

    menuItems.add(ProfileMenuItems(
        id: 40,
        title: localizations?.translate(
                localizations.translate(AppStringConstant.signOut)) ??
            '',
        icon: AppImages.logout));
  }

  if (isUserLogin) {}

  return ListView.builder(
      shrinkWrap: true,
      itemCount: menuItems.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, i) {
        var menuItem = menuItems[i];
        return Container(
          child: profileTiles(context, logoutFunction, menuItem, localizations,
              setState, showSellerRequestBottomSheet, isUserLogin),
        );
      });
}

Widget dropdownProfileTile(
    BuildContext context,
    ProfileMenuItems data,
    Function logoutFunction,
    AppLocalizations? localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    List<ProfileMenuItems> children) {
  return Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      iconColor: const Color(0xFF6A7282),
      tilePadding: const EdgeInsets.only(right: 16),
      childrenPadding: EdgeInsets.zero,
      collapsedIconColor: const Color(0xFF6A7282),
      title: Row(
        children: [
          if (data.id == 14) // Add an icon for title ID 14
            Padding(
                padding: const EdgeInsets.only(left: AppSizes.size16),
                child: CircleAvatar(
                  backgroundColor: AppColors.transparent,
                  child: Image.asset(
                    AppImages.settingIcon,
                    height: AppSizes.size24,
                    width: AppSizes.size24,
                    color: AppColors.icon_grey,
                  ),
                )),
          if (data.id == 15) // Add an icon for title ID 15
            Padding(
                padding: const EdgeInsets.only(left: AppSizes.size16),
                child: CircleAvatar(
                  backgroundColor: AppColors.transparent,
                  child: Image.asset(
                    AppImages.infoIcon,
                    height: AppSizes.size24,
                    width: AppSizes.size24,
                    color: AppColors.icon_grey,
                  ),
                )),
          if (data.id == 16) // Add an icon for title ID 15
            Padding(
                padding: const EdgeInsets.only(left: AppSizes.size16),
                child: CircleAvatar(
                  backgroundColor: AppColors.transparent,
                  child: Image.asset(
                    AppImages.linkIcon,
                    height: AppSizes.size24,
                    width: AppSizes.size24,
                    color: AppColors.icon_grey,
                  ),
                )),
          Text(data.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w400, color: AppColors.icon_grey)),
        ],
      ),
      children: children
          .map((e) => expansionChildren(
              context,
              e.title,
              e.id,
              logoutFunction,
              localizations,
              setState,
              showSellerRequestBottomSheet,
              isUserLogin,
              e.cmsData))
          .toList(),
    ),
  );
}

// Widget dropdownProfileTile(
//     BuildContext context,
//     ProfileMenuItems data,
//     Function logoutFunction,
//     AppLocalizations? _localizations,
//     VoidCallback setState,
//     VoidCallback showSellerRequestBottomSheet,
//     bool? isUserLogin,
//     List<ProfileMenuItems> children) {
//   return Theme(
//     data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//     child: ExpansionTile(
//       // leading: Padding(
//       //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
//       //   child: Icon(Icons.phone_missed),
//       // ),
//       iconColor: Theme.of(context).iconTheme.color,
//       tilePadding: EdgeInsets.zero,
//       childrenPadding: EdgeInsets.zero,
//       title: Row(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24.0),
//             child: Icon(Icons.home),
//           ),
//           Text(data.title, style: Theme.of(context).textTheme.headline6),
//         ],
//       ),
//       children: children
//           .map((e) => expansionChildren(
//               context,
//               e.title,
//               e.id,
//               logoutFunction,
//               _localizations,
//               setState,
//               showSellerRequestBottomSheet,
//               isUserLogin,
//               e.cmsData))
//           .toList(),
//     ),
//   );
// }

List<ProfileMenuItems> getSettingsChildren(AppLocalizations? localizations) {
  return [
    ProfileMenuItems(
        id: 17,
        title: localizations?.translate(AppStringConstant.language) ?? '',
        icon: "",
        iconData: Icons.language),
    ProfileMenuItems(
        id: 18,
        title: localizations?.translate(AppStringConstant.currency) ?? '',
        icon: "",
        iconData: Icons.money)
  ];
}

List<ProfileMenuItems> getQuickLinks(AppLocalizations? localizations) {
  return [
    ProfileMenuItems(
        id: 34,
        title:
            localizations?.translate(AppStringConstant.directFromFactory) ?? '',
        icon: "",
        iconData: Icons.language),
    ProfileMenuItems(
        id: 35,
        title: localizations?.translate(AppStringConstant.support) ?? '',
        icon: "",
        iconData: Icons.money),
    ProfileMenuItems(
        id: 36,
        title: localizations?.translate(AppStringConstant.faqs) ?? '',
        icon: "",
        iconData: Icons.money),
    ProfileMenuItems(
        id: 37,
        title:
            localizations?.translate(AppStringConstant.termAndCondition) ?? '',
        icon: "",
        iconData: Icons.money),
    ProfileMenuItems(
        id: 38,
        title: localizations?.translate(AppStringConstant.deliveryPolicy) ?? '',
        icon: "",
        iconData: Icons.money),
    ProfileMenuItems(
        id: 39,
        title: localizations?.translate(AppStringConstant.privacyPolicy) ?? '',
        icon: "",
        iconData: Icons.money)
  ];
}

List<ProfileMenuItems> getAboutChildren() {
  int lastIndex = 18;
  var cmsList = <ProfileMenuItems>[];
  for (AbautUs cms in GlobalData.sideMenu?.abaut_us ?? []) {
    lastIndex++;
    cmsList.add(ProfileMenuItems(
        id: lastIndex, title: cms.name ?? '', icon: "", cmsData: cms));
  }
  return cmsList;
}

List<ProfileMenuItems> getQuickLinkChildren() {
  int lastIndex = 18;
  var cmsList = <ProfileMenuItems>[];
  for (AbautUs cms in GlobalData.sideMenu?.quick_link ?? []) {
    lastIndex++;
    cmsList.add(ProfileMenuItems(
        id: lastIndex, title: cms.name ?? '', icon: "", cmsData: cms));
  }
  return cmsList;
}

// Widget profileTiles(
//     BuildContext context,
//     Function logoutFunction,
//     ProfileMenuItems item,
//     AppLocalizations? _localizations,
//     VoidCallback setState,
//     VoidCallback showSellerRequestBottomSheet,
//     bool? isUserLogin,
//     {double iconWidth = AppSizes.size20,
//     double? iconHeight = AppSizes.size20}) {
//   return ListTile(
//     onTap: () {
//       callBack(context, item.id, logoutFunction, _localizations, setState,
//           showSellerRequestBottomSheet, isUserLogin);
//     },
//     leading: item.iconData != null
//         ? CircleAvatar(
//             backgroundColor: AppColors.lightGray.withAlpha(50),
//             child: Icon(item.iconData!,
//                 size: iconHeight, color: Theme.of(context).iconTheme.color),
//           )
//         : CircleAvatar(
//             backgroundColor: AppColors.lightGray.withAlpha(50),
//             //backgroundColor: Colors.red,
//             child: Image.asset(
//               item.icon,
//               height: iconHeight,
//               width: iconWidth,
//               color: Theme.of(context).textTheme.headline6?.color,
//             ),
//           ),
//     title: item.id == 14
//         ? dropdownProfileTile(
//             context,
//             item,
//             logoutFunction,
//             _localizations,
//             setState,
//             showSellerRequestBottomSheet,
//             isUserLogin,
//             getSettingsChildren(_localizations),
//           )
//         : item.id == 15
//             ? dropdownProfileTile(
//                 context,
//                 item,
//                 logoutFunction,
//                 _localizations,
//                 setState,
//                 showSellerRequestBottomSheet,
//                 isUserLogin,
//                 getAboutChildren())
//             : Text(item.title, style: Theme.of(context).textTheme.headline6),
//   );
// }

Widget profileTiles(
    BuildContext context,
    Function logoutFunction,
    ProfileMenuItems item,
    AppLocalizations? localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    {double iconWidth = AppSizes.size20,
    double? iconHeight = AppSizes.size20}) {
  return item.id == 14 ||
          item.id == 15 ||
          item.id == 16 // Check if the item is a dropdown menu
      ? dropdownProfileTile(
          context,
          item,
          logoutFunction,
          localizations,
          setState,
          showSellerRequestBottomSheet,
          isUserLogin,
          item.id == 14
              ? getSettingsChildren(localizations)
              : item.id == 15
                  ? getAboutChildren()
                  : getQuickLinkChildren())
      : ListTile(
          horizontalTitleGap: item.iconData != null
              ? AppSizes.size8
              : item.icon != ''
                  ? 0
                  : -8,
          visualDensity: item.icon != ''
              ? const VisualDensity(vertical: -3)
              : const VisualDensity(vertical: -4, horizontal: -4),
          onTap: () {
            callBack(context, item.id, logoutFunction, localizations, setState,
                showSellerRequestBottomSheet, isUserLogin);
          },
          leading: item.iconData != null
              ? CircleAvatar(
                  backgroundColor: AppColors.transparent,
                  child: Icon(
                    item.iconData!,
                    size: iconHeight,
                    color: AppColors.icon_grey,
                  ),
                )
              : item.icon != ''
                  ? CircleAvatar(
                      backgroundColor: AppColors.transparent,
                      //backgroundColor: Colors.red,
                      child: Image.asset(
                        item.icon ?? "",
                        height: AppSizes.size24,
                        width: AppSizes.size24,
                        color: AppColors.icon_grey,
                      ),
                    )
                  : const SizedBox(),
          title: item.iconData != null || (item.icon?.isNotEmpty ?? false)
              ? Text(item.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400, color: AppColors.icon_grey))
              : Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
        );
}

void callBack(
    BuildContext context,
    int id,
    Function logoutFunction,
    AppLocalizations? localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    {AbautUs? cmsData}) async {
  if (id > 18 && cmsData != null) {
    print("Url---${cmsData.menu_type}");
    // if(cmsData.information_id!="0"){
    //   Navigator.of(context).pushNamed(AppRoute.cmsPage,
    //       arguments: getCmsPageArguments(
    //           cmsData.information_id ?? "1", cmsData.name ?? ""));
    // }
    if (cmsData.menu_type == MenuType.pages) {
      Navigator.of(context).pushNamed(AppRoute.cmsPage,
          arguments: getCmsPageArguments(
              cmsData.information_id ?? "1", cmsData.name ?? ""));
    } else if (cmsData.menu_type == MenuType.external) {
      print("Trying to open URL: ${cmsData.external_link}");
      final Uri url = Uri.parse(cmsData.external_link ?? "");
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      } else {
        print("Invalid URL: $url");
      }
    } else if (cmsData.menu_type == MenuType.support) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const ContactForm()));
    } else {
      print("dfghghf");
    }
  } else {
    print("dwaasa---$id");
    switch (id) {
      case 1:
        Navigator.of(context).pushNamed(AppRoute.dashboardScreen);
        break;
      case 2:
        Navigator.of(context).pushNamed(AppRoute.accountInfo);
        break;
      case 3:
        Navigator.of(context).pushNamed(AppRoute.addressBook);
        break;
      case 4:
        Navigator.of(context).pushNamed(AppRoute.orderList, arguments: false);
        break;
      case 5:
        if (isUserLogin ?? false) {
          Navigator.of(context).pushNamed(AppRoute.wishlist);
        } else {
          DialogHelper.wishlistConfirmationDialog(
              "${AppLocalizations.of(context)?.translate(AppStringConstant.wishlistDesc)}",
              "${AppLocalizations.of(context)?.translate(AppStringConstant.loginRequired)}",
              context,
              AppLocalizations.of(context), onConfirm: () async {
            Navigator.of(context).pushNamed(
              AppRoute.login,
              arguments: getSignInSignUpPageArgument(false, false),
            );
          });
        }

        break;
      case 6:
        Navigator.of(context).pushNamed(AppRoute.loginUsingQr);
        break;
      case 7:
        Navigator.of(context).pushNamed(AppRoute.newsLetter);
        break;
      // case 8:
      //--------------Item removed
      //   break;
      case 9:
        Navigator.of(context).pushNamed(AppRoute.downloadableProducts);
        break;
      case 10:
        Navigator.of(context).pushNamed(AppRoute.rewardScreen);
        break;
      case 11:
        Navigator.of(context).pushNamed(AppRoute.transactionScreen);
        break;
      case 12:
        Navigator.of(context).pushNamed(AppRoute.returnOrders);
        break;
      case 13:
        showSellerRequestBottomSheet();
        /* Navigator.of(context).pushNamed(AppRoute.login,
            arguments: getSignInSignUpPageArgument(false, false));*/
        break;
      case 14:
        //-----Expansion Tile Setting
        break;
      case 15:
        //-----Expansion Tile About
        break;
      case 16:
        // var wkToken = await AppSharedPref.getWkToken();
        // await ApiClient().logoutUser(wkToken);
        // await AppSharedPref.logoutUser();
        // Navigator.of(context).pushNamed(AppRoute.bottomTabBAr);
        break;
      case 17:
        showLanguageBottomSheet(context);
        break;
      case 18:
        showCurrenciesBottomSheet(context);
        break;
      case 19:
        Navigator.of(context).pushNamed(AppRoute.sellerPage);
        break;
      case 20:
        Navigator.of(context).pushNamed(AppRoute.addProduct, arguments: "");
        break;
      case 21:
        Navigator.of(context).pushNamed(AppRoute.sellerDashboard);
        break;
      case 22:
        Navigator.of(context).pushNamed(AppRoute.sellerOrders);
        break;
      case 23:
        Navigator.of(context).pushNamed(AppRoute.sellerReviews);
        break;
      case 24:
        Navigator.of(context).pushNamed(AppRoute.sellerTransition);
        break;
      case 25:
        Navigator.of(context).pushNamed(AppRoute.productList);
        break;
      case 26:
        Navigator.of(context).pushNamed(AppRoute.compareProduct);
        break;
      // case 31:
      //   Navigator.of(context).pushNamed(AppRoute.ordersAndReturns);
      //   break;
      case 32:
        Navigator.of(context)
            .pushNamed(AppRoute.previouslyOrderedScreen, arguments: false);
        break;
      case 33:
        Navigator.of(context)
            .pushNamed(AppRoute.changePassword, arguments: false);
        break;
      case 40:
        var wkToken = await AppSharedPref.getWkToken();
        await ApiClient().logoutUser(wkToken);
        // HiveService.getHive().deleteBox(HiveConstant.getAddress);
        //await Hive.deleteFromDisk();
        await AppSharedPref.logoutUser();
        //BottomTabController.check.countController.sink.add(0);
        AppRestart.rebirth(context);
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //     AppRoute.bottomTabBAr, (route) => false);
        break;
      case 41:
        Navigator.of(context).pushNamed(AppRoute.cmsPage, arguments: {
          cmsPageTitle:
              localizations?.translate(AppStringConstant.pdfCatalogue) ??
                  'PDF Catalogue',
          cmsPageUrl: ApiConstant.pdfCatalogueLandingUrl,
        });
        break;

      /* case 19:
        await AppSharedPref.getLoginUserData().then((value) {
          var email = value?.email;
          if (email?.isNotEmpty == true && email != "demo@webkul.com") {
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
          }
        });

        break;*/
      default:
    }
  }
}

Widget expansionChildren(
    BuildContext context,
    String title,
    int id,
    Function logoutFunction,
    AppLocalizations? localizations,
    VoidCallback setState,
    VoidCallback showSellerRequestBottomSheet,
    bool? isUserLogin,
    AbautUs? cmsData) {
  return ListTile(
    visualDensity: const VisualDensity(vertical: -3),
    dense: true,
    horizontalTitleGap: 0,
    contentPadding: EdgeInsets.zero,
    onTap: () {
      callBack(context, id, logoutFunction, localizations, setState,
          showSellerRequestBottomSheet, isUserLogin,
          cmsData: cmsData);
    },

    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 58, vertical: 0),
      child: Text(localizations?.translate(title) ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.icon_grey,
              )),
    ),
    // leading: Icon(Icons.home),
  );
}
