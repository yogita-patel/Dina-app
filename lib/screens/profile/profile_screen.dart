import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/hive/hive_service.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_events.dart';
import 'package:oc_demo/screens/profile/bloc/profile_screen_state.dart';
import 'package:oc_demo/screens/profile/views/HeaderProfileView.dart';
import 'package:oc_demo/screens/profile/views/logged_out_header.dart';
import 'package:oc_demo/screens/profile/views/profile_menu.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/bottom_sheet.dart';
import '../../common_widgets/common_outlined_button.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../hive/hive_constant.dart';
import '../../main.dart';
import '../../network_manager/api_client.dart';
import 'bloc/profile_screen_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _profileState();
  }
}

class _profileState extends State<ProfileScreen> {
  AppLocalizations? _localizations;
  bool isUserLogin = false;
  bool isPartner = false;
  bool partnerApproveRequired = false;
  ProfileScreenBloc? profileScreenBloc;
  bool isLoading = false;
  String? shopName = "";
  String? shopDescription = "";
  StreamSubscription? _loginStreamSubscription;
  bool _isInitialized = false;
  
  // User data for passing to HeaderProfileView
  String _userName = "";
  String _userEmail = "";
  String? _userImage;

  @override
  void initState() {
    super.initState();
    debugPrint('ProfileScreen: initState called');
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    debugPrint('ProfileScreen: _initializeProfile called');
    
    // Get login status first before trying to access bloc
    var isLoggedIn = await AppSharedPref.isLogin();
    debugPrint('ProfileScreen: Initial login check - $isLoggedIn');
    
    // Get user data from storage synchronously
    var loginUserData = await AppSharedPref.getLoginUserData();
    debugPrint('ProfileScreen: Login user data - ${loginUserData?.firstname}, ${loginUserData?.email}');
    
    // Also check mAppStoragePref for user data
    if (mAppStoragePref.getUserData() != null) {
      final userData = mAppStoragePref.getUserData();
      debugPrint('ProfileScreen: mAppStoragePref user data - name: ${userData?.firstname}, email: ${userData?.email}');
      if (mounted) {
        setState(() {
          _userName = userData?.firstname ?? _userName;
          _userEmail = userData?.email ?? _userEmail;
          _userImage = userData?.image ?? _userImage;
        });
      }
    }

    // Use addPostFrameCallback to ensure bloc is available after build
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint('ProfileScreen: addPostFrameCallback - attempting to read bloc');
      try {
        profileScreenBloc = context.read<ProfileScreenBloc>();
        debugPrint('ProfileScreen: Bloc obtained successfully');
        
        // If already logged in, trigger data fetch immediately
        if (isLoggedIn) {
          debugPrint('ProfileScreen: User already logged in, fetching data');
          if (mounted) {
            setState(() {
              isUserLogin = true;
              isLoading = true;
            });
          }
          profileScreenBloc?.add(const AccountDetailEvent());
        }
      } catch (e) {
        debugPrint('ProfileScreen: Error reading bloc - $e');
      }
    });

    // Get partner data
    if (loginUserData != null) {
      debugPrint('ProfileScreen: getLoginUserData response - partner: ${loginUserData.partner}, partnerApproveRequired: ${loginUserData.partnerApproveRequired}');
      if (mounted) {
        setState(() {
          isPartner = ((loginUserData.partner ?? 0) == 1);
          partnerApproveRequired =
              (loginUserData.partnerApproveRequired ?? false) == false;
          
          // Also get user data for HeaderProfileView
          _userName = loginUserData.firstname ?? _userName;
          _userEmail = loginUserData.email ?? _userEmail;
          _userImage = loginUserData.image;
          debugPrint('ProfileScreen: User data - name: $_userName, email: $_userEmail');
        });
      }
    }

    // Listen to login stream for real-time updates
    _loginStreamSubscription = BottomTabController.check.updateLoginStreamController.stream.listen(
      (event) {
        debugPrint('ProfileScreen: Login stream event received - $event');
        if (mounted) {
          if (event) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) async {
                // Get user data from storage and update state
                var loginUserData = await AppSharedPref.getLoginUserData();
                if (loginUserData != null && mounted) {
                  setState(() {
                    _userName = loginUserData.firstname ?? "";
                    _userEmail = loginUserData.email ?? "";
                    _userImage = loginUserData.image;
                    isUserLogin = true;
                    isLoading = true;
                  });
                  debugPrint('ProfileScreen: User data from login stream - name: $_userName, email: $_userEmail');
                } else {
                  setState(() {
                    isUserLogin = true;
                    isLoading = true;
                  });
                }
                debugPrint('ProfileScreen: Triggering AccountDetailEvent after login');
                // Try to get bloc and trigger event
                try {
                  profileScreenBloc ??= context.read<ProfileScreenBloc>();
                  profileScreenBloc?.add(const AccountDetailEvent());
                } catch (e) {
                  debugPrint('ProfileScreen: Error triggering event - $e');
                }
              },
            );
          }
        }
      },
    );

    // Get cart count
    AppSharedPref.getCartCount().then((value) {
      if (value != null && mounted) {
        TabbarController.countController.sink.add(int.tryParse(value) ?? 0);
      }
    });

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    debugPrint('ProfileScreen: dispose called');
    _loginStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ProfileScreen: build called - isUserLogin: $isUserLogin, isLoading: $isLoading, isInitialized: $_isInitialized');
    
    // Using MediaQuery for responsive layout
    final mediaQuery = MediaQuery.of(context);
    final deviceWidth = mediaQuery.size.width;
    final deviceHeight = mediaQuery.size.height;
    final padding = mediaQuery.padding;
    final isTablet = deviceWidth > 600; // iPad width threshold
    
    debugPrint('ProfileScreen: deviceWidth: $deviceWidth, deviceHeight: $deviceHeight, padding: $padding, isTablet: $isTablet');

    return BlocConsumer<ProfileScreenBloc, ProfileScreenState>(
      listener: (context, currentState) {
        debugPrint('ProfileScreen: BlocConsumer listener - state: $currentState');
        
        if (currentState is ProfileScreenLoading) {
          setState(() {
            isLoading = true;
          });
        } else if (currentState is ToBecomeSellerSuccess) {
          setState(() {
            isLoading = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
          });
        } else if (currentState is ProfileScreenSuccess) {
          // Don't auto-logout when status is 0 - we already have user data from login response
          // The API might return status 0 for various reasons but user is still logged in
          /*
          if ((currentState.accountInfoModel.status) == 0) {
            setState(() {
              isUserLogin = false;
            });
            AppSharedPref.logoutUser();
          }
          */
          // Only update user data from API if it has valid values
          // Otherwise keep the existing data from login response
          final firstName = currentState.accountInfoModel.firstname;
          final email = currentState.accountInfoModel.email;
          
          setState(() {
            // Only update if API returns non-empty values
            if (firstName != null && firstName.isNotEmpty) {
              _userName = firstName;
            }
            if (email != null && email.isNotEmpty) {
              _userEmail = email;
            }
            _userImage = null;
          });
          debugPrint('ProfileScreen: Profile loaded - name: $_userName, email: $_userEmail');
          
          profileScreenBloc?.add(const GetAccountItemsDataEvent());
          AppSharedPref.getCartCount().then((value) {
            if (value != null && mounted) {
              TabbarController.countController.sink.add(int.tryParse(value) ?? 0);
            }
          });
        } else if (currentState is AccountItemDataSuccess) {
          setState(() {
            isLoading = false;
          });
          if ((currentState.model.error) == 1) {
            // Update user data from banner model only if it has valid values
            // Otherwise keep the existing data from login response or AccountDetailEvent
            final banner = currentState.model.banner;
            if (banner != null) {
              setState(() {
                // Only update if API returns non-empty values
                if (banner.firstname != null && banner.firstname!.isNotEmpty) {
                  _userName = banner.firstname ?? _userName;
                }
                if (banner.email != null && banner.email!.isNotEmpty) {
                  _userEmail = banner.email ?? _userEmail;
                }
                if (banner.image != null && banner.image!.isNotEmpty) {
                  _userImage = banner.image;
                }
              });
              debugPrint('ProfileScreen: Account items loaded - name: ${banner.firstname}, email: ${banner.email}, image: ${banner.image}');
            }
            mAppStoragePref.setUserData(currentState.model.banner);
          }
        } else if (currentState is ProfileScreenImageSuccess) {
          setState(() {
            isLoading = false;
          });
          if ((currentState.model?.error) == 1) {
            profileScreenBloc?.add(const GetAccountItemsDataEvent());
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showSuccess(
                  currentState.model?.message ?? '', context);
            });
          }
        } else if (currentState is ProfileScreenError) {
          setState(() {
            isLoading = false;
          });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message ?? '', context);
          });
        } else if (currentState is ProfileScreenComplete) {
          // Handle ProfileScreenComplete to keep user logged in
          setState(() {
            isLoading = false;
          });
          debugPrint('ProfileScreen: ProfileScreenComplete state received');
        }
      },
      builder: (context, currentState) {
        debugPrint('ProfileScreen: BlocConsumer builder - currentState: $currentState');
        return buildUI(deviceWidth, deviceHeight, padding, isTablet);
      },
    );
  }

  Widget buildUI(double deviceWidth, double deviceHeight, EdgeInsets padding, bool isTablet) {
    debugPrint('ProfileScreen: buildUI - isUserLogin: $isUserLogin, isLoading: $isLoading');
    
    // Show loading indicator while initializing
    if (!_isInitialized) {
      debugPrint('ProfileScreen: Showing initial loading');
      return Scaffold(
        appBar: commonAppBar(AppStringConstant.profile.localized(), context,
            isLeadingEnable: true),
        body: const Center(
          child: Loader(),
        ),
      );
    }

    return (isUserLogin)
        ? _buildLoggedInScreen(deviceWidth, deviceHeight, padding, isTablet)
        : _buildLoggedOutScreen(deviceWidth, deviceHeight, padding, isTablet);
  }

  Widget _buildLoggedInScreen(double deviceWidth, double deviceHeight, EdgeInsets padding, bool isTablet) {
    debugPrint('ProfileScreen: _buildLoggedInScreen called');
    
    // Calculate content width based on device type
    final double maxContentWidth = isTablet 
        ? (deviceWidth > 1000 ? deviceWidth * 0.5 : deviceWidth * 0.7)
        : deviceWidth;
    
    return Scaffold(
      appBar: commonAppBar(
          isUserLogin
              ? AppStringConstant.welcome.localized()
              : AppStringConstant.profile.localized(),
          context,
          isLeadingEnable: true),
      // FIX 1: Wrap body with SafeArea for proper notch/dynamic island handling
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // FIX 2: Use LayoutBuilder for responsive layout
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            
            // Use full width for tablet in portrait, or constrained in landscape
            final contentWidth = isTablet && !isLandscape 
                ? constraints.maxWidth 
                : (isTablet ? constraints.maxWidth * 0.8 : constraints.maxWidth);
            
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Stack(
                  children: [
                    // FIX 3: Use Positioned.fill for proper Stack layout
                    Positioned.fill(
                      child: isLoading
                          ? const SizedBox.shrink()
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Pass user data to HeaderProfileView
                                  HeaderProfileView(
                                    userName: _userName,
                                    userEmail: _userEmail,
                                    userImage: _userImage,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isTablet ? 32 : 24,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      "My Account",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isTablet ? 24 : 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  profileMenu(() {}, _localizations, () {
                                    setState(() {});
                                  }, () {
                                    requestForSellerBottomSheet();
                                  }, isUserLogin, isPartner, partnerApproveRequired),
                                  widgetSpace(),
                                ],
                              ),
                            ),
                    ),
                    // FIX 4: Positioned loader properly
                    if (isLoading)
                      const Positioned.fill(
                        child: Loader(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoggedOutScreen(double deviceWidth, double deviceHeight, EdgeInsets padding, bool isTablet) {
    debugPrint('ProfileScreen: _buildLoggedOutScreen called');
    
    return Scaffold(
      appBar: commonAppBar(AppStringConstant.profile.localized(), context,
          isLeadingEnable: true),
      // FIX 1: Wrap body with SafeArea for proper notch/dynamic island handling
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // FIX 2: Use LayoutBuilder for responsive layout
            final isLandscape = constraints.maxWidth > constraints.maxHeight;
            final contentWidth = isTablet 
                ? (isLandscape ? constraints.maxWidth * 0.6 : constraints.maxWidth * 0.8)
                : constraints.maxWidth;
            
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: contentWidth),
                child: Stack(
                  children: [
                    // FIX 3: Use Positioned.fill for proper Stack layout
                    Positioned.fill(
                      child: isLoading
                          ? const SizedBox.shrink()
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const LoggedOutHeader(),
                                  profileMenu(() {}, _localizations, () {
                                    setState(() {});
                                  }, () {
                                    requestForSellerBottomSheet();
                                  }, isUserLogin, isPartner, partnerApproveRequired),
                                  widgetSpace(),
                                ],
                              ),
                            ),
                    ),
                    // FIX 4: Positioned loader properly
                    if (isLoading)
                      const Positioned.fill(
                        child: Loader(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  Widget loginLogoutButton(bool isLogin) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: ElevatedButton.icon(
          onPressed: () async {
            if (isLogin) {
              Navigator.of(context).pushNamed(AppRoute.login,
                  arguments: getSignInSignUpPageArgument(false, false));
            } else {
              var wkToken = await AppSharedPref.getWkToken();
              await ApiClient().logoutUser(wkToken);
              HiveService.getHive().deleteBox(HiveConstant.getAddress);
              await AppSharedPref.logoutUser();
              BottomTabController.check.countController?.sink.add(0);
              setState(() {
                isUserLogin = false;
              });
            }
          },
          icon: Icon(
            isLogin ? Icons.login : Icons.logout,
            size: AppSizes.size24,
            color: MobikulTheme.iconColor
          ),
          label: Text(
            isLogin
                ? _localizations?.translate(AppStringConstant.signIn) ?? 'Sign In'
                : _localizations?.translate(AppStringConstant.signOut) ?? 'Sign Out',
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
                width: AppSizes.size2,
                color: Theme.of(context).textTheme.titleLarge?.color ??
                    Colors.black,
                style: BorderStyle.solid),
            minimumSize: Size(AppSizes.deviceWidth, AppSizes.deviceHeight / 16),
          )),
    );
  }

  void requestForSellerBottomSheet() async {
    showMyModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Scaffold(
        appBar: commonToolBar(
            _localizations?.translate(AppStringConstant.toBecomeSeller) ?? "Become a Seller",
            context,
            isLeadingEnable: true),
        body: StatefulBuilder(
          builder: (context, changeState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.size8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgetSpace(),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            _localizations
                                    ?.translate(AppStringConstant.shopName) ??
                                "Shop Name",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headlineSmall)),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.size8),
                      child: TextField(
                        onChanged: (value) {
                          shopName = value;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: _localizations
                                  ?.translate(AppStringConstant.shopName) ??
                              "Enter shop name",
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    widgetSpace(),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            _localizations?.translate(
                                    AppStringConstant.shopDescription) ??
                                "Shop Description",
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.headlineSmall)),
                    Padding(
                      padding: const EdgeInsets.all(AppSizes.size8),
                      child: TextField(
                        onChanged: (value) {
                          shopDescription = value;
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: _localizations
                                  ?.translate(
                                      AppStringConstant.shopDescription) ??
                              "Enter shop description",
                          hintStyle:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                        ),
                        style: Theme.of(context).textTheme.bodyLarge,
                        cursorColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    widgetSpace(),
                    commonButton(context, () {
                      profileScreenBloc
                          ?.add(ToBecomeSellerEvent(shopName, shopDescription));
                      profileScreenBloc?.emit(ProfileScreenInitial());
                      setState(() {
                        isLoading = true;
                      });
                    }, _localizations?.translate(AppStringConstant.submit) ?? "Submit",
                        backgroundColor: MobikulTheme.primaryColor,
                        textColor: Colors.white),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
