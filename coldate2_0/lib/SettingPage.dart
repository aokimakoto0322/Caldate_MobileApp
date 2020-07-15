import 'dart:async';
import 'dart:io';

import 'package:coldate2_0/file_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingpage extends StatefulWidget {
  @override
  _SettingpageState createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  File imagefile;
  File imagefile2;
  StreamController<double> _events;
  StreamController<double> _blur;

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
                          Text('最初に開いたときの画面背景を設定します。\n画像は端末に沿って拡大されて表示されます。'),
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
                  ],
                ),
              ),
              Card(
                child: Column(
                  children: <Widget>[
                    const ListTile(
                      title: Text(
                        '画像の透過率',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                          'ホーム画面に設定した画像を設定した値に透過します。\n１に設定すると全く透過せず、０に設定すると文字以外すべて透過します。\nすべての設定はアプリを再起動、またはホーム画面で下にスワイプし画面を更新すると完了します。'),
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
                        '背景画像のブラー',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Text(
                          '設定した背景にぼかし（ブラー）をかけます。\nぼかしをかけることによって表示されている文字やボタンが見やすくなります。'),
                    ),
                    StreamBuilder(
                      stream: _blur.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[
                              Text(
                                '現在設定中のブラー：' + snapshot.data.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 16
                                ),
                              ),
                              Slider(
                                min: 0,
                                max: 15,
                                divisions: 15,
                                value: snapshot.data,
                                onChanged: (value) {
                                  _blur.add(value);
                                },
                                onChangeEnd: (value) {
                                  _setBlur(value);
                                },
                              )
                            ],
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    FutureBuilder(
                      future: _getBlur(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _blur.add(snapshot.data.toDouble());
                          return Text('');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
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
