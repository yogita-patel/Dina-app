// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/image_view.dart';
import '../../../common_widgets/product_status_badges.dart';
import '../../../constants/app_constants.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import 'full_screen_image_carousel.dart';

class ProductDetailsImageWidget extends StatefulWidget {
  List<Images> productImages;
  String? title;
  dynamic bought;
  ProductDetailsImageWidget(this.productImages, this.title,
      {super.key, this.bought});
  @override
  _ProductDetailsImageWidgetState createState() =>
      _ProductDetailsImageWidgetState();
}

class _ProductDetailsImageWidgetState extends State<ProductDetailsImageWidget>
    with TickerProviderStateMixin {
  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  final CarouselSliderController _controller = CarouselSliderController();
  int _currentPage = 0;
  int _currentIndex = 0;
  Timer? _timer;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < widget.productImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      // _pageController.animateToPage(_currentPage,
      //     duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(_currentPage,
            duration: const Duration(milliseconds: 60), curve: Curves.easeIn);
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF3F4F6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(),
                    backgroundColor: Colors.black,
                    builder: (ctx) => DraggableScrollableSheet(
                        expand: true,
                        maxChildSize: 1,
                        initialChildSize: 0.968, // starts at 95% height
                        builder: (context, scrollController) {
                          return SafeArea(
                            child: FullScreenImageCarousel(
                              images: widget.productImages,
                              initialIndex: _currentIndex,
                              title: widget.title ?? "",
                            ),
                          );
                        }));
              },
              child: CarouselSlider.builder(
                itemCount: widget.productImages.length,
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 1,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.84,
                  enlargeCenterPage: true,
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
                  double containerSize =
                      MediaQuery.of(context).size.width * 0.84;

                  return Center(
                    child: Container(
                      width: containerSize,
                      height: containerSize,
                      margin: const EdgeInsets.only(top: AppSizes.size8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.grey_border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ImageView(
                                url: widget.productImages[index].popup
                                    .toString(),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          if (ProductStatusBadges.shouldShowBought(
                              widget.bought))
                            const Positioned(
                              top: AppSizes.size24,
                              right: AppSizes.size24,
                              child: ProductBoughtBadge(),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            if ((widget.productImages.length) > 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.productImages.length, (index) {
                  bool isActive = index == _currentIndex;

                  return Padding(
                    padding: (index != widget.productImages.length - 1)
                        ? const EdgeInsets.only(right: 8.0)
                        : const EdgeInsets.only(right: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.0),
                      child: isActive
                          ? AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return CustomPaint(
                                  size: const Size(35, 6),
                                  painter: ExpandingFillPainter(
                                    _animationController.value,
                                    const Color(0xFF0D479C),
                                  ),
                                );
                              },
                            )
                          : CustomPaint(
                              size: const Size(10, 6),
                              painter: ExpandingFillPainter(
                                0.0,
                                Colors.blue,
                              ), // No fill
                            ),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
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
        const Radius.circular(200),
      ),
      backgroundPaint,
    );

    // Draw fill (active)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * progress, size.height),
        const Radius.circular(200),
      ),
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant ExpandingFillPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
