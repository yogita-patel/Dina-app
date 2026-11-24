import 'package:equatable/equatable.dart';

abstract class QuickCartEvent extends Equatable{
  const QuickCartEvent();

  @override
  List<Object> get props => [];
}

class QuickCartSuggestionEvent extends QuickCartEvent{
  final String searchKey;
  const QuickCartSuggestionEvent(this.searchKey);
}

class GetProductDetailQuickCartEvent extends QuickCartEvent {
  String? productId;
//  String? eTag;
  GetProductDetailQuickCartEvent(this.productId/*,this.eTag*/);

  @override
  List<Object> get props => [];
}
class AddProductToCartEvent extends QuickCartEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  String? UnitofSalenew;
  AddProductToCartEvent(this.productId, this.quantity, this.productOptions,this.UnitofSalenew);
}

class FetchCartEvent extends QuickCartEvent {
  const FetchCartEvent();
}

class CartScreenRemoveItemEvent extends QuickCartEvent {
  const CartScreenRemoveItemEvent(this.key);

  final String key;

  @override
  List<Object> get props => [key];
}


class RemoveItemEvent extends QuickCartEvent{
  final String productId;

  const RemoveItemEvent(this.productId);

  @override
  List<Object> get props => [];
}

/*
* Update cart event
* */
class CartUpdateEvent extends QuickCartEvent {
  const CartUpdateEvent(this.quantityJson, this.UnitOfSalesJson);

  final String quantityJson;
  final String UnitOfSalesJson;

  @override
  List<Object> get props => [quantityJson];
}
class WishlistDataFetchEvent extends QuickCartEvent{

}
class InitialQuickCartSuggestionEvent extends QuickCartEvent{

}
class AddProductToWishListEvent extends QuickCartEvent{
  String? productId;
  String? key;
  String? quantity;
  String? UnitofSalenew;
  AddProductToWishListEvent(this.productId, this.key, this.quantity, this.UnitofSalenew);
}
class MoveToCartEvent extends QuickCartEvent{
  String? productId;
  String? quantity;
  String? productOptions;
  String? UnitofSalenew;
  MoveToCartEvent(this.productId, this.quantity, this.productOptions,this.UnitofSalenew);

  @override
  List<Object> get props => [];

}
