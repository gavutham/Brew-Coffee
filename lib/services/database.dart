import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final uid;
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");

  DatabaseService({this.uid});

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  Stream<QuerySnapshot> get brews {
    return brewCollection.snapshots();
  }

}
