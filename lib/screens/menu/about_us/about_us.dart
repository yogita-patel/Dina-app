import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/about_us/about_us_model.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../constants/global_data.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  AboutUsModel? _aboutUs;
  bool isLoading = true;




  AppLocalizations? _localizations;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAboutUs();
  }

  Future<void> loadAboutUs() async {
    try {
      _aboutUs = await ApiClient().getAboutData("wk_token");
      isLoading = false;
      print("About US ${_aboutUs?.pages}");
    } catch (e) {
      // handle error
      debugPrint('Error loading manufacturers: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.aboutUs) ?? "",
          context,
          isElevated: false),

      body: SingleChildScrollView(
        child: isLoading?const Loader():Column(
          children: [
            widgetSpace(0, AppSizes.size12),
            getSearchCategorySuggestion(_aboutUs?.pages??[]),
            const Divider(),
            getContactCard(),
          ],
        ),
      ),
    );
  }

  Widget getContactCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:AppSizes.size20 ,vertical: AppSizes.size4,),
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
          contactRow(AppImages.timerIcon, 'Monday to Friday 9am to 5pm'),
          const SizedBox(height: AppSizes.size16),
          contactRow(AppImages.locationIcon,
              'Prashanti House Sussex Street\nLeicester LE5 3BF\nUnited Kingdom'),
          const SizedBox(height: AppSizes.size16),
          contactRow(AppImages.callIcon, 'Call us: +44 (0) 116 251 0990'),
          const SizedBox(height: AppSizes.size16),
        ],
      ),
    );
  }

  Widget socialIcon( String iconData) {
    return CircleAvatar(
        backgroundColor: const Color(0xFFFFD464),
        child: Image.asset(iconData,height: AppSizes.size40,width: AppSizes.size40,));
  }

  Widget contactRow(String iconData, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconData,height: AppSizes.size20,width: AppSizes.size20,),
        const SizedBox(width: AppSizes.size12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ],
    );
  }

  Widget getSearchCategorySuggestion(List<PageModel>? page) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: page?.length ?? 0,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 6,
        crossAxisSpacing: 0,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final category = page![index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoute.cmsPage,
                arguments: getCmsPageArguments(
                    category.information_id ?? "1", category.name ?? ""));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: AppSizes.deviceWidth / 4,
                  width: AppSizes.deviceWidth / 4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(category.image ?? ''),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.size6),
              Text(
                category.name ?? '',
                textAlign: TextAlign.center,
                style:Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600,fontSize: AppSizes.size12),
              ),
            ],
          ),
        );
      },
    );
  }

}

