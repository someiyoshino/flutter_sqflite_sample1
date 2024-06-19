/// Dog Model Class
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

  /// mapに変換する用
  /// nullは許容していないはずなので、Object?ではなく、dynamicを使用する。
  /// 数値、文字列を許容するため、dynamicを使用する。
  /// 一般的にはデータベースからロードしたデータがnullかもしれないことには注意する...（誰かが）
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

  /// toString()を実装(override)する。
  /// Dogインスタンスのフィールドを文字列に変換する用。
  /// toString()は、print()関数で出力されるときなどに呼び出される。
  /// 文字列に変換されるときに暗黙的に呼び出される。
  @override
  String toString() {
    return 'Dog {id: $id, name: $name, age: $age}';
  }

  /// 便利メソッド
  /// カードのsubtitleやbodyに表示する文字列を返すメソッド
  String toBody() {
    return 'id: $id / age: $age';
  }

  /// タイトル文字列を返すメソッド
  /// nameの先頭文字を大文字にして返す
  String toTitle() {
    return name[0].toUpperCase() + name.substring(1);
  }
}
