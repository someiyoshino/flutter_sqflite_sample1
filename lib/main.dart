import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'database_helper.dart';
import 'dog.dart';
import 'dart:math'; // Random

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

class _MyHomePageState extends State<MyHomePage> {
  // ランダムなdogを生成する
  Dog createRandomDog() {
    var name = WordPair.random().asLowerCase;
    var age = Random().nextInt(10);
    return Dog(id: 0, name: name, age: age);
  }

  // Dog Function() randomDog = () {
  //   var name = WordPair.random().asLowerCase;
  //   var age = Random().nextInt(10);
  //   return Dog(id: 0, name: name, age: age);
  // };

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
              //
              // Title.
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text('LIST OF DOGS', style: TextStyle(fontSize: 26)),
              ),
              //
              // Body.
              FutureBuilder<List<Dog>>(
                future: DatabaseHelper.instance.dogs(), // 非同期関数
                builder:
                    (BuildContext context, AsyncSnapshot<List<Dog>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // loading...
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Error! Why?
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // Yes! Got Data!
                    return DogList(dogs: snapshot.data!);
                  }
                },
              )
            ],
          ),
        ),
      ),
      //
      // Action Button
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          // Insert Random Dog
          FloatingActionButton(
              onPressed: () async {
                try {
                  await DatabaseHelper.instance.addDog(createRandomDog());
                  setState(() {});
                } catch (e) {
                  debugPrint('データの追加に失敗しました: $e');
                }
              },
              tooltip: 'データを追加する',
              child: const Icon(Icons.add)),
          //
          const Gap(8),
          //
          // Delete Dog
          FloatingActionButton(
              onPressed: () async {
                try {
                  await DatabaseHelper.instance.deleteLatestDog();
                  setState(() {});
                } catch (e) {
                  debugPrint('データの取得に失敗しました: $e');
                }
              },
              tooltip: '最新データを1件削除する',
              child: const Icon(Icons.remove)),
        ],
      ),
    );
  }
}

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
      reverse: true,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dogs.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(dogs[index].toTitle()),
            subtitle: Text(dogs[index].toBody()),
          ),
        );
      },
    );
  }
}
