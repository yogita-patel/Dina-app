import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/menu/widget/hot_and_new_cate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string_constant.dart';
import '../../constants/arguments_map.dart';
import '../../constants/global_data.dart';
import '../../helper/app_localizations.dart';
import '../../helper/app_shared_pref.dart';
import '../../helper/push_notifications_manager.dart';
import '../../models/homPage/home_screen_model.dart';
import '../home/bloc/home_screen_bloc.dart';
import 'about_us/about_us.dart';
import 'contact_form/contact_form.dart';

class MenuScreen extends StatefulWidget {
  // final Function(int) moveToCategory;
  // const MenuScreen(this.moveToCategory, {super.key});
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static const String TAG = "_HomeScreenState";
  HomeScreenBloc? homePageBloc;
  AppLocalizations? _localizations;
  bool isLoading = true; // Variable used to handle visibility of loader
  HomePageData? homePageModel; //HomePage Model/data
  bool? addedToWishlist = false;
  String token = "";
  final _scrollController = ScrollController();
  List<Product> recentProductList = [];
  Set<String> displayedCarousels = {};

  @override
  void initState() {
    notification.checkInitialMessage(context);
    GlobalData.selectedIndex = 0;
    GlobalData.selectedCategory = 0;
    GlobalData.selectedCategoryId = "";
    homePageBloc = context.read<HomeScreenBloc>();
    if ((GlobalData.mainMenu ?? []).isNotEmpty) {
      print("main ${(GlobalData.mainMenu)}");
      homePageModel?.mainMenu = GlobalData.mainMenu;
      print("main ${(homePageModel?.mainMenu)}");
    }
    if ((GlobalData.shopCatergory ?? []).isNotEmpty) {
      print("shop ${(GlobalData.shopCatergory)}");
      homePageModel?.shopCatergory = GlobalData.shopCatergory;
      print("shop ${(homePageModel?.shopCatergory)}");
    }
    AppSharedPref.getCartCount().then((value) {
      if (value != null) {
        TabbarController.countController.sink.add(int.parse(value) ?? 0);
      }
    });
    // if((GlobalData.mainMenu??[]).isEmpty ||(GlobalData.shopCatergory??[]).isEmpty){
    //   print("Home blocj ${(GlobalData.shopCatergory)}");
    //   homePageBloc?.add(HomeScreenDataFetchEvent());
    // }

    //
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    print("dsnddvv${AppBar().preferredSize.height * 0.7}");
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            height: AppBar().preferredSize.height * 0.7,
            width: AppBar().preferredSize.height * 1.39,
            child: setAppLogoWidget(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ),
        ),
        body: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (context, currentState) {
            print("Rishabh$currentState");
            if (currentState is HomeScreenInitial) {
              isLoading = false;
            } else if (currentState is HomeScreenSuccess) {
              homePageModel = currentState.homePageData;
              AppSharedPref.setCartCount((homePageModel?.cart ?? 0).toString());
              AppSharedPref.getLoginUserData().then((value) {
                if (value != null) {
                  value.partner = homePageModel?.partner ?? 0;
                  value.partnerApproveRequired =
                      homePageModel?.partner_approve_required ?? false;
                  AppSharedPref.setLoginUserData(value);
                }
              });
              // TabbarController.countController.sink
              //     .add(homePageModel?.cart ?? 0);
              print("defdefeff" "${homePageModel?.shopCatergory?.length}");
              isLoading = false;
              print("defdefeff" "${homePageModel?.shopCatergory?.length}");
              /*   WidgetsBinding.instance?.addPostFrameCallback((_) {
                buildHomePageView();
              */ /* setState(() {

               });*/ /*
              });*/
            } else if (currentState is HomeScreenError) {
              isLoading = false;
              print("Rishabh${currentState.message}");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AlertMessage.showError(currentState.message ?? '', context);
              });
            }
            return buildHomePageView();
          },
        ));
  }

  Widget buildHomePageView() {
    // PrefetchService.preFetchBestProductsFromDb();
    // PrefetchService.preFetchPopularProductsFromDb();
    // PrefetchService.preFetchLatestProductsFromDb();
    // PrefetchService.preFetchFeatureProductsFromDb();
    // if (homePageModel == null) {
    //   return  Scaffold(
    //     body: SafeArea(
    //       child: const Center(
    //         child: Loader(), // 👈 Your custom loader widget
    //       ),
    //     ),
    //   );
    // }
    return RefreshIndicator(
      onRefresh: _refreshHomePage,
      child: Stack(
        children: [
          // Show Loader while loading

          // Show actual data when not loading and data is available
          // if (!isLoading && (homePageModel?.homeSequence?.isNotEmpty ?? false))
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///...getWidgets(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 12),
                  child: Text(
                    _localizations?.translate(AppStringConstant.mainMenu) ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                getMainManuCategorySuggestion(GlobalData.mainMenu),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 12),
                  child: Text(
                      _localizations
                              ?.translate(AppStringConstant.shopByCategory) ??
                          '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ),
                getShopCategorySuggestion(GlobalData.shopCatergory),
                const Divider(),
                getContactCard()
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ** App refresh function  function **//

  Future<Null> _refreshHomePage() async {
    print('${TAG}refreshing home');
    //only call api and refresh view some view like-recent product will not change
    homePageBloc?.add(HomeScreenDataFetchEvent());
    homePageBloc?.emit(HomeScreenInitial());
    //to reload whole page
    //Navigator.pop(context);
    BottomTabController.check.countController?.sink.add(0);
    //Navigator.pushNamed(context, AppRoute.bottomTabBAr);
  }

  Widget getShopCategorySuggestion(List<ShopCatergory>? categories) {
    print("dfgth$categories");
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 0,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final category = categories![index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoute.catalog,
              arguments: categoryMap(
                category.manufacturerId ?? "",
                category.name ?? "",
                "",
                "",
                true,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: category.image ?? '',
                  height: AppSizes.deviceWidth / 4,
                  width: AppSizes.deviceWidth / 4,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.size6),
              Text(
                category.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600, fontSize: AppSizes.size12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getMainManuCategorySuggestion(List<MainMenu>? categories) {
    print("dfgth$categories");
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 0,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final category = categories![index];
        return GestureDetector(
          onTap: () {
            if (category.mainGroup == "about") {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const AboutUs()));
            }
            if (category.mainGroup == "wishlist") {
              Navigator.of(context).pushNamed(AppRoute.wishlist);
            }
            if (category.mainGroup == "order") {
              Navigator.of(context)
                  .pushNamed(AppRoute.orderList, arguments: false);
            }
            if (category.mainGroup == "category") {
              if (category.categoryId == "168") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotAndNewCate(
                            title: category.name,
                          )),
                );
              } else {
                Navigator.of(context).pushNamed(
                  AppRoute.catalog,
                  arguments: categoryMap(
                    category.categoryId ?? "",
                    category.name ?? "",
                    "",
                    "",
                    false,
                  ),
                );
              }
            }

            if (category.mainGroup == "contact") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ContactForm()));
            }

            // Navigator.of(context).pushNamed(
            //   AppRoute.catalog,
            //   arguments: categoryMap(
            //     category.categoryId??"",
            //     category.name ?? "",
            //     "",
            //     true,
            //   ),
            // );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: category.image ?? '',
                  height: AppSizes.deviceWidth / 4,
                  width: AppSizes.deviceWidth / 4,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.size6),
              Text(
                category.name ?? '',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: AppSizes.size12,
                    color: AppColors.bottomBarIconActiveColor),
              ),
            ],
          ),
        );
      },
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
        Image.asset(
          iconData,
          height: AppSizes.size20,
          width: AppSizes.size20,
        ),
        const SizedBox(width: AppSizes.size10),
        Expanded(
          child: Text(
            text ?? "",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Widget setAppLogoWidget() {
    return (Theme.of(context).brightness == Brightness.dark &&
            mAppStoragePref.getDarkThemeLogo().isNotEmpty)
        ? Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                mAppStoragePref.getDarkThemeLogo(),
              ),
              fit: BoxFit.fill,
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
                  fit: BoxFit.fill,
                )),
              )
            : Image.asset(
                "assets/images/app_logo.png", // Local fallback image
                fit: BoxFit.fill,
              );
  }
}
