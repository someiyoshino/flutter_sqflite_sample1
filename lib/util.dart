import 'dog.dart';
import 'dart:math';
import 'package:english_words/english_words.dart';

class Util {
  static var add = (int a, int b) => a + b;
  static var add2 = () {
    return 100;
  };

  static Dog createRandomDog() {
    var name = WordPair.random().asLowerCase;
    var age = Random().nextInt(10);
    return Dog(id: 0, name: name, age: age);
  }

  static var createRandomDog2 = () {
    var name = WordPair.random().asLowerCase;
    var age = Random().nextInt(10);
    return Dog(id: 0, name: name, age: age);
  };
}
