import 'package:classify_garbage/pages/home.dart';
import 'package:classify_garbage/pages/startup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Garbage Detection App',
    //home: Temp(),

    initialRoute: '/',
    routes: {
      '/': (context) => Startup(),
      '/home': (context) => Home(),
    },
  ));
}


