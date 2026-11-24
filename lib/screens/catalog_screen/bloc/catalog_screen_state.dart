import 'package:oc_demo/models/catalog/brand/manufacture_model.dart';

import '../../../models/base_model.dart';
import '../../../models/catalog/catalog_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../models/product_search/product_search_model.dart';

abstract class CatalogScreenState {}

enum CatalogStatus { success, fail }

class OnClickLoaderCatalogState extends CatalogScreenState {
  final bool? isReqToShowLoader;

  OnClickLoaderCatalogState({this.isReqToShowLoader});


}

class ChangeViewState extends CatalogScreenState {
  final bool isGrid;

  ChangeViewState(this.isGrid);

  @override
  List<Object> get props => [isGrid];
}

class CatalogFetchState extends CatalogScreenState {
  final CatalogModel model;
  final bool isFromDb;

  CatalogFetchState(this.model,this.isFromDb);


}

class BrandFetchState extends CatalogScreenState {
  final ManufactureModel manufactureModel;
  final bool isFromDb;
  BrandFetchState(this.manufactureModel,this.isFromDb);


}
class ProductSearchModelState extends CatalogScreenState {
  final ProductSearchModel productSearchModel;
  ProductSearchModelState(this.productSearchModel);


}

class CatalogErrorState extends CatalogScreenState {
  CatalogErrorState(this._message);

  String? _message;

  // ignore: unnecessary_getters_setters
  String? get message => _message;

  // ignore: unnecessary_getters_setters
  set message(String? message) {
    _message = message;
  }


}

class CatalogInitialState extends CatalogScreenState {}

class AddProductToCartStateSuccess extends CatalogScreenState {
  AddProductToCartStateSuccess(this.baseModel, this.productId);

  BaseModel baseModel;
  final String productId;

  @override
  List<Object> get props => [];
}

class WishlistIdleState extends CatalogScreenState {}

class AddProductToWishlistStateSuccess extends CatalogScreenState {
  final AddProductToWishListModel wishListModel;
  final String productId;

   AddProductToWishlistStateSuccess(this.wishListModel,this.productId);

 /* @override
  List<Object> get props => [];*/
}

class CartIdleState extends CatalogScreenState {}
