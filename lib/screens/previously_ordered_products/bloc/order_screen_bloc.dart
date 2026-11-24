import 'package:flutter_bloc/flutter_bloc.dart';
import 'order_screen_events.dart';
import 'order_screen_state.dart';
import 'order_screen_repository.dart';

class PreviouslyOrderedProductsBloc extends Bloc<PreviouslyOrderedProductsEvent,
    PreviouslyOrderedProductsState> {
  PreviouslyOrderedScreenRepositoryImp? repository;

  PreviouslyOrderedProductsBloc({this.repository})
      : super(PreviouslyOrderedScreenInitial()) {
    on<PreviouslyOrderedProductsEvent>(mapEventToState);
  }

  void mapEventToState(PreviouslyOrderedProductsEvent event,
      Emitter<PreviouslyOrderedProductsState> emit) async {
    if (event is PreviouslyOrderedScreenDataFetchEvent) {
      emit(PreviouslyOrderedScreenInitial());
      try {
        var model = await repository?.getPreviouslyOrderedList(
            event.page ?? "", event.eTag ?? "");
        if (model != null) {
          emit(PreviouslyOrderedScreenSuccess(model));
        } else {
          emit(const PreviouslyOrderedScreenError(''));
        }
      } catch (error, _) {
        print("rthyjukkk${error.toString()}");
        emit(PreviouslyOrderedScreenError(error.toString()));
      }
    } else if (event is AddToCartEvent) {
      try {
        var model = await repository?.addProductToCart(
            event.productId ?? "",
            event.quantity ?? "",
            event.productOptions ?? "",
            event.UnitofSalenew ?? '');
        if (model != null && model.error == 0) {
          emit(AddProductToCartStateSuccess(model));
        } else {
          emit(PreviouslyOrderedScreenError(model?.message ?? ""));
        }
      } catch (error, _) {
        print(error.toString());
        emit(PreviouslyOrderedScreenError(error.toString()));
      }
    } else if (event is AddToWishlistEvent) {
      try {
        var model = await repository?.addToWishList(event.productId ?? "",
            event.quantity ?? "", event.UnitofSalenew ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model, event.productId ?? ''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(PreviouslyOrderedScreenError(error.toString()));
      }
    }else if (event is EmptyEvent) {
      emit(AddProductSuccessEmptyState());
    }
  }
}
