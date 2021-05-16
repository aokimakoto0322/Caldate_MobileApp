import 'dart:async';

import 'package:coldate2_0/home_model.dart';
import 'package:coldate2_0/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Groval.dart';
import 'card.dart';
import 'colcounter.dart';

import 'DatabaseHelper.dart';

class Oldmenulist extends StatefulWidget {
  //databasehelper
  @override
  _OldmenulistState createState() => _OldmenulistState();
}

class _OldmenulistState extends State<Oldmenulist> {
  final dbHelper = DatabaseHelper.instance;
  final PageController pageController = PageController();

  //snackbar表示のscaffoldkey設定
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  //DBに保管するためのカウンタ
  var todaycount = colcounter();

  var yesterdaycount = colcounter();

  var pastcount = colcounter();

  //過去日付選択
  DateTime _date = DateTime.now();
  //選択フラグ
  bool flag = false;

  List<Map<String, dynamic>> pastlistitem = [];

  List<Map<String, dynamic>> tmpList = [];

  //Edittextメニュー名の初期値設定のコントローラー
  TextEditingController menuController = TextEditingController();

  //Edittextカロリーの初期値設定のコントローラー
  TextEditingController calController = TextEditingController();

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
              "id" : element["_id"],
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
          key: _scaffoldKey,
          backgroundColor: Colors.cyan[10],
          body: Container(
            child: Center(
              child: FutureBuilder(
                future: _query(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    //queryList
                    List<Map<String, dynamic>> listitem = snapshot.data;

                    //今日食べたもののリストの初期化
                    List<Map<String, dynamic>> todaylistitem = [];

                    //昨日食べたもののリストの初期化
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
                          "id" : element["_id"],
                          "date": element["date"],
                          "datetime": element["datetime"],
                          "menuname": splitmenu[0],
                          "menucal": element["menucal"]
                        });
                        todayTotalcal += element["menucal"];
                        todaycount.setCol(todayTotalcal);
                      }
                      //昨日食べたものを抽出
                      if (element["date"] ==
                          DateFormat('yyyy-MM-dd').format(yesterday)) {
                        var splitmenu = element["menuname"].split("【");
                        yesterdaylistitem.add({
                          "id" : element["_id"],
                          "date": element["date"],
                          "datetime": element["datetime"],
                          "menuname": splitmenu[0],
                          "menucal": element["menucal"]
                        });
                        yesterdayTotalcal += element["menucal"];
                        yesterdaycount.setCol(yesterdayTotalcal);
                      }
                    });

                    //今日食べたものリストから削除するメソッド
                    Future<bool> _showConfirmationDialog(BuildContext context, String action, int index, int id) {
                      return showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return FutureBuilder(
                            future: Todo().select().toList(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return AlertDialog(
                                  title: Text('削除'),
                                  content: Text("$action を削除しますか？"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('いいえ'),
                                      onPressed: () {
                                        Navigator.pop(context, false); // showDialog() returns false
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('はい'),
                                      onPressed: () {
                                        Navigator.pop(context, true); // showDialog() returns true
                                        setState(() {
                                          //リストから削除
                                          todaylistitem.removeAt(index);
                                          //食べたもののDBから削除
                                          _delete(id);

                                          //入力後のトータルカロリーの再計算
                                          int tmp = 0;
                                          todaylistitem.forEach((element) {
                                            tmp += element["menucal"];
                                          });
                                          //再計算した値をセット
                                          todaycount.setCol(tmp);
                                          
                                          //summaryに表示されるDBの値をUPDATEで変更
                                          Todo(id: snapshot.data.length, cal: todaycount.getCol(), date: now.month.toString() + '/' + now.day.toString(), year: now.year.toString()).save();

                                          //snackBarの表示
                                          _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text("削除しました"),
                                              duration: const Duration(seconds: 5),
                                              action: SnackBarAction(
                                                label: "OK",
                                                onPressed: () {
                                                  //snackbarのOKボタンを押したときの動作
                                                  //特になし
                                                },
                                              ),
                                            )
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }else{
                                return CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      );
                    }

                    //昨日食べたものから削除するメソッド
                    Future<bool> _showConfirmationYesterdayDialog(BuildContext context, String action, int index, int id) {
                      return showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return FutureBuilder(
                            future: Todo().select().toList(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return AlertDialog(
                                  title: Text('削除'),
                                  content: Text("$action を削除しますか？"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('いいえ'),
                                      onPressed: () {
                                        Navigator.pop(context, false); // showDialog() returns false
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('はい'),
                                      onPressed: () {
                                        Navigator.pop(context, true); // showDialog() returns true
                                        setState(() {
                                          //リストから削除
                                          yesterdaylistitem.removeAt(index);
                                          //食べたもののDBから削除
                                          _delete(id);

                                          //入力後のトータルカロリーの再計算
                                          int tmp = 0;
                                          yesterdaylistitem.forEach((element) {
                                            tmp += element["menucal"];
                                          });
                                          //再計算した値をセット
                                          yesterdaycount.setCol(tmp);
                                          
                                          //summaryに表示されるDBの値をUPDATEで変更
                                          Todo(id: snapshot.data.length-1, cal: yesterdaycount.getCol(), date: yesterday.month.toString() + '/' + yesterday.day.toString(), year: yesterday.year.toString()).save();

                                          //snackBarの表示
                                          _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text("削除しました"),
                                              duration: const Duration(seconds: 5),
                                              action: SnackBarAction(
                                                label: "OK",
                                                onPressed: () {
                                                  //snackbarのOKボタンを押したときの動作
                                                  //特になし
                                                },
                                              ),
                                            )
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }else{
                                return CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      );
                    }

                    //過去食べたものから削除するメソッド
                    Future<bool> _showConfirmationPastDialog(BuildContext context, String action, int index, int id, String selectedDate, String selectedYear) {
                      return showDialog<bool>(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return FutureBuilder(
                            future: Todo().select().toList(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData){
                                return AlertDialog(
                                  title: Text('削除'),
                                  content: Text("$action を削除しますか？"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('いいえ'),
                                      onPressed: () {
                                        Navigator.pop(context, false); // showDialog() returns false
                                      },
                                    ),
                                    ElevatedButton(
                                      child: const Text('はい'),
                                      onPressed: (){
                                        Navigator.pop(context, true); // showDialog() returns true
                                        setState(() async {
                                          //リストから削除
                                          pastlistitem.removeAt(index);
                                          //食べたもののDBから削除
                                          _delete(id);

                                          //入力後のトータルカロリーの再計算
                                          int tmp = 0;
                                          pastlistitem.forEach((element) {
                                            tmp += element["menucal"];
                                          });
                                          //再計算した値をセット
                                          pastcount.setCol(tmp);

                                          //id取得
                                          var p1 = await Todo().select().date.contains(selectedDate).toList();
                                          var x1 = p1[p1.length - 1].toMap();
                                          var getid = x1['id'];
                                          
                                          //summaryに表示されるDBの値をUPDATEで変更
                                          Todo(id: getid, cal: pastcount.getCol(), date: selectedDate, year: selectedYear).save();

                                          //snackBarの表示
                                          _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                              content: Text("削除しました"),
                                              duration: const Duration(seconds: 5),
                                              action: SnackBarAction(
                                                label: "OK",
                                                onPressed: () {
                                                  //snackbarのOKボタンを押したときの動作
                                                  //特になし
                                                },
                                              ),
                                            )
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              }else{
                                return CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      );
                    }

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
                                        return Dismissible(
                                          key: ObjectKey(todaylistitem[index]["id"]),
                                          background: Container(
                                            color: Colors.red,
                                          ),
                                          confirmDismiss: (direction) async{
                                            switch(direction) {
                                              case DismissDirection.endToStart:
                                                return await _showConfirmationDialog(context, todaylistitem[index]["menuname"], index, todaylistitem[index]["id"]) == true;
                                              case DismissDirection.startToEnd:
                                                return await _showConfirmationDialog(context, todaylistitem[index]["menuname"], index, todaylistitem[index]["id"]) == true;
                                              case DismissDirection.horizontal:
                                              case DismissDirection.vertical:
                                              case DismissDirection.up:
                                              case DismissDirection.down:
                                                assert(false);
                                                break;
                                              case DismissDirection.none:
                                            }
                                            return false;
                                          },
                                          child: ListTile(
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
                                            onTap: () async{
                                              //食品名の初期値設定
                                              menuController.text = todaylistitem[index]["menuname"];

                                              //カロリーの初期値設定
                                              calController.text = todaylistitem[index]["menucal"].toString();


                                              //ダイアログの表示
                                              var dialog = await showGeneralDialog(
                                                barrierColor: Colors.black.withOpacity(0.5),
                                                transitionDuration: Duration(milliseconds: 200),
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: "",
                                                transitionBuilder: (context, a1, a2, widget) {
                                                  return Transform.scale(
                                                    scale: a1.value,
                                                    child: Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4.0)
                                                      ),
                                                      child: Stack(
                                                        overflow: Overflow.visible,
                                                        alignment: Alignment.topCenter,
                                                        children: [
                                                          FutureBuilder(
                                                            future: Todo().select().toList(),
                                                            builder: (context, snapshot) {
                                                              if(snapshot.hasData){
                                                                var i = snapshot.data;
                                                                return Container(
                                                                  height: screenheight - 200,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: menuController,
                                                                          maxLength: 50,
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "メニュー名"
                                                                          ),
                                                                        ),
                                                                        TextFormField(
                                                                          controller: calController,
                                                                          keyboardType: TextInputType.number,
                                                                          maxLength: 4,
                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "カロリー"
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                              child: Text("キャンセル"),
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () async{
                                                                              //入力後のデータ
                                                                              int id = todaylistitem[index]["id"];
                                                                              String aftermenuname = menuController.text;
                                                                              int aftermenucal = 0;
                                                                              try{
                                                                                aftermenucal = int.parse(calController.text);
                                                                              }catch(e){
                                                                                AlertDialog(
                                                                                  shape: const RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.all(Radius.circular(
                                                                                      10)
                                                                                    )
                                                                                  ),
                                                                                  backgroundColor: Color(0xffa18cd1).withOpacity(0.85),
                                                                                  title:Text(
                                                                                    '項目にエラーがあります',
                                                                                    style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                  content:
                                                                                    Column(
                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                        children: <Widget>[
                                                                                          SizedBox(
                                                                                            height: 10,
                                                                                          ),
                                                                                          
                                                                                          Text(
                                                                                            '・変更するカロリーには数字以外は入力できません',
                                                                                            style: TextStyle(color: Colors.white, fontSize: 16),
                                                                                          )
                                                                                        ],
                                                                                    )
                                                                                );
                                                                              }
                                                                              
                                                                              
                                                                              //リストの更新
                                                                              todaylistitem[index]["menuname"] = menuController.text;
                                                                              todaylistitem[index]["menucal"] = int.parse(calController.text);

                                                                              //入力後のトータルカロリーの再計算
                                                                              int tmp = 0;
                                                                              todaylistitem.forEach((element) {
                                                                                tmp += element["menucal"];
                                                                              });
                                                                              //再計算した値をセット
                                                                              todaycount.setCol(tmp);

                                                                              //Summaryに表示されるDBの更新                                                      
                                                                              await Todo(id: i.length, cal: todaycount.getCol(), date: now.month.toString() + '/' + now.day.toString(), year: now.year.toString()).save();
                                                                              
                                                                              
                                                                              //食べたもののDB更新
                                                                              await _update(id, aftermenuname, aftermenucal);
                                                                              
                                                                        
                                                                              //snackBarの表示
                                                                              _scaffoldKey.currentState.showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text("変更しました。"),
                                                                                  duration: const Duration(seconds: 5),
                                                                                  action: SnackBarAction(
                                                                                    label: "OK",
                                                                                    onPressed: () {
                                                                                      //snackbarのOKボタンを押したときの動作
                                                                                      //特になし
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              );
                                                                              
                                                                              //ダイアログを閉じる
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                              child: Text('変更する', style: TextStyle(color: Colors.white),),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                return CircularProgressIndicator();
                                                              }
                                                            },
                                                            
                                                          ),
                                                          Positioned(
                                                            top: -60,
                                                            child: CircleAvatar(
                                                              backgroundColor: Color(0xff332A7C),
                                                              radius: 60,
                                                              child: Icon(Icons.refresh, color: Colors.white, size: 50,),
                                                            )
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                  );
                                                }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {  },
                                              );
                                            },
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
                                        return Dismissible(
                                          key: ObjectKey(yesterdaylistitem[index]["id"]),
                                          background: Container(
                                            color: Colors.red,
                                          ),
                                          confirmDismiss: (direction) async{
                                            switch(direction) {
                                              case DismissDirection.endToStart:
                                                return await _showConfirmationYesterdayDialog(context, yesterdaylistitem[index]["menuname"], index, yesterdaylistitem[index]["id"]) == true;
                                              case DismissDirection.startToEnd:
                                                return await _showConfirmationYesterdayDialog(context, yesterdaylistitem[index]["menuname"], index, yesterdaylistitem[index]["id"]) == true;
                                              case DismissDirection.horizontal:
                                              case DismissDirection.vertical:
                                              case DismissDirection.up:
                                              case DismissDirection.down:
                                                assert(false);
                                                break;
                                              case DismissDirection.none:
                                            }
                                            return false;
                                          },
                                          child: ListTile(
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
                                            onTap: ()  async{
                                              //食品名の初期値設定
                                              menuController.text = yesterdaylistitem[index]["menuname"];

                                              //カロリーの初期値設定
                                              calController.text = yesterdaylistitem[index]["menucal"].toString();


                                              //ダイアログの表示
                                              var dialog = await showGeneralDialog(
                                                barrierColor: Colors.black.withOpacity(0.5),
                                                transitionDuration: Duration(milliseconds: 200),
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: "",
                                                transitionBuilder: (context, a1, a2, widget) {
                                                  return Transform.scale(
                                                    scale: a1.value,
                                                    child: Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4.0)
                                                      ),
                                                      child: Stack(
                                                        overflow: Overflow.visible,
                                                        alignment: Alignment.topCenter,
                                                        children: [
                                                          FutureBuilder(
                                                            future: Todo().select().toList(),
                                                            builder: (context, snapshot) {
                                                              if(snapshot.hasData){
                                                                var i = snapshot.data;
                                                                return Container(
                                                                  height: screenheight - 200,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: menuController,
                                                                          maxLength: 50,
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "メニュー名"
                                                                          ),
                                                                        ),
                                                                        TextFormField(
                                                                          controller: calController,
                                                                          keyboardType: TextInputType.number,
                                                                          maxLength: 4,
                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "カロリー"
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                              child: Text("キャンセル"),
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () async{
                                                                              //入力後のデータ
                                                                              int id = yesterdaylistitem[index]["id"];
                                                                              String aftermenuname = menuController.text;
                                                                              int aftermenucal = int.parse(calController.text);
                                                                              
                                                                              //リストの更新
                                                                              yesterdaylistitem[index]["menuname"] = menuController.text;
                                                                              yesterdaylistitem[index]["menucal"] = int.parse(calController.text);

                                                                              //入力後のトータルカロリーの再計算
                                                                              int tmp = 0;
                                                                              yesterdaylistitem.forEach((element) {
                                                                                tmp += element["menucal"];
                                                                              });

                                                                              todaycount.setCol(tmp);

                                                                              //今日のカロリーを未入力の場合のバリデーションチェック
                                                                              if(todaylistitem.length == 0){
                                                                                //Summaryに表示されるDBの更新                                                      
                                                                                await Todo(id: i.length, cal: todaycount.getCol(), date: yesterday.month.toString() + '/' + yesterday.day.toString(), year: yesterday.year.toString()).save();
                                                                              }else{
                                                                                //Summaryに表示されるDBの更新                                                      
                                                                                await Todo(id: i.length - 1, cal: todaycount.getCol(), date: yesterday.month.toString() + '/' + yesterday.day.toString(), year: yesterday.year.toString()).save();
                                                                              }
                                                                              
                                                                              //食べたもののDB更新
                                                                              await _update(id, aftermenuname, aftermenucal);
                                                                              
                                                                        
                                                                              //snackBarの表示
                                                                              _scaffoldKey.currentState.showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text("変更しました。"),
                                                                                  duration: const Duration(seconds: 5),
                                                                                  action: SnackBarAction(
                                                                                    label: "OK",
                                                                                    onPressed: () {
                                                                                      //snackbarのOKボタンを押したときの動作
                                                                                      //特になし
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              );
                                                                              
                                                                              //ダイアログを閉じる
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                              child: Text('変更する', style: TextStyle(color: Colors.white),),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                return CircularProgressIndicator();
                                                              }
                                                            },
                                                            
                                                          ),
                                                          Positioned(
                                                            top: -60,
                                                            child: CircleAvatar(
                                                              backgroundColor: Color(0xffF25767),
                                                              radius: 60,
                                                              child: Icon(Icons.refresh, color: Colors.white, size: 50,),
                                                            )
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                  );
                                                }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {  },
                                              );
                                            },
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 40, left: 15),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.yellowAccent[100])
                                          
                                        ),
                                        child: flag == false
                                            ? Text(
                                              "過去データ選択",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.black54
                                              ),
                                              )
                                            : Text(_date.year.toString() + "年" + _date.month.toString() + "月" + _date.day.toString() + "日", style: TextStyle(fontSize: 22, color: Colors.black54),),
                                        onPressed: () async {
                                          //日付選択
                                          _selectDate(context);

                                        },
                                      )
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 45),
                                      child: Row(
                                        children: [
                                          TextButton.icon(
                                            label: Text("検索"),
                                            icon: Icon(Icons.search_rounded, color: Colors.blue,),
                                            //リスト更新
                                            onPressed: () => pastincrement(),
                                          ),
                                        ],
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
                                        return Dismissible(
                                          key: ObjectKey(pastlistitem[index]["id"]),
                                          background: Container(
                                            color: Colors.red,
                                          ),
                                          confirmDismiss: (direction) async{
                                            switch(direction) {
                                              case DismissDirection.endToStart:
                                                return await _showConfirmationPastDialog(context, pastlistitem[index]["menuname"], index, pastlistitem[index]["id"], _date.month.toString() +'/' + _date.day.toString(), _date.year.toString()) == true;
                                              case DismissDirection.startToEnd:
                                                return await _showConfirmationPastDialog(context, pastlistitem[index]["menuname"], index, pastlistitem[index]["id"], _date.month.toString() +'/' + _date.day.toString(), _date.year.toString()) == true;
                                              case DismissDirection.horizontal:
                                              case DismissDirection.vertical:
                                              case DismissDirection.up:
                                              case DismissDirection.down:
                                                assert(false);
                                                break;
                                              case DismissDirection.none:
                                            }
                                            return false;
                                          },
                                          child: ListTile(
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
                                            onTap: () async {
                                              //食品名の初期値設定
                                              menuController.text = pastlistitem[index]["menuname"];

                                              //カロリーの初期値設定
                                              calController.text = pastlistitem[index]["menucal"].toString();


                                              //ダイアログの表示
                                              var dialog = await showGeneralDialog(
                                                barrierColor: Colors.black.withOpacity(0.5),
                                                transitionDuration: Duration(milliseconds: 200),
                                                context: context,
                                                barrierDismissible: true,
                                                barrierLabel: "",
                                                transitionBuilder: (context, a1, a2, widget) {
                                                  return Transform.scale(
                                                    scale: a1.value,
                                                    child: Dialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(4.0)
                                                      ),
                                                      child: Stack(
                                                        overflow: Overflow.visible,
                                                        alignment: Alignment.topCenter,
                                                        children: [
                                                          FutureBuilder(
                                                            future: Todo().select().toList(),
                                                            builder: (context, snapshot) {
                                                              if(snapshot.hasData){
                                                                var i = snapshot.data;
                                                                return Container(
                                                                  height: screenheight - 200,
                                                                  child: Padding(
                                                                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                                                                    child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                      children: [
                                                                        TextFormField(
                                                                          controller: menuController,
                                                                          maxLength: 50,
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "メニュー名"
                                                                          ),
                                                                        ),
                                                                        TextFormField(
                                                                          controller: calController,
                                                                          keyboardType: TextInputType.number,
                                                                          maxLength: 4,
                                                                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                                          decoration: const InputDecoration(
                                                                            border: OutlineInputBorder(),
                                                                            labelText: "カロリー"
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                              child: Text("キャンセル"),
                                                                              onPressed: () => Navigator.of(context).pop(),
                                                                            ),
                                                                            ElevatedButton(
                                                                              onPressed: () async{
                                                                              //入力後のデータ
                                                                              int id = pastlistitem[index]["id"];
                                                                              String aftermenuname = menuController.text;
                                                                              int aftermenucal = int.parse(calController.text);
                                                                              
                                                                              //リストの更新
                                                                              pastlistitem[index]["menuname"] = menuController.text;
                                                                              pastlistitem[index]["menucal"] = int.parse(calController.text);

                                                                              //入力後のトータルカロリーの再計算
                                                                              int tmp = 0;
                                                                              pastlistitem.forEach((element) {
                                                                                tmp += element["menucal"];
                                                                              });

                                                                              pastcount.setCol(tmp);

                                                                              //id取得
                                                                              var p1 = await Todo().select().date.contains(_date.month.toString() +'/' + _date.day.toString()).toList();
                                                                              var x1 = p1[p1.length - 1].toMap();
                                                                              var getid = x1['id'];

                                                                              //Summaryに表示されるDBの更新                                                      
                                                                              await Todo(id: getid, cal: pastcount.getCol(), date: _date.month.toString() + '/' + _date.day.toString(), year: _date.year.toString()).save();
                                                                              
                                                                              
                                                                              //食べたもののDB更新
                                                                              await _update(id, aftermenuname, aftermenucal);
                                                                              
                                                                        
                                                                              //snackBarの表示
                                                                              _scaffoldKey.currentState.showSnackBar(
                                                                                SnackBar(
                                                                                  content: Text("変更しました。"),
                                                                                  duration: const Duration(seconds: 5),
                                                                                  action: SnackBarAction(
                                                                                    label: "OK",
                                                                                    onPressed: () {
                                                                                      //snackbarのOKボタンを押したときの動作
                                                                                      //特になし
                                                                                    },
                                                                                  ),
                                                                                )
                                                                              );
                                                                              
                                                                              //ダイアログを閉じる
                                                                              Navigator.of(context).pop();
                                                                            },
                                                                              child: Text('変更する', style: TextStyle(color: Colors.white),),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              }else{
                                                                return CircularProgressIndicator();
                                                              }
                                                            },
                                                            
                                                          ),
                                                          Positioned(
                                                            top: -60,
                                                            child: CircleAvatar(
                                                              backgroundColor: Color(0xffFFA000),
                                                              radius: 60,
                                                              child: Icon(Icons.refresh, color: Colors.white, size: 50,),
                                                            )
                                                          ),
                                                        ],
                                                      )
                                                    ),
                                                  );
                                                }, pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {  },
                                              );
                                            },
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
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOutQuart);
                          print("test" + index.toString());
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
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
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              DateTime _changedDate = DateTime.now();
              var _changeController = TextEditingController();
              showDialog(
                context: context,
                builder: (context) {
                  return Scaffold(
                    backgroundColor: Colors.transparent.withOpacity(0.5),
                    body: StatefulBuilder(
                      builder: (context, setState) {
                        return SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              Text(
                                '追加する日',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  decoration:TextDecoration.none,
                                  fontWeight:FontWeight.bold
                                ),
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
                                  _changedDate.year.toString() +'年' +_changedDate.month.toString() +'月' +_changedDate.day.toString() +'日',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30
                                  ),
                                ),
                                onPressed: () async {
                                  final DateTime picked =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: _changedDate,
                                          firstDate: DateTime(2020),
                                          lastDate: DateTime.now().add(Duration(days:360))
                                      );
                                  if (picked != null) {
                                    setState(() {
                                      _changedDate = picked;
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10, left: 50, right: 50),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                  controller: _changeController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 4,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white
                                      )
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.white
                                      )
                                    ),
                                    labelText: "追加するカロリー",
                                    labelStyle: TextStyle(
                                      color: Colors.white
                                    )
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async{ 
                                  //過去Summaryに表示するDBの取得
                                  var p1 = await Todo().select().date.contains(_changedDate.month.toString() +'/' + _changedDate.day.toString()).toList();
                                  
                                  if(p1.length == 0){
                                    //Summaryに何もレコードが無い場合
                                    //Todo(cal: int.parse(_changeController.text), date: _changedDate.month.toString() + '/' + _changedDate.day.toString(), year: _changedDate.year.toString()).save();
                                  }else{
                                    //Summaryに何もレコードがある場合
                                    //id取得
                                    var x1 = p1[p1.length - 1].toMap();
                                    var getid = x1['id'];
                                    
                                    //対象日のカロリーを取得し、追加するカロリーに追加
                                    var tmpcal = x1["cal"] + int.parse(_changeController.text);

                                    //summaryのDBをUPDATE
                                    Todo(id: getid, cal: tmpcal, date: _changedDate.month.toString() + '/' + _changedDate.day.toString(), year: _changedDate.year.toString()).save();
                                    print(_changedDate.month.toString() + '/' + _changedDate.day.toString());
                                  }
                                  
                                  //OldmenulistのDBをUPDATE
                                  _insert(int.parse(_changeController.text), _changedDate);

                                  //ダイアログを閉じる
                                  Navigator.of(context).pop();

                                  //snackBarの表示
                                  _scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text("追加しました。"),
                                      duration: const Duration(seconds: 5),
                                      action: SnackBarAction(
                                        label: "OK",
                                        onPressed: () {
                                          //snackbarのOKボタンを押したときの動作
                                          //特になし
                                        },
                                      ),
                                    )
                                  );
                                },
                                child: Text("追加する"),
                              )
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
        ),
      );
    });
  }

  @override
  void dispose(){
    menuController.dispose();
    calController.dispose();
    super.dispose();
  }

  //食べたものリストのINSERT
  void _insert(int cal, DateTime tmpdate) async {
    Map<String, dynamic> row = {
      DatabaseHelper.date: DateFormat('yyyy-MM-dd').format(tmpdate),
      DatabaseHelper.datetime: DateFormat('HH:mm').format(tmpdate),
      DatabaseHelper.menuname: "手入力",
      DatabaseHelper.menucal: cal,
    };
    await dbHelper.insert(row);
    print("INSERT成功");
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

  Future<void> _update(int id, String menu, int cal) async{
    await dbHelper.updateMenu(id, menu, cal);
  }

  Future<void> _delete(int id) async{
    await dbHelper.delete(id);
  }
}
