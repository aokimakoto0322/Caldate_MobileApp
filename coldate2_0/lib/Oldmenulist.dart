import 'dart:async';

import 'package:coldate2_0/home_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Groval.dart';
import 'card.dart';

import 'DatabaseHelper.dart';

class Oldmenulist extends StatefulWidget {
  //databasehelper
  @override
  _OldmenulistState createState() => _OldmenulistState();
}

class _OldmenulistState extends State<Oldmenulist> {
  final dbHelper = DatabaseHelper.instance;
  final PageController pageController = PageController();

  //過去日付選択
  DateTime _date = DateTime.now();
  //選択フラグ
  bool flag = false;

  List<Map<String, dynamic>> pastlistitem = [];

  List<Map<String, dynamic>> tmpList = [];

  void pastincrement(){
      setState(() {
        //配列の初期化
        pastlistitem = [];

        //過去データ配列に検索値を選択
        tmpList.forEach((element) { 
          var splitmenu = element["menuname"].split("【");
          if(element["date"] == DateFormat('yyyy-MM-dd').format(_date)){
            print("合致");
            pastlistitem.add({
              "date": element["date"],
              "datetime": element["datetime"],
              "menuname": splitmenu[0],
              "menucal": element["menucal"]
            });
          }else{
            print("非合致");
          }
        });
        print(pastlistitem.toString());
      });
    }

  @override
  Widget build(BuildContext context) {
    //mediaquery
    final screenwidth = MediaQuery.of(context).size.width;
    final screenheight = MediaQuery.of(context).size.height;

    //今日の日時
    var now = DateTime.now();

    //昨日の日時
    var yesterday = now.add(Duration(days: 1) * -1);

    return Consumer<HomeModel>(builder: (context, model, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.cyan[10],
          body: Container(
            child: Center(
              child: FutureBuilder(
                future: _query(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //queryList
                    List<Map<String, dynamic>> listitem = snapshot.data;

                    List<Map<String, dynamic>> todaylistitem = [];

                    List<Map<String, dynamic>> yesterdaylistitem = [];


                    tmpList = listitem;
                    

                    //今日食べたカロリーの合計
                    int todayTotalcal = 0;

                    //昨日食べたカロリーの合計
                    int yesterdayTotalcal = 0;

                    //今日食べたものを抽出
                    listitem.forEach((element) {
                      if (element["date"] ==
                          DateFormat('yyyy-MM-dd').format(now)) {
                        var splitmenu = element["menuname"].split("【");
                        todaylistitem.add({
                          "date": element["date"],
                          "datetime": element["datetime"],
                          "menuname": splitmenu[0],
                          "menucal": element["menucal"]
                        });
                        todayTotalcal += element["menucal"];
                      }
                      //昨日食べたものを抽出
                      if (element["date"] ==
                          DateFormat('yyyy-MM-dd').format(yesterday)) {
                        var splitmenu = element["menuname"].split("【");
                        yesterdaylistitem.add({
                          "date": element["date"],
                          "datetime": element["datetime"],
                          "menuname": splitmenu[0],
                          "menucal": element["menucal"]
                        });
                        yesterdayTotalcal += element["menucal"];
                      }
                    });

                    

                    return PageView(
                      children: [
                        //リスト１　今日食べたもの
                        Center(
                          child: Container(
                            width: screenwidth - 50,
                            height: screenheight - 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff332A7C).withOpacity(0.5),
                                    blurRadius: 40.0)
                              ],
                              color: Color(0xff332A7C),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 40),
                                        child: Text(
                                          "今日食べたもの",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(top: 40),
                                      child: Text(
                                        "合計：$todayTotalcal" + "kCal",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: todaylistitem.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            todaylistitem[index]["menuname"],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            todaylistitem[index]["datetime"],
                                            style:
                                                TextStyle(color: Colors.white60),
                                          ),
                                          trailing: Text(
                                            todaylistitem[index]["menucal"]
                                                    .toString() +
                                                "kCal",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //リスト２ 昨日食べたもの
                        Center(
                          child: Container(
                            width: screenwidth - 50,
                            height: screenheight - 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffF25767).withOpacity(0.5),
                                    blurRadius: 40.0)
                              ],
                              color: Color(0xffF25767),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        margin: EdgeInsets.only(top: 40),
                                        child: Text(
                                          "昨日食べたもの",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Container(
                                      margin: EdgeInsets.only(top: 40),
                                      child: Text(
                                        "合計：$yesterdayTotalcal" + "kCal",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: yesterdaylistitem.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            yesterdaylistitem[index]["menuname"],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            yesterdaylistitem[index]["datetime"],
                                            style:
                                                TextStyle(color: Colors.white60),
                                          ),
                                          trailing: Text(
                                            yesterdaylistitem[index]["menucal"]
                                                    .toString() +
                                                "kCal",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //リスト３ 過去食べたものを検索
                        Center(
                          child: Container(
                            width: screenwidth - 50,
                            height: screenheight - 180,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffFFA000).withOpacity(0.5),
                                    blurRadius: 40.0)
                              ],
                              color: Color(0xffFFA000),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 40, left: 15),
                                      child: TextButton(
                                        child: flag == false
                                            ? Text(
                                              "過去のデータを選択する",
                                              style: TextStyle(
                                                fontSize: 22
                                              ),
                                              )
                                            : Text(_date.year.toString() + "年" + _date.month.toString() + "月" + _date.day.toString() + "日", style: TextStyle(fontSize: 22),),
                                        onPressed: () async {
                                          //日付選択
                                          _selectDate(context);

                                          //リスト更新
                                          //pastincrement();

                                        },
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 45),
                                      child: IconButton(
                                        icon: Icon(Icons.search_rounded),
                                        //リスト更新
                                        onPressed: () => pastincrement(),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    child: ListView.builder(
                                      itemCount: pastlistitem.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            pastlistitem[index]["menuname"],
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            pastlistitem[index]["datetime"],
                                            style:
                                                TextStyle(color: Colors.white60),
                                          ),
                                          trailing: Text(
                                            pastlistitem[index]["menucal"]
                                                    .toString() +
                                                "kCal",
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                      controller: pageController,
                      onPageChanged: (index) {
                        model.updateIndex(index);
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 100,
            decoration: BoxDecoration(
                color: Colors.black12,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 40.0)],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0))),
            child: Transform(
              transform:
                  Matrix4.translationValues(model.center(screenwidth), 0, 0),
              child: Stack(
                  children: List.generate(3, (index) {
                final card = CustomCard.fromMap(Global.cardData[index]);
                return Align(
                  alignment:
                      index == 0 ? Alignment.centerLeft : Alignment.centerRight,
                  child: Transform(
                    transform: Matrix4.translationValues(
                        model.spacing(screenwidth, index), 0, 0),
                    child: AnimatedContainer(
                      transform: Matrix4.translationValues(
                          index == 1 ? model.moveMiddle : 0, 0, 0),
                      duration: Duration(milliseconds: 500),
                      width: model.animation(index),
                      height: model.dotSize,
                      curve: Curves.elasticOut,
                      child: GestureDetector(
                        onTap: () {
                          model.updateIndex(index);

                          pageController.animateToPage(index,
                              duration: Duration(milliseconds: 1000),
                              curve: Curves.easeInOutQuart);
                          print("test" + index.toString());
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(model.dotSize / 2),
                              color: card.backGroundColor),
                        ),
                      ),
                    ),
                  ),
                );
              })),
            ),
          ),
        ),
      );
    });
  }

  void _incrementpast(){
    setState(() {
      
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    flag = true;
    if (picked != null) setState(() => _date = picked);
  }

  Future<List<Map<String, dynamic>>> _query() async {
    return await dbHelper.queryAllRows();
  }
}
