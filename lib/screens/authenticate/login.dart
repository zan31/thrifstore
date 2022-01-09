import 'package:flutter/material.dart';
import 'package:thrifstore/screens/authenticate/register.dart';
import 'package:thrifstore/services/auth.dart';
import 'package:thrifstore/shared/loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.toggleView}) : super(key: key);
  final Function toggleView;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  //textfieldstate
  String email = '';
  String pass = '';
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
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/alt_logo.png'))),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 6),
                        Column(
                          children: const [
                            Text(
                              "Welcome back!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(133, 96, 185, 1.0),
                              ),
                            ),
                            Text(
                              "Sign in with your credentials.",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(133, 96, 185, 1.0),
                              ),
                            ),
                            SizedBox(height: 10)
                          ],
                        ),
                        TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                            obscureText: true,
                            validator: (val) => val!.length < 6
                                ? 'Enter a password 6+ characters long'
                                : null,
                            onChanged: (val) {
                              setState(() {
                                pass = val;
                              });
                            }),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                            child: const Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                primary:
                                    const Color.fromRGBO(133, 96, 185, 1.0)),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                dynamic result =
                                    await _auth.loginEmailPass(email, pass);
                                if (result == null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        _buildPopupDialog(context),
                                  );
                                  setState(() {
                                    loading = false;
                                    error = 'Wrong email or password!';
                                  });
                                }
                              }
                            }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account? ",
                                style: TextStyle(
                                    color: Color.fromRGBO(133, 96, 185, 1.0))),
                            GestureDetector(
                              onTap: () {
                                widget.toggleView();
                              },
                              child: const Text(
                                "Sign up",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Color.fromRGBO(133, 96, 185, 1.0)),
                              ),
                            )
                          ],
                        )
                      ],
                    ))),
          );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(248, 215, 218, 1.0),
      title: const Text(
        "Error",
        style: TextStyle(
          color: Color.fromRGBO(132, 32, 41, 1.0),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            'The email or password is incorrect!',
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

/*ElevatedButton(
          child: Text("Sign in anonymously"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print('error signing in');
            } else {
              print('singed in');
              print(result.uid);
            }
          },
        ),*/
