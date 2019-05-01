class WordItem {
  final String name;
  const WordItem(this.name);    //コンストラクタ(Dartでは代入部分を省略できる)

  @override
  String toString() => "$name";
}