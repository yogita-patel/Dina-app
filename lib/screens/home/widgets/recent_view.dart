//
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:oc_demo/models/homPage/home_screen_model.dart';
//
// import '../../../common_widgets/image_view.dart';
// import '../../../constants/app_constants.dart';
// import '../../../constants/app_routes.dart';
// import '../../../constants/arguments_map.dart';
// import '../../../helper/app_localizations.dart';
// import '../../../hive/hive_constant.dart';
// import '../../../hive/hive_service.dart';
//
//
// class RecentView extends StatefulWidget {
//   const RecentView({Key? key}) : super(key: key);
//
//   @override
//   State<RecentView> createState() => _RecentViewState();
// }
//
// class _RecentViewState extends State<RecentView> {
//   List<Product>? _recentProducts=[];
//   late double _size;
//
//   @override
//   void initState() {
//     _size = (AppSizes.deviceWidth / 3) - AppSizes.linePadding;
//
//     fetchRecentProducts();
//   /*  RecentViewController.controller.stream.listen((event) {
//       fetchRecentProducts();
//     });*/
//
//     super.initState();
//   }
//   @override
//   void didChangeDependencies() {
//     // TODO: implement didChangeDependencies
//
//     super.didChangeDependencies();
//   }
//
//   void fetchRecentProducts() async {
//    /* _recentProducts =
//         await (await AppDatabase.getDatabase()).recentProductDao.getProducts();*/
//    // List<Product>? recentProductList=[];
//     await HiveService.getHive()
//         .isExists(boxName: HiveConstant.recentProduct)
//         .then((value) async {
//       if (value) {
//         await HiveService.getHive()
//             .getBoxes(HiveConstant.recentProduct)
//             .then((value) {
//
//           (value as List).forEach((element) {
//             _recentProducts?.add(element as Product);
//           });
//           //recentProductList = value as  List<Product>;
//           // recentProductList.add(productPageData);
//           /*  HiveService.getHive().addBoxes(
//               recentProductList, HiveConstant.recentProduct);*/
//           //print("pankaj save recent view product()-- " + "${value}");
//           //  subCategoryModel = value as SubCategoryModel;
//         });
//       }
//     });
//
//     setState(() {
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//   //  fetchRecentProducts();
//     return _recentProducts == null || _recentProducts?.isEmpty == true
//         ? Container()
//         : Padding(
//             padding:  EdgeInsets.symmetric(
//               horizontal: AppSizes.size8,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//
//                 Padding(
//                   padding:
//                   const EdgeInsets.symmetric(vertical: AppSizes.size8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Text(AppLocalizations.of(context)?.translate("recentlyProduct")?? "Recently Viewed Products",
//                         style: Theme.of(context).textTheme.headline5,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: AppSizes.size8),
//                 SizedBox(
//                   height: (AppSizes.deviceWidth / 1.6),
//                   child: ListView.builder(
//                     itemBuilder: (ctx, index) {
//                       return GestureDetector(
//                         onTap: () {
//
//                           Navigator.of(context).pushNamed(AppRoute.productPage,
//                               arguments: getProductDataAttributeMap(
//                                   _recentProducts?.elementAt(index).name ?? '', _recentProducts?.elementAt(index).productId ?? ''));
//                          /* Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => BlocProvider(
//                                 create: (context) => ProductScreenBloc(
//                                   repository: ProductScreenRepositoryImp(),
//                                 ),
//                                 child: ProductScreen(
//                                   _recentProducts?.elementAt(index).productId,
//                                   _recentProducts?.elementAt(index).name,
//                                 ),
//                               ),
//                             ),
//                           );*/
//                         },
//                         child: Card(
//                           shadowColor: Colors.black54,
//                           elevation: 2.0,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 ImageView(
//                                   fit: BoxFit.fill,
//                                   url: _recentProducts?.elementAt(index).thumb??"",
//                                   width: (AppSizes.deviceWidth / 2.5) - AppSizes.linePadding,
//                                   height: (AppSizes.deviceWidth / 2.5) - AppSizes.linePadding,
//                                 ),
//                                 const SizedBox(height: 4),
//                                 SizedBox(
//                                   width: _size,
//                                   child: Text(
//                                     _recentProducts?.elementAt(index).price ??
//                                         "",
//                                     style:
//                                         Theme.of(context).textTheme.bodyText1,
//                                     maxLines: 1,
//                                   ),
//                                 ),
//                                 if(Platform.isIOS)
//                                 const SizedBox(height: 10,),
//                                 SizedBox(
//                                   width: _size,
//                                   child: Text(
//                                     _recentProducts?.elementAt(index).name ??
//                                         "",
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     itemCount: _recentProducts?.length,
//                     scrollDirection: Axis.horizontal,
//                   ),
//                 ),
//               ],
//             ),
//           );
//   }
// }



import 'package:flutter/material.dart';
import 'package:oc_demo/screens/home/widgets/recent_product_card.dart';
import 'package:video_player/video_player.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/local_db/floor/database.dart';
import '../../../helper/local_db/floor/entities/recent_product_entitie.dart';
import '../../../helper/local_db/floor/recent_view_controller.dart';


class RecentView extends StatefulWidget {
  bool background;
  RecentView({super.key, this.background = false});

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  List<RecentProduct>? _recentProducts;
  late double _size;
  AppLocalizations? _localizations;

  @override
  void initState() {
    // Calculate responsive size based on device width
    // Use normalized width to ensure consistent sizing on Android and iPad
    final double normalizedWidth = AppSizes.deviceWidth > 600 ? 400.0 : AppSizes.deviceWidth;
    _size = (normalizedWidth / 3) - AppSizes.linePadding;
    fetchRecentProducts();

    RecentViewController.controller.stream.listen((event) {
      fetchRecentProducts();
    });

    super.initState();
  }

  void fetchRecentProducts() async {
    final db = await AppDatabase.getDatabase();
    final products = await db.recentProductDao.getProducts();

    _recentProducts = products.reversed.toList(); // Reverse the list
    // setState(() {});
    if (mounted) setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return _recentProducts == null || _recentProducts?.isEmpty == true
        ? Container()
        : Container(
      color: widget.background?const Color(0xFFF3F4F6):Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.mediumPadding, vertical: AppSizes.mediumPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _localizations?.translate(AppStringConstant.recentlyProduct).localized() ??
                      "Recently viewed products",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.linePadding),
          // Use normalized height for consistent sizing on Android and iPad
          Container(
            height: AppSizes.deviceWidth > 600 ? 230.0 : (AppSizes.deviceWidth / 1.6),
            padding: const EdgeInsets.only(left: AppSizes.size16, right:AppSizes.size10),
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              itemCount: _recentProducts?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return RecentProductCard(
                  product: _recentProducts![index],
                  video: _recentProducts?[index].video_url??"",
                  imageSize: AppSizes.deviceWidth > 600 ? 140.0 : (AppSizes.deviceWidth / 2.7),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

