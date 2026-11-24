import 'package:equatable/equatable.dart';
import '../../../models/base_model.dart';
import '../../../models/previouslyOrderedProducts/previously_ordered_products_model.dart';
import '../../../models/productDetail/add_product_wishlist_model.dart';

abstract class PreviouslyOrderedProductsState extends Equatable {
  const PreviouslyOrderedProductsState();

  @override
  List<Object?> get props => [];
}

class PreviouslyOrderedScreenInitial extends PreviouslyOrderedProductsState {}

class PreviouslyOrderedScreenSuccess extends PreviouslyOrderedProductsState {
  final PreviousOrderResponse? OrderListModel;

  PreviouslyOrderedScreenSuccess(this.OrderListModel);

  @override
  List<Object?> get props => [OrderListModel];
}

class AddProductToCartStateSuccess extends PreviouslyOrderedProductsState {
  final BaseModel baseModel;

  AddProductToCartStateSuccess(this.baseModel);

  @override
  List<Object?> get props => [baseModel];
}

class PreviouslyOrderedScreenError extends PreviouslyOrderedProductsState {
  final String message;
  const PreviouslyOrderedScreenError(this.message);
}

class AddProductToWishlistStateSuccess extends PreviouslyOrderedProductsState {
  final AddProductToWishListModel wishListModel;
  final String productId;

  AddProductToWishlistStateSuccess(this.wishListModel, this.productId);

  @override
  List<Object?> get props => [wishListModel, productId];
}

class AddProductSuccessEmptyState extends PreviouslyOrderedProductsState {


  AddProductSuccessEmptyState();

}