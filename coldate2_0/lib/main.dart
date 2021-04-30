import 'dart:ui';

import 'package:coldate2_0/DatabaseHelper.dart';
import 'package:coldate2_0/Mainmenutab.dart';
import 'package:coldate2_0/Okotowari.dart';
import 'package:coldate2_0/Oldmenulist.dart';
import 'package:coldate2_0/Piechart.dart';
import 'package:coldate2_0/SettingPage.dart';
import 'package:coldate2_0/file_controller.dart';
import 'package:coldate2_0/metabo.dart';
import 'package:coldate2_0/summary.dart';
import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'MenuPage.dart';
import 'graphlayout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:after_layout/after_layout.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:supercharged/supercharged.dart';
import 'models.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


int todaycal;
var flag = true;
var arrow = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bool isInitialized = await TodoDbModel().initializeDB();
  if (isInitialized == true) {
    myInterstitial2.load();
    myInterstitial.load();
    mybanner.load();
    runApp(MyApp());
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //admobの設定
  @override
  void initState() {
    super.initState();
  }
  //--admobの設定

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool _seen = (pref.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context)
          .pushReplacement(new MaterialPageRoute(builder: (context) => Home()));

      mybanner.load();
    } else {
      await pref.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => Intro()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  //bannerの設定
  final AdWidget adWidget = AdWidget(ad: mybanner);

  @override
  Widget build(BuildContext context) {
    
    final Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Color(0xffa1c4fd),
        primaryColor: Color(0xffa1c4fd),
      ),
      home: Stack(
        children: <Widget>[
          const Backgroundsetting(),
          //モーションブラー
          /* FutureBuilder(
              future: _getBlur(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                        sigmaX: snapshot.data.toDouble(),
                        sigmaY: snapshot.data.toDouble()),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }), */
          FutureBuilder(
              future: _getOpacity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DefaultTabController(
                    length: 4,
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      drawer: Drawer(
                        child: Container(
                          child: ListView(
                              padding: EdgeInsets.zero,
                              children: <Widget>[
                                DrawerHeader(
                                  child: Text(
                                    'Caldate\nMenu',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(colors: <Color>[
                                    const Color(0xffa18cd1),
                                    const Color(0xfffbc2eb)
                                  ])),
                                ),
                                ListTile(
                                  title: Text("過去食べたものを見る"),
                                  onTap: () {
                                    myInterstitial2.show();
                                    //pushWithReload(context);
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Mainmenutab()));
                                  },
                                ),
                                ListTile(
                                  title: Text("メニュー一覧"),
                                  onTap: () {
                                    myInterstitial.show();
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MenuPage()));
                                  },
                                ),
                                ListTile(
                                  title: Text('設定'),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => Settingpage()));
                                  },
                                ),
                                ListTile(
                                  title: Text('アプリについて'),
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => Okotowari()));
                                  },
                                ),
                                ListTile(
                                  title: Text('情報'),
                                  onTap: () {
                                    showAboutDialog(
                                        context: context,
                                        applicationName: "Coldate",
                                        applicationVersion: '3.0.0',
                                        applicationLegalese: '2020 Coldate',
                                        applicationIcon: Image.asset(
                                            'assets/images/splashicon.png',
                                            height: 50));
                                  },
                                )
                              ]),
                        ),
                      ),
                      appBar: AppBar(
                        //透過率の設定１
                        backgroundColor: Color(0xffa18cd1)
                            .withOpacity(snapshot.data.toDouble()),
                        title: Text('Caldate'),
                        elevation: 0,
                        bottom: PreferredSize(
                          child: TabBar(
                            isScrollable: true,
                            tabs: <Widget>[
                              Container(
                                width: size.width / 4,
                                child: Tab(
                                  child: Icon(Icons.home),
                                ),
                              ),
                              Container(
                                width: size.width / 4,
                                child: Tab(
                                  child: Icon(Icons.equalizer),
                                ),
                              ),
                              Container(
                                width: size.width / 4,
                                child: Tab(
                                  child: Icon(Icons.pie_chart),
                                ),
                              ),
                              Container(
                                width: size.width / 4,
                                child: Tab(child: Icon(Icons.fastfood)),
                              )
                            ],
                          ),
                          preferredSize: Size.fromHeight(30.0),
                        ),
                      ),
                      body: Stack(
                        children: [
                          TabBarView(
                            children: <Widget>[
                              Summary(),
                              graphlayout(),
                              Piechart(),
                              metabo(),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: adWidget,
                              width: mybanner.size.width.toDouble(),
                              height: mybanner.size.height.toDouble(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );
  }

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  _getBlur() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('Blur') ?? 0;
  }
}

class Intro extends StatelessWidget {
  final introKey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Color(0xffa18cd1),
        color: Colors.black26,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0)
        )
      ),
      key: introKey,
      showNextButton: true,
      next: const Icon(Icons.arrow_forward),
      onDone: () => Navigator.of(context)
          .pushReplacement(new MaterialPageRoute(builder: (context) => Home())),
      pages: [
        PageViewModel(
            title: "はじめまして",
            body: '簡単にアプリの使い方を説明します',
            image: Center(
              child: Image.asset(
                'assets/images/splashicon.png',
                height: 150,
              ),
            ),
            decoration: PageDecoration(pageColor: Colors.blue[100])),
        PageViewModel(
            title: "カロリーを保存する",
            body:
                "食べたカロリー分数字をタップし、「今日の摂取カロリーに追加する」を押すと食べた分蓄積されます。\n\n食べた物のカロリーが分からない場合は「メニュー一覧」から食べた物を選択すれば、追加できます。",
            image: Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset(
                  'assets/images/introduce2.gif',
                ),
              ),
            ),
            decoration: PageDecoration(pageColor: Colors.orange[100])),
        PageViewModel(
            title: "振り返る",
            body: "真ん中のタブでは、過去摂取したカロリーをグラフで見ることができます。",
            image: Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset('assets/images/introduce3.jpg'),
              ),
            ),
            decoration: PageDecoration(pageColor: Colors.pink[100])),
        PageViewModel(
            title: '比較する',
            body:
                '基礎代謝に対して、今日どのくらいの割合でカロリーを摂取したか確認することができます。\n\n※この機能を使用するには、基礎代謝を測定する必要があります。測定方法は次ページにあります。',
            decoration: PageDecoration(pageColor: Colors.yellow[100]),
            image: Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset('assets/images/introduce6.png'),
              ),
            )),
        PageViewModel(
            title: "基礎代謝を測る",
            body:
                "一番右のタブで基礎代謝を計算することができます。\nやり方は項目を入力するだけでできます。\n結果は一番上に表示されます。",
            decoration: PageDecoration(pageColor: Colors.lime[100]),
            image: Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset('assets/images/introduce4.PNG'),
              ),
            )),
        PageViewModel(
            title: "自分好みのアプリにする",
            body: "画面左上のメニュー「設定」から、背景を選択しあなた好みの見た目に変えることができます。",
            decoration: PageDecoration(pageColor: Colors.indigo[100]),
            image: Container(
              margin: EdgeInsets.only(top: 80),
              child: Center(
                child: Image.asset('assets/images/introduce5.jpg'),
              ),
            ))
      ],
      done: const Text('はじめる'),
    );
  }
}

final InterstitialAd myInterstitial2 = InterstitialAd(
  adUnitId: 'ca-app-pub-8627512781946422/2312420457',
  request: AdRequest(),
  listener: AdListener(),
);

final InterstitialAd myInterstitial = InterstitialAd(
  adUnitId: 'ca-app-pub-8627512781946422/4738687830',
  request: AdRequest(),
  listener: AdListener(),
);

final BannerAd mybanner = BannerAd(
    adUnitId: "ca-app-pub-8627512781946422/9988986141",
    size: AdSize.banner,
    request: AdRequest(),
    listener: AdListener());

enum _BgProps { color1, color2 }

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_BgProps>()
      ..add(
          _BgProps.color1, Color(0xffd38312).tweenTo(Colors.lightBlue.shade900))
      ..add(_BgProps.color2, Color(0xffa83279).tweenTo(Colors.blue.shade600));
    return MirrorAnimation<MultiTweenValues<_BgProps>>(
      tween: tween,
      duration: 3.seconds,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                value.get(_BgProps.color1),
                value.get(_BgProps.color2)
              ])),
        );
      },
    );
  }
}

class Backgroundsetting extends StatelessWidget {
  const Backgroundsetting({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: FileController.loadLocalImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            return Image.memory(
              snapshot.data.readAsBytesSync(),
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
            );
          } catch (e) {
            return Container();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
