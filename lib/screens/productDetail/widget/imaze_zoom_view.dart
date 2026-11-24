import 'package:flutter/material.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../product_page_image_indicator.dart';


class ZoomImageView extends StatefulWidget {
  ZoomImageView({super.key, this.productImages});
  List<Images>? productImages;

  @override
  _ZoomImageViewState createState() => _ZoomImageViewState();
}

class _ZoomImageViewState extends State<ZoomImageView> {
  final _pageController = PageController(initialPage: 0);
  final _currentPageNotifier = ValueNotifier<int>(0);
  double? imageSize;
  @override
  Widget build(BuildContext context) {
    print(Theme.of(context).brightness);
    imageSize ??= (AppSizes.deviceWidth / 4);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding:  const EdgeInsets.only(top:AppSizes.size14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:AppSizes.size16,right:AppSizes.size16,left:AppSizes.size16,bottom:AppSizes.size8 ),
                    child: Image.asset(
                      AppImages.cancelIcon,
                      width: AppSizes.size16,
                      height: AppSizes.size16,
                      color: MediaQuery.of(context).platformBrightness ==Brightness.light? Colors.black : Colors.white
                    ),
                  )),
              //widgetSpace(),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.productImages?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ImageView(
                      url: widget.productImages?[index].popup,
                    );
                  },
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                ),
              ),
             _buildCircularIndicator(_currentPageNotifier),

              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: AppSizes.marginFive,vertical:AppSizes.spacingDefault ),
              //   child: SizedBox(
              //     height: (AppSizes.width / 4),
              //     child: ListView.builder(
              //         physics: const ClampingScrollPhysics(),
              //         shrinkWrap: true,
              //         scrollDirection: Axis.horizontal,
              //         itemCount: widget.productImages?.length,
              //         itemBuilder: (BuildContext context, int index) {
              //           return GestureDetector(
              //             onTap: () {
              //               //todo
              //               setState(() {
              //                 _pageController = PageController(initialPage: index);
              //               });
              //             },
              //             child: ImageView(
              //               url: widget.productImages?[index].thumb,
              //               width: imageSize!,
              //               height: imageSize!,
              //               fit: BoxFit.fill,
              //             ),
              //           );
              //         }),
              //   ),
              // )

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCircularIndicator(currentPageNotifier){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProductPageImageIndicator(
        dotColor: AppColors.darkGray,
        selectedDotColor: Theme.of(context).bottomAppBarTheme.color ?? Colors.black,
        itemCount: widget.productImages?.length,
        currentPageNotifier: currentPageNotifier,
        productImages: widget.productImages,
        onPageSelected: (int index) {
          currentPageNotifier.value = index;
          setState(() {
            _pageController.animateToPage(index,curve: Curves.ease,duration: const Duration(milliseconds: 300));
          });
        },
      ),
    );

  }
}
