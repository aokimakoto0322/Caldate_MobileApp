import 'package:coldate2_0/Alldate.dart';
import 'package:coldate2_0/Mainmenutab.dart';
import 'package:coldate2_0/Oldmenulist.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Animations/FadeAnimations.dart';
import 'models.dart';
import 'main.dart';

class graphlayout extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<graphlayout>
    with SingleTickerProviderStateMixin {
  var p1, p2, p3, p4, p5, p6, p7;
  List<BarChartGroupData> data = [];
  var width = 15.0;
  DateTime _changedDate = new DateTime.now();
  var _changeController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final InterstitialAd myInterstitial2 = InterstitialAd(
      adUnitId: 'ca-app-pub-8627512781946422/2312420457',
      request: AdRequest(),
      listener: AdListener(),
    );

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
                              future: Todo().select().toList(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  try {
                                    var i = snapshot.data;
                                    p1 = i[i.length - 1].toMap();
                                    if (i.length == 1) {
                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                      ];
                                    } else if (i.length == 2) {
                                      p2 = i[i.length - 2].toMap();
                                      data = [
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                      ];
                                    } else if (i.length == 3) {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    } else if (i.length == 4) {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      p4 = i[i.length - 4].toMap();

                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p4['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 3,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    } else if (i.length == 5) {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      p4 = i[i.length - 4].toMap();
                                      p5 = i[i.length - 5].toMap();

                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p5['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p4['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 3,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    } else if (i.length == 6) {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      p4 = i[i.length - 4].toMap();
                                      p5 = i[i.length - 5].toMap();
                                      p6 = i[i.length - 6].toMap();
                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p6['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p5['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p4['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 3,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    } else if (i.length == 7) {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      p4 = i[i.length - 4].toMap();
                                      p5 = i[i.length - 5].toMap();
                                      p6 = i[i.length - 6].toMap();
                                      p7 = i[i.length - 7].toMap();
                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p7['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p6['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p5['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p4['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 3,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    } else {
                                      p2 = i[i.length - 2].toMap();
                                      p3 = i[i.length - 3].toMap();
                                      p4 = i[i.length - 4].toMap();
                                      p5 = i[i.length - 5].toMap();
                                      p6 = i[i.length - 6].toMap();
                                      p7 = i[i.length - 7].toMap();
                                      data = [
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p7['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p6['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p5['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 0,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p4['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 1,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p3['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 2,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p2['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ]),
                                        BarChartGroupData(
                                            x: 3,
                                            barsSpace: 4,
                                            barRods: [
                                              BarChartRodData(
                                                y: p1['cal'].toDouble(),
                                                color: Color(0xffa18cd1),
                                                width: width,
                                              )
                                            ])
                                      ];
                                    }

                                    return BarChart(BarChartData(
                                        alignment:
                                            BarChartAlignment.spaceEvenly,
                                        barTouchData: BarTouchData(
                                            touchTooltipData:
                                                BarTouchTooltipData(
                                          maxContentWidth: 400,
                                          getTooltipItem: (group, groupIndex,
                                              rod, rodIndex) {
                                            return BarTooltipItem(
                                                rod.y.round().toString(),
                                                TextStyle(
                                                    color: Color(0xffa1c4fd),
                                                    fontWeight:
                                                        FontWeight.bold));
                                          },
                                        )),
                                        titlesData: FlTitlesData(
                                            show: true,
                                            bottomTitles: SideTitles(
                                                showTitles: true,
                                                margin: 10,
                                                textStyle: TextStyle(
                                                    color: Color(0xffa18cd1),
                                                    fontWeight:
                                                        FontWeight.bold),
                                                getTitles: (double value) {
                                                  if (i.length == 1) {
                                                    switch (value.toInt()) {
                                                      case 0:
                                                        return p1['date'];
                                                    }
                                                  } else if (i.length == 2) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    switch (value.toInt()) {
                                                      case 1:
                                                        return p1['date'];
                                                      case 0:
                                                        return p2['date'];
                                                    }
                                                  } else if (i.length == 3) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    switch (value.toInt()) {
                                                      case 2:
                                                        return p1['date'];
                                                      case 1:
                                                        return p2['date'];
                                                      case 0:
                                                        return p3['date'];
                                                    }
                                                  } else if (i.length == 4) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    p4 =
                                                        i[i.length - 4].toMap();
                                                    switch (value.toInt()) {
                                                      case 3:
                                                        return p1['date'];
                                                      case 2:
                                                        return p2['date'];
                                                      case 1:
                                                        return p3['date'];
                                                      case 0:
                                                        return p4['date'];
                                                    }
                                                  } else if (i.length == 5) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    p4 =
                                                        i[i.length - 4].toMap();
                                                    p5 =
                                                        i[i.length - 5].toMap();
                                                    switch (value.toInt()) {
                                                      case 4:
                                                        return p1['date'];
                                                      case 3:
                                                        return p2['date'];
                                                      case 2:
                                                        return p3['date'];
                                                      case 1:
                                                        return p4['date'];
                                                      case 0:
                                                        return p5['date'];
                                                    }
                                                  } else if (i.length == 6) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    p4 =
                                                        i[i.length - 4].toMap();
                                                    p5 =
                                                        i[i.length - 5].toMap();
                                                    p6 =
                                                        i[i.length - 6].toMap();
                                                    switch (value.toInt()) {
                                                      case 5:
                                                        return p1['date'];
                                                      case 4:
                                                        return p2['date'];
                                                      case 3:
                                                        return p3['date'];
                                                      case 2:
                                                        return p4['date'];
                                                      case 1:
                                                        return p5['date'];
                                                      case 0:
                                                        return p6['date'];
                                                    }
                                                  } else if (i.length == 7) {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    p4 =
                                                        i[i.length - 4].toMap();
                                                    p5 =
                                                        i[i.length - 5].toMap();
                                                    p6 =
                                                        i[i.length - 6].toMap();
                                                    p7 =
                                                        i[i.length - 7].toMap();
                                                    switch (value.toInt()) {
                                                      case 6:
                                                        return p1['date'];
                                                      case 5:
                                                        return p2['date'];
                                                      case 4:
                                                        return p3['date'];
                                                      case 3:
                                                        return p4['date'];
                                                      case 2:
                                                        return p5['date'];
                                                      case 1:
                                                        return p6['date'];
                                                      case 0:
                                                        return p7['date'];
                                                    }
                                                  } else {
                                                    p2 =
                                                        i[i.length - 2].toMap();
                                                    p3 =
                                                        i[i.length - 3].toMap();
                                                    p4 =
                                                        i[i.length - 4].toMap();
                                                    p5 =
                                                        i[i.length - 5].toMap();
                                                    p6 =
                                                        i[i.length - 6].toMap();
                                                    p7 =
                                                        i[i.length - 7].toMap();
                                                    switch (value.toInt()) {
                                                      case 6:
                                                        return p1['date'];
                                                      case 5:
                                                        return p2['date'];
                                                      case 4:
                                                        return p3['date'];
                                                      case 3:
                                                        return p4['date'];
                                                      case 2:
                                                        return p5['date'];
                                                      case 1:
                                                        return p6['date'];
                                                      case 0:
                                                        return p7['date'];
                                                    }
                                                  }
                                                }),
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
                                            )),
                                        //枠線を非表示
                                        borderData: FlBorderData(
                                          show: false,
                                        ),
                                        barGroups: data));
                                  } catch (e) {
                                    return Text('保存されているデータがありません');
                                  }
                                } else {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          )),
                    ),
                    FadeAnimation(
                        0.5,
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(15),
                              child: Center(
                                child: ElevatedButton(
                                  child: Text("食べたものを確認する"),
                                  onPressed: () {
                                    myInterstitial2.show();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Mainmenutab()));
                                  },
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  child: Center(
                                    child: ElevatedButton(
                                      child: Text('過去データをグラフで見る'),
                                      onPressed: () {
                                        myInterstitial.show();
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return Alldate();
                                        }));
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  child: ElevatedButton(
                                    child: Text('データ修正'),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Scaffold(
                                            backgroundColor: Colors.transparent,
                                            body: StatefulBuilder(
                                              builder: (context, setState) {
                                                return SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: 50,
                                                        child: FlatButton(
                                                          child: Icon(
                                                            Icons.clear,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 100,
                                                      ),
                                                      Text(
                                                        '変更する日時',
                                                        style: TextStyle(
                                                            fontSize: 40,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      FlatButton.icon(
                                                        icon: Icon(
                                                          Icons.calendar_today,
                                                          color: Colors.white,
                                                        ),
                                                        label: Text(
                                                          _changedDate.year
                                                                  .toString() +
                                                              '年' +
                                                              _changedDate.month
                                                                  .toString() +
                                                              '月' +
                                                              _changedDate.day
                                                                  .toString() +
                                                              '日',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30),
                                                        ),
                                                        onPressed: () async {
                                                          final DateTime
                                                              picked =
                                                              await showDatePicker(
                                                                  context:
                                                                      context,
                                                                  initialDate:
                                                                      _changedDate,
                                                                  firstDate:
                                                                      DateTime(
                                                                          2020),
                                                                  lastDate: DateTime
                                                                          .now()
                                                                      .add(Duration(
                                                                          days:
                                                                              360)));
                                                          if (picked != null) {
                                                            setState(() {
                                                              _changedDate =
                                                                  picked;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 100,
                                                      ),
                                                      Text(
                                                        '変更するカロリー',
                                                        style: TextStyle(
                                                            fontSize: 35,
                                                            color: Colors.white,
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 100,
                                                            right: 100),
                                                        child: TextField(
                                                          onSubmitted:
                                                              (value) async {
                                                            var p1 = await Todo().select().date.contains(_changedDate.month.toString() +'/' + _changedDate.day.toString()).toList();
                                                            print(_changedDate
                                                                    .month
                                                                    .toString() +
                                                                '/' +
                                                                _changedDate.day
                                                                    .toString());
                                                            try {
                                                              var x1 = p1[p1.length - 1].toMap();
                                                              var getid = x1['id'];
                                                              int cal = int.parse(
                                                                  _changeController
                                                                      .text);
                                                              Todo(
                                                                      id: getid,
                                                                      cal: cal)
                                                                  .save();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } catch (e) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              10))),
                                                                      backgroundColor: Color(
                                                                              0xffa18cd1)
                                                                          .withOpacity(
                                                                              0.85),
                                                                      title:
                                                                          Text(
                                                                        '項目にエラーがあります',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      content:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: <
                                                                            Widget>[
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Text(
                                                                            '・保存されていない日にちのカロリーは変更できません',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 16),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            '・変更するカロリーには数字以外は入力できません',
                                                                            style:
                                                                                TextStyle(color: Colors.white, fontSize: 16),
                                                                          )
                                                                        ],
                                                                      ));
                                                                },
                                                              );
                                                            }
                                                          },
                                                          controller:
                                                              _changeController,
                                                          decoration: InputDecoration(
                                                              hintText: '1234',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                              border: UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                          color:
                                                                              Colors.white))),
                                                          maxLength: 5,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 40),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
