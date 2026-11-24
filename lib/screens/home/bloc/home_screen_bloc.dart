import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:oc_demo/helper/app_shared_pref.dart';
import 'package:oc_demo/models/productDetail/add_product_wishlist_model.dart';

import '../../../models/homPage/home_screen_model.dart';
import '../../../constants/global_data.dart';
import 'home_screen_repository.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenRepository? repository;

  HomeScreenBloc({this.repository}) : super(HomeScreenInitial()) {
    on<HomeScreenEvent>(mapEventToState);
  }

  @override
  void mapEventToState(
      HomeScreenEvent event, Emitter<HomeScreenState> emit) async {
    // if (event is HomeScreenDataFetchEvent) {
    //   emit(HomeScreenInitial());
    //   try {
    //
    //     /*var modelDb = await repository?.getHomeDataFromDb();
    //     if (modelDb != null) {
    //       GlobalData.rootCategories = modelDb.getMenuCategory();
    //       GlobalData.cmsPageData = modelDb.footerMenu;
    //       AppSharedPref.setAvailableCurrencies(modelDb.currencies);
    //       AppSharedPref.setAvailableLanguages(modelDb.languages);
    //       emit(HomeScreenSuccess(modelDb));
    //     } *//*else {
    //       emit(HomeScreenError(''));
    //     }*/
    //
    //     var model = await repository?.getHomeData(/*modelDb?.eTag??*/"");
    //     print("Rishabh model "+model!.languages.toString());
    //     if (model != null) {
    //       print("asdjhfdajd====${model}");
    //       GlobalData.rootCategories = model.categories;
    //       GlobalData.shopCatergory = model.shopCatergory;
    //       GlobalData.subCategory = model.subcategory;
    //       GlobalData.cmsPageData = model.footerMenu;
    //       GlobalData.sideMenu = model.sidemenu;
    //       GlobalData.mainMenu =model.mainMenu;
    //       GlobalData.socialLink =model.social_links;
    //       AppSharedPref.setAvailableCurrencies(model.currencies);
    //       AppSharedPref.setAvailableLanguages(model.languages);
    //       emit(HomeScreenSuccess(model));
    //     } else {
    //       emit(HomeScreenError(''));
    //     }
    //   } catch (error, stack) {
    //     print("Rishabh error"+error.toString());
    //     print("Rishabh stack"+stack.toString());
    //     emit(HomeScreenError(error.toString()));
    //   }
    // }
    if (event is HomeScreenDataFetchEvent) {
      final box = await Hive.openBox('homeBox');
      final cachedJson = box.get('homeData');

      if (cachedJson != null) {
        final cachedModel = HomePageData.fromJson(jsonDecode(cachedJson));
        print("Rishabh Bloc data:= ${cachedModel.toJson()}");
        GlobalData.rootCategories = cachedModel.categories;
        GlobalData.homeCarousels = cachedModel.carousels;
        GlobalData.shopCatergory = cachedModel.shopCatergory;
        GlobalData.subCategory = cachedModel.subcategory;
        GlobalData.cmsPageData = cachedModel.footerMenu;
        GlobalData.sideMenu = cachedModel.sidemenu;
        GlobalData.mainMenu = cachedModel.mainMenu;
        GlobalData.socialLink = cachedModel.social_links;
        GlobalData.getIntouch = cachedModel.getIntouch;
        emit(HomeScreenSuccess(cachedModel, true));
      }

      final freshModel = await repository?.getHomeData("");

      if (freshModel != null) {
        GlobalData.rootCategories = freshModel.categories;
        GlobalData.homeCarousels = freshModel.carousels;
        GlobalData.shopCatergory = freshModel.shopCatergory;
        GlobalData.subCategory = freshModel.subcategory;
        GlobalData.cmsPageData = freshModel.footerMenu;
        GlobalData.sideMenu = freshModel.sidemenu;
        GlobalData.mainMenu = freshModel.mainMenu;
        GlobalData.socialLink = freshModel.social_links;
        GlobalData.getIntouch = freshModel.getIntouch;
        AppSharedPref.setAvailableCurrencies(freshModel.currencies);
        AppSharedPref.setAvailableLanguages(freshModel.languages);

        emit(HomeScreenSuccess(freshModel, false)); // emit updated model
      } else if (cachedJson == null) {
        emit(HomeScreenError('No data found'));
      }
    } else if (event is AddToWishlist) {
      print("jkdkjadajs");
      try {
        var model = await repository?.addToWishList(event.productId ?? "");
        if (model != null && model.error == 0) {
          emit(AddProductToWishlistStateSuccess(model));
        } else {
          emit(HomeScreenError(''));
        }
      } catch (error, _) {
        print(error.toString());
        emit(HomeScreenError(error.toString()));
      }
    }
    /*else if(event is RecentProductEvent){
      print("jkdkjadajs");
      try {
        var model = await repository?.getRecentProduct();
        if (model != null ) {
          emit(RecentproductStateSuccess(model));
        } */ /*
        else {
          emit(HomeScreenError(''));
        }*/ /*
      } catch (error, _) {
        print(error.toString());
       // emit(HomeScreenError(error.toString()));
      }

    }*/
  }
}
