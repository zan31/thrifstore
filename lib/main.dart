import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:thrifstore/models/user.dart';
import 'package:thrifstore/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:thrifstore/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<CUser?>.value(
      value: AuthService().user,
      catchError: (User, CUser) => null,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Thrifstore',
        theme: ThemeData(
            iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
            primaryIconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
            canvasColor: const Color(0xFFFFFFFF),
            primarySwatch:
                createMaterialColor(const Color.fromRGBO(171, 255, 184, 1.0)),
            textTheme: GoogleFonts.montserratTextTheme(
              Theme.of(context).textTheme,
            ),
            scaffoldBackgroundColor: const Color(0xFFF6E6FF)),
        home: Wrapper(),
      ),
    );
  }
}
