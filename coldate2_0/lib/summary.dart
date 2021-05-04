import 'package:coldate2_0/DatabaseHelper.dart';
import 'package:coldate2_0/main.dart';
import 'package:coldate2_0/metabo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Animations/FadeAnimations.dart';
import 'Mainmenutab.dart';
import 'models.dart';
import 'colcounter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'MenuPage.dart';
import 'file_controller.dart';
import 'package:rate_my_app/rate_my_app.dart';

colcounter _col = new colcounter();
//メソッドチャンネルの設定
const MethodChannel _channel = const MethodChannel('package/coldate');



class Summary extends StatefulWidget {
  @override
  _summaryState createState() => _summaryState();
}

class _summaryState extends State<Summary> with SingleTickerProviderStateMixin, RouteAware {
  int sub = 0;
  var now = DateTime.now();
  List<Slide> slides = new List();
  AnimationController _controller;
  Animation<double> _animation;

  RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'rateMyApp',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 5,
      appStoreIdentifier: '1487352735',
      googlePlayIdentifier: 'com.makotoaoki.Caldate2');

  @override
  void initState() {
    super.initState();

    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = _controller;

    _rateMyApp.init().then((value) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: 'ご利用ありがとうございます。',
          message:
              'アプリの使い心地はいかがですか？\nもし気に入っていただけたら応援レビューをお願いいたします。\nご協力ありがとうございます。',
          actionsBuilder: (context, stars) {
            return [
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  print('Thanks for the' +
                      (stars == null ? '0' : stars.round().toString()) +
                      ' star(s) !');
                  await _rateMyApp
                      .callEvent(RateMyAppEventType.rateButtonPressed);
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                },
              )
            ];
          },
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20)),
          starRatingOptions: StarRatingOptions(),
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    DateTime now = DateTime.now();
    var dateformatter = DateFormat("yyyy-MM-dd HH:mm");

    

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
          future: _getOpacity(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(snapshot.data.toDouble())),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ClipPath(
                          clipper: MyClipper(),
                          child: Container(
                            height: size.height / 2.5,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  //透過率の設定２
                                  colors: [
                                    Color(0xffa18cd1).withOpacity(
                                        snapshot.data.toDouble()),
                                    Color(0xffc2e9fb).withOpacity(
                                        snapshot.data.toDouble()),
                                  ]),
                            ),
                            child: Stack(
                              children: <Widget>[
                                FadeAnimation(
                                    0.1,
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              EdgeInsets.only(top: 30, left: 30),
                                          child: Text(
                                            now.month.toString() +
                                                '/' +
                                                now.day.toString() +
                                                'の摂取カロリー',
                                            style: GoogleFonts.notoSans(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 30),
                                          child: Icon(
                                            Icons.calendar_today_outlined
                                          )
                                        )
                                      ],
                                    )),
                                Center(
                                  child: FadeAnimation(
                                      0.2,
                                      Container(
                                        constraints: BoxConstraints.expand(),
                                        child: FutureBuilder(
                                            future: Todo().select().toList(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var i, p;
                                                try {
                                                  i = snapshot.data;
                                                  p = i[i.length - 1].toMap();
                                                  _col.setCol(p['cal']);
                                                } catch (e) {
                                                  return Text(
                                                      'データが登録されていません');
                                                }
                                                return FutureBuilder(
                                                  future: getRewardtime(),
                                                  builder: (context, snapshot) {
                                                    if(snapshot.hasData){
                                                      return FlatButton(
                                                        onPressed: (){
                                                          if(now.isAfter(dateformatter.parse(snapshot.data))){
                                                            print("今日よりどうがえつらんが後");
                                                            print(dateformatter.parse(snapshot.data));
                                                            myInterstitial2.show();
                                                          }else{
                                                            print("今日よりどうがえつらんが前");
                                                            print(dateformatter.parse(snapshot.data));
                                                          }
                                                          //myInterstitial2.show();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Mainmenutab()
                                                            )
                                                          );
                                                        },
                                                        textColor: Colors.white,
                                                        padding: EdgeInsets.all(0),
                                                        child: Container(
                                                          padding:
                                                            EdgeInsets.all(10),
                                                          child: Text(
                                                          (() {
                                                            //DBにアクセスして、今日の日付とDB最新の日付と比較
                                                            //DBに今日の日付が有ったら0と書く

                                                            if (p['date'] ==
                                                                now.month
                                                                        .toString() +
                                                                    '/' +
                                                                    now.day
                                                                        .toString()) {
                                                              return p['cal']
                                                                      .toString() +
                                                                  'kCal';
                                                            } else {
                                                              _col.setCol(0);
                                                              var nextday = now
                                                                      .day
                                                                      .toInt() +
                                                                  1;
                                                              //Todo(id: p.length + 1, cal: 0, date: now.month.toString() + '/' + nextday.toString(), year: now.year.toString()).save();
                                                              return '0kCal';
                                                            }
                                                          })(),
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 65),
                                                          )
                                                        ),
                                                      );
                                                    }else{
                                                      //リワード広告を見ていない場合
                                                      return FlatButton(
                                                        onPressed: (){
                                                          myInterstitial2.show();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Mainmenutab()
                                                            )
                                                          );
                                                        },
                                                        textColor: Colors.white,
                                                        padding: EdgeInsets.all(0),
                                                        child: Container(
                                                            padding:
                                                                EdgeInsets.all(10),
                                                            child: Text(
                                                              (() {
                                                                //DBにアクセスして、今日の日付とDB最新の日付と比較
                                                                //DBに今日の日付が有ったら0と書く

                                                                if (p['date'] ==
                                                                    now.month
                                                                            .toString() +
                                                                        '/' +
                                                                        now.day
                                                                            .toString()) {
                                                                  return p['cal']
                                                                          .toString() +
                                                                      'kCal';
                                                                } else {
                                                                  _col.setCol(0);
                                                                  var nextday = now
                                                                          .day
                                                                          .toInt() +
                                                                      1;
                                                                  //Todo(id: p.length + 1, cal: 0, date: now.month.toString() + '/' + nextday.toString(), year: now.year.toString()).save();
                                                                  return '0kCal';
                                                                }
                                                              })(),
                                                              style:
                                                                  GoogleFonts.lato(
                                                                      fontSize: 65),
                                                          )
                                                        ),
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                return CircularProgressIndicator();
                                              }
                                            }),
                                      )),
                                ),
                              ],
                            ),
                          )),
                      FutureBuilder(
                          future: _getOpacity(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                //透過の設定

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    FadeAnimation(
                                        0.3,
                                        Container(
                                          margin: EdgeInsets.only(bottom: 15),
                                          padding: EdgeInsets.all(10),
                                          child: GestureDetector(
                                            onLongPress: () {
                                              setState(() {
                                                sub = 0;
                                                _animation = new Tween<
                                                            double>(
                                                        begin:
                                                            _animation.value,
                                                        end: 0)
                                                    .animate(new CurvedAnimation(
                                                        curve: Curves
                                                            .fastLinearToSlowEaseIn,
                                                        parent: _controller));
                                              });
                                              _controller.forward(from: 0.0);
                                            },
                                            child: AnimatedBuilder(
                                                animation: _animation,
                                                builder: (context, child) {
                                                  return Text(
                                                    _animation.value
                                                        .toStringAsFixed(0),
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        color:
                                                            Colors.black87),
                                                  );
                                                }),
                                          ),
                                        )),
                                  ],
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          }),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              FadeAnimation(
                                  0.7,
                                  RaisedButton(
                                    textColor: Colors.black87,
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    highlightElevation: 9,
                                    highlightColor: Color(0xFFa1c4fd),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      setState(() {
                                        sub += 1;
                                        _animation = new Tween<double>(
                                          begin: _animation.value,
                                          end: sub.toDouble(),
                                        ).animate(new CurvedAnimation(
                                            curve:
                                                Curves.fastLinearToSlowEaseIn,
                                            parent: _controller));
                                      });
                                      _controller.forward(from: 0.0);
                                    },
                                  ))
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              FadeAnimation(
                                  0.7,
                                  RaisedButton(
                                    textColor: Colors.black87,
                                    child: Text(
                                      '10',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    highlightColor: Colors.yellow[300],
                                    highlightElevation: 9,
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      buildSetState();
                                      _controller.forward(from: 0.0);
                                    },
                                  ))
                            ],
                          ),
                          Column(children: <Widget>[
                            FadeAnimation(
                                0.7,
                                RaisedButton(
                                  textColor: Colors.black87,
                                  child: Text(
                                    '100',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  highlightColor: Colors.red[300],
                                  highlightElevation: 9,
                                  shape: StadiumBorder(),
                                  onPressed: () {
                                    setState(() {
                                      sub += 100;
                                      _animation = new Tween<double>(
                                        begin: _animation.value,
                                        end: sub.toDouble(),
                                      ).animate(new CurvedAnimation(
                                          curve:
                                              Curves.fastLinearToSlowEaseIn,
                                          parent: _controller));
                                    });
                                    _controller.forward(from: 0.0);
                                  },
                                ))
                          ])
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FadeAnimation(
                          1,
                          Container(
                              margin: EdgeInsets.all(10),
                              child: RaisedButton(
                                  textColor: Colors.white,
                                  padding: const EdgeInsets.all(0),
                                  shape: StadiumBorder(),
                                  color: Colors.deepPurple[200],
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Text('今日の摂取カロリーに追加する'),
                                  ),
                                  onPressed: () async {
                                    //食べたものリストInsert
                                    _insert(sub);

                                    final pl = await Todo().select().toList();
                                    setState(() {
                                      var x = _col.getCol();
                                      x += sub;
                                      _col.setCol(x);

                                      _animation = new Tween<double>(
                                              begin: _animation.value, end: 0)
                                          .animate(new CurvedAnimation(
                                              curve: Curves
                                                  .fastLinearToSlowEaseIn,
                                              parent: _controller));
                                      _controller.forward(from: 0.0);
                                      sub = 0;
                                      //もしデータベースに何も入っていない場合(データベース内データ数参照

                                      if (pl.length == 0) {
                                        Todo(
                                          cal: _col.getCol(),
                                          date: now.month.toString() +
                                              '/' +
                                              now.day.toString(),
                                          year: now.year.toString(),
                                        ).save();
                                      } else {
                                        var p = pl[pl.length - 1].toMap();
                                        if (now.month.toString() +
                                                '/' +
                                                now.day.toString() ==
                                            p['date']) {
                                          Todo(
                                                  id: p['id'],
                                                  cal: _col.getCol(),
                                                  date: now.month.toString() +
                                                      '/' +
                                                      now.day.toString(),
                                                  year: now.year.toString())
                                              .save();
                                        } else {
                                          Todo(
                                                  cal: _col.getCol(),
                                                  date: now.month.toString() +
                                                      '/' +
                                                      now.day.toString(),
                                                  year: now.year.toString())
                                              .save();
                                        }
                                      }

                                      //methodchannel
                                      _channel.invokeMethod(
                                          'test', _col.getCol().toString());

                                      for (var x in pl) {
                                        //print(x.toMap());
                                      }
                                      //print(pl.length);
                                    });
                                  }))),
                      FadeAnimation(
                          1.1,
                          FutureBuilder(
                            future: getRewardtime(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                if(now.isAfter(dateformatter.parse(snapshot.data))){
                                  print("今日よりどうがえつらんが後");
                                  print(dateformatter.parse(snapshot.data));
                                  myInterstitial.show();

                                  //画面遷移
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return MenuPage();
                                    },
                                  ));
                                }else{
                                  print("今日よりどうがえつらんが前");
                                  print(dateformatter.parse(snapshot.data));
                                }
                              }else{
                                return Container(
                                  child: RaisedButton(
                                    child: Text('メニュー一覧'),
                                    shape: StadiumBorder(),
                                    onPressed: () {
                                      myInterstitial.show();
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) {
                                          return MenuPage();
                                        },
                                      ));
                                    },
                                  ),
                                );
                              }
                            },
                          )),
                      SizedBox(
                        height: 250,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }

  Future<String> getRewardtime() async{
    //リワードに設定された時間の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("REWARD_DAY") == null ? "1900-09-09 23:59" : prefs.getString("REWARD_DAY");
  }

  //DBHelperの設定
  final dbHelper = DatabaseHelper.instance;

  //食べたものリストのINSERT
  void _insert(int cal) async {
    Map<String, dynamic> row = {
      DatabaseHelper.date: DateFormat('yyyy-MM-dd').format(now),
      DatabaseHelper.datetime: DateFormat('HH:mm').format(now),
      DatabaseHelper.menuname: "手入力",
      DatabaseHelper.menucal: cal,
    };
    await dbHelper.insert(row);
    print("INSERT成功");
  }

  void buildSetState() {
    return setState(() {
      sub += 10;
      _animation = new Tween<double>(
        begin: _animation.value,
        end: sub.toDouble(),
      ).animate(new CurvedAnimation(
          curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
    });
  }
}
