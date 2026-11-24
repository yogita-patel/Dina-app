import 'dart:convert';

import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';

import '../../../constants/app_constants.dart';
import '../../../helper/app_shared_pref.dart';
import '../../../hive/hive_constant.dart';
import '../../../hive/hive_service.dart';
import '../../../models/base_model.dart';
import '../../../models/catalog/catalog_model.dart';
import '../../../models/catalog/request/catalog_product_request.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../models/product_search/product_search_model.dart';
import '../../../network_manager/api_client.dart';

abstract class CatalogRepository {
  Future<CatalogModel> getCatalogProducts(
      CatalogProductRequest request, String etag);

  Future<ManufactureModel> getManufactureDetails(
      CatalogProductRequest request, String eTag);

  Future<ManufactureModel?> getManufactureDetailsFromDb(
      CatalogProductRequest request);

  Future<BaseModel?> addProductToCart(
      String productId, String quantity, String/*Map<String, String>?*/ productOption,String UnitofSalenew);
  Future<CatalogModel> getPopularProducts(CatalogProductRequest request, String? eTag);
  Future<CatalogModel?> getPopularProductsFromDb(CatalogProductRequest request);

  Future<CatalogModel> getBestProducts(CatalogProductRequest request, String? eTag);
  Future<CatalogModel?> getBestProductsFromDb(CatalogProductRequest request);

  Future<CatalogModel> getFeaturedProducts(
      CatalogProductRequest request, String eTag);

  Future<CatalogModel> getLatestProduct(
      CatalogProductRequest request, String eTag);

  Future<CatalogModel> getCustomCollection(CatalogProductRequest request);

  Future<CatalogModel?> getCatalogProductsFromDb(CatalogProductRequest request);

  Future<CatalogModel?> getLatestProductsFromDb(CatalogProductRequest request);

  Future<CatalogModel?> getFeatureProductsFromDb(CatalogProductRequest request);
  Future<AddProductToWishListModel?> addToWishList(String productId, String quantity,String UnitofSalenew);
  Future<CatalogModel> getCarouselProducts(CatalogProductRequest request);

  Future<ProductSearchModel?> productSearch(
      String? page,
      String? limit,
      String? width,
      String? tag,
      String? sort,
      String? order,
      String? filter,
      String? wkToken,
      String? eTag,);
}

class CatalogRepositoryImpl extends CatalogRepository {
  /*catalog*/

  @override
  Future<CatalogModel?> getCatalogProductsFromDb(
      CatalogProductRequest request) async {
    CatalogModel? catalogModel;
    String boxname = HiveConstant.catalogBox +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaxsxscj ---->>>>>>>>$boxname");
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive()
            .getBoxes(
                boxname /*HiveConstant.catalogBox + request.page! + request.path! +
            request.sort! + request.filter! + request.order!*/
                )
            .then((value) {
              if(value  is CatalogModel){
            catalogModel = value;
              }

        });
      }
    });

    return catalogModel;
  }

  @override
  Future<CatalogModel> getCatalogProducts(
      CatalogProductRequest request, String etag) async {
    CatalogModel? catalogModel = await ApiClient().getCatalogProducts(
        request.page!,
        request.limit!,
        request.width!,
        request.path!,
        request.sort,
        request.order,
        request.filter,
        request.token!,
        etag);
    String boxname = HiveConstant.catalogBox +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaxsxscj ---->>>>>>>>$boxname");
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;
    /* return await ApiClient().getCatalogProducts(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
        etag
    );*/
  }

  //Brands

  @override
  Future<ManufactureModel> getManufactureDetails(
      CatalogProductRequest request, String? eTag) async {
    ManufactureModel model = await ApiClient().manufactureInfo(
        request.page!,
        request.limit!,
        request.width!,
        request.manufactureId!,
        request.sort ?? "",
        request.order ?? "",
        request.filter??"",
        request.token!,
        eTag ?? '');
    String boxnames = HiveConstant.manufacturerInfo +( request.manufactureId??'');
    await HiveService.getHive().addBoxes(model, boxnames);
    return model;
  }
  @override
  Future<ProductSearchModel> productSearch(
      String? page,
      String? limit,
      String? width,
      String? tag,
      String? sort,
      String? order,
      String? filter,
      String? wkToken,
      String? eTag,) async {
    ProductSearchModel model = await ApiClient().productSearch(
         page,
         limit,
         width,
         tag,
         sort,
         order,
         filter,
         wkToken,
         eTag);
    return model;
  }

  @override
  Future<CatalogModel> getPopularProducts(CatalogProductRequest request,String? etag) async {
    CatalogModel? catalogModel = await ApiClient().popularProducts(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
      etag??''
    );
    String boxname = HiveConstant.popularProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;

  }
@override
  Future<CatalogModel?> getPopularProductsFromDb(CatalogProductRequest request) async {
  CatalogModel? catalogModel;
  String boxname = HiveConstant.popularProduct +
      (request.page ?? "") +
      (request.path ?? "") +
      (request.sort ?? "") +
      (request.filter ?? "") +
      (request.order ?? "");

  await HiveService.getHive().isExists(boxName: boxname).then((value) async {
    if (value) {
      await HiveService.getHive().getBoxes(boxname).then((value) {
        if(value is CatalogModel){
          catalogModel = value;
        }

      });
    }
  });

  return catalogModel;
  }

  /// *
  ///
  /// get best products

  @override
  Future<CatalogModel> getBestProducts(CatalogProductRequest request,String? eTag) async {
    CatalogModel? catalogModel = await ApiClient().bestProducts(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,eTag??''
    );
    String boxname = HiveConstant.bestProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;
  }
  @override
  Future<CatalogModel?> getBestProductsFromDb(
      CatalogProductRequest request) async {
    CatalogModel? catalogModel;
    String boxname = HiveConstant.bestProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");

    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if(value is CatalogModel){
            catalogModel = value;
          }

        });
      }
    });

    return catalogModel;
  }


/*Feature Product start*/
  @override
  Future<CatalogModel?> getFeatureProductsFromDb(
      CatalogProductRequest request) async {
    CatalogModel? catalogModel;
    String boxname = HiveConstant.featureProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaj ---->>>>>>>>$boxname");
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if(value is CatalogModel){
            print("pankaj getFeatureProductsFromDb()-- " "$value");
            catalogModel = value;
          }

        });
      }
    });

    return catalogModel;
  }


  @override
  Future<CatalogModel> getFeaturedProducts(
      CatalogProductRequest request, String eTag) async {
    CatalogModel? catalogModel = await ApiClient().featured(
        request.page!,
        request.limit!,
        request.width!,
        request.path!,
        request.sort,
        request.order,
        request.filter,
        request.token!,
        eTag);
    String boxname = HiveConstant.featureProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;
    /*return await ApiClient().featured(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
    );*/
  }

  /*Feature Product end*/

/*Latest start ----*/
  @override
  Future<CatalogModel?> getLatestProductsFromDb(
      CatalogProductRequest request) async {
    CatalogModel? catalogModel;
    String boxname = HiveConstant.latestProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    print("pankaj ---->>>>>>>>$boxname");
    await HiveService.getHive().isExists(boxName: boxname).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxname).then((value) {
          if(value is CatalogModel){
            print("pankaj getLatestProductsFromDb()-- " "$value");
            catalogModel = value;
          }

        });
      }
    });

    return catalogModel;
  }

  @override
  Future<CatalogModel> getLatestProduct(
      CatalogProductRequest request, String eTag) async {
    CatalogModel? catalogModel = await ApiClient().latestProduct(
        request.page!,
        request.limit!,
        request.width!,
        request.path!,
        request.sort,
        request.order,
        request.filter,
        request.token!,
        eTag);
    String boxname = HiveConstant.latestProduct +
        (request.page ?? "") +
        (request.path ?? "") +
        (request.sort ?? "") +
        (request.filter ?? "") +
        (request.order ?? "");
    await HiveService.getHive().addBoxes(catalogModel, boxname);
    return catalogModel;
    /* return await ApiClient().latestProduct(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
    );*/
  }

/*Latest End*/
  @override
  Future<CatalogModel> getCustomCollection(
      CatalogProductRequest request) async {
    return await ApiClient().getCustomCollection(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.filter,
      request.token!,
    );
  }

  @override
  Future<ManufactureModel?> getManufactureDetailsFromDb(
      CatalogProductRequest request) async {
    ManufactureModel? cacheModel;

    String boxnames = HiveConstant.manufacturerInfo +( request.manufactureId??'');
    await HiveService.getHive().isExists(boxName:boxnames).then((value) async {
      if (value) {
        await HiveService.getHive().getBoxes(boxnames).then((value) {

          if(value is ManufactureModel){
            cacheModel = value;
          }else{
            return null;
          }

        });
      }else{
        HiveService.getHive().deleteBox(boxnames);
      }
    });

    return cacheModel;
  }


  /// ****AddToWishList**/
  @override
  Future<AddProductToWishListModel?> addToWishList(String productId, String quantity, String UnitofSaleNew) async {
    AddProductToWishListModel model= await ApiClient().addProductToWishlist(
        productId, await AppSharedPref.getWkToken(),quantity,UnitofSaleNew);
    return model;
  }




  @override
  Future<CatalogModel> getCarouselProducts(CatalogProductRequest request) async {
    return await ApiClient().getCarouselProducts(
      request.page!,
      request.limit!,
      request.width!,
      request.path!,
      request.sort,
      request.order,
      request.token!,
    );
  }

  @override
  Future<BaseModel?> addProductToCart(String productId, String quantity,
      String productOption,String UnitofSalenew) async {
    BaseModel model = await ApiClient().addToCart(
        productId, quantity, productOption,AppSizes.deviceWidth.toString(), await AppSharedPref.getWkToken(),UnitofSalenew);
    return model;
  }

}
