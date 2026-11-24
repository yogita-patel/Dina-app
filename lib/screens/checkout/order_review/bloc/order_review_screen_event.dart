import 'package:equatable/equatable.dart';

abstract class OrderReviewScreenEvent extends Equatable {
  const OrderReviewScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadingEvent extends OrderReviewScreenEvent {
  const LoadingEvent();

  @override
  List<Object> get props => [];
}

class ApplyCouponEvent extends OrderReviewScreenEvent {
  const ApplyCouponEvent(this.applyCoupon);

  final String applyCoupon;

  @override
  List<Object> get props => [applyCoupon];
}

class OrderReviewEvent extends OrderReviewScreenEvent {
  OrderReviewEvent(this.paymentMethod, this.comment, this.agree);
  String paymentMethod, comment, agree;

  @override
  List<Object> get props => [];
}

class PaymentMethodEvent extends OrderReviewScreenEvent {
  PaymentMethodEvent(this.comment);
  String comment;

  @override
  List<Object> get props => [];
}

class PaymentMethodEventWhileShippingNotRequired
    extends OrderReviewScreenEvent {
  const PaymentMethodEventWhileShippingNotRequired();

  @override
  List<Object> get props => [];
}

class OrderPlaceEvent extends OrderReviewScreenEvent {
  const OrderPlaceEvent(
    this.state,
  );

  final String state;
  //final String comment;

  @override
  List<Object> get props => [state];
}

class AddToBackorderEvent extends OrderReviewScreenEvent {
  const AddToBackorderEvent(
      this.productId, this.quantity, this.unitOfSale, this.key);

  final String productId;
  final String quantity;
  final String unitOfSale;
  final String key;

  @override
  List<Object> get props => [productId, quantity, unitOfSale, key];
}

class RemoveItemEvent extends OrderReviewScreenEvent {
  const RemoveItemEvent(this.key);

  final String key;

  @override
  List<Object> get props => [key];
}
