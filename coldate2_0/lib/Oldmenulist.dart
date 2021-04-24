import 'package:flutter/material.dart';

import 'DatabaseHelper.dart';

class Oldmenulist extends StatelessWidget {
  //databasehelper
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _query(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.toString());
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _query() async {
    return await dbHelper.queryAllRows();
  }
}
