import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Thrifstore',
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
          primaryIconTheme: const IconThemeData(color: Color(0xFFFFFFFF)),
          canvasColor: const Color(0xFFFFFFFF),
          primarySwatch: createMaterialColor(const Color(0xFF3D3C42)),
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),
          scaffoldBackgroundColor: const Color(0xFFF0D4FF)
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 30),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height/3.5,
                        decoration: const BoxDecoration(
                            image:DecorationImage(image: AssetImage('assets/alt_logo.png'))
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/3,
                      ),

                      MaterialButton(
                        minWidth: double.infinity,
                        height:60,
                        onPressed: (){
                        },
                        color: const Color.fromRGBO(133, 96, 185, 1.0),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color.fromRGBO(133, 96, 185, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: const Text("Login",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF)
                        ),),


                      ),

                      MaterialButton(
                        minWidth: double.infinity,
                        height:60,
                        onPressed: (){
                        },
                        color: const Color.fromRGBO(171, 255, 184, 1.0),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Color.fromRGBO(171, 255, 184, 1.0),
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: const Text("Register",style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFFFFFFF)
                        ),),
                      ),
                    ]
                )
            )
        )
    );
  }
}