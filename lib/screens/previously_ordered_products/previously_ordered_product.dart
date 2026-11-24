import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/previouslyOrderedProducts/previously_ordered_products_model.dart';
import 'bloc/order_screen_events.dart';
import 'bloc/order_screen_state.dart';

import '../../common_widgets/CommonEmptyCard.dart';
import '../../common_widgets/Tabbar/bottom_tabbar.dart';
import '../../common_widgets/alert_message.dart';
import '../../common_widgets/common_tool_bar.dart';
import '../../common_widgets/loader.dart';
import '../../helper/app_localizations.dart';
import 'bloc/order_screen_bloc.dart';
import 'itemList.dart';

class PreviouslyOrderedScreen extends StatefulWidget {
  PreviouslyOrderedScreen(this.isFromDashboard, {super.key});
  bool isFromDashboard = false;

  @override
  _PreviouslyOrderedScreenState createState() =>
      _PreviouslyOrderedScreenState();
}

class _PreviouslyOrderedScreenState extends State<PreviouslyOrderedScreen> {
  final ScrollController _scrollController = ScrollController();
  AppLocalizations? _localizations;
  PreviouslyOrderedProductsBloc? _orderScreenBloc;
  bool isLoading = false;
  bool isFromPagination = false;
  PreviousOrderResponse? orderList;
  List<ProductOrder> recentOrders = [];
  int page = 1;
  String wkToken = "";
  String? productId;
  int? index1;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _orderScreenBloc = context.read<PreviouslyOrderedProductsBloc>();
    AppSharedPref.getWkToken().then((value) {
      wkToken = value;
      _orderScreenBloc?.add(PreviouslyOrderedScreenDataFetchEvent("$page", ""));
    });
    _scrollController.addListener(() {
      if (!widget.isFromDashboard) paginationFunction();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (widget.isFromDashboard)
          ? null
          : commonToolBar(
              _localizations
                      ?.translate(AppStringConstant.previouslyOrderProducts) ??
                  '',
              context),
      body: BlocBuilder<PreviouslyOrderedProductsBloc,
          PreviouslyOrderedProductsState>(builder: (context, currentState) {
        if (currentState is PreviouslyOrderedScreenInitial) {
          if (!isFromPagination) {
            isLoading = true;
          }
        } else if (currentState is PreviouslyOrderedScreenSuccess) {
          isLoading = false;
          isFromPagination = false;
          orderList = currentState.OrderListModel;
          if (page == 1) {
            recentOrders = orderList?.products ?? [];
          } else {
            recentOrders.addAll(orderList?.products ?? []);
          }
        } else if (currentState is AddProductToCartStateSuccess) {
          AppSharedPref.setCartCount(currentState.baseModel.cartTotal!);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.baseModel.message ?? '', context);
            _orderScreenBloc?.add(EmptyEvent());
          });
          //selectedProductOptions?.clear();
        }else if (currentState is AddProductToWishlistStateSuccess) {
          print("AddProductToWishlistStateSuccess ................");
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showSuccess(
                currentState.wishListModel.message ?? '', context);
            _orderScreenBloc?.add(EmptyEvent());
          });
        }

        else if (currentState is PreviouslyOrderedScreenError) {
          isLoading = false;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AlertMessage.showError(currentState.message, context);
          });
        }
        return _buildUI();
      }),
    );
  }

  Widget _buildUI() {
    return Stack(
      children: [
        Visibility(
          visible: recentOrders.isNotEmpty,
          child: getProductView(),
        ),
        Visibility(
          visible: (recentOrders.isEmpty && (!isLoading)),
          child: Center(
            child: CommonEmptyCard(
              imagePath: AppImages.noPreviousOrderIcon,
              title: _localizations
                      ?.translate(AppStringConstant.noPreviousOrdersYet) ??
                  '',
              subtitle: _localizations
                      ?.translate(AppStringConstant.noPreviousOrdersSubtitle) ??
                  '',
              showButton: false,
              showButtonText: false,
              buttonText:
                  _localizations?.translate(AppStringConstant.startShopping) ??
                      '',
              onButtonPressed: () {
                BottomTabController.check.countController?.sink.add(0);
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   AppRoute.bottomTabBAr,
                //       (route) => false,
                // );
              },
            ),
          ),
        ),
        Visibility(visible: isLoading, child: const Loader())
      ],
    );
  }

  Widget getProductView() {
    return ItemListView(
        products: recentOrders,
        bloc: _orderScreenBloc,
        byDefultSelected: orderList?.byDefultSelected ?? '',
        controller: _scrollController,
        localizations: _localizations,
        addProductToWishList: (value, index) {
          index1 = index;
          _orderScreenBloc
              ?.add(PreviouslyOrderedScreenDataFetchEvent("$page", ""));
        });
  }

  void paginationFunction() {
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        (orderList?.cartTotal ?? 0) != recentOrders.length) {
      setState(() {
        var totalPages = (int.parse(orderList?.cartTotal ?? "10") / 10);
        if (page < totalPages) {
          page++;
          if (!(widget.isFromDashboard)) {
            _orderScreenBloc
                ?.add(PreviouslyOrderedScreenDataFetchEvent("$page", ""));
          }
          isFromPagination = true;
        }
      });
    }
  }
}
