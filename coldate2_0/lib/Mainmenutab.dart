import 'package:coldate2_0/Oldmenulist.dart';
import 'package:coldate2_0/home_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Mainmenutab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => HomeModel(),
        child: Oldmenulist(),
      ),
    );
  }
}
