
import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';

AppBar commonToolBar(String heading, BuildContext context,
    { bool isElevated = true, bool isLeadingEnable = false}) {
  return AppBar(
    backgroundColor: Colors.white,
    leading: isLeadingEnable ? IconButton(onPressed: (){Navigator.pop(context);}, icon:  Icon(Icons.clear ,color: Theme.of(context).iconTheme.color,)) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
      child: GestureDetector(onTap:(){Navigator.pop(context);},child: Image.asset(AppImages.backArrow,height: AppSizes.size24,width: AppSizes.size24,
        color: Theme.of(context).iconTheme.color)),
    ),
    elevation: isElevated ? null : 0,
    title: Padding(
      padding: const EdgeInsets.only(right:AppSizes.size48),
      child: Center(
        child: Text(
          heading,
          style: Theme.of(context).textTheme.headlineMedium,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: true,
        ),
      ),
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1.0),
      child: Container(
        color: Colors.grey.shade300,
        height: 1.0,
      ),
    ),
  );
}
