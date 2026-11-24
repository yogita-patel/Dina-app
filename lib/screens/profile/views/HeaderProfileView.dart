/*
 *
 *  Webkul Software.
 * @package Mobikul Application Code.
 *  @Category Mobikul
 *  @author Webkul <support@webkul.com>
 *  @Copyright (c) Webkul Software Private Limited (https://webkul.com)
 *  @license https://store.webkul.com/license.html
 *  @link https://store.webkul.com/license.html
 *
 * /
 */

import 'package:flutter/material.dart';
import 'package:oc_demo/models/accountItemsListModel/account_items_list_model.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';

class HeaderProfileView extends StatefulWidget {
  final String? userName;
  final String? userEmail;
  final String? userImage;

  const HeaderProfileView({
    super.key,
    this.userName,
    this.userEmail,
    this.userImage,
  });

  @override
  _HeaderProfileViewState createState() => _HeaderProfileViewState();
}

class _HeaderProfileViewState extends State<HeaderProfileView> {
  String? bannerImage;
  String? profileImage;
  String name = "";
  String email = "";
  AppLocalizations? _localizations;
  BannerModel? userModel;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    debugPrint('HeaderProfileView: _loadUserData called');
    
    // First use data passed from parent (ProfileScreen)
    if (widget.userName != null && widget.userName!.isNotEmpty) {
      setState(() {
        name = widget.userName!;
        email = widget.userEmail ?? "";
        profileImage = widget.userImage;
      });
      debugPrint('HeaderProfileView: Using passed user data - name: $name, email: $email');
      return;
    }
    
    // Otherwise try to get from storage
    if (mAppStoragePref.getUserData() != null) {
      userModel = mAppStoragePref.getUserData();
      bannerImage = userModel?.banner;
      profileImage = userModel?.banner;
      name = userModel?.firstname ?? "";
      email = userModel?.email ?? "";
      debugPrint('HeaderProfileView: User data loaded from storage - name: $name, email: $email');
      setState(() {});
    }
  }

  void getDetails() {
    // FIX: Don't call setState in build() - this causes infinite rebuilds
    // Instead, just refresh the local data without triggering rebuild
    debugPrint('HeaderProfileView: getDetails called');
    if (mAppStoragePref.getUserData() != null) {
      userModel = mAppStoragePref.getUserData();
      bannerImage = userModel?.banner;
      profileImage = userModel?.image;
      name = userModel?.firstname ?? "";
      email = userModel?.email ?? "";
    }
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(HeaderProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Rebuild when user data is passed from parent
    if (widget.userName != oldWidget.userName || widget.userEmail != oldWidget.userEmail) {
      debugPrint('HeaderProfileView: didUpdateWidget - user data changed');
      _loadUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // FIX: Don't call getDetails() here which calls setState internally
    // The data should be loaded in initState or via a callback
    // getDetails() is now just a data refresh method without state update
    
    // Get device width from MediaQuery for responsive layout
    final double deviceWidth = MediaQuery.of(context).size.width;
    final isTablet = deviceWidth > 600;
    
    debugPrint('HeaderProfileView: build called - deviceWidth: $deviceWidth, isTablet: $isTablet, name: $name, email: $email');
    
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
          width: deviceWidth,
          child: _commonBannerView(bannerImage, profileImage, name, email, isTablet)),
    );
  }

  Widget _commonBannerView(
      String? bannerImage, String? profileImage, String name, String email, bool isTablet) {
    // Use MediaQuery for actual device width
    final double deviceWidth = MediaQuery.of(context).size.width;
    
    debugPrint('HeaderProfileView: _commonBannerView - profileImage: $profileImage, name: $name, email: $email');
    
    return Column(
      children: [
        SizedBox(
            width: deviceWidth,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isTablet ? AppSizes.size24 : AppSizes.size16,
                horizontal: isTablet ? AppSizes.size24 : AppSizes.size16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: isTablet ? AppSizes.size48 : AppSizes.size60 + AppSizes.size8,
                    width: isTablet ? AppSizes.size48 : AppSizes.size60 + AppSizes.size8,
                    child: (profileImage != null && profileImage != "")
                        ? ImageView(
                            url: profileImage,
                            fit: BoxFit.cover,
                          )
                        : CircleAvatar(
                            child: Icon(
                              Icons.person,
                              size: isTablet ? AppSizes.size40 : AppSizes.size45,
                            ),
                            backgroundColor: AppColors.searchText,
                            foregroundColor: AppColors.black,
                            radius: 1,
                          ),
                  ),
                  SizedBox(width: isTablet ? AppSizes.size24 : AppSizes.size16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isNotEmpty ? name : '',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: isTablet ? 18 : AppSizes.size14,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: AppSizes.size4,
                        ),
                        Text(
                          email.isNotEmpty ? email : '',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: isTablet ? 16 : AppSizes.size14,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
        ),
        const Divider(
          color: AppColors.icon_grey,
          thickness: 0.4,
        )
      ],
    );
  }
}
