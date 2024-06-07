# sqflite3

sqlite のお勉強の続き
sqflite を使用します
Flutter では SQFLite パッケージを使用する
sample は動作したので flutter の widget と絡めて実装していきます

[公式の元記事。dogs](https://docs.flutter.dev/cookbook/persistence/sqlite)

犬の名前を登録できる database ですね

sqflite: ^2.3.3
path_provider: ^2.1.3
path: ^1.9.0

---

## Package to use.

### [path](https://pub.dev/packages/path)

```
flutter pub add path
```

### [path_provider](https://pub.dev/packages/path_provider)

```
flutter pub add path_provider
```

### [sqflite](https://pub.dev/packages/sqflite)

```
flutter pub add sqflite
```

---

2024.3.11
DogList も Dog モデルに押し込んだほうがいいかな
Widget を返す形が良きかも
モデル操作を極力 main.dart から排除したほうがいいかも
dog.dart に押し込んだほうがいいのかな

main は controller であるべきかな
logic は sub へ
bussiness logic は外へがいいのかも
処理を外に任せて反応するだけにする

2024.4.4
追加するときの引数を、1 つの数値ではなく、モデルを引き渡すようにした
追加時は id は不要なのだが、インスタンス生成時の引数に必要なので 0 としてみた
実際のレコード追加処理では id は使用されない

2024.6.2
・addDog ではなく insert のほうが抽象的かな。いやでも明確なほうがいいのかな？

「予期できて対処可能な例外のみをキャッチし、その他の例外はコールスタックを上位に伝播させ、上位のエラーハンドリングコードによってキャッチされるようにすることが一般的に良い習慣です。これにより、バグの特定と修正が容易になり、アプリケーションで予期しないエラーや挙動を避けることができます。」

私が初期に出会った、シングルトンの記述方法
プロパティアクセス方式
\_database の null チェックをわかりやすく記述している。

```
Future<Database> get database async {
  if (_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
}
```

2024.6.7 関数型のパラダイムを入れていきたいかな
現在は、dogs という変数を持っている。状態である。
変数 1 つ 1 つが、副作用の中心です
シグネチャを介さずアタッチするとその関数が副作用化します。透過性が壊れるのかな？
