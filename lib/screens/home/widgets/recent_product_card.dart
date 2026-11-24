import 'package:flutter/material.dart';

import '../../../common_widgets/image_view.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/arguments_map.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../helper/local_db/floor/entities/recent_product_entitie.dart';

class RecentProductCard extends StatefulWidget {
  final RecentProduct product;
  final double imageSize;
  final String? video;

  const RecentProductCard({super.key, required this.product, required this.imageSize, this.video});

  @override
  State<RecentProductCard> createState() => _RecentProductCardState();
}

class _RecentProductCardState extends State<RecentProductCard> {
  bool isUserLogin = false;

  @override
  void initState() {
    super.initState();
    AppSharedPref.isLogin().then((value) {
      if (value) {
        setState(() {
          isUserLogin = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rishabh name ${widget.product.name} url ${widget.product.video_url}");
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoute.productPage,
          arguments: getProductDataAttributeMap(
            widget.product.name ?? "",
            widget.product.productId ?? "",
          ),
        );
      },
      child: _buildProductCard(),
    );
  }

  Widget _buildProductCard(){
    return SizedBox(
      width: AppSizes.deviceWidth / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: AppSizes.size8),
            width: widget.imageSize,
            height: widget.imageSize, // Ensures square shape
            decoration: BoxDecoration(
              color: Colors.white, // Container background color
              border: Border.all(
                color: AppColors.grey_border, // Customize border color
                width: 1,         // Customize border width
              ),
              borderRadius: BorderRadius.circular(10), // Optional rounded corners
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Match border radius if any
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ImageView(
                  url: widget.product.image.toString() ?? '',
                  width: widget.imageSize??0,
                  height: widget.imageSize??0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Text(
              widget.product.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.text_color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              (widget.product.price != false && isUserLogin)
                  ? Padding(
                padding: const EdgeInsets.only(left: AppSizes.size0),
                child: Text(
                  widget.product.price.toString() ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              )
                  : const SizedBox(),

                const SizedBox(
                  width: AppSizes.size8,
                ),
            ],
          ),
        ],
      ),
    );

  }
}
