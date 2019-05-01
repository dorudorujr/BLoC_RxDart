import 'dart:collection';

import 'package:bloc_rxdart/models/word_item.dart';

//表示するWordをモデル化
class Word {
  final List<WordItem> _items = <WordItem>[];

  Word();

  //特定要素の複製?
  Word.clone(Word word) {
    _items.addAll(word._items);
  }

  int get itemCount => _items.length;   //get(getter)

  //変更不可なリスト
  UnmodifiableListView<WordItem> get items => UnmodifiableListView(_items);

  void add(String name) {
    _updateCountAdd(name);
  }

  void remove (String name) {
    _updateCountRemove(name);
  }

  @override
  String toString() => "$items";

  //指定したnameを_itemsに追加
  void _updateCountAdd(String name) {
    for (int i = 0; i < _items.length; i++ ) {
      final item = _items[i];
      //既に追加済みなら無視
      if (name == item.name) { return; }
    }

    _items.add(WordItem(name));
  }

  void _updateCountRemove(String name) {
    for (int i = 0; i < _items.length; i++) {
      final item = _items[i];
      if (name == item.name) {
        _items.removeAt(i);
      }
    }
  }
}