import 'package:equatable/equatable.dart';
import 'package:oc_demo/models/catalog/request/catalog_product_request.dart';

abstract class CatalogScreenEvent extends Equatable {}

class OnClickLoaderCatalogEvent extends CatalogScreenEvent {
  final bool? isReqToShowLoader;

  OnClickLoaderCatalogEvent({this.isReqToShowLoader});

  @override
  List<Object> get props => [];
}

class ChangeViewEvent extends CatalogScreenEvent {
  final bool isGrid;

  ChangeViewEvent(this.isGrid);

  @override
  List<Object> get props => [];
}

class LoadingEvent extends CatalogScreenEvent {
  LoadingEvent();

  @override
  List<Object?> get props => [];
}

class FetchCatalogEvent extends CatalogScreenEvent {
  FetchCatalogEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
class FetchCatalogBrandEvent extends CatalogScreenEvent {
  FetchCatalogBrandEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [];
}

class FetchProductSearchEvent extends CatalogScreenEvent {
  FetchProductSearchEvent( this.page,
      this.limit,
      this.width,
      this.tag,
      this.sort,
      this.order,
      this.filter,
      this.token,
      this.etag);

  String? page;
  String? limit;
  String? width;
  String? tag;
  String? sort;
  String? order;
  String? filter;
  String? token;
  String? etag;

  @override
  List<Object> get props => [];
}

class FetchPopularEvent extends CatalogScreenEvent {
  FetchPopularEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
class FetchBestEvent extends CatalogScreenEvent {
  FetchBestEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
class FetchFeatureEvent extends CatalogScreenEvent {
  FetchFeatureEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
class FetchLatestEvent extends CatalogScreenEvent {
  FetchLatestEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}
class FetchCarouselsEvent extends CatalogScreenEvent {
  FetchCarouselsEvent(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}

class FetchCustomCollection extends CatalogScreenEvent {
  FetchCustomCollection(this.request);

  final CatalogProductRequest request;

  @override
  List<Object> get props => [request];
}


class FetchCatalogMoreProductEvent extends CatalogScreenEvent {
  FetchCatalogMoreProductEvent(
    this.object, {
    this.selectedFilters,
    this.page,
    this.blockId,
  });

  final String? object;
  final int? page;
  final String? selectedFilters;
  final String? blockId;

  @override
  List<Object> get props => [];
}
class AddProductToCartEvent extends CatalogScreenEvent {
  String? productId;
  String? quantity;
  String? productOptions;
  String? UnitofSalenew;
  AddProductToCartEvent(this.productId, this.quantity, this.productOptions,this.UnitofSalenew);

  @override
  // TODO: implement props
  @override
  List<Object> get props => [];
}

class FetchCatalogSearchedEvent extends CatalogScreenEvent {
  FetchCatalogSearchedEvent(this.key, {this.selectedFilters, this.page});

  final String? key;
  final int? page;
  final String? selectedFilters;

  @override
  List<Object> get props => [];
}
//add to wishlist
class AddToWishlistEvent extends CatalogScreenEvent{
  String? productId;
  String? quantity;
  String? UnitofSalenew;
  AddToWishlistEvent(this.productId, this.quantity, this.UnitofSalenew);

  @override

  List<Object?> get props => throw UnimplementedError();

}
// catalog_screen_event.dart
class ResetCatalogStateEvent extends CatalogScreenEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
