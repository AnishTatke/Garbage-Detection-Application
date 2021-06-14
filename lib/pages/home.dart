import 'dart:io';
import 'package:classify_garbage/classes/garbage_data.dart';
import 'package:classify_garbage/classes/location.dart';
import 'package:classify_garbage/classes/prediction.dart';
import 'package:classify_garbage/shared/orientation.dart';
import 'package:classify_garbage/services/database.dart';
import 'package:classify_garbage/shared/loading.dart';
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
  bool _connection = false;
  Model valueChoose;
  Model _model;
  Prediction _prediction;
  GarbageData garbageData;
  String conf;
  ImageLocation _loc;


  List<Model> modelList = [
  Model(name: 'Dump Classifier',
  modelPath: 'assets/gdump/cnn_dump.tflite',
  labelPath: 'assets/gdump/labels.txt'),
  Model(name: 'Trash Classifier',
  modelPath: 'assets/trash/vgg16_trash.tflite',
  labelPath: 'assets/trash/labels.txt')
  ];



  @override
  void initState(){
    super.initState();
    _loading = true;
    _prediction = Prediction();
    _loc = ImageLocation();
    if (_model == null) {
      valueChoose = modelList[0];
    }
    _model = Model(name: valueChoose.name,
        modelPath: valueChoose.modelPath,
        labelPath: valueChoose.labelPath);

    _model.loadModel().then((val) {
      setState(() {
        _loading = false;
      });
    });
  }

    Future<GarbageData> createResult() async {
      return GarbageData(
          modelname: _model.name ?? valueChoose.name,
          label: _prediction.label,
          confidence: _prediction.confidence,
          longitude: _loc.location.longitude,
          latitude: _loc.location.latitude,
          timestamp: _loc.location.timestamp.toLocal() ?? DateTime.now().toLocal(),
          country: _loc.address.countryName ?? '',
          state: _loc.address.adminArea ?? '',
          city: _loc.address.locality ?? '',
          locality: _loc.address.subLocality ?? '',
          postalCode: _loc.address.postalCode
      );
    }

  sendData(GarbageData data) async {
    try {
      if(data.label == 'garbage') {
        await DatabaseService().postGarbageData(data);
      } else {
        print("Garbage data not found");
      }
    } catch(e) {
      setState(() => _connection = true);
      print(e);
    }
  }

  Future getImage(ImageSource source) async {
    _model = valueChoose;
    var image = await ImagePicker().getImage(source: source);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = File(image.path);
    });
    await _prediction.predictImage(_image);
    await _loc.getLocation();
    garbageData = await createResult();
    sendData(garbageData);
    setState(() => _loading = false);
    print(_prediction.outputs);
    print(garbageData.country);
  }



  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    return _loading ? Loading() : Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Container(),
          title: Text(
            "Garbage App",
            style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
        ),
        body: Container(
            color: Colors.blue[100],
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
                          color: Colors.grey[900],
                          letterSpacing: 2.0,
                        ),
                      ),
                    ) : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            //borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.black45, width: 5.0),
                            image: DecorationImage(
                                image: FileImage(_image),
                                fit: BoxFit.cover
                            )
                        ),
                      ),
                    ),
                    _image == null ? Container() : _prediction.outputs != null ? Card(
                      color: Colors.blue[50],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _prediction.label == 'non-garbage' ? ListTile(
                            leading: Icon(Icons.thumb_up_alt_outlined, size: 60.0),
                            title: _loc.location != null ? Text("Image does not contain garbage") : Text("Image does not contain garbage"),
                            subtitle: _prediction.confidence != null
                                ? Text("${_model.name}: ${_prediction.confidence}")
                                : Text(""),
                          ) : ListTile(
                            leading: Icon(CupertinoIcons.trash, size: 60.0),
                            title: _loc.location != null ? Text("Image contains garbage") : Text("Image contains garbage"),
                            subtitle: _prediction.confidence != null
                                ? Text("${_model.name}: ${_prediction.confidence}")
                                : Text(""),
                          )
                        ],
                      ),
                    ) : Container(child: Text("")),
                  ],
                ),
              ),
              Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45, width: 1, style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: DropdownButton(
                          icon: Icon(Icons.arrow_drop_down, color: Colors.black87),
                          hint: Text(
                              "Choose Model Type"
                          ),
                          dropdownColor: Colors.white,
                          value: valueChoose,
                          isExpanded: true,
                          underline: SizedBox(),
                          style: TextStyle(
                              color: Colors.grey[900],
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
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: IconButton(
                            icon: Icon(Icons.camera),
                            iconSize: 50.0,
                            color: Colors.black54,
                            onPressed: () {
                              getImage(ImageSource.camera);
                            },
                            tooltip: 'Camera',
                          )
                        ),
                        SizedBox(width: 30.0),
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: IconButton(
                              icon: Icon(Icons.image_outlined),
                              iconSize: 50.0,
                              color: Colors.black54,
                              onPressed: () {
                                getImage(ImageSource.gallery);
                              },
                              tooltip: 'Gallery',
                            )
                        ),
                      ],
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