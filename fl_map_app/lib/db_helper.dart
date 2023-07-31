import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocationData {
  String? city;
  String? district;
  String? name;
  double? latitude;
  double? longitude;

  LocationData({
    this.city,
    this.district,
    this.name,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'city': city,
      'district': district,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      city: map['city'],
      district: map['district'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}

class DatabaseHelper {
  static final String _databaseName = "location.db";
  static final int _databaseVersion = 1;

  static final table = 'location_table';
  static final columnId = '_id';
  static final columnCity = 'city';
  static final columnDistrict = 'district';
  static final columnName = 'name';
  static final columnLatitude = 'latitude';
  static final columnLongitude = 'longitude';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnCity TEXT NOT NULL,
        $columnDistrict TEXT NOT NULL,
        $columnName TEXT NOT NULL,
        $columnLatitude REAL NOT NULL,
        $columnLongitude REAL NOT NULL
      )
    ''');
  }

  Future<int> insert(LocationData locationData) async {
    Database db = await instance.database;
    return await db.insert(table, locationData.toMap());
  }

  Future<List<LocationData>> queryAll() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return LocationData.fromMap(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}

final instance = DatabaseHelper();
