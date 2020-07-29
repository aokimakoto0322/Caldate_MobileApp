import 'dart:convert';
import 'package:flutter/material.dart';
import 'Mesi.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'models.dart';

const MethodChannel _channel = const MethodChannel('package/coldate');

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Mesi> _notes = List<Mesi>();
  List<Mesi> _noteForDisplay = List<Mesi>();
  var now = DateTime.now();
  var mesicalsub = 0;
  

  var _controller = TextEditingController();

  Future<List<Mesi>> fetchNotes() async {
    var url =
        'https://raw.githubusercontent.com/aokimakoto0322/caldate/master/Mesilist.json';
    var response = await http.get(url);

    var notes = List<Mesi>();

    if (response.statusCode == 200) {
      var noteJson = json.decode(response.body);
      for (var noteJson in noteJson) {
        notes.add(Mesi.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _noteForDisplay = _notes;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(bottom: 100),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: false,
              snap: true,
              expandedHeight: 50,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 50),
                title: Align(
                  alignment: Alignment.bottomCenter,
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      value = value.toLowerCase();
                      setState(() {
                        _noteForDisplay = _notes.where((element) {
                          var mesiTitle = element.mesiname.toLowerCase();
                          return mesiTitle.contains(value);
                        }).toList();
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black38,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            _controller.clear();
                          },
                        ),
                        hintText: 'Search',
                        border: InputBorder.none),
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 100,
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return _listItem(index);
              }, childCount: _noteForDisplay.length),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 110),
        child: FloatingActionButton.extended(
          label: Text(
            mesicalsub.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
          ),
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () async {
            final pl = await Todo().select().toList();
            if (pl.length == 0) {
            } else {
              var x1 = pl[pl.length - 1].toMap();
              var x2 = x1['cal'];
              x2 += mesicalsub;
                //methodchannel
              _channel.invokeMethod('test', x2.toString());

              if (x1['date'] ==
                  now.month.toString() + '/' + now.day.toString()) {
                Todo(
                        id: x1['id'],
                        cal: x2,
                        date: now.month.toString() + '/' + now.day.toString(),
                        year: now.year.toString())
                    .save();
              } else {
                Todo(
                        cal: mesicalsub,
                        date: now.month.toString() + '/' + now.day.toString(),
                        year: now.year.toString())
                    .save();
              }
            }
            
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  _listItem(index) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(_noteForDisplay[index].mesiname),
            subtitle: Text(_noteForDisplay[index].mesical.toString() + 'kCal'),
            onTap: () {
              setState(() {
                mesicalsub += _noteForDisplay[index].mesical;
              });
            },
          ),
        ],
      ),
    );
  }
}
