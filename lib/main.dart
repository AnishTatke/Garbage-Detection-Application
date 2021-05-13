import 'package:classify_garbage/pages/home.dart';
import 'package:classify_garbage/pages/startup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  title: 'Garbage Detection App',
  //home: Temp(),

  initialRoute: '/',
  routes: {
    '/': (context) => Startup(),
    '/home': (context) => Home(),
  },
));


