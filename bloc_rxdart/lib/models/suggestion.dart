import 'dart:collection';
import 'package:english_words/english_words.dart';

final Suggestion suggestion = Suggestion();

class Suggestion {
  final List<WordPair> _suggestedWords = <WordPair>[];  //生成された単語を保持

  Suggestion();

  //なくても動作は正常にする
  /*Suggestion.clone(Suggestion suggestion) {
    _suggestedWords.addAll(suggestion._suggestedWords);
  }*/

  int get suggestionCount => _suggestedWords.length;

  // 変更不可なリスト
  //値はここでしか変えられないということ
  //suggestedWordsがなくても機能面ではかわりない
  UnmodifiableListView<WordPair> get suggestedWords => UnmodifiableListView(_suggestedWords);

  void add(WordPair wordPair) {
    _updateCount(wordPair);
  }

  //WordPairを一気に生成して、一気に追加するために定義
  void addMulti(List<WordPair> wordPairs) {
    for (int i = 0; i < wordPairs.length; ++i) {
      _updateCount(wordPairs[i]);
    }
  }

  void _updateCount(WordPair wordPair) {
    _suggestedWords.add(wordPair);
  }
}