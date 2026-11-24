
import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../common_widgets/circle_page_indicator.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

class HomePageImageCarousel extends StatefulWidget {

  Banners? banner;
  HomePageImageCarousel(this.banner, {super.key});

  @override
  _HomePageImageCarouselState createState() => _HomePageImageCarouselState();
}

class _HomePageImageCarouselState extends State<HomePageImageCarousel> {
  final _currentPageNotifier = ValueNotifier<int>(0);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.banner?.type) {
          case "product":
            Navigator.of(context).pushNamed(
              AppRoute.productPage,
              arguments: getProductDataAttributeMap(
                widget.banner?.title ?? '',
                widget.banner?.link ?? '',
              ),
            );
            break;
          case "category":
            Navigator.of(context).pushNamed(
              AppRoute.catalog,
              arguments: categoryMap(
                widget.banner?.link ?? "",
                widget.banner?.title ?? "",
                "",
                ""
              ),
            );
            break;
          case "manufacturer":
            Navigator.of(context).pushNamed(
              AppRoute.catalog,
              arguments: categoryMap(
                widget.banner?.link ?? "",
                widget.banner?.title ?? "",
                "",
                ""
              ),
            );
            break;
          default:
            break;
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
      return Image.network(
        widget.banner?.image ?? "",
        width: constraints.maxWidth,
        height: constraints.maxWidth/2.8,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: constraints.maxWidth,// fallback ratio like 16:9
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
      );
    },
    )

    );
  }


  Widget _buildCircularIndicator(currentPageNotifier) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.size8),
      child: CirclePageIndicator(
        size: 11,
        selectedSize: 11,
        dotColor: Colors.grey[300],
        selectedDotColor:
            Theme.of(context).bottomAppBarTheme.color ?? Colors.black,
        itemCount: 5,
        currentPageNotifier: currentPageNotifier,
      ),
    );
  }
}
