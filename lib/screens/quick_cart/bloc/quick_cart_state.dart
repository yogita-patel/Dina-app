import 'package:equatable/equatable.dart';

import '../../../models/base_model.dart';
import '../../../models/cart/cart_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';
import '../../../models/productDetail/product_detail_screen_model.dart';
import '../../../models/searchModel/search_model.dart';
import '../../../models/wishlist/get_wish_list.dart';


abstract class QuickCartState {
  const QuickCartState();
}

class QuickCartInitialState extends QuickCartState{
  
}
class QuickCartScreenSuccess extends QuickCartState{
  final SearchModel model;
  const QuickCartScreenSuccess(this.model);
}

class ProductDetailStateSuccess extends QuickCartState {
  ProductDetailStateSuccess(this.productDetailScreenModel);

  ProductDetailScreenModel productDetailScreenModel;

/*@override
  List<Object> get props => [];*/
}
class AddProductToCartStateSuccess extends QuickCartState {
  AddProductToCartStateSuccess(this.baseModel);

  BaseModel baseModel;

  @override
  List<Object> get props => [];
}

class CartScreenSuccess extends QuickCartState {
  const CartScreenSuccess(this.data);

  final CartModel data;


}

class RemoveCartItemSuccess extends QuickCartState {
  const RemoveCartItemSuccess(this.data);

  final BaseModel data;


}

class UpdateCartSuccess extends QuickCartState {
  const UpdateCartSuccess(this.data);

  final BaseModel data;


}
class WishlistScreenSuccess extends QuickCartState{
  GetWishlist? wishlistModel;

  WishlistScreenSuccess(this.wishlistModel);

/* @override
  List<Object> get props => [];*/
}


class QuickCartActionState extends QuickCartState{
}

class QuickCartEmptyState extends QuickCartState{
}
class RemoveItemSuccess extends QuickCartState{
  BaseModel? baseModel;

  RemoveItemSuccess(this.baseModel);

/*@override
  List<Object> get props => [];*/
}

class QuickCartScreenError extends QuickCartState {
  const QuickCartScreenError(this.message);

  final String message;
}
class AddProductToWishlistStateSuccess extends QuickCartState {
  AddProductToWishlistStateSuccess(this.wishListModel, this.key);
  final String key;
  AddProductToWishListModel wishListModel;

}
class CompleteState extends QuickCartState {
  const CompleteState();

}
class MoveToCartSuccess extends QuickCartState{
  BaseModel? baseModel;

  MoveToCartSuccess(this.baseModel);

/* @override
  List<Object> get props => [];*/
}