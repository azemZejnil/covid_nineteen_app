import 'package:flutter/material.dart';

AppBar appBar = AppBar(
  centerTitle: true,
  flexibleSpace: Container(
    decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xff2B5E80),
          Color(0xff5BAFE7),
        ])
    ),
  ),
  title: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Image.asset('assets/virus.png',width: 45,),
      SizedBox(width: 10,),
      Text('COVID-19 Stats',style: TextStyle(color: Colors.white),),
    ],
  ),
);