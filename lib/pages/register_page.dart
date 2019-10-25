import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/register_model.dart';

import '../hero_tag.dart';
import '../underdog_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fnController = TextEditingController();
  TextEditingController _lnController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _enabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white70, width: 1));
  final _focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2));
  final _textStyle = TextStyle(color: Colors.white);
  final _cursorColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      builder: (context) => locator<RegisterModel>(),
      child: Consumer<RegisterModel>(
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            body: Hero(
              tag: HeroTag.SIGN_UP,
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: 280),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            'Become a Rescuer',
                            style: UnderdogTheme.pageTitle
                                .copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: TextFormField(
                                controller: _fnController,
                                style: _textStyle,
                                cursorColor: _cursorColor,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    enabledBorder: _enabledBorder,
                                    focusedBorder: _focusedBorder,
                                    hintText: 'First Name',
                                    hintStyle: UnderdogTheme.hintTextDark,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16)),
                                validator: (value) {
                                  if (value.isNotEmpty) return null;

                                  return 'This field is required';
                                },
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _lnController,
                                style: _textStyle,
                                cursorColor: _cursorColor,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                    enabledBorder: _enabledBorder,
                                    focusedBorder: _focusedBorder,
                                    hintText: 'Last Name',
                                    hintStyle: UnderdogTheme.hintTextDark,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 16)),
                                validator: (value) {
                                  if (value.isNotEmpty) return null;

                                  return 'This field is required';
                                },
                              ),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: _emailController,
                          style: _textStyle,
                          cursorColor: _cursorColor,
                          decoration: InputDecoration(
                              enabledBorder: _enabledBorder,
                              focusedBorder: _focusedBorder,
                              hintText: 'E-mail',
                              hintStyle: UnderdogTheme.hintTextDark,
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

                            return 'Please enter your registered e-mail';
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          style: _textStyle,
                          cursorColor: _cursorColor,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: _enabledBorder,
                              focusedBorder: _focusedBorder,
                              hintText: 'Password (8 or more characters)',
                              hintStyle: UnderdogTheme.hintTextDark,
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
                          style: _textStyle,
                          cursorColor: _cursorColor,
                          obscureText: true,
                          decoration: InputDecoration(
                              enabledBorder: _enabledBorder,
                              focusedBorder: _focusedBorder,
                              hintText: 'Confirm Password',
                              hintStyle: UnderdogTheme.hintTextDark,
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
                        Builder(
                          builder: (context) => RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: BorderSide(color: Colors.black12)),
                            child: AnimatedSize(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.fastOutSlowIn,
                              vsync: this,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    (model.state == PageState.Idle)
                                        ? 'Register'
                                        : 'Registering',
                                    style: UnderdogTheme.raisedButtonTextDark,
                                  ),
                                  (model.state == PageState.Busy)
                                      ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            SizedBox(
                                              width: 8,
                                            ),
                                            SizedBox(
                                              height: 10,
                                              width: 10,
                                              child: CircularProgressIndicator(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .accentColor,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                model
                                    .registerUser(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                        _fnController.text,
                                        _lnController.text)
                                    .then(
                                  (value) {
                                    if (value == null) {
                                      Navigator.pop(context,
                                          'Successfully registered! Let\'s start rescuing');
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(value),
                                        ),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
        },
      ),
    );
  }
}
