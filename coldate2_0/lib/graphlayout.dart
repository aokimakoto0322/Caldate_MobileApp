import 'package:coldate2_0/Mainmenutab.dart';
import 'package:coldate2_0/Oldmenulist.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Animations/FadeAnimations.dart';
import 'colcounter.dart';
import 'main.dart';
import 'DatabaseHelper.dart';

class graphlayout extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<graphlayout>
    with SingleTickerProviderStateMixin {
  var p1, p2, p3, p4, p5, p6, p7;
  List<BarChartGroupData> data = [];
  var width = 15.0;
  DateTime _changedDate = DateTime.now();
  var _changeController = TextEditingController();

  //DBHelperのインスタンス生成
  final dbHelper = DatabaseHelper.instance;

  //過去日付選択
  DateTime _date = DateTime.now();

  bool isTouched = false;

  @override
  void initState() {
    super.initState();
    myInterstitial2.load();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  //食べ物リストからすべてのクエリ選択※一週間のクエリ取得の改善の余地あり
  Future<List<Map<String, dynamic>>> _query() async {
    return await dbHelper.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {

    //今日の日時
    DateTime now = DateTime.now();
    //今日食べたもののリストの初期化
    var todaycount = colcounter();

    //昨日の日時
    DateTime yesterday = now.add(Duration(days: 1) * -1);
    //昨日のカウンタ
    var yesterdaycount = colcounter();

    //二日前
    DateTime twodayago = now.add(Duration(days: 1) * -2);
    //二日前食べたもののリストの初期化
    var twodaycount = colcounter();

    //三日前
    DateTime threedayago = now.add(Duration(days: 1) * -3);
    //三日前食べたもののリストの初期化
    var threedaycount = colcounter();

    //四日前
    DateTime fourdayago = now.add(Duration(days: 1) * -4);
    //四日前食べたもののリストの初期化
    var fourdaycount = colcounter();

    //五日前
    DateTime fivedayago = now.add(Duration(days: 1) * -5);
    //五日前食べたもののリストの初期化
    var fivedaycount = colcounter();

    //六日前
    DateTime sixdayago = now.add(Duration(days: 1) * -6);
    //六日前食べたもののリストの初期化
    var sixdaycount = colcounter();


    return FutureBuilder(
        future: _getOpacity(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(snapshot.data.toDouble())),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: FadeAnimation(
                          0.5,
                          Container(
                            margin: EdgeInsets.only(top: 10, left: 5),
                            height: 500,
                            child: FutureBuilder(
                              future: _query(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  try{
                                    //その日食べた総カロリーの取得
                                    //すべてのリスト
                                    List<Map<String, dynamic>> list = snapshot.data;

                                    //各日のtmp
                                    var tmp0 = 0;
                                    var tmp1 = 0;
                                    var tmp2 = 0;
                                    var tmp3 = 0;
                                    var tmp4 = 0;
                                    var tmp5 = 0;
                                    var tmp6 = 0;

                                    //すべてのリストから、過去7日のカロリー総計を算出
                                    list.forEach((element) {
                                      //今日のカロリー総計
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(now)){
                                        tmp0 += element["menucal"];
                                        todaycount.setCol(tmp0);
                                      }

                                      //昨日のカロリー総計
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(yesterday)){
                                        tmp1 += element["menucal"];
                                        yesterdaycount.setCol(tmp1);
                                      }

                                      //二日前
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(twodayago)){
                                        tmp2 += element["menucal"];
                                        twodaycount.setCol(tmp2);
                                      }

                                      //三日前
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(threedayago)){
                                        tmp3 += element["menucal"];
                                        threedaycount.setCol(tmp3);
                                      }

                                      //四日前
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(fourdayago)){
                                        tmp4 += element["menucal"];
                                        fourdaycount.setCol(tmp4);
                                      }

                                      //五日前
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(fivedayago)){
                                        tmp5 += element["menucal"];
                                        fivedaycount.setCol(tmp5);
                                      }

                                      //六日前
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(sixdayago)){
                                        tmp6 += element["menucal"];
                                        sixdaycount.setCol(tmp6);
                                      }
                                    });

                                    //***カロリー総計計算終わり

                                    //グラフに描画

                                    data = [
                                      //六日前
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: sixdaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //五日前
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: fivedaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //四日前
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: fourdaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //三日前
                                      BarChartGroupData(
                                        x: 1,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: threedaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //二日前
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: twodaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //昨日
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: yesterdaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      ),
                                      //今日
                                      BarChartGroupData(
                                        x: 0,
                                        barsSpace: 4,
                                        barRods: [
                                          BarChartRodData(
                                            y: todaycount.getCol().toDouble(),
                                            color: Color(0xffa18cd1),
                                            width: width,
                                          )
                                        ]
                                      )
                                    ];

                                    return BarChart(
                                      BarChartData(
                                        alignment: BarChartAlignment.spaceEvenly,
                                        barTouchData: BarTouchData(
                                          touchTooltipData: BarTouchTooltipData(
                                            maxContentWidth: 400,
                                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                              return BarTooltipItem(
                                                rod.y.round().toString(),
                                                TextStyle(
                                                  color: Color(0xffa1c4fd),
                                                  fontWeight: FontWeight.bold
                                                )
                                              );
                                            },
                                          )
                                        ),
                                        titlesData: FlTitlesData(
                                          show: true,
                                          bottomTitles: SideTitles(
                                            showTitles: true,
                                            margin: 10,
                                            textStyle: TextStyle(
                                              color: Color(0xffa18cd1),
                                              fontWeight: FontWeight.bold
                                            ),
                                            getTitles: (value) {
                                              switch (value.toInt()) {
                                                case 6:
                                                  return now.month.toString() + "/" + now.day.toString();
                                                case 5:
                                                  return yesterday.month.toString() + "/" + yesterday.day.toString();
                                                case 4:
                                                  return twodayago.month.toString() + "/" + twodayago.day.toString();
                                                case 3:
                                                  return threedayago.month.toString() + "/" + threedayago.day.toString();
                                                case 2:
                                                  return fourdayago.month.toString() + "/" + fourdayago.day.toString();
                                                case 1:
                                                  return fivedayago.month.toString() + "/" + fivedayago.day.toString();
                                                case 0:
                                                  return sixdayago.month.toString() + "/" + sixdayago.day.toString();
                                              }
                                            },
                                          ),
                                          //左のタイトルを非表示
                                          leftTitles: SideTitles(
                                            showTitles: true,
                                            textStyle: TextStyle(
                                                color: Color(0xffa18cd1),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10),
                                            getTitles: (double value) {
                                              return value.toInt().toString();
                                            },
                                            interval: 500,
                                          ),
                                        ),
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups: data
                                      )
                                    );
                                  }catch(e){
                                    return Text('保存されているデータがありません');
                                  }
                                }else{
                                  return CircularProgressIndicator();
                                }
                              },
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
      );
  }
}
