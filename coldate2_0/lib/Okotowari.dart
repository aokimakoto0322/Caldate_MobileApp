import 'package:flutter/material.dart';

class Okotowari extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(30),
            child: Column(
              children: <Widget>[
                Container(
                  child: Text(
                    '＜本アプリについて＞',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
                Container(
                  child: Text('本アプリは自らの健康管理を目的として作成しております。基本疾病が治癒したり、より健康を増進するものではありません。',style: TextStyle(color: Colors.black54),),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    '＜基礎代謝について＞',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
                Container(
                  child: Text('基礎代謝はHarris-Benedict式を参考にして算出しております。',style: TextStyle(color: Colors.black54)),
                ),
                Container(
                  child: Text('男性：13.397×体重kg＋4.799×身長cm−5.677×年齢+88.362',style: TextStyle(color: Colors.black54)),
                ),
                Container(
                  child: Text('女性：9.247×体重kg＋3.098×身長cm−4.33×年齢+447.593',style: TextStyle(color: Colors.black54)),
                ),
                Container(
                  child: Text('この式で算出した値に運動強度を追加した値をトータルの基礎代謝として表示しております。\nここで算出したものは性別や年齢等で多少の誤差がありますので、あくまで目安としてご利用ください。本アプリケーションはユーザーの健康状態について個別相談はできません。',style: TextStyle(color: Colors.black54)),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Text(
                    '＜メニュー一覧のカロリーについて＞',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                ),
                Container(
                  child: Text('作り方や材料、お店によっても誤差があります。こちらに表示されているカロリーはあくまで目安としてご利用ください。',style: TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
