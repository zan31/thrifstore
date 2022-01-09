import 'package:flutter/material.dart';
import 'package:thrifstore/screens/authenticate/login.dart';
import 'package:thrifstore/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool toggleForm = true;
  void toggleView() {
    setState(() {
      toggleForm = !toggleForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (toggleForm) {
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
