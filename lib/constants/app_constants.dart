import 'package:flutter/material.dart';

import '../../helper/extension.dart';

class ApiConstant {
  /// *************************************************Builder live demo *******************************************

  //static const String baseUrl = "https://www.dinainternational.co.uk/";
  static const String baseUrl = "https://www.dinainternational.com/";
  static const String pdfCataloguePath =
      "index.php?route=api/wkrestapi/pdf_catalogue/download";
  static const String pdfCatalogueUrl = "$baseUrl$pdfCataloguePath";
  static const String pdfCatalogueLandingUrl = "${baseUrl}dina-pdf-catalogue";
  static const String apiKey = 'dinainternational';
  static const String apiPassword = '69c33dd75472333b9cce6a53d67d9d8e';
}

class AppConstant {
  static const String channelName = "com.webkul.oc.methodchannel";
  static const String searchText = "searchText";
  static const String searchImage = "searchImage";

  static const String appDocPath = "";
  static const List<String> supportedLanguages = ['en'];
  static const String mainPageBanner = "banner";
  static const String mainPageCategory = "category";
  static const String mainPagePopular = "popular";
  static const String mainPageBest = "best";
  static const String mainFeatureFeature = "featured";
  static const String mainPageLatest = "latest";
  static const String mainPageCarousel = "carousel";
  static const String mainPageRecent = "recently";

  /// Uncomment these topics for testing notification on local instance
  static const TOPICS = ["global", "globalAndroid"];
  static const appLogo = "assets/images/app_logo.png";

/*
* Demo login credentials
* */
  static const String demoEmail = "";

  static const String demoPassword = "";

  /*
  * Number constant like product limit or count on home page need to send in api's
  *
  * */
  static const String homePageProductCount = "6";
  static const String productReviewLimit = "10";

  // TODO("Replace this with API key")
  static const String googleKey = "AIzaSyC7KJpt2Bii6zG0QXdvG3VuWUCj3t_HjMg";

  /*
  * Function name need to send in checkout process api
  * */
  static const String shippingAddress = "shippingAddress";
  static const String paymentAddress = "paymentAddress";
  static const String shippingMethod = "shippingMethod";
  static const String paymentMethod = "paymentMethod";
  static const String confirm = "confirm";
  static const String existing = "existing";
  static const String guest = "guest";
  static const String saveGuest = "saveGuest";
  static const String saveGuestShipping = "saveGuestShipping";
}

class AppSizes {
  static const double linePadding = 4;
  static double deviceHeight =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;
  static double deviceWidth =
      MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;
  static const int splashScreenTitleFontSize = 14;
  static const double size15 = 15;
  static const double size14 = 14;
  static const double size12 = 12;
  static const double size8 = 8;
  static const double size4 = 4;
  static const double size5 = 5;
  static const double size6 = 6;
  static const double size16 = 16;
  static const double size24 = 24;
  static const double size25 = 25;
  static const double size10 = 10;
  static const double size20 = 20;
  static const double size18 = 18;
  static const double size22 = 22;
  static const double size26 = 26;
  static const double size30 = 30;
  static const double size34 = 34;
  static const double size27 = 27;
  static const double size88 = 88;
  static const double size1 = 1;
  static const double size2 = 2;
  static const double size72 = 72;
  static const double size240 = 240;
  static const double size58 = 58;
  static const double appBarSize = 56.0;
  static const double size40 = 40;
  static const double size44 = 44;
  static const double size45 = 45;
  static const double size110 = 120;
  static const double size126 = 126;
  static const double size0 = 0;
  static const double productListHeight = 210;
  static const double categoryImageSizeSmall = 90;
  static const double catProductItemHeight = 160;
  static const double categoryImageSizeMedium = 130;
  static const double cartProductSize = 96;
  static const double normalPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double size100 = 100;
  static const double size250 = 250;

  static const double size3 = 3;
  static const double size60 = 60;
  static const double size65 = 65;

  static const double size48 = 48;
  static const double categoryListingImageSize = 50;
  static const double itemHeight = 45;
}

class AppColors {
  static const red = Color(0xFFDB3022);
  static const searchText = Color(0xFF99A1AF);
  static const lightRed = Color(0xFFF65F53);
  static const yellow = Color(0xFFEA9301);
  static const black = Color(0xFF222222);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const borderGray = Color(0xFFE5E7EB);
  static const gray = Color(0xFF7D7D7D);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const selectedBoxBackground = Color(0xFFF3F4F6);
  static Color success = HexColor.fromHex("22bb33");
  static Color error = HexColor.fromHex("BB2124");
  static Color warning = HexColor.fromHex("f0ad4e");
  static const green = Color(0xFF2AA952);
  static const bottomBarIconActiveColor = Color(0xFF0D479C);
  static const bottomBarIconInActiveColor = Color(0xFF4A5565);
  static const blue = Color(0xFF3D79EC);
  static const order_color = Color(0xFFFFE0B1);
  static const sortFiltercolor = Color(0xFF4A5565);
  static const customer_color = Color(0xFFF57C1F);
  static const lightPrimaryColor = Color(0xFF546E7A);
  static const searchBackGroundColor = Color(0xFFF3F4F6);
  //static const dividerColor = Color(0xFFE5E5E5);#F3F4F6
  static const dividerColor = Color(0xFFD1D5DC);
  static const backgroundColor = Color(0xFFF5F5F5);
  static const buttonBackgroundColor = Color(0xFFFFD269);
  static const textBorderColor = Color(0xFFE0E0E0);
  static const transparentBackground = Color(0x3B7F7D7D);
  static const icon_grey = Color(0xFF4A5565);

  ///Customization Color
  static const grey_cust = Color(0xFF101828);
  static const grey_border = Color(0xFFE5E7EB);
  static const text_color = Color(0xFF1E2939);

  static const summaryTitle = Color(0xFF101828);
  static const summarySubTitle = Color(0xFF101828);

  // ------- CARD STATUS COLOR ------  //
  static const pendingColor = Color(0xFFFFD269);
  static const processingColor = Color(0xFF0D479C);
  static const completedColor = Color(0xFF00C950);
}

class AppImages {
  //================Icons Tab bar view ==================//
  static const accountIcon = "assets/icons/account.png";
  static const viewall = "assets/icons/view_all.png";
  static const cartIcon = "assets/icons/cart.png";
  static const homeIcon = "assets/icons/home.png";
  static const menuIcon = "assets/icons/menu.png";
  static const quickOrderIcon = "assets/icons/quick_order.png";
  static const changePassword = "assets/icons/shield_key.png";

  //================Icons sort and filter ==================//
  static const filterIcon = "assets/icons/filterIcon.png";
  static const sortIcon = "assets/icons/sortIcon.png";

  //================Icons==================//
  static const settingsIcon = "assets/icons/settings.png";
  static const settingIcon = "assets/icons/setting.png";
  static const infoIcon = "assets/icons/info.png";
  static const linkIcon = "assets/icons/link.png";
  static const returnIcon = "assets/icons/return.png";
  static const order_history = "assets/icons/order_history.png";
  static const previous_ordered = "assets/icons/previous_ordered.png";
  static const address_book_ = "assets/icons/address_book_.png";
  static const newsletter_icon = "assets/icons/newsletter_icon.png";
  static const logout = "assets/icons/logout.png";
  static const translationIcon = "assets/icons/translation.png";
  static const googleIcon = "assets/icons/ic_google.png";
  static const facebookIcon = "assets/icons/ic_facebook.png";
  static const loginIcon = "assets/icons/login.png";

  static const accountInfoIcon = "assets/icons/account_information.png";
  static const addressIcon = "assets/icons/address_book.png";
  static const dashboardIcon = "assets/icons/dashboard.png";
  static const logoutIcon = "assets/icons/logout.png";
  static const ordersIcon = "assets/icons/orders.png";
  static const wishlistsIcon = "assets/icons/wishlist.png";
  static const placeholder = "assets/images/placeholder.png";
  static const compare = "assets/icons/compare.png";
  static const cancelIcon = "assets/icons/close.png";
  static const deleteIcon = "assets/icons/ic_delete.png";
  //================Customisation Icons==================//
  static const backIcon = "assets/icons/arrow_back.png";

  //==============Lottie Assets============//
  static const fingerPrintLottie = "assets/lottie/finger_print.json";
  static const emptyAddressLottie = "assets/lottie/empty_address.json";
  static const emptyCartLottie = "assets/lottie/empty_cart.json";
  static const emptyOrderLottie = "assets/lottie/empty_order_list.json";
  static const emptyWishlistLottie = "assets/lottie/empty_wishlist.json";

  //=============Images===============//
  static const dashboardImage = "assets/images/dashboard_header.webp";
  static const buyerIcon = "assets/icons/icon_buyers.png";
  static const orderIcon = "assets/icons/icon_orders.png";
  static const salesIcon = "assets/icons/icon_sales.png";
  //static const filterIcon = "assets/icons/filter.png";
  static const reviewIcon = "assets/icons/review.png";
  static const orderIcons = "assets/icons/sellerorder.png";
  static const transaction = "assets/icons/transaction.png";
  static const sellerDashboard = "assets/icons/sellerdashboard.png";
  static const addProduct = "assets/icons/addproduct.png";
  static const sellerPage = "assets/icons/sellerpage.png";
  static const productList = "assets/icons/product_list.png";
  static const editNote = "assets/icons/edit.png";

  static const noProduct = "assets/images/no_product.png";
  static const noBackorder = "assets/images/backorder.png";

  //================Customisation Icons==================//
  static const searchScanIcon = "assets/icons/search_icon.png";
  static const searchIcon = "assets/images/searchIcon.png";
  static const noProductFound = "assets/icons/no_product_found.png";
  static const backArrow = "assets/icons/back_Arrow.png";
  static const callIcon = "assets/icons/call.png";
  static const facebookIcons = "assets/icons/facebook.png";
  static const instagramIcon = "assets/icons/instagram.png";
  static const linkdineIcon = "assets/icons/linkdine.png";
  static const locationIcon = "assets/icons/location.png";
  static const timerIcon = "assets/icons/timer.png";
  static const cartButton = "assets/icons/cartButton.png";
  static const returnOrder = "assets/icons/returnOrder.png";
  static const cartEmpty = "assets/icons/cartEmpty.png";
  static const refreshButton = "assets/icons/refresh_button.png";
  static const delete = "assets/icons/delete.png";
  static const crossBackButton = "assets/icons/cross_back_button.png";
  static const successIcon = "assets/icons/successIcon.png";
  static const noOrderIcon = "assets/icons/no_order.png";
  static const noPreviousOrderIcon = "assets/icons/previous_order.png";
  static const quick_empty = "assets/icons/quick_empty.png";
  static const askQuestion = "assets/icons/ask_question.png";
  static const bannerImage = "assets/images/banner_image.jpeg";
}
