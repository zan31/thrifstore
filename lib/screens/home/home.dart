import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/services/auth.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(133, 96, 185, 1.0),
        elevation: 0.0,
        title: Image.asset(
          'assets/logomint.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await _auth.logOut();
            },
            icon: const Icon(
              LineAwesomeIcons.alternate_sign_out,
              color: Color.fromRGBO(171, 255, 184, 1.0),
            ),
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }
}
