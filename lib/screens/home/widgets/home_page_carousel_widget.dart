/*
import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/widget_space.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../hive/prefetch_service.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget homePageCarouselWidget(
    BuildContext context, List<Carousel>? carouselList) {
  return SizedBox(
    height: (AppSizes.deviceWidth / 2.2),
    child: ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: carouselList!.length,
      itemBuilder: (BuildContext context, int index) {
        var data = carouselList[index];
        Future.delayed(const Duration(seconds: 10), (){
          // call API functionality
          PrefetchService.preFetchManuffacture(data.link??'');
        });
        return homePageCarouselItem(context, carouselList[index]);
      },
      separatorBuilder: (BuildContext context, int index) => widgetSpace(1, 8),
    ),
  );
}

Widget homePageCarouselItem(BuildContext context, Carousel carousel) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          carousel.link ?? "",
          carousel.title ?? "",
          "",
          true,
        ),
      );
    },
    child: Container(
      width: AppSizes.deviceWidth / 3,
      decoration: BoxDecoration(
          border: Border.all(
        color: AppColors.background,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: <Widget>[
            Center(
              child: ImageView(
                url: carousel.image,
                width: (AppSizes.deviceWidth / 3),
                height: (AppSizes.deviceWidth / 3),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.only(
              left: AppSizes.size8,
              top: AppSizes.size8,
              bottom: AppSizes.size8,
            ),
            child: Center(
              child: Text(
                carousel.title ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
*/

import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../models/homPage/home_screen_model.dart';

Widget homePageCarouselWidget(
    BuildContext context, List<ImageManufacturer>? carouselList) {
  print("pankaj ${carouselList!.length}");

  return Padding(
    padding: const EdgeInsets.all(AppSizes.size8),
    child: GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Use parent scroll
      shrinkWrap: true,
      itemCount: carouselList.length>8?8:carouselList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 2 columns
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.68, // Adjust for height/width of card
      ),
      itemBuilder: (BuildContext context, int index) {
        return homePageCarouselItem(context, carouselList[index]);
      },
    ),
  );
}

Widget homePageCarouselItem(BuildContext context, ImageManufacturer carousel) {
  return GestureDetector(
    onTap: () {
      Navigator.of(context).pushNamed(
        AppRoute.catalog,
        arguments: categoryMap(
          carousel.manufacturerId ?? "",
          carousel.name ?? "",
          "",
          "",
          true,
        ),
      );
    },
    child:Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Square image that fills the top
          AspectRatio(
            aspectRatio: 1, // ensures square shape
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // Adjust radius as needed
                child: ImageView(
                  url: carousel.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Text below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:AppSizes.size0,),
            child: Text(
              carousel.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 12
              ),
            ),
          ),
        ],
      ),
    )

  );
}
