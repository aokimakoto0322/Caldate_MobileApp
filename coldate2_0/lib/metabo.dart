import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Animations/FadeAnimations.dart';
import 'database.dart';

class metabo extends StatefulWidget {
  @override
  _metaboState createState() => _metaboState();
}

class _metaboState extends State<metabo> {
  //0 equal Men , 1 equal Women Defalult men
  int sex = 0;
  int age = 20;
  int height = 170;
  int weight = 55;
  double kiso = 1.3;
  Metaboresult me = new Metaboresult();
  List<bool> _selections = List.generate(2, (_) => false);
  List<bool> _selections2 = List.generate(4, (_) => false);

  final Shader _linearGradient = LinearGradient(
    colors: <Color>[
      Color(0xffa18cd1),
      Color(0xfffbc2eb),
    ],
  ).createShader(
    Rect.fromLTWH(
      0.0,
      0.0,
      250.0,
      70.0,
    ),
  );

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 240,
          backgroundColor: Colors.black87,
          automaticallyImplyLeading: false,
          bottom: PreferredSize(
              child: Text(''), preferredSize: Size.fromHeight(50)),
          flexibleSpace: FutureBuilder(
              future: getmetabos(),
              builder: (context, snapshot) {
                try {
                  if (snapshot.hasData) {
                    var i = snapshot.data;
                    var g = i[i.length - 1].toMap();
                    return FutureBuilder(
                        future: _getOpacity(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue[50]
                                      .withOpacity(snapshot.data.toDouble())),
                              child: FlexibleSpaceBar(
                                title: FadeAnimation(
                                    1,
                                    Text(
                                      g['meta'].toString() + 'kCal',
                                      style: GoogleFonts.libreFranklin(
                                          foreground: Paint()
                                            ..shader = _linearGradient,
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                } catch (e) {
                  return FutureBuilder(
                      future: _getOpacity(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[50]
                                    .withOpacity(snapshot.data.toDouble())),
                            child: FlexibleSpaceBar(
                              title: Text(
                                'あなたの基礎代謝を\n計算してみましょう',
                                style: TextStyle(
                                  foreground: Paint()..shader = _linearGradient,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }
              }),
        ),
        SliverList(
            delegate: SliverChildListDelegate(<Widget>[
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1,
                        Container(
                          margin:
                              EdgeInsets.only(left: 20, top: 40, bottom: 30),
                          child: Text(
                            '基礎代謝とは？',
                            style:
                                TextStyle(fontSize: 30, color: Colors.black87),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.1,
                        Container(
                          margin: EdgeInsets.only(
                              top: 10, left: 25, right: 25, bottom: 10),
                          child: Text(
                            '"基礎代謝とは、普段の生活の中で歩いたり生活する上で必要なエネルギーです"',
                            style: TextStyle(color: Colors.black45),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    padding: EdgeInsets.only(bottom: 20),
                    child: FadeAnimation(
                        1.1,
                        Container(
                            margin: EdgeInsets.only(
                                top: 15, left: 25, right: 25, bottom: 20),
                            child: Text(
                              '年齢や性別、普段の活動量により一人ひとり基礎代謝量は違います\n以下の項目を入力して自身の基礎代謝量を測定してみましょう。',
                              style: TextStyle(color: Colors.black45),
                            ))),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Step1 性別は？',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Center(
                          child: ToggleButtons(
                            borderRadius: BorderRadius.circular(20),
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    padding: EdgeInsets.only(top: 3),
                                    child: Image.asset(
                                      'assets/images/mensicon.png',
                                      height: 30,
                                    ),
                                  ),
                                  Container(
                                    child: Text('men'),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    padding: EdgeInsets.only(top: 3),
                                    child: Image.asset(
                                      'assets/images/womensicon.png',
                                      height: 30,
                                    ),
                                  ),
                                  Container(
                                    child: Text('Women'),
                                  )
                                ],
                              ),
                            ],
                            isSelected: _selections,
                            onPressed: (int index) {
                              setState(() {
                                for (int buttonindex = 0;
                                    buttonindex < _selections.length;
                                    buttonindex++) {
                                  if (buttonindex == index) {
                                    _selections[buttonindex] = true;
                                  } else {
                                    _selections[buttonindex] = false;
                                  }
                                }
                              });
                              sex = index;
                            },
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Step2 何歳ですか？',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text('-'),
                              onPressed: () {
                                setState(() {
                                  if (age > 0) {
                                    age -= 1;
                                  } else {}
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  if (age > 10) {
                                    age -= 10;
                                  } else {}
                                });
                              },
                            ),
                            Text(age.toString() + '歳'),
                            TextButton(
                              child: Text('+'),
                              onPressed: () {
                                setState(() {
                                  age += 1;
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  age += 10;
                                });
                              },
                            )
                          ],
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Step3 身長は何cmですか？',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text('-'),
                              onPressed: () {
                                setState(() {
                                  if (height > 0) {
                                    height -= 1;
                                  } else {}
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  if (height > 10) {
                                    height -= 10;
                                  } else {}
                                });
                              },
                            ),
                            Text(height.toString() + 'cm'),
                            TextButton(
                              child: Text('+'),
                              onPressed: () {
                                setState(() {
                                  height += 1;
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  height += 10;
                                });
                              },
                            )
                          ],
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Step4 体重は何Kgですか？',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              child: Text('-'),
                              onPressed: () {
                                setState(() {
                                  if (weight > 0) {
                                    weight -= 1;
                                  } else {}
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  if (weight > 10) {
                                    weight -= 10;
                                  } else {}
                                });
                              },
                            ),
                            Text(weight.toString() + 'kg'),
                            TextButton(
                              child: Text('+'),
                              onPressed: () {
                                setState(() {
                                  weight += 1;
                                });
                              },
                              onLongPress: () {
                                setState(() {
                                  weight += 10;
                                });
                              },
                            )
                          ],
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Step5 普段の運動量はどのくらいですか？',
                            style: TextStyle(fontSize: 20),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Center(
                          child: ToggleButtons(
                            children: <Widget>[
                              Container(
                                child: Text('あまりしない'),
                              ),
                              Container(
                                child: Text('ふつう'),
                              ),
                              Container(
                                child: Text('する'),
                              ),
                              Container(
                                child: Text('よくする'),
                              ),
                            ],
                            isSelected: _selections2,
                            onPressed: (int index) {
                              //_selections2[index] = !_selections2[index];
                              setState(() {
                                for (int buttonindex = 0;
                                    buttonindex < _selections2.length;
                                    buttonindex++) {
                                  if (buttonindex == index) {
                                    _selections2[buttonindex] = true;
                                  } else {
                                    _selections2[buttonindex] = false;
                                  }
                                }
                              });
                              if (index == 0) {
                                kiso = 1.3;
                              } else if (index == 1) {
                                kiso = 1.5;
                              } else if (index == 2) {
                                kiso = 1.7;
                              } else if (index == 3) {
                                kiso = 1.9;
                              }
                            },
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            Colors.white.withOpacity(snapshot.data.toDouble())),
                    child: FadeAnimation(
                        1.2,
                        Container(
                          margin: EdgeInsets.only(bottom: 150),
                          child: Center(
                            child: ElevatedButton(
                              //shape: StadiumBorder(),
                              onPressed: () {
                                //男性のパターン
                                //13.397 * weight + 4.799 * height - 5.677 * age + 88.362
                                if (sex == 0) {
                                  var x1 = 13.397 * weight;
                                  var x2 = 4.799 * height;
                                  var x3 = 5.677 * age;
                                  var x4 = x1 + x2 - x3 + 88.362;
                                  var result = x4 * kiso;
                                  setState(() {
                                    InsertMetabo(result.toInt());
                                    me.setMetabo(result.toInt());
                                  });
                                } else if (sex == 1) {
                                  var x1 = 9.247 * weight;
                                  var x2 = 3.098 * height;
                                  var x3 = 4.33 * age;
                                  var x4 = x1 + x2 - x3 + 447.593;
                                  var result = x4 * kiso;
                                  InsertMetabo(result.toInt());
                                  setState(() {
                                    me.setMetabo(result.toInt());
                                  });
                                }
                              },
                              child: Text('基礎代謝を算出する'),
                            ),
                          ),
                        )),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              })
        ]))
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class Metaboresult {
  var _metaboresult = 0;
  var syoki = 'No Data';
  Metaboresult() {
    this._metaboresult = _metaboresult;
  }

  void setMetabo(int m) {
    this._metaboresult = m;
  }

  dynamic getResult() {
    if (this._metaboresult == 0) {
      return syoki;
    } else {
      return _metaboresult.toString() + 'kCal';
    }
  }
}
