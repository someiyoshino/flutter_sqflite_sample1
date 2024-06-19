import 'dart:io'; // Directory
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dog.dart';

/// DatabaseHelper
/// SQLiteを扱うためのヘルパークラスです
/// データベースの操作に焦点を当てたクラスです
/// テーブル作成、レコード追加、取得、削除等の機能を実装します
/// 一般的に、ヘルパークラスやリポジトリクラスの責務として、データベースの操作や作成を受け持ちます
///
/// シングルトンパターンを使用してヘルパーのインスタンスを管理します
/// 重要なstatic変数は2つあります。ヘルパインスタンス保持用とdatabase保持用です
class DatabaseHelper {
  // 定数
  static const _databaseName = "dog_database.db";
  static const _databaseTableName = "dogs";
  static const _databaseVersion = 1;

  // インスタンス保持用
  static DatabaseHelper? _instance;
  DatabaseHelper._();

  // インスタンス生成
  // getter でアクセスされます
  // プロパティへのアクセスがprivateのコンストラクタを起動します
  // newで生成しないパターンとなります
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  // newによるインスタンス生成は使わない予定ですが、安全の為設置しています
  // var helper = DatabaseHelper(); // 生成例
  // このように内部からgetterを呼び出すことも可能です
  factory DatabaseHelper() => instance; // 追加

  // database保持用
  // static Database? _database; // staticでなくてもいいかも
  Database? _database;

  // getter でアクセスされます
  // プロパティdatabaseにアクセス（getter）すればインスタンスが生成されます
  Future<Database> get database async => _database ??= await _initDatabase();

  // databaseを作成します
  // databaseプロパティに初回アクセスがあった場合に実行されます
  // openDatabaseを実行します。返り値はFuture<Database>です
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // tableを作成します
  // tableが存在しない場合のみ作成されます
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_databaseTableName (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            age INTEGER NOT NULL
          )
          ''');
  }

  // レコードを1行追加
  // modelを受け取る
  // 引数としてModel（Dogインスタンス）を受け取りますが、idは自動採番のため指定しません。
  Future<void> addDog(Dog dog) async {
    try {
      // 例外故意
      // _exception();

      // (await database).insert これは本当にシンプルか？
      // 一旦変数dbに代入することにした。
      final db = await database;
      await db.insert(
        _databaseTableName,
        dog.toInsertMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('dataのinsertに失敗しました');
    }
  }

  // レコード全取得
  Future<List<Dog>> dogs() async {
    try {
      final db = await database;

      // MapのListを取得
      final List<Map<String, dynamic>> maps =
          await db.query(_databaseTableName);

      // この関数の返却型が示すとおり、DogモデルのListを返します
      return List.generate(maps.length, (i) {
        return Dog.fromMap(maps[i]);
      });
    } catch (e) {
      throw Exception('Recordの取得に失敗しました');
    }
  }

  // 最新のレコードを1行削除する
  Future<void> deleteLatestDog() async {
    final db = await database;
    await db.rawDelete('''
      DELETE FROM $_databaseTableName
        WHERE id = (SELECT MAX(id) FROM $_databaseTableName)
        ''');
  }

  // 例外をわざと発生させるメソッド
  // ignore: unused_element
  // _exception() {
  //   throw Exception('例外を発生です');
  // }
}
