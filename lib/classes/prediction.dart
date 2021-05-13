import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class Prediction {
  List outputs;
  String number = "";
  String label = "";
  String confidence = "";
  double imageWidth;
  double imageHeight;


  Future predictImage(File image) async {
    if (image == null) return;
    await recognizeImage(image);
    new FileImage(image)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
          imageHeight = info.image.height.toDouble();
          imageWidth = info.image.width.toDouble();
    }));
  }


  Future recognizeImage(File image) async {
    var op = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    outputs = op;
    updateParams();
  }

  Future updateParams() async {
    //print(outputs);
    label = outputs[0]['label'].toString().substring(2);
    number = outputs[0]['label'].toString().substring(1, 2);
    try {
      confidence = (outputs[0]['confidence'] * 100).toStringAsFixed(2);
    } on TypeError {
      print("");
    }
  }
}