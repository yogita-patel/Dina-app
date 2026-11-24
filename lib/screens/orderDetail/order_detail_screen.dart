import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/common_tool_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/orderDetailModel/order_detail_model.dart';
import 'package:oc_demo/screens/orderDetail/bloc/order_detail_screen_bloc.dart';
import 'package:oc_demo/screens/orderDetail/views/order_heading_view.dart';
import 'package:oc_demo/screens/orderDetail/views/order_history.dart';
import 'package:oc_demo/screens/orderDetail/views/order_id_date_view.dart';
import 'package:oc_demo/screens/orderDetail/views/order_price_details.dart';

import '../../common_widgets/image_view.dart';
import '../../common_widgets/widget_space.dart';

class OrderDetails extends StatefulWidget {
  String orderId;

  OrderDetails(this.orderId, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _OrderDetailState();
  }
}

class _OrderDetailState extends State<OrderDetails> {
  AppLocalizations? _localizations;
  bool isLoading = false;
  OrderDetailModel? _orderModel;
  String? orderLoadErrorMessage;
  OrderDetailsBloc? _orderBloc;

  @override
  void initState() {
    super.initState();

    _orderBloc = context.read<OrderDetailsBloc>();
    _orderBloc?.add(OrderDetailFetchEvent(widget.orderId));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonToolBar(
          _localizations?.translate(AppStringConstant.itemOrdered) ?? "",
          context,
          isElevated: false),
      body: BlocConsumer<OrderDetailsBloc, OrderDetailState>(
        listener: (context, state) {
          if (state is AddProductToCartStateSuccess) {
            AlertMessage.showSuccess(state.baseModel.message ?? '', context);
            Navigator.pushNamed(context, AppRoute.cart);
            _orderBloc?.add(OrderDetailResetStateEvent());
          } else if (state is OrderDetailError) {
            AlertMessage.showError(state.message ?? '', context);
          }
        },
        builder: (context, state) {
          if (state is OrderDetailInitial) {
            isLoading = true;
          } else if (state is OrderDetailSuccess) {
            isLoading = false;
            _orderModel = state.model;
            orderLoadErrorMessage = null;
          } else if (state is AddProductToCartStateSuccess ||
              state is OrderDetailError) {
            isLoading = false;
            if (state is OrderDetailError) {
              _orderModel = null;
              orderLoadErrorMessage =
                  (state.message?.trim().isNotEmpty ?? false)
                      ? state.message?.trim()
                      : 'Order not found';
            }
          }
          return /*isLoading ? Loader() :*/ buildUI();
        },
      ),
    );
  }

  Widget buildUI() {
    if ((orderLoadErrorMessage?.isNotEmpty ?? false) && _orderModel == null) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size24),
            child: Text(
              orderLoadErrorMessage ?? 'Order not found',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: Stack(
        children: [
          if (_orderModel != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderIDPlaceDateContainer(
                            context, _orderModel, _localizations),
                        paymentDeliveryInfo(
                            context, _orderModel, _localizations),
                        orderedItemList(),
                        const Divider(thickness: 1),
                        orderPriceDetails(_orderModel ?? OrderDetailModel(),
                            context, _localizations),
                        const Divider(thickness: 1),
                        orderHistoryDetails(_orderModel ?? OrderDetailModel(),
                            context, _localizations),
                        const Divider(thickness: 1),
                        const SizedBox(
                          height: AppSizes.size20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          Visibility(visible: isLoading, child: const Loader())
        ],
      ),
    );
  }

  Widget orderedItemList() {
    print("defefeff${AppSizes.deviceWidth}");
    return orderHeaderLayout(
        context,
        '${_orderModel?.products?.length} ${_localizations?.translate(AppStringConstant.items)}',
        ListView.builder(
            itemCount: _orderModel?.products?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: index != (_orderModel?.products?.length ?? 0) - 1
                      ? const Border(
                          bottom: BorderSide(
                            color: AppColors.dividerColor,
                            width: 1.0,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppSizes.size2,
                        bottom: AppSizes.size8,
                      ),
                      child: Row(
                        children: <Widget>[
                          Stack(children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: AppSizes.size8),
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.all(AppSizes.size4),
                                // space between image and border
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                    width: AppSizes.size1,
                                  ),
                                ),
                                child: ImageView(
                                  url:
                                      _orderModel?.products?[index].image ?? '',
                                  height: AppSizes.size88,
                                  width: AppSizes.size88,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(
                            width: AppSizes.size10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSizes.size4,
                                  ),
                                  child: Text(
                                    _orderModel?.products?[index].name ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .primaryColorDark),
                                  ),
                                ),
                                const SizedBox(height: AppSizes.size10),
                                Text(
                                  _orderModel?.products?[index].model ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(height: AppSizes.size10),
                                _orderModel?.products?[index].price != false
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSizes.size4,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: /*center ? MainAxisSize.min :*/
                                              MainAxisSize.max,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  _orderModel?.products?[index]
                                                          .price ??
                                                      "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                widgetSpace(1, AppSizes.size8),
                                                Text(
                                                  _localizations?.translate(
                                                          AppStringConstant
                                                              .perItem) ??
                                                      '',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                /*  Text(
                              product?.price ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimary),
                            ),*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: AppSizes.deviceWidth / 4,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Total
                              InkWell(
                                  onTap: () {
                                    _orderBloc?.add(ReorderProductEvent(
                                        _orderModel?.orderId ?? "",
                                        _orderModel?.products?[index]
                                                .orderProductId ??
                                            ""));
                                    _orderBloc?.emit(OrderDetailInitial());
                                    //callback(item?.orderId ?? '');
                                  },
                                  child: Image.asset(AppImages.cartButton,
                                      width: AppSizes.size40,
                                      height: AppSizes.size40)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.size10,
                        ),
                        Expanded(
                          child: Container(
                            height: AppSizes.size45,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size6),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.size12,
                            ),
                            // Light grey background
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total Qty ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      _orderModel?.products?[index].quantity ??
                                          "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w400),
                                    ),
                                    Text(
                                      _orderModel?.products?[index].total ?? "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
              //   Column(
              //   children: [
              //     // orderItemCard(
              //     //     _orderModel?.products?[index] ?? OrderedProducts(),
              //     //     context,
              //     //     _localizations),
              //     const Divider(
              //       thickness: 1,
              //       height: 1,
              //     ),
              //     actionContainer(
              //       context,
              //       () {
              //         Navigator.of(context).pushNamed(
              //           AppRoute.returnProduct,
              //           arguments: getProductReturnMap(
              //               _orderModel?.products?[index].productId ?? "",
              //               _orderModel?.orderId ?? ""),
              //         );
              //       },
              //       () {
              //
              //         _orderBloc?.add(ReorderProductEvent(
              //             _orderModel?.orderId ?? "",
              //             _orderModel?.products?[index].orderProductId ??
              //                 ""));
              //         _orderBloc?.emit(OrderDetailInitial());
              //         //callback(item?.orderId ?? '');
              //       },
              //       titleRight: _localizations
              //           ?.translate(AppStringConstant.addToCart),
              //       titleLeft: _localizations
              //           ?.translate(AppStringConstant.returnOrder),
              //       iconRight: Icons.add_shopping_cart,
              //       iconLeft: Icons.assignment_return_outlined,
              //     ),
              //     const Divider(
              //       thickness: 1,
              //       height: 1,
              //     ),
              //   ],
              // );
            }));
  }
}

Widget paymentDeliveryInfo(BuildContext context, OrderDetailModel? orderModel,
    AppLocalizations? localization) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (orderModel?.paymentMethod?.isNotEmpty == true ||
          orderModel?.shippingMethod?.isNotEmpty == true)
        const Divider(thickness: 1),
      if (orderModel?.paymentMethod?.isNotEmpty == true ||
          orderModel?.shippingMethod?.isNotEmpty == true)
        const SizedBox(
          height: AppSizes.size6,
        ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (orderModel?.paymentMethod?.isNotEmpty == true)
              Text(
                '${localization?.translate(AppStringConstant.paymentMethods)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            if (orderModel?.paymentMethod?.isNotEmpty == true)
              Text(
                '${orderModel?.paymentMethod}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            if (orderModel?.shippingMethod?.isNotEmpty == true)
              const SizedBox(height: AppSizes.size16),
            if (orderModel?.shippingMethod?.isNotEmpty == true)
              Text(
                '${localization?.translate(AppStringConstant.deliveryMethod)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            if (orderModel?.shippingMethod?.isNotEmpty == true)
              Text(
                '${orderModel?.shippingMethod}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            if (orderModel?.shippingMethod?.isNotEmpty == true)
              const SizedBox(
                height: AppSizes.size6,
              ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (orderModel?.paymentAddress?.isNotEmpty == true ||
                orderModel?.shippingAddress?.isNotEmpty == true)
              const Divider(thickness: 1),
            if (orderModel?.paymentAddress?.isNotEmpty == true ||
                orderModel?.shippingAddress?.isNotEmpty == true)
              const SizedBox(
                height: AppSizes.size8,
              ),
            if (orderModel?.paymentAddress?.isNotEmpty == true)
              Text(
                '${localization?.translate(AppStringConstant.invoiceAddress)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            if (orderModel?.paymentAddress?.isNotEmpty == true)
              Text(
                '${orderModel?.paymentAddress}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            if (orderModel?.shippingAddress?.isNotEmpty == true)
              const SizedBox(height: AppSizes.size16),
            if (orderModel?.shippingAddress?.isNotEmpty == true)
              Text(
                '${localization?.translate(AppStringConstant.deliveryAddress)}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w400),
              ),
            if (orderModel?.shippingAddress?.isNotEmpty == true)
              Text(
                '${orderModel?.shippingAddress}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            if (orderModel?.shippingAddress?.isNotEmpty == true)
              const SizedBox(
                height: AppSizes.size6,
              ),
          ],
        ),
      ),
      if (orderModel?.paymentMethod?.isNotEmpty == true ||
          orderModel?.shippingMethod?.isNotEmpty == true)
        const Divider(thickness: 1),
    ],
  );
}

Widget actionContainer(
    BuildContext context, VoidCallback leftCallback, VoidCallback rightCallback,
    {IconData? iconLeft,
    IconData? iconRight,
    String? titleLeft,
    String? titleRight}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
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
                    size: AppSizes.size16,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
                  ),
                  Text((titleLeft ?? '').toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold))
                ],
              ),
            )),
        Container(
          color: Colors.grey,
          height: AppSizes.size20,
          width: 1,
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: rightCallback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconRight ?? Icons.add,
                    size: AppSizes.size16,
                  ),
                  const SizedBox(
                    width: AppSizes.size4,
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
