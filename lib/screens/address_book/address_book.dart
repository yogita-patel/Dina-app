import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/app_bar.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/common_widgets/lottie_animation.dart';
import 'package:oc_demo/config/theme.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/models/address/get_address.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_bloc.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_event.dart';
import 'package:oc_demo/screens/address_book/bloc/addressbook_screen_state.dart';
import 'package:oc_demo/screens/address_book/widget/action_container_column.dart';
import 'package:oc_demo/screens/address_book/widget/address_item_card.dart';

class AddressBook extends StatefulWidget {
  bool isFromDashboard;

  AddressBook({super.key, this.isFromDashboard = false});

  @override
  State<AddressBook> createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  late bool _isLoading;
  late AppLocalizations? _localizations;
  GetAddress? _addressModel;

  AddressBookScreenBloc? _addressBookScreenBloc;

  @override
  void didChangeDependencies() {
    _localizations = AppLocalizations.of(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _isLoading = true;
    _addressBookScreenBloc = context.read<AddressBookScreenBloc>();
    _addressBookScreenBloc?.add(const AddressBookDataFetchEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isFromDashboard
          ? null
          : commonAppBar(AppStringConstant.addressBook.localized(), context),
      body: BlocBuilder<AddressBookScreenBloc, AddressBookState>(
        builder: (context, state) {
          if (state is AddressBookInitial) {
            _isLoading = true;
          } else if (state is AddressBookSuccess) {
            _isLoading = false;
            _addressModel = state.model;
          } else if (state is AddressBookError) {
            _isLoading = false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AlertMessage.showError(state.message ?? '', context);
            });
          } else if (state is DeleteAddressSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.model.error != 1) {
                AlertMessage.showSuccess(state.model.message ?? '', context);
              } else {
                AlertMessage.showError(state.model.message ?? '', context);
              }
            });

            _addressBookScreenBloc?.add(const AddressBookDataFetchEvent());
            _addressBookScreenBloc?.add(LoadingAddressEvent());
          }
          return buildUI(context);
        },
      ),
      bottomNavigationBar: SafeArea(child: addAddressContainer(context)),
    );
  }

  Widget buildUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        Visibility(
          visible: _addressModel != null,
          child: SingleChildScrollView(
            child: Column(
              children: [
                addressList(),
              ],
            ),
          ),
        ),
        Visibility(
          visible: (_addressModel == null ||
                  _addressModel?.addressData?.isEmpty == true) &&
              !_isLoading,
          child: LottieAnimation(
            lottiePath: AppImages.emptyAddressLottie,
            title: _localizations?.translate(AppStringConstant.noAddress) ?? "",
            subtitle:
                _localizations?.translate(AppStringConstant.noAddressMessage) ??
                    "",
            buttonTitle:
                _localizations?.translate(AppStringConstant.addNewAddress) ??
                    "",
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AppRoute.addEditAddress)
                  .then((value) {
                if (value == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _addressBookScreenBloc?.add(LoadingAddressEvent());
                    _addressBookScreenBloc
                        ?.add(const AddressBookDataFetchEvent());
                  });
                }
              });
            },
          ),
        ),
        Visibility(
          visible: _isLoading,
          child: const Loader(),
        ),
      ],
    );
  }

  Widget addAddressContainer(BuildContext context) {
    var isDarkMode =
        SchedulerBinding.instance.window.platformBrightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(
           left: AppSizes.size14, right: AppSizes.size14,bottom: AppSizes.size14),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamed(AppRoute.addEditAddress)
              .then((value) {
            if (value == true) {
              _addressBookScreenBloc?.add(LoadingAddressEvent());
              _addressBookScreenBloc?.add(const AddressBookDataFetchEvent());
            }
          });
        },
        style: ElevatedButton.styleFrom(
          shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
          backgroundColor: MobikulTheme.accentColor,
          minimumSize: Size(AppSizes.deviceWidth,  AppSizes.deviceHeight / 20),
        ),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                AppStringConstant.addNewAddress.localized(),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: MobikulTheme.primaryColor
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget addressList() {
    return Padding(
      padding: const EdgeInsets.only(
          top: AppSizes.size0, left: AppSizes.size14, right: AppSizes.size14),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _addressModel?.addressData?.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          var addressData = _addressModel?.addressData?.elementAt(index);
          return AddressItemCard(
            address: addressData?.value ?? "",
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoute.addEditAddress,
                arguments: {"addressId": addressData?.addressId},
              ).then(
                (value) {
                  if (value == true) {
                    _addressBookScreenBloc?.add(LoadingAddressEvent());
                    _addressBookScreenBloc
                        ?.add(const AddressBookDataFetchEvent());
                  }
                },
              );
            },
            actions: ActionContainerColumn(
              bottomCallback: () {
                if ((_addressModel?.addressData?.length ?? 0) > 1) {
                  _addressBookScreenBloc?.add(
                    DeleteAddressEvent(addressData?.addressId.toString() ?? ''),
                  );
                } else {
                  AlertMessage.showWarning(
                      AppStringConstant.minimumOneAddressIsRequired.localized(),
                      context);
                }
              },
              topCallback: () {
                Navigator.of(context).pushNamed(
                  AppRoute.addEditAddress,
                  arguments: {"addressId": addressData?.addressId},
                ).then(
                  (value) {
                    if (value == true) {
                      _addressBookScreenBloc?.add(LoadingAddressEvent());
                      _addressBookScreenBloc
                          ?.add(const AddressBookDataFetchEvent());
                    }
                  },
                );
              },
              imageTop: "assets/icons/pen.png",
              imageBottom: "assets/icons/delete.png",
            ),
          );
        },
      ),
    );
  }
}
