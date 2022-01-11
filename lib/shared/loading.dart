import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6E6FF),
      child: const Center(
        child: SpinKitDoubleBounce(
          color: Color.fromRGBO(133, 96, 185, 1.0),
          size: 50.0,
        ),
      ),
    );
  }
}
