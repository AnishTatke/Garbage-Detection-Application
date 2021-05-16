import 'package:classify_garbage/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tflite/tflite.dart';


class Startup extends StatefulWidget {
  @override
  _StartupState createState() => _StartupState();
}

class _StartupState extends State<Startup> {

  void gotoHome() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    gotoHome();
    return Loading();
  }
}

