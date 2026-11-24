import 'package:floor/floor.dart';

import '../entities/recent_product_entitie.dart';

@dao
abstract class RecentProductDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertRecentProduct(RecentProduct product);

  @Query("SELECT * FROM RecentProduct LIMIT 10")
  Future<List<RecentProduct>> getProducts();

  @Query("DELETE FROM RecentProduct WHERE productId  = :productId")
  Future<void> removeItemFromRecentProduct(String productId);
}
