import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:vbs_sos/models/employee.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {
  DatabaseManager._();

  static final DatabaseManager instance = DatabaseManager._();
  static Database? _database;

  factory DatabaseManager() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    WidgetsFlutterBinding.ensureInitialized();
    return await openDatabase(
      join(await getDatabasesPath(), 'sos_vision.db'),
      onCreate: (db, version) {
        db.execute('''
   CREATE TABLE IF NOT EXISTS employees (
        employeeId INTEGER PRIMARY KEY,
        companyId INTEGER,
        firstname TEXT,
        password TEXT,
        lastname TEXT,
        phone_number TEXT,
        role TEXT,
        job TEXT,
        profilUrl TEXT,
        tokens TEXT,
        companyName TEXT
      )
  ''');
      },
      version: 1,
    );
  }

  Future<Employee?> getLoggedInEmployee() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('employees');

    if (maps.isNotEmpty) {
      return Employee.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> addEmployee(Employee employee) async {
    final Database db = await database;
    return await db.insert(
      'employees',
      employee.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  void updateEmployee(Employee employee) async {
    final Database db = await database;
    await db.update("employees", employee.toMap(),
        where: "employeeId = ?", whereArgs: [employee.employeeId]);
  }

  void deleteEmployee(int id) async {
    final Database db = await database;
    db.delete("employees", where: "employeeId = ?", whereArgs: [id]);
  }

  Future<void> clearDatabase() async {
    final databasePaths = await getDatabasesPath();
    final path = join(databasePaths, 'sos_vision.db');
    await deleteDatabase(path);
  }
}
