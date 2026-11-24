import 'package:bloc/bloc.dart';
import '../../../../helper/app_shared_pref.dart';
import 'order_review_screen_event.dart';
import 'order_review_screen_repository.dart';
import 'order_review_screen_state.dart';

class OrderReviewScreenBloc
    extends Bloc<OrderReviewScreenEvent, OrderReviewScreenState> {
  OrderReviewScreenRepository? repository;

  OrderReviewScreenBloc({this.repository}) : super(const InitialState()) {
    on<OrderReviewScreenEvent>(mapEventToState);
  }

  void mapEventToState(
    OrderReviewScreenEvent event,
    Emitter<OrderReviewScreenState> emit,
  ) async {
    if (event is PaymentMethodEvent) {
      try {
        var model = await repository?.getPaymentMethods(event.comment);
        if (model != null) {
          emit(PaymentMethodState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error, _) {
        print("$error");
        print("$_");
        emit(OrderReviewScreenError(error.toString()));
      }
    }
    if (event is PaymentMethodEventWhileShippingNotRequired) {
      try {
        var model = await repository?.getPaymentMethodWhenShippingNotRequired();
        if (model != null) {
          emit(PaymentMethodState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is OrderReviewEvent) {
      try {
        var model = await repository?.reviewOrder(
            event.paymentMethod, event.comment, event.agree);
        if (model != null) {
          emit(OrderReviewState(model));
        } else {
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is ApplyCouponEvent) {
      try {
        var model = await repository?.applyCoupon((event).applyCoupon);
        if (model != null && model.error == 0) {
          emit(ApplyCouponSuccess(model));
        } else {
          emit(OrderReviewScreenError(model?.message));
        }
      } catch (error, stack) {
        print(stack.toString());
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is LoadingEvent) {
      emit(OrderReviewLoadingState());
    } else if (event is OrderPlaceEvent) {
      try {
        var model = await repository?.placeOrder(
          event.state,
        );
        if (model != null) {
          print("dsdnfrr..........");
          AppSharedPref.setShippingAddressId("");
          AppSharedPref.setSelectedPaymentId("");
          AppSharedPref.setBillingAddressId("");
          AppSharedPref.setSelectedShippingId("");
          AppSharedPref.setCartCount("0");
          AppSharedPref.setCartAmount("0");
          AppSharedPref.setShippingAddressSameAsBilling(true);
          // AppSharedPref.setCartId("");
          emit(OrderPlaceState(model));
        } else {
          print("dsdnfrr..........");
          emit(OrderReviewScreenError(""));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is AddToBackorderEvent) {
      try {
        var model = await repository?.addProductToWishList(
            event.productId, event.quantity, event.unitOfSale);
        if (model != null && (model.error == 0 || model.error == null)) {
          // After adding to backorder, remove from cart
          var removeModel = await repository?.removeItemFromCart(event.key);
          if (removeModel != null) {
            // Re-fetch order review to update the UI
            String paymentId = await AppSharedPref.getSelectedPaymentId();
            var reviewModel = await repository?.reviewOrder(paymentId, "", "1");
            if (reviewModel != null) {
              emit(OrderReviewState(reviewModel));
            } else {
              // If review fails, we might be in an inconsistent state, but usually repo handles it
            }
          }
        } else {
          emit(OrderReviewScreenError(
              model?.message ?? "Failed to add to backorder"));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    } else if (event is RemoveItemEvent) {
      try {
        var model = await repository?.removeItemFromCart(event.key);
        if (model != null) {
          // Re-fetch order review
          String paymentId = await AppSharedPref.getSelectedPaymentId();
          var reviewModel = await repository?.reviewOrder(paymentId, "", "1");
          if (reviewModel != null) {
            emit(OrderReviewState(reviewModel));
          }
        } else {
          emit(OrderReviewScreenError("Failed to remove item"));
        }
      } catch (error) {
        emit(OrderReviewScreenError(error.toString()));
      }
    }
  }
}
