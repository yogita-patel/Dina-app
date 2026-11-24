import 'package:equatable/equatable.dart';

abstract class PreviouslyOrderedProductsEvent extends Equatable {
  const PreviouslyOrderedProductsEvent();

  @override
  List<Object> get props => [];
}

class PreviouslyOrderedScreenDataFetchEvent
    extends PreviouslyOrderedProductsEvent {
  String? page;
  String? eTag;
  PreviouslyOrderedScreenDataFetchEvent(this.page, this.eTag);
}

class AddToCartEvent extends PreviouslyOrderedProductsEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  String? UnitofSalenew;
  AddToCartEvent(
      this.productId, this.quantity, this.productOptions, this.UnitofSalenew);

  @override
  // TODO: implement props
  @override
  List<Object> get props => [];
}

class AddToWishlistEvent extends PreviouslyOrderedProductsEvent {
  String? productId;
  String? quantity;
  String? UnitofSalenew;
  AddToWishlistEvent(this.productId, this.quantity, this.UnitofSalenew);

  @override
  List<Object> get props => [];
}

class EmptyEvent extends PreviouslyOrderedProductsEvent {}