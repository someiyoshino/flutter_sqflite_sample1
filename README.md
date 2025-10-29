# Flutter で sqlite のお勉強

Flutter で sqlite のお勉強です。

Flutter では、sqflite パッケージを使用します。

## Persist data with SQLite

[公式の元記事。「Persist data with SQLite」](https://docs.flutter.dev/cookbook/persistence/sqlite)

Flutter 公式 Document に Sqlite を使用している sample 記事があります。

わんちゃんの名前と年齢を登録できる database の sample です。

この sample はコマンドラインベースでした。

このリポジトリは、widget(GUI) で実装します。

## Package to use.

-   sqflite: ^2.3.3
-   path_provider: ^2.1.3
-   path: ^1.9.0

### [path](https://pub.dev/packages/path)

パスに関連した文字列の操作

```
flutter pub add path
```

### [path_provider](https://pub.dev/packages/path_provider)

各プラットフォームで使用可能なローカルのパスの取得

```
flutter pub add path_provider
```

### [sqflite](https://pub.dev/packages/sqflite)

sqlite 使えるパッケージ

```
flutter pub add sqflite
```

## dog.dart

モデルクラスです。

データベースのテーブル構造を表します。

モデルインスタンスを文字列化するメソッドが定義しています。

Map からインスタンスを生成するメソッドもあります。これは静的メソッドです。そもそもインスタンスが無いからですね。-> 名前付きコンストラクタのほうがよかったかな。

モデルはデータベースに近いといってクエリは定義していはいけません。それはヘルパーに任せましょう。

一般的にモデルはデータ構造と少々の変換のメソッドを定義するのがベターです。

## database_helper.dart

データベースの操作を助けるクラスです。

ヘルパーとかプロバイダーとか呼ばれます。

シングルトンでインスタンス管理しています。

データベースの作成と追加、削除などのメソッドが定義されています。

## main.dart

メインロジックです。ビジネスロジックともいうのかな。

状態を表すプロパティ（変数）が１つあります。「\_dogs」です。

futureBuilder の future 引数に渡しています。

おちゃめな関数が１つありますね。

`createRandomDog()`　です。

ワンちゃんの名前を適当に生成して、年齢も生成して、それを元に Dog を生成して、返します。

例外処理の書き方は適当です。

`DogList` Widget は、Dog の List を元に ListView を返します。
