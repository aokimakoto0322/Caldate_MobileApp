import 'dart:async';
import 'dart:io';

import 'package:coldate2_0/file_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

//snackbar表示のキー
var _scaffoldKey = GlobalKey<ScaffoldState>();

class Settingpage extends StatefulWidget {
  @override
  _SettingpageState createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  File imagefile;
  File imagefile2;
  StreamController<double> _events;
  StreamController<double> _blur;

  

  //カラーテーマのリスト
  List<Widget> colorLis = [
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#a18cd1","#fbc2eb"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffa18cd1),
                const Color(0xfffbc2eb)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#4ECDC4","#556270"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff4ECDC4),
                const Color(0xff556270)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#ff9a9e","#fad0c4"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffff9a9e),
                const Color(0xfffad0c4)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#ff9a9e","#fecfef"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffff9a9e),
                const Color(0xfffecfef)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#a1c4fd","#c2e9fb"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffa1c4fd),
                const Color(0xffc2e9fb)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#fdfbfb","#ebedee"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xfffdfbfb),
                const Color(0xffebedee)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#667eea","#764ba2"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff667eea),
                const Color(0xff764ba2)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#93a5cf","#e4efe9"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff93a5cf),
                const Color(0xffe4efe9)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#29323c","#485563"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff29323c),
                const Color(0xff485563)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#ee9ca7","#ffdde1"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffee9ca7),
                const Color(0xffffdde1)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#B7F8DB","#50A7C2"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffB7F8DB),
                const Color(0xff50A7C2)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#009245","#FCEE21"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff009245),
                const Color(0xffFCEE21)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#662D8C","#ED1E79"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff662D8C),
                const Color(0xffED1E79)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#614385","#516395"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xff614385),
                const Color(0xff516395)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#C6EA8D","#FE90AF"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffC6EA8D),
                const Color(0xffFE90AF)
              ]
            )
          ),
        ),
      ),
    ),
    Material(
      child: InkWell(
        onTap: () async{
          //設定値をsharedPreferenceに反映
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setStringList("ColorLis", ["#D8B5FF","#1EAE98"]);

          //snackbarの表示
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: const Text('設定が完了しました。再起動すると反映されます。'),
              duration: const Duration(seconds: 1),
              action: SnackBarAction(
                label: 'DONE',
                onPressed: () {},
              ),
            ),
          );
        },
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                const Color(0xffD8B5FF),
                const Color(0xff1EAE98)
              ]
            )
          ),
        ),
      ),
    ),
  ];

  _setOpacity(double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble('BackgroundOpacity', value);
  }

  _getOpacity() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('BackgroundOpacity') ?? 1;
  }

  _setBlur(double value) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setDouble('Blur', value);
  }

  _getBlur() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getDouble('Blur') ?? 0;
  }

  @override
  void initState() {
    _events = new StreamController<double>();
    _events.add(1);
    _blur = new StreamController<double>();
    _blur.add(0);
    super.initState();
  }

  @override
  void dispose() {
    _events.close();
    _blur.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('設定'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text(
                        'ホーム画面の背景',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle:
                          Text('最初に開いたときの画面背景を設定します。\n画像は端末に沿って拡大されて表示されます。\n※画像はアプリを再起動した際に反映されます。'),
                    ),
                    FutureBuilder(
                      future: FileController.loadLocalImage(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          try {
                            return Image.memory(
                              snapshot.data.readAsBytesSync(),
                              fit: BoxFit.cover,
                            );
                          } catch (e) {
                            return Center(
                              child: Container(
                                margin: EdgeInsets.all(100),
                                child: Text('NoImage'),
                              ),
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text('画像を選択'),
                          onPressed: () {
                            _getAndSaveImageFromDevice(ImageSource.gallery);
                          },
                        ),
                        FlatButton(
                          child: const Text('初期化'),
                          onPressed: () => FileController.removeImage(),
                        )
                      ],
                    ),
                    const ListTile(
                      title: Text(
                        '画像の透過率',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                          'ホーム画面に設定した画像を設定した値に透過します。\n１に設定すると全く透過せず、０に設定すると文字以外すべて透過します。\nすべての設定はアプリを再起動すると完了します。'),
                    ),
                    StreamBuilder(
                        stream: _events.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  '現在設定中の透過率：' +
                                      snapshot.data.toStringAsPrecision(2),
                                  style: TextStyle(fontSize: 16),
                                ),
                                Slider(
                                  min: 0,
                                  max: 1,
                                  value: snapshot.data,
                                  onChanged: (double value) {
                                    _events.add(value);
                                  },
                                  onChangeEnd: (value) {
                                    _setOpacity(value);
                                  },
                                ),
                              ],
                            );
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
                    FutureBuilder(
                      future: _getOpacity(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _events.add(snapshot.data.toDouble());
                          return Text('');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text(
                        'カラーテーマ',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle:
                          Text('画面のカラーテーマを以下から選択できます。'),
                    ),
                    SizedBox(
                      height: 500,
                      child: GridView.extent(
                        maxCrossAxisExtent: 200,
                        padding: const EdgeInsets.all(4),
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: colorLis
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 140,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getAndSaveImageFromDevice(ImageSource source) async {
    var imageFile = await ImagePicker.pickImage(source: source);
    if (imageFile == null) {
      return;
    }

    var savedFile = await FileController.saveLocalImage(imageFile);
    setState(() {
      this.imagefile = savedFile;
    });
  }
}
