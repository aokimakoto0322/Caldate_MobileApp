import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Animations/FadeAnimations.dart';
import 'colcounter.dart';
import 'DatabaseHelper.dart';

class graphlayout extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<graphlayout>
    with SingleTickerProviderStateMixin {
  List<BarChartGroupData> data = [];
  var width = 12.0;
  DateTime _changedDate = DateTime.now();
  var _changeController = TextEditingController();

  //DBHelperのインスタンス生成
  final dbHelper = DatabaseHelper.instance;

  //過去日付選択
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  //メインカラーの取得
  _getMainColor() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList("ColorLis") ?? ["#a18cd1","#fbc2eb"];
  }

  //食べ物リストからすべてのクエリ選択※一週間のクエリ取得の改善の余地あり
  Future<List<Map<String, dynamic>>> _query() async {
    return await dbHelper.queryAllRows();
  }

  @override
  Widget build(BuildContext context) {

    //青表示グラフの定義

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

    //青表示グラフ表示定義End

    //赤表示グラフ表示定義Start

    //七日前
    DateTime sevendayago = now.add(Duration(days: 1) * -7);
    //七日前食べたもののリストの初期化
    var sevendaycount = colcounter();

    //八日前
    DateTime eightdayago = now.add(Duration(days: 1) * -8);
    //八日前食べたもののリストの初期化
    var eightdaycount = colcounter();

    //九日前
    DateTime ninedayago = now.add(Duration(days: 1) * -9);
    //九日前食べたもののリストの初期化
    var ninedaycount = colcounter();

    //十日前
    DateTime tendayago = now.add(Duration(days: 1) * -10);
    //十日前食べたもののリストの初期化
    var tendaycount = colcounter();

    //十一日前
    DateTime elevendayago = now.add(Duration(days: 1) * -11);
    //十一日前食べたもののリストの初期化
    var elevendaycount = colcounter();

    //十二日前
    DateTime twelvedayago = now.add(Duration(days: 1) * -12);
    //十二日前食べたもののリストの初期化
    var twelvedaycount = colcounter();

    //十三日前
    DateTime thirteendayago = now.add(Duration(days: 1) * -13);
    //十三日前食べたもののリストの初期化
    var thirteendaycount = colcounter();


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
                    FadeAnimation(
                      0.3,
                      SizedBox(
                        width: double.infinity,
                        child: FutureBuilder(
                          future: _getMainColor(),
                          builder: (context, snapshotcolor) {
                            if(snapshotcolor.hasData){
                              return Container(
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
                                        var tmp7 = 0;
                                        var tmp8 = 0;
                                        var tmp9 = 0;
                                        var tmp10 = 0;
                                        var tmp11 = 0;
                                        var tmp12 = 0;
                                        var tmp13 = 0;

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

                                          //赤グラフ表示
                                          //七
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(sevendayago)){
                                            tmp7 += element["menucal"];
                                            sevendaycount.setCol(tmp7);
                                          }

                                          //八
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(eightdayago)){
                                            tmp8 += element["menucal"];
                                            eightdaycount.setCol(tmp8);
                                          }

                                          //九
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(ninedayago)){
                                            tmp9 += element["menucal"];
                                            ninedaycount.setCol(tmp9);
                                          }

                                          //十
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(tendayago)){
                                            tmp10 += element["menucal"];
                                            tendaycount.setCol(tmp10);
                                          }

                                          //十一
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(elevendayago)){
                                            tmp11 += element["menucal"];
                                            elevendaycount.setCol(tmp11);
                                          }

                                          //十二
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(twelvedayago)){
                                            tmp12 += element["menucal"];
                                            twelvedaycount.setCol(tmp12);
                                          }

                                          //十三
                                          if(element["date"] == DateFormat('yyyy-MM-dd').format(thirteendayago)){
                                            tmp13 += element["menucal"];
                                            thirteendaycount.setCol(tmp13);
                                          }

                                          //赤グラフ表示計算終わり
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
                                                y: thirteendaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: sixdaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
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
                                                y: twelvedaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: fivedaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
                                                width: width,
                                              )
                                            ]
                                          ),
                                          BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              //四日前
                                              BarChartRodData(
                                                y: elevendaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: fourdaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
                                                width: width
                                              )
                                            ]
                                          ),
                                          //三日前
                                          BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: tendaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: threedaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
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
                                                y: ninedaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: twodaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
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
                                                y: eightdaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: yesterdaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
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
                                                y: sevendaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[1]),
                                                width: width,
                                              ),
                                              BarChartRodData(
                                                y: todaycount.getCol().toDouble(),
                                                color: HexColor(snapshotcolor.data[0]),
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
                                                      color: Colors.black54,
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
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold
                                                ),
                                                getTitles: (value) {
                                                  switch (value.toInt()) {
                                                    case 6:
                                                      return now.month.toString() + "/" + now.day.toString() + "\n" + "/" + sevendayago.day.toString();
                                                    case 5:
                                                      return yesterday.month.toString() + "/" + yesterday.day.toString() + "\n" + "/" + eightdayago.day.toString();
                                                    case 4:
                                                      return twodayago.month.toString() + "/" + twodayago.day.toString() + "\n" + "/" + ninedayago.day.toString();
                                                    case 3:
                                                      return threedayago.month.toString() + "/" + threedayago.day.toString() + "\n" + "/" + tendayago.day.toString();
                                                    case 2:
                                                      return fourdayago.month.toString() + "/" + fourdayago.day.toString() + "\n" + "/" + elevendayago.day.toString();
                                                    case 1:
                                                      return fivedayago.month.toString() + "/" + fivedayago.day.toString() + "\n" + "/" + twelvedayago.day.toString();
                                                    case 0:
                                                      return sixdayago.month.toString() + "/" + sixdayago.day.toString() + "\n" + "/" + thirteendayago.day.toString();
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
                              );
                            }else{
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
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
