import 'package:flutter/material.dart';
import 'package:oc_demo/models/checkout/checkout_payment_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_address_model.dart';
import 'package:oc_demo/models/checkout/checkout_shipping_method_model.dart';

import '../../../../common_widgets/bottom_sheet.dart';
import '../../../../common_widgets/common_tool_bar.dart';
import '../../../../common_widgets/image_view.dart';
import '../../../../common_widgets/title_separated_card.dart';
import '../../../../common_widgets/widget_space.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_routes.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../constants/arguments_map.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_shared_pref.dart';
import '../../../cart/widgets/cart_icon_button.dart';
import 'checkout_shipping_change_address.dart';
import 'orderPriceDetails.dart';

class ShippingView extends StatefulWidget {
  ShippingView({
    required this.checkoutShippingAddressModel,
    required this.checkoutShippingMethodModel,
    required this.checkoutBillingAddressModel,
    required this.updateCarrier,
    required this.onAddAddressSuccess,
    this.isGuestCheckout,
    this.comment,
    this.shippingRequired,
    this.savedAddress = "",
    this.onChangeClick,
    super.key,
  });

  final CheckoutShippingAddressModel? checkoutShippingAddressModel;
  final CheckoutShippingMethodModel? checkoutShippingMethodModel;
  final CheckoutPaymentAddressModel? checkoutBillingAddressModel;
  final ValueChanged<bool> updateCarrier;
  final ValueChanged<bool> onAddAddressSuccess;
  final Function(String)? comment;
  bool? isGuestCheckout;
  bool? shippingRequired;
  String? savedAddress;
  final void Function(String couponText)? onChangeClick;

  @override
  State<ShippingView> createState() => _ShippingViewState();
}

class _ShippingViewState extends State<ShippingView> {
  String? selectedShippingAddressId = "";
  String? selectedBillingAddressId = "";
  String? selectedShippingMethodId = "";
  bool _checked = true;
  AppLocalizations? localizations;

  @override
  void initState() {
    /* _checked = true;*/
    AppSharedPref.isShippingAddressSameAsBilling().then((value) {
      _checked = value;
      getShippingAndBillingAddressID();
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if ((widget.isGuestCheckout ?? false) ==
            false /*widget.checkoutShippingMethodModel?.account!="guest"*/) ...[
          Padding(
            padding: const EdgeInsets.all(AppSizes.size12),
            child: GestureDetector(
              onTap: () async {
                var addressId = "";
                addressId = await AppSharedPref.getBillingAddressId();
                Navigator.of(context)
                    .pushNamed(AppRoute.addEditAddress,
                        arguments:
                            addressId == "0" ? null : {"addressId": addressId})
                    .then((value) {
                  // var success = value["success"];
                  if (value == true) {
                    widget.onAddAddressSuccess(true);
                  } else {
                    widget.onAddAddressSuccess(false);
                  }
                });
              },
              child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.searchBackGroundColor,
                    // Light grey background
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _shippingCard(0)),
            ),
          ),
          // Billing Address
          if ((widget.checkoutBillingAddressModel?.shippingRequired == null ||
              widget.checkoutBillingAddressModel?.shippingRequired ==
                  true)) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
              child: TitleSeparatedCard(
                (localizations?.translate(AppStringConstant.shippingAddress) ??
                    ""),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(
                      height: AppSizes.size12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _checked = !_checked;
                                AppSharedPref.setShippingAddressSameAsBilling(
                                    _checked);
                                if (_checked == true) {
                                  selectedShippingAddressId =
                                      selectedBillingAddressId;
                                  AppSharedPref.setShippingAddressId(
                                      selectedBillingAddressId ?? "");
                                  widget.updateCarrier(false);
                                }
                              });
                            },
                            child: Container(
                              width: AppSizes.size24,
                              height: AppSizes.size24,
                              decoration: BoxDecoration(
                                color: _checked
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _checked
                                      ? Theme.of(context).primaryColorDark
                                      : Colors.grey.shade700,
                                  width: 1.5,

                                  // Theme.of(context)
                                  //                 .textTheme
                                  //                 .titleLarge?.copyWith(fontWeight: FontWeight.w600,color: Theme.of(context).primaryColorDark
                                ),
                              ),
                              child: _checked
                                  ? const Icon(
                                      Icons.check,
                                      size: AppSizes.size18,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.size12,
                          ),
                          Text(
                            (localizations?.translate(
                                    AppStringConstant.sameAsBilling) ??
                                ""),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size4,
                    ),
                    if (!_checked)
                      GestureDetector(
                        onTap: () async {
                          var addressId = "";
                          addressId =
                              await AppSharedPref.getShippingAddressId();

                          Navigator.of(context)
                              .pushNamed(AppRoute.addEditAddress,
                                  arguments: addressId == "0"
                                      ? null
                                      : {"addressId": addressId})
                              .then((value) {
                            // var success = value["success"];
                            if (value == true) {
                              widget.onAddAddressSuccess(true);
                            } else {
                              widget.onAddAddressSuccess(false);
                            }
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.searchBackGroundColor,
                              // Light grey background
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: _shippingCard(1)),
                      ),
                    if (_checked)
                      const SizedBox(
                        height: AppSizes.size10,
                      )
                  ],
                ),
              ),
            ),
            if (widget.shippingRequired == true) ...[
              _shippingMethod(),
              const Divider(
                thickness: 1,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (localizations?.translate(AppStringConstant.items) ?? ""),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          widget.checkoutBillingAddressModel?.items?.length ??
                              0,
                      itemBuilder: (ctx, index) {
                        final items = widget.checkoutBillingAddressModel?.items;
                        return itemCard(
                          items?[index],
                          localizations,
                          index,
                          items?.length ?? 0,
                        );
                      },
                    ),
                  ],
                ),
              ),
              ShippingPriceDetails(
                  widget.checkoutBillingAddressModel, context, localizations),
              const Divider(thickness: 1),
              const SizedBox(height: AppSizes.size20)
            ]
          ],
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
            child: Card(child: guestShipping(widget.savedAddress)),
          ),
          if (widget.shippingRequired == true) ...[
            _shippingMethod(),
            const Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (localizations?.translate(AppStringConstant.items) ?? ""),
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        widget.checkoutBillingAddressModel?.items?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      final items = widget.checkoutBillingAddressModel?.items;
                      return itemCard(
                        items?[index],
                        localizations,
                        index,
                        items?.length ?? 0,
                      );
                    },
                  ),
                ],
              ),
            ),
            ShippingPriceDetails(
                widget.checkoutBillingAddressModel, context, localizations),
            const Divider(thickness: 1),
            const SizedBox(height: AppSizes.size20)
          ]
        ],
      ],
    );
  }

/*addShippingMethodView(){

}*/
  getShippingAndBillingAddressID() {
    if (_checked == true) {
      AppSharedPref.getBillingAddressId().then((value) {
        setState(() {
          selectedBillingAddressId = value;
          selectedShippingAddressId = value;
        });
      });
    } else {
      AppSharedPref.getShippingAddressId().then((value) {
        setState(() {
          selectedShippingAddressId = value;
        });
      });

      AppSharedPref.getBillingAddressId().then((value) {
        setState(() {
          selectedBillingAddressId = value;
        });
      });
    }
    //to get selected shipping method
    AppSharedPref.getSelectedShippingId().then((value) {
      setState(() {
        selectedShippingMethodId = value;
      });
    });
  }

  String getSelectedAddress(int type) {
    var address = "";
    if (type == 0) {
      if (selectedBillingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddBillingAddress) ??
            "";
      } else {
        widget.checkoutBillingAddressModel?.paymentAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedBillingAddressId) {
            address = element.formatted ?? "";
          }
        });
      }
    } else {
      if (selectedShippingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddShippingAddress) ??
            "";
      } else {
        widget.checkoutShippingAddressModel?.shippingAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedShippingAddressId) {
            address = element.formatted ?? "";
          } /*
          else if(selectedShippingAddressId=="0" && selectedBillingAddressId!="0" && element.addressId == selectedBillingAddressId ){
          address = element.formatted ?? "";
        }
        */
          // });
        });
      }
    }

    print("pankaj $address${selectedShippingAddressId!}");
    return address;
  }

  String getSelectedFirstName(int type) {
    var address = "";
    if (type == 0) {
      if (selectedBillingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddBillingAddress) ??
            "";
      } else {
        widget.checkoutBillingAddressModel?.paymentAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedBillingAddressId) {
            address = ("${element.address?.firstname ?? ""} ");
          }
        });
      }
    } else {
      if (selectedShippingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddShippingAddress) ??
            "";
      } else {
        widget.checkoutShippingAddressModel?.shippingAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedShippingAddressId) {
            address = ("${element.address?.firstname ?? ""} ");
          } /*
          else if(selectedShippingAddressId=="0" && selectedBillingAddressId!="0" && element.addressId == selectedBillingAddressId ){
          address = element.formatted ?? "";
        }
        */
          // });
        });
      }
    }

    print("pankaj $address${selectedShippingAddressId!}");
    return address;
  }

  String getSelectedLastName(int type) {
    var address = "";
    if (type == 0) {
      if (selectedBillingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddBillingAddress) ??
            "";
      } else {
        widget.checkoutBillingAddressModel?.paymentAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedBillingAddressId) {
            address = (element.address?.lastname ?? "");
          }
        });
      }
    } else {
      if (selectedShippingAddressId == "0") {
        address = localizations?.translate(
                AppStringConstant.pleaseSelectOrAddShippingAddress) ??
            "";
      } else {
        widget.checkoutShippingAddressModel?.shippingAddress?.addresses
            ?.forEach((element) {
          if (element.addressId == selectedShippingAddressId) {
            address = (element.address?.lastname ?? "");
          } /*
          else if(selectedShippingAddressId=="0" && selectedBillingAddressId!="0" && element.addressId == selectedBillingAddressId ){
          address = element.formatted ?? "";
        }
        */
          // });
        });
      }
    }

    print("pankaj $address${selectedShippingAddressId!}");
    return address;
  }

  Widget guestShipping(String? savedAddress) => Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.size8, vertical: AppSizes.size16),
            child: Text(
              localizations?.translate(AppStringConstant.guestShipping) ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(savedAddress ?? ""),
          )
        ],
      );

  Widget _shippingCard(int type) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.size12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (type == 0) // ) For billing address and 1 for shipping address
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSizes.size16),
                child: Text(
                  type == 0
                      ? (localizations
                              ?.translate(AppStringConstant.billingAddress) ??
                          "")
                      : (localizations
                              ?.translate(AppStringConstant.shippingAddress) ??
                          ""),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            const SizedBox(
              height: AppSizes.size12,
            ),
            Row(
              children: [
                Text(
                  (type == 0
                          ? getSelectedFirstName(0)
                          : getSelectedFirstName(1))
                      .replaceFirstMapped(
                          RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase()),
                  // type == 0 ? getSelectedName(0).toUpperCase() : getSelectedName(1).toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  (type == 0 ? getSelectedLastName(0) : getSelectedLastName(1))
                      .replaceFirstMapped(
                          RegExp(r'^\w'), (m) => m.group(0)!.toUpperCase()),
                  // type == 0 ? getSelectedName(0).toUpperCase() : getSelectedName(1).toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(
              height: AppSizes.size4,
            ),
            Text(
              type == 0 ? getSelectedAddress(0) : getSelectedAddress(1),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: AppSizes.size14, fontWeight: FontWeight.w400),
            ),
            // ListTile(
            //   title: Text(
            //     type == 0 ? getSelectedAddress(0) : getSelectedAddress(1),
            //     style: Theme.of(context)
            //         .textTheme
            //         .bodyText2
            //         ?.copyWith(fontSize: AppSizes.size14),
            //   ),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     size: AppSizes.size18,
            //     color: Colors.grey,
            //   ),
            //   contentPadding: const EdgeInsets.all(AppSizes.size8),
            //
            // ),
            //  const Divider(height: 0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: CartIconButton(
                    leadingIcon: Icons.edit,
                    title: (localizations
                            ?.translate(AppStringConstant.changeAddress) ??
                        ""),
                    onClick: () async {
                      var result = await showMyModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (ctx) => Scaffold(
                          appBar: commonToolBar(
                              (localizations?.translate(
                                      AppStringConstant.selectAddress) ??
                                  ""),
                              context,
                              isElevated: true),
                          body: ChangeAddress(
                              localizations,
                              (type == 0)
                                  ? widget.checkoutBillingAddressModel
                                      ?.paymentAddress
                                  : widget.checkoutShippingAddressModel
                                      ?.shippingAddress,
                              type,
                              _checked, onAddressUpdate: () {
                            getShippingAndBillingAddressID();
                          }),
                        ),
                      );
                      if (result != null) {
                        if (type == 0) {
                          widget.updateCarrier(true);
                        } else if (type == 1) {
                          widget.updateCarrier(false);
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size12,
                ),
                Expanded(
                  child: CartIconButton(
                    leadingIcon: Icons.add,
                    title: (localizations
                            ?.translate(AppStringConstant.newAddress) ??
                        ""),
                    onClick: () {
                      Navigator.of(context)
                          .pushNamed(AppRoute.addEditAddress)
                          .then((value) {
                        if (value == true) {
                          widget.onAddAddressSuccess(true);
                        } else {
                          widget.onAddAddressSuccess(false);
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _shippingMethod() => Padding(
        padding: const EdgeInsets.all(AppSizes.size12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.searchBackGroundColor, // Light grey background
            borderRadius: BorderRadius.circular(6),
          ),
          //color: Theme.of(context).cardColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.size12, vertical: AppSizes.size16),
                child: Text(
                  (localizations
                          ?.translate(AppStringConstant.shippingMethods) ??
                      ""),
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              widget.checkoutShippingMethodModel?.shippingMethods == null
                  ? Padding(
                      padding: const EdgeInsets.all(AppSizes.size16),
                      child: Text(
                        (localizations?.translate(
                                AppStringConstant.noShippingMethod) ??
                            ""),
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => shippingMethodList(widget
                          .checkoutShippingMethodModel
                          ?.shippingMethods
                          ?.shippingMethodList?[index]
                          .quote),
                      separatorBuilder: (BuildContext context, int index) =>
                          widgetSpace(1, AppSizes.size8),
                      itemCount: widget.checkoutShippingMethodModel
                              ?.shippingMethods?.shippingMethodList?.length ??
                          0,
                    ),
            ],
          ),
        ),
      );

  Widget shippingMethodList(List<Quote>? quote) {
    // if(selectedShippingMethodId==""){
    //   selectedShippingMethodId = quote?[0].code;
    // }
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var item = quote?[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RadioListTile<String?>(
              contentPadding: EdgeInsets.zero,
              dense: true,
              visualDensity: const VisualDensity(
                horizontal: -4.0,
                vertical: -4.0,
              ),
              title: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      quote?[index].text ?? "",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              value: item?.code,
              groupValue: selectedShippingMethodId,
              onChanged: (value) async {
                setState(() {
                  selectedShippingMethodId = value;
                });
                await AppSharedPref.setSelectedShippingId(
                    selectedShippingMethodId ?? "");
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSizes.size45, bottom: AppSizes.size6),
              child: Text(
                quote?[index].title ?? "",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: AppSizes.size14),
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(),
      itemCount: quote?.length ?? 0,
    );
  }

  Widget itemCard(Items? product, AppLocalizations? localizations, int index,
      int totalLength) {
    double total = double.tryParse(product?.total?.toString() ?? "0") ?? 0;
    double quantity =
        double.tryParse(product?.quantity?.toString() ?? "1") ?? 1;

    String pricePerUnit =
        quantity != 0 ? (total / quantity).toStringAsFixed(2) : "0.00";

    "£$pricePerUnit";
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoute.productPage,
          arguments: getProductDataAttributeMap(
            product?.name ?? "",
            product?.productId ?? "",
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: index != totalLength - 1
              ? const Border(
                  bottom: BorderSide(
                    color: AppColors.dividerColor,
                    width: 1.0,
                  ),
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: AppSizes.size8),
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.size4),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.grey.shade300, width: AppSizes.size1),
                      ),
                      child: ImageView(
                        url: product?.image ?? '',
                        height: AppSizes.size88,
                        width: AppSizes.size88,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSizes.size10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: AppSizes.size4),
                          child: Text(
                            product?.name ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColorDark),
                          ),
                        ),
                        const SizedBox(height: AppSizes.size10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  // color: const Color(0xFF00C48C),
                                  color: (product?.stock ?? false)
                                      ? (((int.tryParse(product?.carton ??
                                                          "0") ??
                                                      0) *
                                                  10 >
                                              (int.tryParse(
                                                      product?.totalQuantity ??
                                                          "0") ??
                                                  0))
                                          ? const Color(0xFFFFA500)
                                          : product?.totalQuantity == "0"
                                              ? const Color(0xFFE7000B)
                                              : const Color(0xFF00C48C))
                                      : const Color(0xFFE7000B),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                  (product?.stock ?? false)
                                      ? (((int.tryParse(product?.carton ??
                                                          "0") ??
                                                      0) *
                                                  10 >
                                              (int.tryParse(
                                                      product?.totalQuantity ??
                                                          "0") ??
                                                  0))
                                          ? "Low Stock"
                                          : product?.totalQuantity == "0"
                                              ? "Out Of Stock"
                                              : "In Stock")
                                      :
                                      //localizations?.translate(AppStringConstant.inStock) ?? '' :
                                      localizations?.translate(
                                              AppStringConstant.outStock) ??
                                          '',
                                  //(product?.stock ?? false)?localizations?.translate(AppStringConstant.inStock) ?? '':localizations?.translate(AppStringConstant.outStock) ?? '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white)),
                            ),
                            const SizedBox(width: 8),
                            Text(product?.model ?? "",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w400)),
                          ],
                        ),
                        const SizedBox(height: AppSizes.size10),
                        if (product?.price != false)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.size4),
                            child: Row(
                              children: [
                                Text(
                                    "£${pricePerUnit}",
                                    //'£${matchedDiscountPrice != null ? matchedDiscountPrice.toStringAsFixed(2) : product?.total.toStringAsFixed(2) ?? "0.00"}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall),
                                //Text("£${product?.price ?? ""}", style: Theme.of(context).textTheme.headlineSmall),
                                widgetSpace(1, AppSizes.size8),
                                Text(
                                    localizations?.translate(
                                            AppStringConstant.perItem) ??
                                        '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.size8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: AppSizes.size45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(AppSizes.size6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.size12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Total Quantity
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Total Qty ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '${product?.quantity}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          // Total Price
                          Row(
                            children: [
                              Text(
                                'Total ',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '£${product?.total.toStringAsFixed(2)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
