import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  static String? uid;

  static Future<void> updateItem({
    required String car,
    required String name,
    required String phone,
    required String userName,

  }) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final CollectionReference _mainCollection = _firestore.collection('parkingTech');
    DocumentReference documentReferencer =
    _mainCollection.doc(uid).collection('items').doc(uid);

    Map<String, dynamic> data = <String, dynamic>{
      "car": car,
      "name": name,
      "phone" : phone,
      "userName" : userName,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("item updated in the database"))
        .catchError((e) => print(e));
  }
}