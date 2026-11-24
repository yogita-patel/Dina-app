import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oc_demo/network_manager/api_client.dart';
import 'package:oc_demo/constants/app_routes.dart';
import 'package:oc_demo/constants/arguments_map.dart';
import 'package:oc_demo/common_widgets/alert_message.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'dart:convert';
import 'package:oc_demo/models/base_model.dart';

import '../../constants/app_constants.dart';

class BarcodeScanScreen extends StatefulWidget {
  const BarcodeScanScreen({super.key});

  @override
  State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
}

class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
  bool isFlash = false;
  bool isLoading = false;
  String scannedCode = "";
  String byDefultSelected = "";
  List<dynamic> results = [];
  bool isUserLogin = false;

  final MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    // initialize login state
    AppSharedPref.isLogin().then((value) {
      setState(() {
        isUserLogin = value;
      });
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  Future<void> fetchBarcodeProduct(String code) async {
    setState(() {
      isLoading = true;
      scannedCode = code;
    });

    try {
      final wk = await AppSharedPref.getWkToken();
      final client = ApiClient();
      final resp = await client.barcodeSearch(code, wk);

      results = resp.searchData ?? [];
      byDefultSelected = resp.byDefultSelected ??"";
      print("byDefultSelected--$byDefultSelected");
      if (results.isEmpty) {
        AlertMessage.showError("No product found", context);
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AlertMessage.showError("API Error: ${e.toString()}", context);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner",style: Theme.of(context).textTheme.headlineMedium,),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(isFlash ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await cameraController.toggleTorch();
              setState(() => isFlash = !isFlash);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Scanner view
          SizedBox(
            height: 340,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                final barcode = capture.barcodes.first;
                final raw = barcode.rawValue;

                if (raw != null && raw.isNotEmpty && scannedCode != raw) {
                  fetchBarcodeProduct(raw);
                }
              },
            ),
          ),

          if (isLoading)
            const LinearProgressIndicator(),

          // Result header
          if (scannedCode.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Scanning result for: $scannedCode",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

          // Product List
          Expanded(
            child: results.isEmpty
                ? Center(child: Text("No products"))
                : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final item = results[index];
                return ListTile(
                  leading: Image.network(
                    item.thumb ?? "",
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.name ?? ""),
                  subtitle: Text("${item.productCode ?? ''}",
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(color: AppColors.black)
                    // SizedBox(height: AppSizes.size8),

                  ),
                  trailing: !isUserLogin
                      ? GestureDetector(
                          onTap: ()  async {
                          await  Navigator.of(context).pushNamed(
                              AppRoute.login,
                              arguments: getSignInSignUpPageArgument(false, false),
                            );
                          final value = await AppSharedPref.isLogin();
                          if (!mounted) return;

                          setState(() {
                            isUserLogin = value;
                          });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text("LOG IN TO BUY",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(color: AppColors.white)),
                          ),
                        )
                      : const SizedBox(),
                  // Text(
                  //   "${item.status ?? ''}",
                  // ),
                  onTap: () async {

                    if (!isUserLogin) {
                      Navigator.of(context).pushNamed(
                        AppRoute.productPage,
                        arguments: getProductDataAttributeMap(
                          item.name ?? "",
                          item.productId ?? "",
                        ),
                      );
                    }else  {
                      // Try to add the product to cart regardless of login state (wk token used if present)
                      final wk = await AppSharedPref.getWkToken();
                      final client = ApiClient();

                      // Determine productId robustly (support Map or model)
                      String productId = '';
                      try {
                        if (item is Map) {
                          productId = (item['product_id'] ?? item['productId'])?.toString() ?? '';
                        } else {
                          productId = (item.productId ?? item.product_id)?.toString() ?? '';
                        }
                      } catch (_) {
                        productId = '${item.product_id ?? item.productId ?? ''}';
                      }

                      // Determine unit value based on byDefultSelected (e.g., 'carton', 'inner', 'minipack')
                      String unitValue = '';
                      final defaultKey = byDefultSelected.toString();

                      if (defaultKey.isNotEmpty) {
                        try {
                          if (item is Map) {
                            // try key as-is first, then lowercase variants
                            unitValue = (item[defaultKey] ?? item[defaultKey.toLowerCase()] ?? '').toString();
                          } else {
                            // try common fields
                            if (defaultKey.toLowerCase().contains('carton')) unitValue = (item.carton ?? '').toString();
                            else if (defaultKey.toLowerCase().contains('inner')) unitValue = (item.inner ?? '').toString();
                            else if (defaultKey.toLowerCase().contains('mini')) unitValue = (item.minipack ?? '').toString();
                          }
                        } catch (_) {
                          unitValue = '';
                        }
                      }

                      // Fallbacks if unitValue still empty
                      if (unitValue.isEmpty) {
                        try {
                          if (item is Map) {
                            unitValue = (item['minipack'] ?? item['carton'] ?? item['inner'] ?? item['quantity'] ?? '1').toString();
                          } else {
                            unitValue = (item.minipack ?? item.carton ?? item.inner ?? item.quantity ?? '1').toString();
                          }
                        } catch (_) {
                          unitValue = '1';
                        }
                      }

                      if (unitValue.isEmpty) unitValue = '1';

                      try {
                        // Always attempt to add to cart (send UnitofSalenew from barcode response)
                        debugPrint('Calling addToCart: productId=$productId, quantity=1, unitValue=$unitValue, wk=$wk');

                        if (productId.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            AlertMessage.showError('Invalid product id', context);
                          });
                          return;
                        }

                        final payload = {
                          'product_id': productId,
                          'quantity': '1',
                          'option': '',
                          'width': AppSizes.deviceWidth.toString(),
                          'wk_token': wk,
                          'UnitofSalenew': unitValue,
                        };
                        debugPrint('addToCart payload: ${jsonEncode(payload)}');

                        // If not logged in, send user to login and await result; if they log in, continue


                        // // logged in -> call addToCart
                        // BaseModel? addResp;
                        // try {
                        //   addResp = await client.addToCart(productId, '1', '', AppSizes.deviceWidth.toString(), wk, unitValue);
                        // } catch (e) {
                        //   addResp = null;
                        // }

                        // Inspect response and show details
                        // String addMsg = 'Added to cart';
                        // if (addResp != null) {
                        //   addMsg = addResp.message ?? addResp.cartTotal?.toString() ?? addMsg;
                        //   try {
                        //     final respJson = addResp.toJson();
                        //     debugPrint('addToCart response: ${jsonEncode(respJson)}');
                        //   } catch (_) {}
                        // }
                        //
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   AlertMessage.showSuccess(addMsg, context);
                        // });
                      } catch (e) {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   AlertMessage.showError('Add to cart failed: ${e.toString()}', context);
                        // });
                      }

                      // After addToCart (or login redirect), navigate to product page only if user is logged in
                      if (isUserLogin) {
                        Navigator.of(context).pushNamed(
                          AppRoute.productPage,
                          arguments: getProductDataAttributeMap(
                            item.name ?? "",
                            item.productId ?? "",
                          ),
                        );
                      }
                    }

                   },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
