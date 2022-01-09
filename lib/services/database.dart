import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(
    String name,
    String phone,
    String adress,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'adress': adress,
    });
  }
}
