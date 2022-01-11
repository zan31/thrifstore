import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thrifstore/models/user.dart';
import 'package:thrifstore/screens/authenticate/authenticate.dart';
import 'package:thrifstore/screens/home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CUser?>(context);

    if (user == null) {
      return Authenticate();
    } else {
      return Home(
        userid: user.uid,
      );
    }
  }
}
