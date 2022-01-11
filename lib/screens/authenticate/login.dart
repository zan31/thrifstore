import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
  bool invisible = true;

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
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelStyle:
                                    TextStyle(fontWeight: FontWeight.bold)),
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
                            obscureText: invisible,
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
                            },
                            color: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                borderRadius: BorderRadius.circular(40)),
                            child: const Text(
                              "Login",
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
