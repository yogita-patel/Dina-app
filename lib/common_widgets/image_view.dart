import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String? url;
  double height;
  double width;
  BoxFit fit;

  ImageView(
      {super.key, this.url, this.width = 0.0, this.height = 0.0, this.fit = BoxFit.fill});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
      child: CachedNetworkImage(
          imageUrl: url ?? '',
          fit: BoxFit.contain,
          placeholder: (context, url) => Container(
            color: Colors.white,
            width: width != 0.0 ? width : null,
            height: height != 0.0 ? height : null,
          ),
          errorWidget: (context, url, error) {
            return Container(
              color: Colors.white,
              width: width != 0.0 ? width : null,
              height: height != 0.0 ? height : null,
            );
              // Image.asset('assets/images/placeholder.png',
              //   fit: BoxFit.contain);
          }),
    );

    /*previously using below code*/
    /*  return FadeInImage(
      placeholder: const AssetImage('assets/images/placeholder.png'),
      image: NetworkImage(url ?? ''),
      imageErrorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/images/placeholder.png',
            width: width != 0.0 ? width : null,
            height: height != 0.0 ? height : null);
      },
      fit: fit,
      width: width != 0.0 ? width : null,
      height: height != 0.0 ? height : null,
    );*/
  }
}
