import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

class Model {
  String name;
  String modelPath;
  String labelPath;

  Model({ this.name, this.modelPath, this.labelPath });

  loadModel() async {
    Tflite.close();
    String res = await Tflite.loadModel(
      model: modelPath,
      labels: labelPath,
    );
    print("Loaded the model: $res");
  }

}