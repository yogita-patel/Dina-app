/*
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/hive/prefetch_service.dart';

import '../../../common_widgets/circle_page_indicator.dart';
import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageBannerWidget extends StatefulWidget {
  List<Banners> banners = [];

  HomePageBannerWidget(this.banners);

  @override
  _HomePageBannerWidgetState createState() => _HomePageBannerWidgetState();
}

class _HomePageBannerWidgetState extends State<HomePageBannerWidget> {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.banners.length-1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: AppSizes.size4,top:0,right:AppSizes.size4,bottom:0),
          child: Container(
            padding: const EdgeInsets.only(top: AppSizes.size16),
            height: AppSizes.deviceWidth / 2,
            width: AppSizes.deviceWidth.toDouble(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.banners.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () async {
                   */
/* final String response = await rootBundle.loadString('assets/languages/ar.json');
                    final data = await json.decode(response);
                    final Map<dynamic,dynamic> dataMap = data.map((key, value) => MapEntry(key.toString(), value));
                    dataMap.forEach((key, value) {
                      String f="<string name="+"${key}"+"> ${value}</string>";
                      print(f);
                    });*/ /*

                   // data

                    switch (widget.banners[index].type) {
                      case "product":
                        Navigator.of(context).pushNamed(
                          AppRoute.productPage,
                          arguments: getProductDataAttributeMap(
                            widget.banners[index].title ?? '',
                            widget.banners[index].link ?? '',
                          ),
                        );
                        PrefetchService.preFetchProductDetails(widget.banners[index].link);
                        break;
                      case "category":
                        Navigator.of(context).pushNamed(
                          AppRoute.catalog,
                          arguments: categoryMap(
                            widget.banners[index].link ?? "",
                            widget.banners[index].title ?? "",
                            "",
                          ),

                        );
                        PrefetchService.preFetchCategoryProduct( widget.banners[index].link);
                        break;
                      case "manufacturer":
                        Navigator.of(context).pushNamed(
                          AppRoute.catalog,
                          arguments: categoryMap(
                            widget.banners[index].link ?? "",
                            widget.banners[index].title ?? "",
                            "",
                          ),
                        );
                        PrefetchService.preFetchManuffacture( widget.banners[index].link);
                        break;
                      default:
                        break;
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size4, vertical: AppSizes.size4),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.size4),
                    ),
                    elevation: AppSizes.size4,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(0.0)),
                          child: ImageView(
                            url: widget.banners[index].image!,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {
                _currentPageNotifier.value = index;
              },
            ),
          ),
        ),
        if ((widget.banners.length) > 1)
          Center(
            child: _buildCircularIndicator(_currentPageNotifier),
          )
      ],
    );
  }

  Widget _buildCircularIndicator(_currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: CirclePageIndicator(
        itemCount: widget.banners.length,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }
}
*/

import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/models/homPage/home_screen_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/app_constants.dart';

class HomePageBannerWidget extends StatefulWidget {
  List<SliderImages> banners = [];
  String title;

  HomePageBannerWidget(this.banners, this.title, {super.key});

  @override
  _HomePageBannerWidgetState createState() => _HomePageBannerWidgetState();
}

class _HomePageBannerWidgetState extends State<HomePageBannerWidget>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;
  int _currentIndex = 0;
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
      }

    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            print("Curent index $_currentIndex");
            print("Rishabh Banner");
            print(widget.banners);
            switch (widget.banners[_currentIndex].type) {
              case "product":
                Navigator.of(context).pushNamed(
                  AppRoute.productPage,
                  arguments: getProductDataAttributeMap(
                    widget.banners[_currentIndex].title ?? '',
                    widget.banners[_currentIndex].link ?? '',
                  ),
                );
                break;
              case "category":
                Navigator.of(context).pushNamed(
                  AppRoute.catalog,
                  arguments: categoryMap(
                    widget.banners[_currentIndex].link ?? "",
                    widget.banners[_currentIndex].title ?? "",
                    "",
                    ""
                  ),
                );
                break;
              case "manufacturer":
                Navigator.of(context).pushNamed(
                  AppRoute.catalog,
                  arguments: categoryMap(
                    widget.banners[_currentIndex].link ?? "",
                    widget.banners[_currentIndex].title ?? "",
                    "",
                    ""
                  ),
                );
                break;
              case "external_link":
                String? rawLink = widget.banners[_currentIndex].link;
                if (rawLink != null && rawLink.isNotEmpty) {
                  // Ensure scheme is present
                  if (!rawLink.startsWith("http://") && !rawLink.startsWith("https://")) {
                    rawLink = "https://$rawLink";
                  }

                  final Uri url = Uri.parse(rawLink);
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                    throw 'Could not launch $url';
                  }
                }
                break;
              default:
                break;
            }
          },
          child: CarouselSlider.builder(
            itemCount: widget.banners.length,
            carouselController: _controller,
            options: CarouselOptions(
              height: AppSizes.deviceWidth / 2,
              autoPlay: true,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 5),
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
            ),
            itemBuilder: (context, index, realIndex) {
              final imageUrl = widget.banners[index].image;

              if (imageUrl == null || imageUrl.isEmpty) {
                return Image.asset(
                  AppImages.bannerImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              }
              return Image.network(
                widget.banners[index].image! ?? "",
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppImages.bannerImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        if ((widget.banners.length) > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.banners.length, (index) {
              bool isActive = index == _currentIndex;

              return Padding(
                padding: (index != widget.banners.length - 1)
                    ? const EdgeInsets.only(right: 8.0)
                    : const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2.0),
                  child: isActive
                      ? AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(35, 4),
                        painter: ExpandingFillPainter(
                          _animationController.value,
                              const Color(0xFF0D479C),
                        ),
                      );
                    },
                  )
                      : CustomPaint(
                    size: const Size(10, 4),
                    painter: ExpandingFillPainter(
                      0.0,
                      Theme.of(context).iconTheme.color ?? Colors.blue,
                    ), // No fill
                  ),
                ),
              );
            }),
          ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class ExpandingFillPainter extends CustomPainter {
  final double progress;
  final Color fillColor;

  ExpandingFillPainter(this.progress, this.fillColor);

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = AppColors.darkGray
      ..style = PaintingStyle.fill;

    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Draw background
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(2),
      ),
      backgroundPaint,
    );

    // Draw fill (active)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        const Radius.circular(2),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ExpandingFillPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
