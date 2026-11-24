import 'package:flutter/material.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/models/cart/country_data_model.dart';
import 'package:oc_demo/screens/cart/bloc/cart_screen_bloc.dart';

import '../../../../common_widgets/common_outlined_button.dart';
import '../../../../common_widgets/common_text_field.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/app_string_constant.dart';
import '../../../../helper/app_localizations.dart';
import '../../../common_widgets/alert_message.dart';
import '../../../constants/app_routes.dart';
import '../../../main.dart';
import '../../../models/cart/cart_shipping_model.dart';

class EstimateShippingAndTaxesWidget extends StatefulWidget {
  final CountryDataModel? countryDataModel;
  final CartScreenBloc? bloc;
  final Function(String countryId)? onCountrySelected;

  const EstimateShippingAndTaxesWidget(
      this.countryDataModel, this.bloc,
      {super.key, this.onCountrySelected});

  @override
  _EstimateShippingAndTaxesWidgetState createState() =>
      _EstimateShippingAndTaxesWidgetState();
}

class _EstimateShippingAndTaxesWidgetState
    extends State<EstimateShippingAndTaxesWidget> {
  AppLocalizations? _localizations;
  bool isLoading = false;
  String selectedCountry = "";
  String selectedState = "";
  String? countryId, stateId;
  List<Zone>? zoneList;
  List<ShippingMethod>? shippingMethodList;
  TextEditingController postCodeTextContoller = TextEditingController();

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    selectedCountry =
        _localizations?.translate(AppStringConstant.selectCountry) ?? "";
    selectedState =
        _localizations?.translate(AppStringConstant.selectState) ?? "";
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSizes.size14),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(AppSizes.size6),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,
          ),
        ),
        child: ExpansionTile(
            childrenPadding:
            const EdgeInsets.symmetric(horizontal: AppSizes.size16),
            initiallyExpanded: true,
            title: Text(
              _localizations?.translate(AppStringConstant.estimateShippingTax) ??
                  "",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _localizations?.translate(AppStringConstant.country) ?? "Country",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: AppSizes.size8),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        value: countryId,
                        dropdownColor:  Theme.of(context).cardColor,
                        decoration: formFieldDecoration(context, "", "", isRequired: true),
                        items: widget.countryDataModel?.countryData?.map((CountryData value) {
                          return DropdownMenuItem(
                            value: value.countryId,
                            child: SizedBox(
                              width: 200,
                              child: Text(value.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),),
                            ),
                          );
                        }).toList(),
                        hint: SizedBox(
                          width: 200,
                          child: Text(
                            selectedCountry,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w400,color: AppColors.darkGray
                            ),
                          ),
                        ),
                        onChanged: (newValue) {
                          widget.countryDataModel?.countryData?.forEach((element) {
                            if (newValue == element.countryId) {
                              setState(() {
                                selectedCountry = element.name ?? "";
                                countryId = element.countryId;
                                zoneList = element.zone;

                                if (element.zone?.isNotEmpty == true) {
                                  // ✅ Auto-select first state
                                  selectedState = element.zone!.first.name ?? "";
                                  stateId = element.zone!.first.zoneId;
                                } else {
                                  // ✅ No states available
                                  selectedState = "";
                                  stateId = null;
                                }
                              });

                              if (widget.onCountrySelected != null) {
                                widget.onCountrySelected!(countryId!);
                              }
                            }
                          });
                        },

                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.size16),
                  Text(
                      _localizations?.translate(AppStringConstant.selectState) ?? "",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w400,
                      )
                  ),
                  const SizedBox(height: AppSizes.size8),
                  Container(
                    color: Theme.of(context).cardColor,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        value: stateId,
                        dropdownColor:  Theme.of(context).cardColor,
                        decoration: formFieldDecoration(context, "", "", isRequired: true),
                        items: zoneList?.map((Zone value) {
                          return DropdownMenuItem(
                            value: value.zoneId,
                            child: Text(value.name ?? "",style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),),
                          );
                        }).toList(),
                        hint: Text(
                            selectedState,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w400,color: AppColors.darkGray
                            )
                        ),
                        onChanged: (newValue) {
                          zoneList?.forEach((element) {
                            if (newValue == element.zoneId) {
                              setState(() {
                                selectedState = element.name ?? "";
                                stateId = element.zoneId;
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.size16),
                  CommonTextField(
                    labelText: _localizations?.translate(AppStringConstant.postCode) ?? "",
                    controller: postCodeTextContoller,
                    isPassword: false,
                    hintText: _localizations?.translate(AppStringConstant.enterPostCode) ?? "",
                    maxLine: 1,
                    isRequired: true,
                  ),
                  const SizedBox(height: AppSizes.size16),
                  commonButton(
                    width: AppSizes.size126,
                    height: AppSizes.size40,
                    context,
                        () {
                      if ((countryId?.isNotEmpty ?? false) &&
                          (stateId?.isNotEmpty ?? false) &&(postCodeTextContoller.text.isNotEmpty ?? false)) {
                        // widget.bloc.add(GetShippingMethodEvent(
                        //
                        // ));
                        // widget.bloc.emit(CartScreenStateInitial());
                        cartActionDisableToQuote = true;
                        print("dcfddvfdvv..............");
                        Navigator.of(context).pushNamed(
                          AppRoute.cartShipping,
                          arguments: {
                            'countryId': countryId,
                            'stateId': stateId,
                            'postCodeText': postCodeTextContoller.text,
                          },
                        );
                      } else {
                        AlertMessage.showError(
                          _localizations?.translate(
                              AppStringConstant.pleaseSelectCountryOrState) ??
                              "",
                          context,
                        );
                      }
                    },
                    (_localizations?.translate(AppStringConstant.getQuote) ?? "")
                    ,
                    backgroundColor: MobikulTheme.accentColor,
                    textColor: Theme.of(context).primaryColorDark,
                  ),
                  if (isLoading) const Loader(),
                  const SizedBox(height: AppSizes.size8),
                ],
              )
            ]),
      ),
    );



  }
}

