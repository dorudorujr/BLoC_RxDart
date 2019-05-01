import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:bloc_rxdart/BlocFavoritePage.dart';
import 'package:bloc_rxdart/models/word_item.dart';
import 'package:bloc_rxdart/word_bloc.dart';
import 'package:bloc_rxdart/WordProvider.dart';
import 'package:bloc_rxdart/models/suggestion.dart';
import 'package:bloc_rxdart/widgets/CountLabel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //mainWidgetはWordProviderを親とする
    return WordProvider(
      child: MaterialApp(
        title: 'Startup Name Generator',
        theme: new ThemeData(primaryColor: Colors.white), //
        // テーマカラ-
        home: RandomWordsHomePage(),
        //画面遷移を指定
        routes: <String, WidgetBuilder> {
          BlocFavoritePage.routeName: (context) => BlocFavoritePage()
        },
      ),
    );
  }
}

class RandomWordsHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordBloc = WordProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup Name Generator"),
        actions: <Widget>[
          StreamBuilder<int>(
            stream: wordBloc.itemCount,
            initialData: 0, //初期値
            //無名関数
            builder: (context, snapshot) => CountLabel(
              favoriteCount: snapshot.data,
            ),
          ),
          new IconButton(
              icon:const Icon(Icons.list),
              onPressed: (){
                Navigator.of(context).pushNamed(BlocFavoritePage.routeName);
              }
          )
        ],
      ),
      body: WordList(),
    );
  }
}

class WordList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),

      //ListViewの各行をWidgetとして作る匿名関数を設定します
      //偶数行なら、この関数は ListTile を生成し、
      //奇数業なら、この関数は Divider widget (区切り線)を生成します
      itemBuilder: (context, i) {
        //偶数行ならば、区切り線を作成(Dividerで)
        if (i.isOdd) return new Divider();

        // "i ~/ 2" という文法は、 i を 2で割って整数を返します
        //これは ListView 内の実際の単語数を計算します。つまり区切り線の数を引きます
        final index = i ~/ 2;
        ////リストのインデックスがsuggestionsの要素数以上になったら単語を追加
        if (index >= suggestion.suggestionCount) {
          const addNum = 10;
          //生成した単語を追加している
          suggestion.addMulti(generateWordPairs().take(addNum).toList());
        }
        //精製した文字列を返却
        return _buildRow(WordProvider.of(context), suggestion.suggestedWords[index]);
      },
    );
  }

  //Listの一行の設定
  Widget _buildRow(WordBloc word, WordPair pair) {
    return new StreamBuilder<List<WordItem>>(
      stream: word.items, //いいねされた単語のリスト
      //いいねされた単語の名前をすべて取り出している
      builder: (_, snapshot) {
        if (snapshot.data == null || snapshot.data.isEmpty) {
          return _createWordListTile(word, false, pair.asPascalCase);
        } else {
          final addedWord = snapshot.data.map(
              (item) {
                return item.name;
              }
          );
          final alreadyAdded = addedWord.toString().contains(pair.asPascalCase);    //pairと同一の文字列があるかどうか(返り値はbool)
          return _createWordListTile(word, alreadyAdded, pair.asPascalCase);
        }
      },
    );
  }

  //お気に入りされている単語かどうかを判定して一行を作る
  ListTile _createWordListTile(WordBloc word, bool isFavorited, String title) {
    return new ListTile(
      title: new Text(title),
      trailing: new Icon(
        isFavorited ? Icons.favorite : Icons.favorite_border,
        color: isFavorited ? Colors.red : null,
      ),
      onTap: () {
        if (isFavorited) {
          word.wordRemoval.add(WordRemoval(title));
        } else {
          word.wordAddition.add(WordAddition(title));
        }
      },
    );
  }

}