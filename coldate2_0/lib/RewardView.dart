import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardView extends StatefulWidget{

  @override
  _RewardViewState createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {

  @override
  void initState(){
    myRewarded.load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: TextButton(
          child: Text("リワードをみる"),
          onPressed: (){
            myRewarded.show();
          },
        ),
      ),
    );
  }

  final RewardedAd myRewarded = RewardedAd(
  adUnitId: 'ca-app-pub-8627512781946422/1095411828',
  request: AdRequest(),
  listener: AdListener(
    onRewardedAdUserEarnedReward: (RewardedAd ad, RewardItem reward) {
      print(reward.type);
      print(reward.amount);
    },
  ),
);
}