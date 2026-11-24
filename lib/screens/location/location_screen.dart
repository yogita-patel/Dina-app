import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/common_widgets/loader.dart';
import 'package:oc_demo/constants/app_constants.dart';
import 'package:oc_demo/constants/app_string_constant.dart';
import 'package:oc_demo/helper/app_localizations.dart';
import 'package:oc_demo/helper/open_bottom_model_sheet_helper.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double? latitude;
  double? longitude;
  late LatLng position;
  location.Location currentLocation = location.Location();
  GoogleMapController? _controller;
  String address = '';
  Map<String, dynamic> addressMap = {};

  @override
  void initState() {
    // getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }

  Widget _buildUI() {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ((latitude != null) && (longitude != null))
                  ? Stack(
                      children: <Widget>[
                        GoogleMap(
                          compassEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                                latitude ?? 28.6296987, longitude ?? 77.3762753),
                            zoom: 16.0,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                          onCameraMove: (positions) {
                            setState(() {
                              position = positions.target;
                            });
                          },
                          onCameraIdle: () {
                            getLocation(position);
                            setState(() {
                              address = '';
                            });
                          },
                        ),
                        const Positioned(
                            right: 0,
                            top: 0,
                            left: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: AppSizes.size40,
                            )),
                        Positioned(
                            bottom: AppSizes.size15,
                            right: AppSizes.size15,
                            child: InkWell(
                              onTap: (){},
                              child: CircleAvatar(backgroundColor: Theme.of(context).colorScheme.onPrimary,
                                child: const Center(
                                  child: Icon(
                                    Icons.my_location_sharp,
                                  ),
                                ),
                              ),
                            )),
                        GestureDetector(
                          onTap: () {
                            placeSearchBottomModelSheet(context, (value) {
                              print(' callback value $value');
                              placeSearch(value);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(AppSizes.size12),
                            margin: const EdgeInsets.all(AppSizes.size12),
                            color: Theme.of(context).cardColor,
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.search),
                                const SizedBox(
                                  width: AppSizes.size16,
                                ),
                                Text(
                                  AppStringConstant.searchLocation.localized(),
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Loader(),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context, addressMap);
              },
              child: Container(
                padding: const EdgeInsets.all(AppSizes.size8),
                height: AppSizes.deviceHeight / 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_pin),
                        const SizedBox(
                          width: AppSizes.size8,
                        ),
                        Text(AppStringConstant.selectLocation.localized()),
                        const Expanded(
                            child:Align(
                            alignment:Alignment.topRight ,
                           child: Padding(
                              padding: EdgeInsets.all(AppSizes.size6),
                              child: Icon(
                                Icons.done_sharp,
                                color: Colors.red,
                                size: AppSizes.size40,
                              )/*Text(AppStringConstant.ok.localized(),
                                textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                              )*/,
                            )))
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size8,
                    ),
                    (address != '')
                        ? Flexible(
                            child: Text(
                              address,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: AppColors.lightGray),
                              softWrap: true,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Text(AppStringConstant.loadingMessage.localized())
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // void getCurrentLocation() async {
  //   location.LocationData location;
  //   try {
  //     location = await currentLocation.getLocation();
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         AlertMessage.showError(e.message.toString(), context);
  //       });
  //     } else {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         AlertMessage.showError(e.toString(), context);
  //       });
  //     }
  //     Navigator.pop(context);
  //     print('exception----------- $e');
  //   }
  //   setState(() {
  //     latitude = location.latitude;
  //     longitude = location.longitude;
  //   });
  //   position = LatLng(latitude!, longitude!);
  //   _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //     target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
  //     zoom: 16.0,
  //   )));
  // }

  void placeSearch(LatLng location) {
    setState(() {
      latitude = location.latitude;
      longitude = location.longitude;
    });
    position = LatLng(latitude!, longitude!);
    _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(latitude ?? 28.6296987, longitude ?? 77.3762753),
      zoom: 16.0,
    )));
    getLocation(location);
  }

  void getLocation(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    setState(() {
      if ((placemarks.first.street ?? '') != '') {
        address += '${placemarks.first.street}, ';
        addressMap['street1'] = placemarks.first.street;
      }
      if ((placemarks.first.thoroughfare ?? '') != '') {
        address += '${placemarks.first.thoroughfare}, ';
        addressMap['street2'] = placemarks.first.thoroughfare;
      }
      if ((placemarks.first.subLocality ?? '') != '') {
        address += '${placemarks.first.subLocality}, ';
        addressMap['street3'] = placemarks.first.subLocality;
      }
      if ((placemarks.first.locality ?? '') != '') {
        address += '${placemarks.first.locality}, ';
        addressMap['city'] = placemarks.first.locality;
      }
      if ((placemarks.first.administrativeArea ?? '') != '') {
        address += '${placemarks.first.administrativeArea}, ';
        addressMap['state'] = placemarks.first.administrativeArea;
      }
      if ((placemarks.first.postalCode ?? '') != '') {
        address += '${placemarks.first.postalCode}, ';
        addressMap['zip'] = placemarks.first.postalCode;
      }
      if ((placemarks.first.country ?? '') != '') {
        address += '${placemarks.first.country} ';
        addressMap['country'] = placemarks.first.country;
      }
    });
    print(" placemarks------- $placemarks");
    print("------------------------------------------------");
  }
}
