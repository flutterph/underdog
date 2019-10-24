import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/register_page.dart';
import 'package:underdog/viewmodels/login_model.dart';

import '../service_locator.dart';
import '../underdog_theme.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      builder: (context) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 256),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: HeroTag.MAIN_TITLE,
                        child: Material(
                          child: Text(
                            'Underdog',
                            style: UnderdogTheme.pageTitle,
                          ),
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
                            bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value);

                            return (emailValid)
                                ? null
                                : 'Please enter a valid e-mail';
                          }

                          return 'You cannot leave this field blank';
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: 'Password',
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16)),
                        validator: (value) {
                          if (value.isNotEmpty) {
                            if (value.length < 8)
                              return 'Must be 8 or more characters';

                            return null;
                          }

                          return 'You cannot leave this field blank';
                        },
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Builder(
                        builder: (context) => RaisedButton(
                          color: Theme.of(context).accentColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              child: Text(
                                'Log In',
                                style: UnderdogTheme.raisedButtonText,
                              )),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              model
                                  .login(_emailController.text.trim(),
                                      _passwordController.text)
                                  .then((value) {
                                if (value == null)
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(value),
                                  ));
                                }
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Builder(
                        builder: (BuildContext context) => FlatButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            _navigateToRegisterPage(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToRegisterPage(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => RegisterPage()));

    if (result is String) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
    }
  }
}
