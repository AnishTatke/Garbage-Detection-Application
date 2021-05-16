import 'package:classify_garbage/classes/garbage_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final CollectionReference garbageCollection =FirebaseFirestore.instance.collection('garbage-images');

  Future postGarbageData(GarbageData garbageData) async {
    return await garbageCollection.doc().set({
      'modelName': garbageData.modelname,
      'confidence': garbageData.confidence,
      'label': garbageData.label,
      'longitude': garbageData.longitude,
      'latitude': garbageData.latitude,
      'timestamp': garbageData.timestamp.toLocal(),
      'country': garbageData.country,
      'state': garbageData.state,
      'city': garbageData.city,
      'locality': garbageData.locality,
      'postalCode': garbageData.postalCode
    });
  }

}