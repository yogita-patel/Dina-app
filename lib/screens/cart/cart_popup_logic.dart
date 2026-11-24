import '../../models/cart/cart_model.dart';

List<Products> cartPopupOutOfStockProducts(List<Products>? products) {
  return products?.where((product) => product.stock == false).toList() ?? [];
}

int cartItemDisplayQuantity({
  required int productQty,
  required int unitOfSale,
  required bool preserveDisplayQuantity,
}) {
  if (preserveDisplayQuantity) {
    return productQty > 0 ? productQty : 1;
  }

  return productQty > unitOfSale
      ? unitOfSale > 0
          ? (productQty / unitOfSale).ceil()
          : productQty
      : 1;
}

List<Products> cartPopupRetainedOutOfStockProducts(
  List<Products> visibleProducts,
  List<Products> latestOutOfStockProducts,
) {
  final latestOutOfStockIds = latestOutOfStockProducts
      .map(_cartPopupProductIdentity)
      .whereType<String>()
      .toSet();

  return visibleProducts
      .where((product) =>
          latestOutOfStockIds.contains(_cartPopupProductIdentity(product)))
      .toList();
}

String? _cartPopupProductIdentity(Products product) {
  return product.key ?? product.productId;
}
