import 'package:coldate2_0/database.dart';
import 'package:coldate2_0/metabo.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'indicator.dart';

import 'models.dart';

class Piechart extends StatefulWidget {
  @override
  _PiechartState createState() => _PiechartState();
}


class _PiechartState extends State<Piechart> {
  int touchedIndex;
  var todaycal2;
  var _todaycalresult;
  var _todaycalresulttext;
  var _todaycalresulttextrad;

  var _metaboResult;
  var _metaboResultText;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          FutureBuilder(
            future: _getOpacity(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return Stack(
                  children: <Widget>[
                    Container(
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(snapshot.data.toDouble())
                      ),
                      child: FutureBuilder(
                        future: Todo().select().toList(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            var todaycal = snapshot.data;
                            try{
                              todaycal2 = todaycal[todaycal.length - 1].toMap();
                            }catch(e){
                              _todaycalresult = 1.0;
                              _todaycalresulttext = '未計測';
                            }
                          }else{
                            return CircularProgressIndicator();
                          }
                          return FutureBuilder(
                            future: getmetabos(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                var i = snapshot.data;
                                var g;
                                try{
                                  
                                  _todaycalresult = todaycal2['cal'].toDouble();
                                  g = i[i.length - 1].toMap();
                                  _metaboResult = g['meta'].toDouble() - todaycal2['cal'].toDouble();

                                  var rad = todaycal2['cal'] / g['meta'] * 100;
                                  _todaycalresulttextrad = rad.toStringAsFixed(1) + '%';
                                  _todaycalresulttext = todaycal2['cal'].toString() + 'kCal' + '\n' + _todaycalresulttextrad;
                                  

                                  _metaboResultText = _metaboResult.toStringAsFixed(0);
                                }catch(e){
                                  _metaboResult = 1.0;
                                  _metaboResultText = '未計測';
                                }
                                return PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(touchCallback: (PieTouchResponse){
                                      setState(() {
                                        if(PieTouchResponse.touchInput is FlLongPressEnd || PieTouchResponse.touchInput is FlPanEnd){
                                          touchedIndex = -1;
                                        }else{
                                          touchedIndex = PieTouchResponse.touchedSectionIndex;
                                        }
                                      });
                                    }),
                                    borderData: FlBorderData(
                                      show: false
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 50,
                                    // ignore: missing_return
                                    sections: List.generate(2, (index) {
                                      final isTouched = index == touchedIndex;
                                      final double fontSize = isTouched ? 26 : 22;
                                      final double radius = isTouched ? 140 : 120;
                                      switch(index){
                                        case 0:
                                          return PieChartSectionData(
                                            color: const Color(0x42000000),
                                            value: _metaboResult,
                                            title: _metaboResultText + 'kCal',
                                            radius: radius,
                                            titleStyle: TextStyle(
                                              fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white
                                            )
                                          );
                                        case 1:
                                          return PieChartSectionData(
                                            color: const Color(0xffa18cd1),
                                            value: _todaycalresult,
                                            title: _todaycalresulttext,
                                            radius: radius,
                                            titleStyle: TextStyle(
                                              fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white
                                            )
                                          );
                                      }
                                    })
                                  )
                                );
                              }else{
                                return CircularProgressIndicator();
                              }
                              
                            }
                          );
                        }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20,left: 20),
                      child: Text(
                        '基礎代謝と摂取カロリーの割合',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 70, left: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Indicator(
                            color: Color(0xffa18cd1),
                            text: '今日の摂取カロリー',
                            isSquare: false,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Indicator(
                            color: Color(0x42000000),
                            text: '推奨摂取カロリー',
                            isSquare: false,
                          )
                        ],
                      ),
                    )
                  ],
                );
              }else{
                return CircularProgressIndicator();
              }
            }
          ),
        ],
      ),
    );
  }


  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }
}


