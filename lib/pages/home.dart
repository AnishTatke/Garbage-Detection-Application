import 'dart:io';
import 'package:classify_garbage/classes/location.dart';
import 'package:classify_garbage/classes/prediction.dart';
import 'package:classify_garbage/resize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:classify_garbage/classes/model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with PortraitStatefulModeMixin<Home> {

  File _image;
  bool _loading = false;
  Model valueChoose;
  Model _model;
  Prediction _prediction;
  String conf;
  ImageLocation _loc;

  List<Model> modelList = [
    Model(name: 'Dump Classifier',
        modelPath: 'assets/gdump/tf_lite_model.tflite',
        labelPath: 'assets/gdump/labels.txt'),
    Model(name: 'Trash Classifier',
        modelPath: 'assets/trash/tf_lite_model.tflite',
        labelPath: 'assets/trash/labels.txt')
  ];

  @override
  void initState() {
    super.initState();
    _loading = true;
    _prediction = Prediction();
    _loc = ImageLocation();
    if (_model == null) {
      valueChoose = modelList[0];
    }
    _model = Model(name: valueChoose.name, modelPath: valueChoose.modelPath, labelPath: valueChoose.labelPath);
    _model.loadModel().then((val) {
      setState(() {
        _loading = false;
      });
    });
  }


  Future getImage() async {
    _model = valueChoose;
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    await _prediction.predictImage(_image);
    await _loc.getLocation();
    setState(() {});
    print(_prediction.outputs);
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(),
          title: Text("Garbage Classification"),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/landscape.jpg'),
                  fit: BoxFit.cover,
                )
            ),
            child: Column(
            children: [
              Container(
                height: 3 * (MediaQuery.of(context).size.height) / 5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    _image == null ? Padding(
                      padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                      child: Text(
                        'No Image Selected',
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            //borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.grey[300], width: 5.0),
                            image: DecorationImage(
                                image: FileImage(_image),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                    _image == null ? Container() : _prediction.outputs != null ? Card(
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _prediction.label == 'non-garbage' ? ListTile(
                            leading: Icon(Icons.thumb_up_alt_outlined),
                            title: _loc.location != null ? Text("Image does not contain garbage at location ${_loc.location.longitude}, ${_loc.location.latitude}") : Text("Image does not contain garbage"),
                            subtitle: _prediction.confidence != null
                                ? Text(_prediction.confidence + " ${_model.name}")
                                : Text(""),
                          ) : ListTile(
                            leading: Icon(CupertinoIcons.trash),
                            title: _loc.location != null ? Text("Image contains garbage at location ${_loc.location.longitude}, ${_loc.location.latitude}") : Text("Image contains garbage"),
                            subtitle: _prediction.confidence != null
                                ? Text(_prediction.confidence + " ${_model.name}")
                                : Text(""),
                          )
                        ],
                      ),
                    ) : Container(child: Text("")),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: DropdownButton(
                          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                          hint: Text(
                              "Choose Model Type"
                          ),
                          dropdownColor: Colors.grey,
                          value: valueChoose,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              valueChoose = newValue;
                            });
                          },
                          items: modelList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: IconButton(
                        icon: Icon(Icons.camera),
                        iconSize: 50.0,
                        color: Colors.white,
                        onPressed: getImage,
                        tooltip: 'Click Me',
                      )
                    )
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}