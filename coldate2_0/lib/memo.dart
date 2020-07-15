class Memo{
  final int metab;
  Memo({this.metab});

  Map<String, dynamic> toMap(){
    return{
      'meta' : metab
    };
  }
  @override
  String toString() {
    return 'Memo{meta: $metab}';
  }
}