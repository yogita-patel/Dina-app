import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../models/base_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../../../models/searchModel/search_model.dart';
import '../../../models/wishlist/get_wish_list.dart';
import '../../../network_manager/api_client.dart';

abstract class QuickCartRepository {
  Future<SearchModel> getSearchSuggestion(String text);
  Future<ProductDetailScreenModel?> getProductDetail(
      String productId, String profilePage,String etag);
  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String/*Map<String, String>?*/ productOption,String UnitofSalenew);
  Future<CartModel?> getCartData();
  Future<BaseModel?> removeItemFromCart(String key);
  Future<BaseModel?> updateCartData(String quantityJsonData, String UnitSalesNew);
  Future<GetWishlist> getWishlistItems(String etag);
  Future<BaseModel> removeFromWishlist(String productId);
  Future<AddProductToWishListModel?> addProductToWishList(
      String productId, String quantity, String unitOfSale);
  Future<BaseModel?> moveToCart(String productId, String quantity,
      String  productOption,String UnitofSalenew);
}


class QuickCartImpRepository implements QuickCartRepository{
  @override
  Future<SearchModel> getSearchSuggestion(String text) async {
    return await ApiClient()
        .quickSearchSuggestions(text, await AppSharedPref.getWkToken());
  }
  //quickSearchSuggestions
  @override
  Future<ProductDetailScreenModel?> getProductDetail(
      String productId, String profilePage,String etag) async {

    ProductDetailScreenModel productDetailScreenModel = await ApiClient()
        .getProductDetail(AppSizes.deviceWidth.toString(), productId,
        profilePage, await AppSharedPref.getWkToken(),"6",etag);

    // await HiveService.getHive().addBoxes(productDetailScreenModel, HiveConstant.productPageBox+productId);
    return productDetailScreenModel;
  }

  @override
  Future<BaseModel?> addProductToCart(String productId, String quantity,
      String productOption,String UnitofSalenew) async {
    BaseModel model = await ApiClient().addToCart(
        productId, quantity, productOption,AppSizes.deviceWidth.toString(), await AppSharedPref.getWkToken(),UnitofSalenew);
    return model;
  }

  @override
  Future<CartModel?> getCartData() async {
    CartModel? model = await ApiClient().viewCart(
      AppSizes.deviceWidth.toString(),
      await AppSharedPref.getWkToken(),
    );
    return model;
  }

  @override
  Future<BaseModel?> updateCartData(String quantityJsonData,String UnitSalesNew) async {
    // BaseModel? model = BaseModel();
    BaseModel? model = await ApiClient().updateCart(quantityJsonData,UnitSalesNew,
        await AppSharedPref.getWkToken()
    );
    return model;
  }

  @override
  Future<BaseModel?> removeItemFromCart(String key) async {
    BaseModel? model = await ApiClient().removeFromCart(
        key, await AppSharedPref.getWkToken());
    return model;
  }
  @override
  Future<GetWishlist> getWishlistItems(String etag) async {
    GetWishlist? model;
    model = await ApiClient().getWishlist(
        AppSizes.deviceWidth.toString(), await AppSharedPref.getWkToken(),etag);
    return model;
  }
  @override
  Future<BaseModel> removeFromWishlist(String productId) async {
    BaseModel? model;
    model =
    await ApiClient().removeFromWishlist(productId, await AppSharedPref.getWkToken());
    return model;
  }

  @override
  Future<AddProductToWishListModel?> addProductToWishList(String productId, String quantity, String unitOfSale) async {
    AddProductToWishListModel model = await ApiClient().addProductToWishlist(
        productId, await AppSharedPref.getWkToken(),"$quantity","$unitOfSale");
    return model;
  }
  @override
  Future<BaseModel?> moveToCart(
      String productId, String quantity, String productOption,String UnitofSalenew) async {
    BaseModel model = await ApiClient().moveToCart(
        productId,
        quantity,
        AppSizes.deviceWidth.toString(),
        await AppSharedPref.getWkToken(),UnitofSalenew);
    return model;
  }

  
}