import 'dart:io'; // Directory
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dog.dart';

/// DatabaseHelper（provider）
/// シングルトンパターンを使用しています
/// factoryキーワードを使用していないパターンです。うそです、使ってます。
/// static変数は2つあります。インスタンス保持用とdatabase保持用です
/// インスタンス生成 / database作成 / レコード追加・削除 / を実装
class DatabaseHelper {
  // 定数
  // constだけではダメなようだ
  // finalだけはOK
  static const _databaseName = "my_database2.db";
  static const _databaseTableName = "my_table";
  static const _databaseVersion = 1;

  // インスタンス保持用
  static DatabaseHelper? _instance;
  DatabaseHelper._();
  // インスタンス生成
  // getter でアクセスされます
  // プロパティへのアクセスがprivateのコンストラクタを起動します
  // newで生成しないパターンとなります
  // keep only instance
  static DatabaseHelper get instance => _instance ??= DatabaseHelper._();

  // このように内部からgetterを呼び出すことも可能です
  // getterで返しています。使わないと思うけど。バカ除けかな。
  factory DatabaseHelper() => instance; // 追加

  // database保持用
  // static Database? _database; // staticでなくてもいいかも
  Database? _database;
  // getter でアクセスされます
  // プロパティdatabaseにアクセス（getter）すればインスタンスが生成されます
  Future<Database> get database async => _database ??= await _initDatabase();

  /// _initDatabase()
  /// databaseを作成します
  /// 1回のみ実行されます
  /// openDatabaseを実行します。返り値はFuture<Database>
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

  /// レコードを1行追加
  /// modelを受け取る
  /// dog model を受け取りますが、idは自動採番のため指定しません。
  Future<void> addDog(Dog dog) async {
    try {
      // 例外故意
      // _exception();

      // (await database).insert これはシンプルかな？
      // 一旦変数dbに代入することにした。
      final db = await database;
      // 以下はawaitしなくてもいいかも
      await db.insert(
        _databaseTableName,
        {
          // dog.idは指定しない
          'name': dog.name,
          'age': dog.age,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // エラーが発生した場合の処理
      // print('Dogの追加中にエラーが発生しました: $e');
      // 必要に応じて、エラーを外部に通知
      throw Exception('dataのinsertに失敗しました');
    }
  }

  /// レコードを1行追加
  /// この関数は、引数にnameとageを取りますが別の関数にfixされました。
  /// Modelを受け取る関数に置き換えられました。
  // Future<void> addDog(String name, int age) async {
  //   try {
  //     final db = await database;
  //     await db.insert(
  //       _databaseTableName,
  //       {
  //         'name': name,
  //         'age': age,
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace,
  //     );
  //   } catch (e) {
  //     // エラーが発生した場合の処理
  //     // print('Dogの追加中にエラーが発生しました: $e');
  //     // 必要に応じて、エラーを外部に通知
  //     throw Exception('Dogの追加に失敗しました');
  //   }
  // }

  /// dogs レコード全取得
  /// レコード全取得
  Future<List<Dog>> dogs() async {
    try {
      final db = await database;

      // MapのListを取得
      final List<Map<String, dynamic>> maps =
          await db.query(_databaseTableName);

      // Listを生成して返す
      // この関数の返却型が示すとおり、DogモデルのListを返します
      return List.generate(maps.length, (i) {
        final id = maps[i]['id'] as int;
        final name = maps[i]['name'] as String;
        final age = maps[i]['age'] as int;
        return Dog(id: id, name: name, age: age);
      });
    } catch (e) {
      // エラーが発生した場合の処理
      // print('Dogの取得中にエラーが発生しました: $e');
      // 必要に応じて、エラーを外部に通知
      throw Exception('Recordの取得に失敗しました');
    }
  }

  /// deleteDog
  /// 最新のレコードを1行削除する
  Future<void> deleteDog() async {
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


/// helper, provider 内でprintは副作用かな。
/// 使用しないほうがいいかも