import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/app_constants.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../bloc/quick_cart_bloc.dart';
import '../bloc/quick_cart_event.dart';
import '../bloc/quick_cart_state.dart';

class ProductBottomSheet extends StatefulWidget {
  String? productId;
  QuickCartBloc? quickCartBloc;
  ProductBottomSheet({super.key, this.productId,this.quickCartBloc});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  ProductDetailScreenModel? product;
  Map<int, String> selectedUnits = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.quickCartBloc?.add(GetProductDetailQuickCartEvent(widget.productId));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<QuickCartBloc, QuickCartState>(
        bloc: widget.quickCartBloc,
        listener: (context, state) {
          if (state is ProductDetailStateSuccess) {
            print("produt name ${product?.name}");
            setState(() {
              product = state.productDetailScreenModel;
            });
            widget.quickCartBloc?.emit(QuickCartEmptyState());
          } else if (state is QuickCartScreenError) {
            // Handle errors if you want
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? "Error")),
            );
          }
        },
        child: _buildUI(),
      ),
    );
  }

 Widget _buildUI(){
   if (product == null) {
     return const Center(
       child: CircularProgressIndicator(),
     );
   }
    return Column(
      children: [
        Text("${product?.name}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: AppSizes.size72,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '10',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Total Qty",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: AppSizes.size72,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '£20',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Total Price",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],

    );
 }
  }

