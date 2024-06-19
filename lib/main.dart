// import 'dart:async';
// import 'dart:io'; // sleep(),
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'database_helper.dart';
import 'dog.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'sqflite demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'sqflite demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// MyHomePageのstate
class _MyHomePageState extends State<MyHomePage> {
  //
  // late DatabaseHelper dbHelper; // やめた
  // var random = Random();
  // なんかグローバルな変数、状態が少なくなると気分がいいかも。
  // 改めて変数を確認すると、Appの仕様が見えてくる。
  List<Dog> dogs = <Dog>[];
  bool isLoaded = false;

  // initStateにasyncは使用できない
  @override
  void initState() {
    super.initState();
    // print('initState');
    // dbHelper = DatabaseHelper.instance;
    // ヘルパーのインスタンスを変数に格納して使用しないのがセオリーなのか？
    // initで変数に格納するのはやめた。毎回Topレベルからアクセスする。

    // この初期化処理で、フィールドの1つの"dogs"を初期化する（このニュアンス）
    loadDogs();
  }

  // setStateにもasyncは使用できない
  Future<void> loadDogs() async {
    setState(() {
      isLoaded = true;
    });
    try {
      dogs = await DatabaseHelper.instance.dogs();
    } catch (e) {
      // debugPrint はトップレベルでの定義がいいかな
      // material.dart も必要
      // debugPrint(e); // NG
      // debugPrint(e as String?);
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoaded = false;
        // debugPrint('load!');
      });
    }
  }

  // Dogsテーブルのレコードを取得する
  Future<List<Dog>> loadDogs2() async {
    setState(() {
      isLoaded = true;
    });
    try {
      return await DatabaseHelper.instance.dogs();
    } catch (e) {
      debugPrint(e.toString());
      return <Dog>[];
    } finally {
      setState(() {
        isLoaded = false;
      });
    }
  }

  /// dogsテーブルにレコードを1行追加する
  Future<void> addDog(Dog dog) async {
    setState(() {
      isLoaded = true;
    });
    // 待機サークルを表示するために、わざと遅延させている
    // addDog自体がloadより遅れて、listの表示が更新されない
    // 呼び出し元でawaitすることで、同期処理になる
    // 結果、sleepだと時間を占有するだけになる。サークルは表示されない。
    // 単純な同期待機という感じかな。
    // sleep(const Duration(milliseconds: 1000)); // 単純待機。
    // Future.delayed は非同期な待機という感じかな。
    await Future.delayed(const Duration(milliseconds: 200), () {
      // debugPrint('addDog()');
    });
    //
    try {
      // await DatabaseHelper.instance.addDog(createRandomDog());
      await DatabaseHelper.instance.addDog(dog);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoaded = false;
        // debugPrint('add!');
      });
    }
  }

  /// dogsテーブルのレコードを1行削除する
  Future<void> deleteDog() async {
    setState(() {
      isLoaded = true;
    });
    try {
      await DatabaseHelper.instance.deleteDog();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        isLoaded = false;
      });
    }
  }

  /// ランダムなdogを生成する
  Dog createRandomDog() {
    var name = WordPair.random().asLowerCase;
    var age = Random().nextInt(10);
    return Dog(id: 0, name: name, age: age);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      //
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // debug用の。
              ElevatedButton(
                  onPressed: () {
                    loadDogs(); // レコード更新
                  },
                  child: const Text('dogsを表示する')),
              //
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('LIST OF DOGS'),
              ),
              //
              // show records
              if (isLoaded)
                const CircularProgressIndicator()
              else
                DogList(dogs: dogs), // レコード表示
              //
            ],
          ),
        ),
      ),
      //
      // Action Button
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // レコード追加
          // 2度押防止
          FloatingActionButton(
              onPressed: isLoaded
                  ? null
                  : () async {
                      try {
                        // futureな処理を同期に処理したい場合はawaitしましょう
                        // onPressedがasync可能でよかったね
                        // ランダムなdogを生成して追加する
                        await addDog(createRandomDog());
                        await loadDogs();
                      } catch (e) {
                        debugPrint('データの追加に失敗しました: $e');
                      }
                    },
              tooltip: 'データを追加する',
              child: const Icon(Icons.add)),
          //
          const Gap(8),
          // レコード削除
          FloatingActionButton(
              onPressed: () async {
                try {
                  await deleteDog();
                  await loadDogs();
                } catch (e) {
                  debugPrint('データの取得に失敗しました: $e');
                }
              },
              tooltip: 'データを1件削除する',
              child: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}

/// DogList
/// Dog-Model専用
/// Dogレコードで構成されたListViewのWidgetを返します
/// 固定型のListViewで構成されます。なので親コンテナでスクロールできると思います
class DogList extends StatelessWidget {
  final List<Dog> dogs;

  const DogList({
    super.key,
    required this.dogs,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dogs.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(dogs[index].toTitle()),
            subtitle: Text(
              // 以下の様にモデルのフィールドにアクセスする機能はmodelに寄せたほうがよいと思っている
              // スッキリしたと思う。
              // 'id: ${dogs[index].id.toString()} / age: ${dogs[index].age.toString()}',
              dogs[index].toBody(),
            ),
          ),
        );
      },
    );
  }
}
