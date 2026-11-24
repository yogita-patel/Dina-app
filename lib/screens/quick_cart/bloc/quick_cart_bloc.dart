import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oc_demo/screens/quick_cart/bloc/quick_cart_event.dart';
import 'package:oc_demo/screens/quick_cart/bloc/quick_cart_repository.dart';
import 'package:oc_demo/screens/quick_cart/bloc/quick_cart_state.dart';

class QuickCartBloc extends Bloc<QuickCartEvent, QuickCartState> {
  QuickCartRepository? repository;

  QuickCartBloc({this.repository}) : super(QuickCartInitialState()) {
    on<QuickCartEvent>(mapEventToState);
  }

  @override
  void mapEventToState(QuickCartEvent event,
      Emitter<QuickCartState> emit) async {
    if (event is QuickCartSuggestionEvent) {
      emit(QuickCartInitialState());
      try {
        var model = await repository?.getSearchSuggestion(event.searchKey);
        if(model!=null){
          emit(QuickCartScreenSuccess(model));
        }else{
         emit(const QuickCartScreenError("Model is null"));
        }
      } catch (e, _) {
        emit(const QuickCartScreenError("Error in Catch"));
      }
    } else if (event is AddProductToWishListEvent) {
      try {
        var model = await repository?.addProductToWishList(event.productId??"",event.quantity??"", event.UnitofSalenew??"");
        if (model != null && model.error != 1) {
          emit(AddProductToWishlistStateSuccess(model, event.key??""));
        } else {
          emit(const QuickCartScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    } else if(event is GetProductDetailQuickCartEvent){
      try{
        var model = await repository?.getProductDetail(event.productId??"", "", "");
        if(model!=null){
          emit(ProductDetailStateSuccess(model));
        }else{
          emit(const QuickCartScreenError("Model is null"));
        }
      }catch(e){
        emit(const QuickCartScreenError("Error in Catch"));
      }
    }
    else if (event is RemoveItemEvent) {
      try {
        var model = await repository?.removeFromWishlist(event.productId);
        if (model != null && model.error != 1) {
          emit(RemoveItemSuccess(model));
        } else {
          emit(const QuickCartScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    }
    else if (event is MoveToCartEvent) {
      try {
        var model = await repository?.moveToCart(event.productId ?? "",
            event.quantity ?? "", event.productOptions ?? "",event.UnitofSalenew??'');
        if (model != null && model.error == 0) {
          emit(MoveToCartSuccess(model));
        } else {
          emit(QuickCartScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    }
    else if(event is AddProductToCartEvent){
      try{
        var model = await repository?.addProductToCart(event.productId??"", event.quantity??"", event.productOptions??"",event.UnitofSalenew ??'');
        if(model!=null){
          emit(AddProductToCartStateSuccess(model));
        }else{
          emit(const QuickCartScreenError("Model is null"));
        }
      }catch(e){
        emit(const QuickCartScreenError("Error in Catch"));
      }
    }else if (event is FetchCartEvent){
      try{
        var model = await repository?.getCartData();
        if(model!=null){
          emit(CartScreenSuccess(model));
        }else{
          emit(const QuickCartScreenError("Model is null"));
        }
      }catch(e,f){
        print("Error:- $e");
        print("Error:- $f");
        emit(const QuickCartScreenError("Error in Catch"));
      }
    }else if(event is CartScreenRemoveItemEvent){
      try {
        var model = await repository
            ?.removeItemFromCart((event).key);
        if (model != null) {
          emit(RemoveCartItemSuccess(model));
        } else {
          emit(const QuickCartScreenError(""));
        }
      } catch (error, stack) {
        print(stack.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    }else if(event is WishlistDataFetchEvent){
      try {
        var model = await repository?.getWishlistItems("");
        if (model != null) {
          emit(WishlistScreenSuccess(model));
        } else {
          emit(const QuickCartScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    }

    else if(event is CartUpdateEvent){
      try {
        var model = await repository
            ?.updateCartData((event).quantityJson, event.UnitOfSalesJson);
        if (model != null && model.error==0) {
          emit(UpdateCartSuccess(model));
        } else {
          emit(QuickCartScreenError(model?.message??""));
        }
      } catch (error, stack) {
        print(stack.toString());
        emit(QuickCartScreenError(error.toString()));
      }
    }
  }
}
