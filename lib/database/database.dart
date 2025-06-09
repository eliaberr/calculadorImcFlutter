import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      version: 2, //recria a tabela no banco
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, email TEXT, password TEXT)",
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute("DROP TABLE IF EXISTS users");
        await db.execute(
          "CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, email TEXT, password TEXT)",
        );
      },
    );
  }

  Future<bool> emailExiste(String email) async {
    final db = await database;
    final result = await db!.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  Future<void> insertUser(String nome, String email, String password) async {
    final db = await database;
    await db!.insert('users', {
      'nome': nome,
      'email': email,
      'password': password,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> users = await db!.query(
      'users',
      where: "email = ?",
      whereArgs: [email],
    );
    if (users.isNotEmpty) {
      return users.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db!.query('users');
  }
}
