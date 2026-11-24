import 'package:flutter/material.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderListModel/order_list_model.dart';

Widget orderMainView(
    BuildContext context,
    List<OrderListData>? orders,
    AppLocalizations? localizations,
    Function(String orderId) callback,
    ScrollController controller,
    {ScrollPhysics scrollPhysics = const AlwaysScrollableScrollPhysics()}) {
  return ListView.separated(
    controller: controller,
    shrinkWrap: true,
    physics: scrollPhysics,
    itemBuilder: (ctx, index) =>
        orderItem(context, orders?[index], localizations, callback),
    separatorBuilder: (ctx, index) => const SizedBox(
        // height: AppSizes.size4,
        // child: Divider(color: AppColors.darkGray,),
        ),
    itemCount: (orders?.length ?? 0),
  );
}

Widget orderItem(BuildContext context, OrderListData? item,
    AppLocalizations? localizations, Function(String) callback) {
  return InkWell(
    onTap: (){Navigator.of(context).pushNamed(
      AppRoute.orderDetail,
      arguments: item?.orderId ?? "",
    );},
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: AppSizes.size20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "#${item?.orderId.toString() ?? " "}",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: AppSizes.size8),
                  statusContainer(context, item?.status ?? ''),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item?.dateAdded ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w400)),
                  const SizedBox(height: AppSizes.size8),
                  Text(item?.total ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
              Text("${item?.products ?? 0} ${localizations?.translate(AppStringConstant.items) ?? ''}",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w400)),
            ],
          ),
          const SizedBox(height: AppSizes.size12),
           Divider(
            thickness: 1,
            height: 1,
            color: Colors.grey.shade300,
          ),

          // const SizedBox(height: AppSizes.size26),
          // const Divider(
          //   thickness: 1,
          //   height: 1,
          //   color: AppColors.lightGray,
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child:
          //   Container(
          //     child: Center(
          //       child: Text(
          //           localizations!.translate(AppStringConstant.writeAReview),
          //
          //           //    "Order Date : ",
          //           style: Theme.of(context).textTheme.headline3?.copyWith(
          //               fontWeight: FontWeight.w500, fontSize: 18)),
          //     ),
          //   ),
          // ),
          // actionContainer(
          //   context,
          //   () {
          //     Navigator.of(context).pushNamed(
          //       AppRoute.orderDetail,
          //       arguments: item?.orderId ?? "",
          //     );
          //   },
          //   () {
          //     callback(item?.orderId ?? '');
          //   },
          //   titleRight: localizations?.translate(AppStringConstant.reviews),
          //   titleLeft: localizations?.translate(AppStringConstant.details),
          //   iconRight: Icons.rate_review_outlined,
          //   iconLeft: Icons.arrow_forward_sharp,
          // ),
        ],
      ),
    ),
  );
}

Widget statusContainer(BuildContext context, String status) {
  return Container(
    decoration: BoxDecoration(
      color: containerColor(status), // background color
      borderRadius: BorderRadius.circular(6), // rounded corners
    ),
    padding: const EdgeInsets.symmetric(
        vertical: AppSizes.size6, horizontal: AppSizes.size12),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          status,
          style: Theme.of(context)
              .textTheme
              .titleLarge?.copyWith(color: textColor(status)),
        )),
      ],
    ),
  );
}

Color containerColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.completedColor;
    case 'PROCESSING':
      return AppColors.processingColor;
    case 'PENDING':
      return AppColors.pendingColor;
    default:
      return AppColors.pendingColor;
  }
}

Color textColor(String status) {
  switch (status.toUpperCase()) {
    case 'COMPLETE':
      return AppColors.white;
    case 'PROCESSING':
      return AppColors.white;
    case 'PENDING':
      return AppColors.black;
    default:
      return AppColors.black;
  }
}

//==Todo change with address card
Widget actionContainer(
    BuildContext context, VoidCallback leftCallback, VoidCallback rightCallback,
    {IconData? iconLeft,
    IconData? iconRight,
    String? titleLeft,
    String? titleRight}) {
  return Padding(
    padding: const EdgeInsets.all(AppSizes.size14),
    child: Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: leftCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconLeft ?? Icons.edit,
                    size: AppSizes.size24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: AppSizes.size8,
                  ),
                  Text((titleLeft ?? '').toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: rightCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconRight ?? Icons.add,
                    size: AppSizes.size24,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(
                    width: AppSizes.size8,
                  ),
                  Text(
                      // _localizations?.translate(AppStringConstant.newAddress) ??
                      (titleRight ?? "").toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
      ],
    ),
  );
}
