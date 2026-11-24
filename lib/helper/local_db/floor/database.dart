import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/recent_dao.dart';
import 'entities/recent_product_entitie.dart';

part 'database.g.dart'; // GENERATED FILE

@Database(version: 1, entities: [RecentProduct])
abstract class AppDatabase extends FloorDatabase {
  RecentProductDao get recentProductDao;

  // AppDatabase._();

  static AppDatabase? _database;

  static Future<AppDatabase> getDatabase() async {
    _database ??= await $FloorAppDatabase
        .databaseBuilder("opencart_database.db")
        .build();
    return _database!;
  }
}
