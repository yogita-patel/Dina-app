import 'package:json_annotation/json_annotation.dart';
import 'package:oc_demo/models/base_model.dart';

part 'home_screen_model.g.dart';

@JsonSerializable()
class HomePageData extends BaseModel {
  bool? guest_status;
  int? partner;
  bool? partner_approve_required;
  List<HomeSequenceElement>? home_sequence;
  List<Banners>? banners;
  /*List<Product>? bestProduct;
  List<Product>? latestProduct;
  List<Product>? popularProduct;
  List<Product>? featuredProduct;*/
  List<Carousels>? carousels;
  List<Categories>? categories;
  @JsonKey(name: "shopCatergory")
  List<ShopCatergory>? shopCatergory;
  @JsonKey(name: "mainmenu")
  List<MainMenu>? mainMenu;
  @JsonKey(name: "subcategory")
  List<SubCategory>? subcategory;
  Languages? languages;
  Currencies? currencies;
  int? cart;
  String? language;
  List<FooterMenu>? footerMenu;
  Sidemenu? sidemenu;
  List<SocialLink>? social_links;
  GetIntouch? getIntouch;
  List<String>? widgets;
  List<String>? top_heder_content;

  HomePageData(
      {this.guest_status,
      this.partner,
      this.partner_approve_required,
      this.home_sequence,
      this.banners,
      /* this.bestProduct,
      this.latestProduct,
      this.popularProduct,
      this.featuredProduct,*/
      this.carousels,
      this.categories,
      this.shopCatergory,
      this.languages,
      this.currencies,
      this.cart,
      this.language,
      this.footerMenu,
      this.getIntouch,
      this.widgets,
      this.top_heder_content});

  factory HomePageData.fromJson(Map<String, dynamic> json) =>
      _$HomePageDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$HomePageDataToJson(this);
}

@JsonSerializable()
class Banners {
  @JsonKey(name: "home_sequence_id")
  String? homeSequenceId;
  String? title;
  String? type;
  String? link;
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;

  Banners(
      {this.title,
      this.type,
      this.link,
      this.image,
      this.dominantColor,
      this.homeSequenceId});

  factory Banners.fromJson(Map<String, dynamic> json) =>
      _$BannersFromJson(json);

  Map<String, dynamic> toJson() => _$BannersToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: "product_id")
  String? productId;
  String? thumb;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? name;
  dynamic price;
  String? quantity;
  int? special;
  @JsonKey(name: "formatted_special")
  String? formattedSpecial;
  String? tax;
  int? rating;
  String? reviews;
  bool? hasOption;
  @JsonKey(name: "wishlist_status")
  bool? wishlistStatus;
  @JsonKey(name: "is_cart_added")
  dynamic isCartAdded;
  dynamic bought;

  Product(
      {this.productId,
      this.thumb,
      this.dominantColor,
      this.name,
      this.price,
      this.quantity,
      this.special,
      this.formattedSpecial,
      this.tax,
      this.rating,
      this.reviews,
      this.hasOption,
      this.wishlistStatus,
      this.isCartAdded,
      this.bought});

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

@JsonSerializable()
class Categories {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? icon;
  @JsonKey(name: "dominant_color_icon")
  String? dominantColorIcon;

  Categories(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory Categories.fromJson(Map<String, dynamic> json) =>
      _$CategoriesFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesToJson(this);
}

@JsonSerializable()
class Languages {
  @JsonKey(name: "child_status")
  String? text_language;
  String? code;
  String? image;
  List<Language>? languages;

  Languages({this.text_language, this.code, this.image, this.languages});

  factory Languages.fromJson(Map<String, dynamic> json) =>
      _$LanguagesFromJson(json);

  Map<String, dynamic> toJson() => _$LanguagesToJson(this);
}

@JsonSerializable()
class Language {
  String? name;
  String? code;
  String? image;

  Language({this.name, this.code, this.image});

  factory Language.fromJson(Map<String, dynamic> json) =>
      _$LanguageFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageToJson(this);
}

@JsonSerializable()
class Currencies {
  String? text_currency;
  String? code;
  List<Currency>? currencies;

  Currencies({this.text_currency, this.code, this.currencies});

  factory Currencies.fromJson(Map<String, dynamic> json) =>
      _$CurrenciesFromJson(json);

  Map<String, dynamic> toJson() => _$CurrenciesToJson(this);
}

@JsonSerializable()
class Currency {
  String? title;
  String? code;

  Currency({this.title, this.code});

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}

@JsonSerializable()
class FooterMenu {
  @JsonKey(name: "information_id")
  String? informationId;
  String? title;
  String? status;
  String? sortOrder;

  FooterMenu({this.informationId, this.title, this.status, this.sortOrder});

  factory FooterMenu.fromJson(Map<String, dynamic> json) =>
      _$FooterMenuFromJson(json);

  Map<String, dynamic> toJson() => _$FooterMenuToJson(this);
}

@JsonSerializable()
class Carousels {
  @JsonKey(name: "home_sequence_id")
  String? homeSequenceId;
  @JsonKey(name: "image_sub_type")
  String? imageSubType;
  String? id;
  String? title;
  String? type;
  @JsonKey(name: "product_type")
  String? productType;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  @JsonKey(name: "products")
  List<Product>? product;

  @JsonKey(name: "image_all_parrent_category")
  List<Categories>? imageTypeCategoryCarousal;

  @JsonKey(name: "image_catagory")
  List<Categories>? imageCatagory;

  @JsonKey(name: "image_carousel")
  List<SliderImages>? slider;
  @JsonKey(name: "image_manufacturer")
  List<ImageManufacturer>? imageManufacturer;

  /*
  *   List<Products>? products;
  List<ImageAllParrentCategory>? imageAllParrentCategory;
  List<ImageManufacturer>? imageManufacturer;
  List<ImageCatagory>? imageCatagory;
  List<ImageCarousel>? imageCarousel;
  * */

  Carousels(
      {this.homeSequenceId,
      this.id,
      this.title,
      this.type,
      this.imageSubType,
      this.productType,
      this.sortOrder,
      this.product,
      this.slider,
      this.imageTypeCategoryCarousal,
      this.imageCatagory,
      this.imageManufacturer});
  factory Carousels.fromJson(Map<String, dynamic> json) =>
      _$CarouselsFromJson(json);
  Map<String, dynamic> toJson() => _$CarouselsToJson(this);
}

@JsonSerializable()
class HomeSequenceElement {
  String? id;
  String? type;

  HomeSequenceElement({
    this.id,
    this.type,
  });
  factory HomeSequenceElement.fromJson(Map<String, dynamic> json) =>
      _$HomeSequenceElementFromJson(json);
  Map<String, dynamic> toJson() => _$HomeSequenceElementToJson(this);
}

@JsonSerializable()
class SliderImages {
  @JsonKey(name: "banner_title")
  String? banner_title;
  String? title;
  String? type;
  String? link;
  String? image;
  String? dominantColor;

  SliderImages(
      {this.banner_title,
      this.title,
      this.type,
      this.link,
      this.image,
      this.dominantColor});

  factory SliderImages.fromJson(Map<String, dynamic> json) =>
      _$SliderImagesFromJson(json);
  Map<String, dynamic> toJson() => _$SliderImagesToJson(this);
}

@JsonSerializable()
class ImageTypeCategoryCarousal {
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  String? path;
  String? image;
  String? dominantColor;
  String? icon;
  String? dominantColorIcon;

  ImageTypeCategoryCarousal(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon});

  factory ImageTypeCategoryCarousal.fromJson(Map<String, dynamic> json) =>
      _$ImageTypeCategoryCarousalFromJson(json);

  Map<String, dynamic> toJson() => _$ImageTypeCategoryCarousalToJson(this);
}

@JsonSerializable()
class ImageManufacturer {
  @JsonKey(name: "manufacturer_id")
  String? manufacturerId;
  String? name;
  String? image;

  ImageManufacturer({this.manufacturerId, this.name, this.image});
  factory ImageManufacturer.fromJson(Map<String, dynamic> json) =>
      _$ImageManufacturerFromJson(json);

  Map<String, dynamic> toJson() => _$ImageManufacturerToJson(this);
}

@JsonSerializable()
class ShopCatergory {
  @JsonKey(name: "manufacturer_id")
  String? manufacturerId;
  String? name;
  String? image;

  ShopCatergory({this.manufacturerId, this.name, this.image});
  factory ShopCatergory.fromJson(Map<String, dynamic> json) =>
      _$ShopCatergoryFromJson(json);
  Map<String, dynamic> toJson() => _$ShopCatergoryToJson(this);
}

@JsonSerializable()
class MainMenu {
  @JsonKey(name: "group_id")
  String? groupId;
  @JsonKey(name: "main_group")
  String? mainGroup;
  @JsonKey(name: "category_id")
  String? categoryId;
  @JsonKey(name: "information_id")
  String? informationId;
  @JsonKey(name: "sort_order")
  String? sortOrder;
  String? name;
  String? image;

  MainMenu(
      {this.groupId,
      this.mainGroup,
      this.categoryId,
      this.informationId,
      this.sortOrder,
      this.name,
      this.image});
  factory MainMenu.fromJson(Map<String, dynamic> json) =>
      _$MainMenuFromJson(json);
  Map<String, dynamic> toJson() => _$MainMenuToJson(this);
}

@JsonSerializable()
class SubCategory {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "child_status")
  bool? childStatus;
  @JsonKey(name: "path")
  String? path;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "dominant_color")
  String? dominantColor;
  String? icon;
  @JsonKey(name: "dominant_color_icon")
  String? dominantColorIcon;
  @JsonKey(name: "subcategory_name")
  String? subcategoryName;

  SubCategory(
      {this.name,
      this.childStatus,
      this.path,
      this.image,
      this.dominantColor,
      this.icon,
      this.dominantColorIcon,
      this.subcategoryName});
  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
}

@JsonSerializable()
class Sidemenu {
  List<AbautUs>? abaut_us;
  List<AbautUs>? quick_link;

  Sidemenu({
    this.abaut_us,
    this.quick_link,
  });

  factory Sidemenu.fromJson(Map<String, dynamic> json) =>
      _$SidemenuFromJson(json);

  Map<String, dynamic> toJson() => _$SidemenuToJson(this);
}

@JsonSerializable()
class AbautUs {
  String? menu_id;
  MenuGroup? menu_group;
  MenuType? menu_type;
  String? information_id;
  String? external_link;
  String? status;
  String? sort_order;
  String? name;

  AbautUs({
    this.menu_id,
    this.menu_group,
    this.menu_type,
    this.information_id,
    this.external_link,
    this.status,
    this.sort_order,
    this.name,
  });

  factory AbautUs.fromJson(Map<String, dynamic> json) =>
      _$AbautUsFromJson(json);

  Map<String, dynamic> toJson() => _$AbautUsToJson(this);
}

enum MenuGroup { abaut_us, quick_link }

enum MenuType { external, pages, support }

@JsonSerializable()
class SocialLink {
  String? name;
  String? url;
  String? icon;

  SocialLink({
    this.name,
    this.url,
    this.icon,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) =>
      _$SocialLinkFromJson(json);

  Map<String, dynamic> toJson() => _$SocialLinkToJson(this);
}

@JsonSerializable()
class GetIntouch {
  String? address;
  String? telephone;
  String? open;

  GetIntouch({
    this.address,
    this.telephone,
    this.open,
  });
  factory GetIntouch.fromJson(Map<String, dynamic> json) =>
      _$GetIntouchFromJson(json);

  Map<String, dynamic> toJson() => _$GetIntouchToJson(this);
}
