import 'package:brew_coffee/models/brew.dart';
import 'package:brew_coffee/models/user.dart';
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


  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((e) => Brew(
        name: e.data().toString().contains("name") ? e["name"] : "",
        sugars: e.data().toString().contains("sugars") ? e["sugars"] : "",
        strength: e.data().toString().contains("strength") ? e["strength"] : 0)).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data().toString().contains("name") ? snapshot["name"] : "",
      sugars: snapshot.data().toString().contains("sugars") ? snapshot["sugars"] : "",
      strength: snapshot.data().toString().contains("strength") ? snapshot["strength"] : 0
    );
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

 Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
 }

}
