
import 'package:oc_demo/models/previouslyOrderedProducts/previously_ordered_products_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/base_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../network_manager/api_client.dart';

abstract class PreviouslyOrderedProductsRepository {
  Future<PreviousOrderResponse> getPreviouslyOrderedList( String? page,String? eTag);
  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String/*Map<String, String>?*/ productOption,String UnitofSalenew);
  Future<AddProductToWishListModel?> addToWishList(String productId, String quantity,String UnitofSalenew);

}

class PreviouslyOrderedScreenRepositoryImp implements PreviouslyOrderedProductsRepository {


  @override
  Future<PreviousOrderResponse> getPreviouslyOrderedList(String? page,String? etag) async {
    try {
      PreviousOrderResponse? model;
      model = await ApiClient().getPreviouslyOrderedProductsRepository(
          await AppSharedPref.getWkToken(), page ?? "", etag ?? "");
      return model;
    }catch(e, stack) {
      print("Error ${e.toString() }and Stack is $stack");
      throw e;
    }
  }
  @override
  Future<BaseModel?> addProductToCart(String productId, String quantity,
      String productOption,String UnitofSalenew) async {
    BaseModel model = await ApiClient().addToCart(
        productId, quantity, productOption,AppSizes.deviceWidth.toString(), await AppSharedPref.getWkToken(),UnitofSalenew);
    return model;
  }

  @override
  Future<AddProductToWishListModel?> addToWishList(String productId, String quantity, String UnitofSaleNew) async {
    AddProductToWishListModel model= await ApiClient().addProductToWishlist(
        productId, await AppSharedPref.getWkToken(),quantity,UnitofSaleNew);
    return model;
  }
}
