import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/constants/app_constants.dart';

import '../../../common_widgets/image_view.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';

class FullScreenImageCarousel extends StatefulWidget {
  final List<Images> images;
  final int initialIndex;
  String? title;

  FullScreenImageCarousel({
    super.key,
    required this.images,
    this.initialIndex = 0,
    required this.title
  });

  @override
  State<FullScreenImageCarousel> createState() => _FullScreenImageCarouselState();
}

class _FullScreenImageCarouselState extends State<FullScreenImageCarousel> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: commonAppBar(widget.title??"", context),
        body: Container(
          color: AppColors.white,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final imageUrl = widget.images[index].popup ?? '';
                  return InteractiveViewer(
                    panEnabled: true,
                    minScale: 1,
                    maxScale: 4,
                    child:Center(
                      child: Container(
                        width: AppSizes.deviceWidth,
                        height: AppSizes.deviceWidth,
                        margin: const EdgeInsets.all( AppSizes.size16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: AppColors.grey_border,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ImageView(
                              url: imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    )
                  );
                },
              ),



              if (widget.images.length > 1)
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.images.length, (index) {
                      final bool isActive = _currentIndex == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        width: isActive ? 40 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF0D479C) : const Color(0xFFE5E7EB),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }
}
