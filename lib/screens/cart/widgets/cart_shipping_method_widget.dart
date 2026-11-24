import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/models/cart/cart_shipping_model.dart';

import '../../../common_widgets/alert_message.dart';
import '../../../common_widgets/common_outlined_button.dart';
import '../../../common_widgets/widget_space.dart';
import '../../../config/theme.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/app_string_constant.dart';
import '../../../helper/app_localizations.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../main.dart';
import '../../../models/base_model.dart';
import '../bloc/cart_screen_bloc.dart';

class CartShippingMethodWidget extends StatefulWidget {
  const CartShippingMethodWidget({
    super.key,
    required this.countryId,
    required this.stateId,
    required this.postCodeText,
  });

  final String countryId;
  final String stateId;
  final String postCodeText;

  @override
  _CartShippingMethodWidgetState createState() =>
      _CartShippingMethodWidgetState();
}

class _CartShippingMethodWidgetState extends State<CartShippingMethodWidget> {
  AppLocalizations? _localizations;
  String? selectedMethodId;
  bool isLoading = true;
  CartScreenBloc? cartScreenBloc;
  BaseModel? baseModel;
  List<ShippingMethod>? shippingMethodList;
  Quote? selectedQuote;

  @override
  void initState() {
    print("dcfddvfdsddefgfffvv..............");
    cartScreenBloc = context.read<CartScreenBloc>();
    cartScreenBloc?.add(GetShippingMethodEvent(
      widget.countryId ?? "",
      widget.stateId ?? "",
      widget.postCodeText ?? "",
    ));
    Future.delayed(const Duration(seconds: 2), () {
      print("dcfddvfdvv..............");
      cartActionDisableToQuote = false;
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size14),
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AppImages.backArrow,
                  height: AppSizes.size24,
                  width: AppSizes.size24,
                )),
          ),
          title: Padding(
            padding: const EdgeInsets.only(right: AppSizes.size48),
            child: Center(
              child: Text(
                _localizations?.translate(AppStringConstant.deliveryOptions) ??
                    "",
                style: Theme.of(context).textTheme.headlineMedium,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: true,
              ),
            ),
          ),
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  AppImages.crossBackButton,
                  height: AppSizes.size40,
                  width: AppSizes.size40,
                ))
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
              left: AppSizes.size14,
              right: AppSizes.size14,
              bottom: AppSizes.size30),
          child: commonButton(
            width: AppSizes.size126,
            height: AppSizes.size45,
            context,
            () async {
              if (selectedQuote != null) {
                await AppSharedPref.setSelectedShippingId(
                    selectedQuote?.code ?? "");
                cartScreenBloc
                    ?.add(ApplyShippingEvent(selectedQuote?.code ?? ''));
                cartScreenBloc?.emit(CartScreenStateInitial());
                isLoading = true;
              } else {
                AlertMessage.showError(
                    "Please select a shipping method", context);
              }
            },
            (_localizations?.translate(AppStringConstant.applyDeliveryCost) ??
                    "")
                .toUpperCase(),
            backgroundColor: MobikulTheme.accentColor,
            textColor: Theme.of(context).primaryColorDark,
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CartScreenBloc, CartScreenState>(
            builder: (context, currentState) {
              if (currentState is CartScreenStateInitial) {
                isLoading = true;
              } else if (currentState is GetShippingMethodStateSuccess) {
                isLoading = false;
                shippingMethodList = currentState.data.shippingMethod;
              } else if (currentState is ApplyShippingStateSuccess) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  (currentState.data.message?.isEmpty == true)
                      ? ""
                      : AlertMessage.showSuccess(
                          currentState.data.message ?? "", context);
                  print(
                      "Back button pressed ............................................");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                });
              } else if (currentState is CartScreenError) {
                isLoading = false;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  AlertMessage.showError(currentState.message ?? '', context);
                });
                cartScreenBloc?.emit(const CompleteState());
              }
              if (isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _buildRadio(0, shippingMethodList);
            },
          ),
        ),
      ),
    );
    //_buildRadio(0, widget.shippingMethodList));
  }

  Widget _buildRadio(int attributeId, List<ShippingMethod>? data) =>
      ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) => buildShippingMethodList(
            shippingMethodList?[index].title, shippingMethodList?[index].quote),
        separatorBuilder: (BuildContext context, int index) =>
            widgetSpace(1, AppSizes.size8),
        itemCount: data?.length ?? 0,
      );

  Widget buildShippingMethodList(String? title, List<Quote>? quote) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: AppSizes.size14, left: AppSizes.size12),
                child: Text((title ?? ""),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: AppSizes.size14),
                    textAlign: TextAlign.start),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppSizes.size6,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      quote?.length ?? 0,
                      (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RadioListTile<String>(
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets
                                  .zero, // Ensure radio is on the left
                              visualDensity: const VisualDensity(vertical: -4),
                              dense: true,
                              selected: false,
                              subtitle: Text(quote?[index].text ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w600)),
                              activeColor: Colors.black,
                              value: quote?[index].title ?? "",
                              groupValue: (quote?[index].isSelected ?? false)
                                  ? (quote?[index].title)
                                  : "",
                              onChanged: (value) {
                                for (Quote d in quote!) {
                                  d.isSelected = false;
                                }
                                quote[index].isSelected = true;
                                setState(() {
                                  selectedQuote =
                                      quote[index]; // Save selected quote
                                  selectedMethodId = selectedQuote?.code;
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 55.0),
                              child: Text(
                                quote?[index].title ?? "",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        );
                      },
                    )),
              ),
            ],
          );
  }
}
