import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favorite_restuarant_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'favorite_restaurants.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_restaurants (
        id TEXT PRIMARY KEY,
        name TEXT,
        city TEXT,
        rating REAL,
        pictureId TEXT
      )
    ''');
  }

  Future<void> insertFavorite(FavoriteRestaurant restaurant) async {
    final db = await database;
    await db.insert(
      'favorite_restaurants',
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteFavorite(String id) async {
    final db = await database;
    await db.delete('favorite_restaurants', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<FavoriteRestaurant>> getFavorites() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_restaurants',
    );
    return List.generate(maps.length, (i) {
      return FavoriteRestaurant.fromMap(maps[i]);
    });
  }
}
