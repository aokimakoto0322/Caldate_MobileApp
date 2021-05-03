
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_google_ad_manager/flutter_google_ad_manager.dart';

class RewardView extends StatefulWidget{
  @override
  _RewardViewState createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {

  DFPRewardedAd _rewardedAd;

  @override
  void initState(){
    super.initState();
    _rewardedAd = DFPRewardedAd(
      isDevelop: false, 
      adUnitId: "ca-app-pub-8627512781946422/1095411828",
      onAdClosed: () {
        print("closed");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("リワードを獲得しました"),
              content: Text("広告が消えない場合は、アプリを再起動して見てください。"),
              actions: <Widget>[
                FlatButton(
                  child: Text("OK"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          }
        );
      },
      onAdLoaded: () {
        print("onadload");
      },
      onVideoCompleted: () {
        print("video completed");
        setRewardtime(1);
      },
      onRewarded: (type, amount) {
        print(type);
        print(amount.toString());
      },
    );
    _rewardedAd.load();
  }

  String day = "";

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    var dateformatter = DateFormat("yyyy-MM-dd HH:mm");
    
    return Material(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffe4a972).withOpacity(0.6),
                const Color(0xff9941d8).withOpacity(0.5)
              ]
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(top: 100, left: 40, right: 40),
                child: Text(
                  "広告無しプレミアム\nバージョンを試す",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white
                  ),
                ),
              ),
              Column(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "リワード広告をみることによって、24時間広告無しでアプリを使用することができます。",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("広告が出なくなる期間は、リワード広告を見てから24時間適用されます。"),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("リワード期間は、さらにリワードを得ることはできません。"),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.all(10),
                          child: Text("本機能はベータ版ですので、プレミアム期間中でも広告が流れる場合がございます。アプリを再起動し直すと改善する場合がございます。"),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: FutureBuilder(
                      future: getRewardtime(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData){
                          if(now.isAfter(dateformatter.parse(snapshot.data))){
                            print("今日よりどうがえつらんが後");
                            print(dateformatter.parse(snapshot.data));
                            return Center(
                              child: ElevatedButton(
                                child: Text(
                                  "リワードをみる",
                                  style: TextStyle(
                                    fontSize: 24
                                  ),
                                ),
                                onPressed: () async{
                                  showRewarded();
                                  //myRewarded.show();
                                },
                              ),
                            );
                          }else{
                            print("今日よりどうがえつらんが前");
                            print(dateformatter.parse(snapshot.data));
                            return Center(
                              child: ElevatedButton(
                                child: Text(
                                  "リワードをみる",
                                  style: TextStyle(
                                    fontSize: 24
                                  ),
                                ),
                                onPressed: () async{
                                  //snackbar
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("現在プレミアム期間中です。"),
                                      duration: const Duration(seconds: 5),
                                      action: SnackBarAction(
                                        label: "OK",
                                        onPressed: () {
                                          
                                        },
                                      ),
                                    )
                                  );
                                },
                              ),
                            );
                          }
                        }else{
                          return Center(
                            child: ElevatedButton(
                              child: Text(
                                "リワードをみる",
                                style: TextStyle(
                                  fontSize: 24
                                ),
                              ),
                              onPressed: () async{
                                showRewarded();
                                //myRewarded.show();
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showRewarded() async {
    try{
      await _rewardedAd.show();
    } on PlatformException catch (e){
      if (e.message == 'not_loaded_yet') {
        await _rewardedAd.load();
      }
    }
  }

  static void setRewardtime(int day) async{
    //今日の日付を取得
    DateTime now = DateTime.now();

    //format
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

    //今日から24時間後を取得
    DateTime dayaftertomorrow = now.add(Duration(days: day) * 1);

    //SharedPreferenceに24時間後の日付を保存
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("REWARD_DAY", format.format(dayaftertomorrow));


    print("reward : " + dayaftertomorrow.toString());
  }

  Future<String> getRewardtime() async{
    //リワードに設定された時間の取得
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("REWARD_DAY") == null ? "1900-09-09 23:59" : prefs.getString("REWARD_DAY");
  }

  
}