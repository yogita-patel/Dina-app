import 'package:flutter/material.dart';
import 'package:oc_demo/models/checkout/checkout_address_model.dart';

import '../../../../constants/app_constants.dart';
import '../../../../helper/app_localizations.dart';
import '../../../../helper/app_shared_pref.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress(
      this.localizations,
      this.checkoutAddress,
      this.type,
      this.isShippingAddressSameAsBillingAddress, {
        this.onAddressUpdate,
        super.key,
      });

  final AppLocalizations? localizations;
  final CheckoutAddressModel? checkoutAddress;
  final int type;
  final bool isShippingAddressSameAsBillingAddress;
  final VoidCallback? onAddressUpdate;

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  String selectedAddressId = '';

  @override
  void initState() {
    super.initState();
    loadSelectedAddress();
  }

  Future<void> loadSelectedAddress() async {
    String id;
    if (widget.type == 0) {
      id = await AppSharedPref.getBillingAddressId();
    } else {
      id = await AppSharedPref.getShippingAddressId();
    }

    setState(() {
      selectedAddressId = id;
    });
  }

  void handleAddressSelection(String? id) async{
    if (widget.type == 0) {
      AppSharedPref.setBillingAddressId(id ?? "0");
      if (widget.isShippingAddressSameAsBillingAddress) {
        await AppSharedPref.setShippingAddressId(id ?? "0");
        widget.checkoutAddress?.addressId = id ?? "0";
      }
    } else {
      await AppSharedPref.setShippingAddressId(id ?? "0");
      widget.checkoutAddress?.addressId = id ?? "0";
    }

    widget.onAddressUpdate?.call();

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.checkoutAddress?.addresses?.length ?? 0,
      separatorBuilder: (context, index) =>
      const SizedBox(height: AppSizes.size8),
      itemBuilder: (context, index) {
        var address = widget.checkoutAddress?.addresses?[index];
        if (address == null) return const SizedBox.shrink();

        final isSelected = selectedAddressId == address.addressId;

        return Container(
          margin: const EdgeInsets.symmetric(
              horizontal: AppSizes.size16, vertical: AppSizes.size4),
          padding: const EdgeInsets.all(AppSizes.size12),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: () {
              handleAddressSelection(address.addressId);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Checkbox(
                    value: isSelected,
                    side: const BorderSide(color: Colors.grey),
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
                          return const Color(0xFF0D479C);
                        }
                        return Colors.white;
                      },
                    ),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    onChanged: (_) {
                      handleAddressSelection(address.addressId);
                    },
                  ),
                ),
                const SizedBox(width: AppSizes.size8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${address.address?.firstname} ${address.address?.lastname}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${address.address?.address1}, ${address.address?.address2}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${address.address?.city}, ${address.address?.postcode}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${address.address?.zone}, ${address.address?.country}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
