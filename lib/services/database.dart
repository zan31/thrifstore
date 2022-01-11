import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  Future updateUserData(
    String name,
    String phone,
    String adress,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'phone': phone,
      'adress': adress,
      'email': email,
    });
  }

  Future insertPost(
    String title,
    double price,
    String desc,
    String imgurl,
    String selectedValue,
  ) async {
    DocumentReference docRef = await postCollection.doc();
    return await postCollection.doc(docRef.id).set({
      'title': title,
      'docId': docRef.id,
      'category_id': selectedValue,
      'desc': desc,
      'price': price,
      'imgurl': imgurl,
      'user_id': uid,
    });
  }

  Future updatePost(String title, double price, String desc, String imgurl,
      String selectedValue, String docid) async {
    return await postCollection.doc(docid).set({
      'title': title,
      'docId': docid,
      'category_id': selectedValue,
      'desc': desc,
      'price': price,
      'imgurl': imgurl,
      'user_id': uid,
    });
  }

  Future deletePost(String docid) async {
    await postCollection.doc(docid).delete();
  }
}
