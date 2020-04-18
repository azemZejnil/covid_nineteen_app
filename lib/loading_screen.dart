import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'app_bar.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitPumpingHeart(
              color:  Color(0xff2B5E80),
            ),
            SizedBox(height: 10,),
            Text('#staysafe',style: TextStyle(color: Color(0xff2B5E80),fontSize: 24),)
          ],
        ),
      ),
    );
  }
}