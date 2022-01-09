import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:thrifstore/screens/authenticate/login.dart';
//import 'package:thrifstore/screens/authenticate/login.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:thrifstore/shared/loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool invisible = true;

  //textfieldstate
  String email = '';
  String pass = '';
  String name = '';
  String phone = '';
  String adress = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 5,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/alt_logo.png'))),
                        ),
                        const SizedBox(height: 20.0),
                        Column(
                          children: const [
                            Text(
                              "Hello!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(133, 96, 185, 1.0),
                              ),
                            ),
                            Text(
                              "Create an account, it's free",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(133, 96, 185, 1.0),
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter your name' : null,
                            onChanged: (val) {
                              setState(() {
                                name = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.phone,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            decoration: const InputDecoration(
                                labelText: 'Phone number',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            validator: (val) => val!.length < 9
                                ? 'Enter a valid phone number'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                phone = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                                labelText: 'Adress',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an adress' : null,
                            onChanged: (val) {
                              setState(() {
                                adress = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an adress' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      // Based on passwordVisible state choose the icon
                                      invisible
                                          ? LineAwesomeIcons.eye
                                          : LineAwesomeIcons.eye_slash,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    onPressed: () {
                                      // Update the state i.e. toogle the state of passwordVisible variable
                                      setState(() {
                                        invisible = !invisible;
                                      });
                                    }),
                                labelText: 'Password',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ characters long'
                                : null,
                            obscureText: invisible,
                            onChanged: (val) {
                              setState(() {
                                pass = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 50,
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result = await _auth.registerEmailPass(
                                    email, pass, name, phone, adress);

                                if (result == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                  setState(() {
                                    loading = false;
                                    error = 'Please enter a valid email!';
                                  });
                                }
                              }
                            },
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                borderRadius: BorderRadius.circular(40)),
                            child: const Text(
                              "Sign in",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFFF6E6FF)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?",
                                style: TextStyle(
                                    color: Color.fromRGBO(133, 96, 185, 1.0))),
                            GestureDetector(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: const Text("Login",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                        color: Color.fromRGBO(
                                            133, 96, 185, 1.0)))),
                          ],
                        )
                      ],
                    ))),
          );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(248, 215, 218, 1.0),
      title: const Icon(LineAwesomeIcons.exclamation_circle,
          color: Color.fromRGBO(132, 32, 41, 1.0), size: 40),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'Oops, something went wrong!',
            style: TextStyle(
              color: Color.fromRGBO(132, 32, 41, 1.0),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Close',
            style: TextStyle(color: Color.fromRGBO(132, 32, 41, 1.0)),
          ),
        ),
      ],
    );
  }
}
