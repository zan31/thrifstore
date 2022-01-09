import 'package:firebase_auth/firebase_auth.dart';
import 'package:thrifstore/models/user.dart';
import 'package:thrifstore/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CUser? _userFromUser(User? user) {
    return user != null ? CUser(uid: user.uid) : null;
  }

  Stream<CUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromUser(user));
  }

  //sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future loginEmailPass(String email, String pass) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      User? user = result.user;
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerEmailPass(String email, String pass, String name, String phone,
      String adress) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      User? user = result.user;

      //Create a document for the user with uid
      await DatabaseService(uid: user!.uid).updateUserData(name, phone, adress);
      return _userFromUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //logout
  Future logOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
