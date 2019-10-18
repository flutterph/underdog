import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../hero_tag.dart';
import '../underdog_theme.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Hero(
        tag: HeroTag.SIGN_UP,
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 256),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      'Become a Rescuer',
                      style:
                          UnderdogTheme.pageTitle.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'E-mail',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16)),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        bool emailValid =
                            RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);

                        return (emailValid)
                            ? null
                            : 'Please enter a valid e-mail';
                      }

                      return 'Please enter your registered e-mail';
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        hintText: 'Password (8 or more characters)',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16)),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        if (value.length < 8)
                          return 'Must be 8 or more characters';

                        return null;
                      }

                      return 'Please enter your password';
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16)),
                    validator: (value) {
                      if (value != _passwordController.text)
                        return 'Passwords must match';

                      return null;
                    },
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(
                        'Register',
                        style: UnderdogTheme.raisedButtonText
                            .copyWith(color: Theme.of(context).accentColor),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _registerUser(
                            _emailController.text, _passwordController.text);
                      }
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerUser(String email, String password) async {
    try {
      final FirebaseUser authResult = (await _auth
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;

      Navigator.of(context)
          .pop('Successfully registered! Let\'s start rescuing!');
    } catch (e) {
      switch (e.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          break;
        case "ERROR_WEAK_PASSWORD":
          break;
      }
    }
  }
}
