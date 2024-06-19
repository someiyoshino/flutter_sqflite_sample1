/// Dog Class, Dog Model
/// id, name, age
/// このDogデータモデルの生成時には、id, name, ageの3つの値を必ず渡す必要がある
class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  /// toMap()メソッド
  /// mapに変換する用
  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  // このDogデータモデルの生成時には、id, name, ageの3つの値を必ず渡す必要がある
  // nullは許容されないので、Object?はマッチしない。
  // 数値、文字列を許容するため、dynamicを使用する。
  // データベースからloadしたときは、nullかもしれないことは注意する...（誰かが）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  /// insert用Mapに変換するメソッド
  /// idは自動採番のため指定しません。
  Map<String, dynamic> toInsertMap() {
    return {
      'name': name,
      'age': age,
    };
  }

  /// fromMap()メソッド
  /// mapからDogモデルに変換する用
  static Dog fromMap(Map<String, dynamic> map) {
    return Dog(
      id: map['id'] as int,
      name: map['name'] as String,
      age: map['age'] as int,
    );
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  // toString()を実装(override)する。
  // toString()は、print()関数で出力されるときに呼び出される。
  /// Dogインスタンスのフィールドを文字列に変換する用。
  // 文字列に変換されるときに呼び出されるようだ。暗黙ですね。
  @override
  String toString() {
    return 'Dog {id: $id, name: $name, age: $age}';
  }

  /// toStr()メソッド
  /// 便利メソッド
  /// モデルのフィールドにアクセスする機能はmodelに寄せたほうがよいと思っている
  String toBody() {
    return 'id: $id / age: $age';
    // 'id: ${dogs[index].id.toString()} / age: ${dogs[index].age.toString()}'
  }

  /// タイトル文字列を返すメソッド
  /// nameの先頭文字を大文字にして返す
  String toTitle() {
    return name[0].toUpperCase() + name.substring(1);
  }
}

/// モデルのフィールドにアクセスする機能はmodelに寄せたほうがよいと思っている
/// mainからdog.dartに移動したら、綺麗にまとまって記述できた気がする。
/// 
/// Modelは新しい型の作ったイメージかな。安全にDBとやり取りするための型。
/// 構造体のような基礎的であって、データの集合体を表す型。クラスである。
/// メソッドは持たなくてもよい。
/// インスタンスのフィールドを操作する場合は、メソッドを持つべきなのかもしれない。
/// helperやproviderとはモデル経由でやり取りをするのがよいのかもしれない。
/// 