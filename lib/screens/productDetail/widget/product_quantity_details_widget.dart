// /*
// import 'package:flutter/material.dart';
// import 'package:oc_demo/screens/productDetail/Bloc/product_detail_event.dart';
//
// import '../../../common_widgets/common_outlined_button.dart';
// import '../../../common_widgets/quantity_selector.dart';
// import '../../../common_widgets/unit_dropdown.dart';
// import '../../../constants/app_constants.dart';
// import '../../../constants/app_string_constant.dart';
// import '../../../helper/app_localizations.dart';
// import '../../catalog_screen/widget/add_to_basket_subtotal_price_card.dart';
// import '../Bloc/product_detail_bloc.dart';
//
// class ProductQuantityDetailsWidget extends StatefulWidget {
//   ProductDetailBloc? productPageBloc;
//   ProductQuantityDetailsWidget({super.key,this.productPageBloc,});
//
//   @override
//   State<ProductQuantityDetailsWidget> createState() => _ProdcutQuantityDetailsWidgetState();
// }
//
// class _ProdcutQuantityDetailsWidgetState extends State<ProductQuantityDetailsWidget> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   final List<String> unitOptions = ['Carton', 'Box', 'Packet'];
//   String selectedUnit = 'Carton';
//   int quantity = 1;
//   late final AppLocalizations? _localizations;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _localizations = AppLocalizations.of(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(padding: const EdgeInsets.symmetric(
//       horizontal: AppSizes.size16,
//       vertical: AppSizes.size8,
//     ),
//           child: Row(
//             children: <Widget>[
//               Expanded(
//                 child: UnitDropdown(
//                   units: unitOptions,
//                   selectedUnit: selectedUnit,
//                   onChanged: (newUnit) {
//                     // setState(() {
//                     //   selectedUnit = newUnit;
//                     // });
//                   },
//                 ),
//               ),
//               const SizedBox(width: 16),
//               // Quantity Selector
//               Expanded(
//                 child: QuantitySelector(
//                   quantity: quantity,
//                   onIncrement: () {
//                     setState(() {
//                       quantity++;
//                     });
//                   },
//                   onDecrement: () {
//                     setState(() {
//                       if (quantity > 1) quantity--;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.symmetric(
//             horizontal: AppSizes.size16,
//             vertical: AppSizes.size8,
//           ),
//           child: commonButton(
//             context,
//             (){
//               print("Rishabh is making api Call");
//               widget.productPageBloc?.add(AddProductToCartEvent("2337", "$quantity", "",""),);
//             },
//             _localizations?.translate(AppStringConstant.addToBasket) ?? "",
//           ),
//         ),
//       ],
//     );
//
//   }
// }
// */
