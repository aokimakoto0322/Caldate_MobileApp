import 'package:coldate2_0/DatabaseHelper.dart';
import 'package:coldate2_0/database.dart';
import 'package:coldate2_0/metabo.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'colcounter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'indicator.dart';


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

  var now = DateTime.now();
  colcounter _col = colcounter();

  
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: <Widget>[
          FutureBuilder(
            future: _getOpacity(),
            builder: (context, snapshotopacity) {
              if(snapshotopacity.hasData){
                return FutureBuilder(
                  future: _getMainColor(),
                  builder: (context, snapshotcolor) {
                    if(snapshotcolor.hasData){
                      return Stack(
                        children: <Widget>[
                          Container(
                            height: size.height,
                            width: size.width,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(snapshotopacity.data.toDouble())
                            ),
                            child: FutureBuilder(
                              future: _query(),
                              builder: (context, snapshot) {
                                if(snapshot.hasData){
                                  try{
                                    //今日の総カロリーを計算
                                    //queryList
                                    List<Map<String, dynamic>> listitem = snapshot.data;
                                    var tmp0 = 0;

                                    listitem.forEach((element) { 
                                      if(element["date"] == DateFormat('yyyy-MM-dd').format(now)){
                                        tmp0 += element["menucal"];
                                        _col.setCol(tmp0);
                                      }
                                    });
                                    //*計算終わり */
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
                                        _todaycalresult = _col.getCol();
                                        g = i[i.length - 1].toMap();
                                        _metaboResult = g['meta'].toDouble() - _col.getCol().toDouble();

                                        var rad = _col.getCol().toDouble() / g['meta'] * 100;
                                        _todaycalresulttextrad = rad.toStringAsFixed(1) + '%';
                                        _todaycalresulttext = _col.getCol().toString() + 'kCal' + '\n' + _todaycalresulttextrad;
                                        

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
                                                  color: HexColor(snapshotcolor.data[0]),
                                                  value: _col.getCol().toDouble(),
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
                                  color: HexColor(snapshotcolor.data[0]),
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
                  },
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

  //DBHelperの設定
  final dbHelper = DatabaseHelper.instance;

  //食べ物リストからすべてのクエリ選択※一週間のクエリ取得の改善の余地あり
  Future<List<Map<String, dynamic>>> _query() async {
    return await dbHelper.queryAllRows();
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
}


