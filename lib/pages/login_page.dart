import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/register_page.dart';
import 'package:underdog/viewmodels/login_model.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';
import 'package:underdog/widgets/success_snackbar.dart';

import '../service_locator.dart';
import '../underdog_theme.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  TextEditingController _emailController =
      TextEditingController(text: 'oliatienza@gmail.com');
  TextEditingController _passwordController =
      TextEditingController(text: 'password');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      builder: (context) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (context, model, child) {
          final isBusy = model.state == PageState.Busy;

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
                          type: MaterialType.transparency,
                          child: SvgPicture.asset(
                            'assets/wordmark.svg',
                            width: 176,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        enabled: !isBusy,
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
                        enabled: !isBusy,
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
                        builder: (context) => AnimatedRaisedButton(
                          isBusy: isBusy,
                          label: !isBusy ? 'Log In' : 'Logging In',
                          onPressed: !isBusy
                              ? () {
                                  if (_formKey.currentState.validate()) {
                                    model
                                        .login(_emailController.text.trim(),
                                            _passwordController.text)
                                        .then((value) {
                                      if (value == null)
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      else {
                                        Scaffold.of(context)
                                            .showSnackBar(ErrorSnackBar(
                                          content: Text(value),
                                        ));
                                      }
                                    });
                                  }
                                }
                              : null,
                        ),
                      ),
                      // Builder(
                      //   builder: (context) => RaisedButton(
                      //     color: Theme.of(context).accentColor,
                      //     disabledColor: Theme.of(context).accentColor,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(16)),
                      //     child: AnimatedSize(
                      //       duration: Duration(milliseconds: 500),
                      //       curve: Curves.fastOutSlowIn,
                      //       vsync: this,
                      //       child: Row(
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: <Widget>[
                      //           Text(
                      //             !isBusy ? 'Log In' : 'Logging In',
                      //             style: UnderdogTheme.raisedButtonText,
                      //           ),
                      //           isBusy
                      //               ? Row(
                      //                   mainAxisSize: MainAxisSize.min,
                      //                   children: <Widget>[
                      //                     SizedBox(
                      //                       width: 8,
                      //                     ),
                      //                     SizedBox(
                      //                       height: 10,
                      //                       width: 10,
                      //                       child: CircularProgressIndicator(
                      //                         backgroundColor: Colors.white,
                      //                         strokeWidth: 2,
                      //                       ),
                      //                     )
                      //                   ],
                      //                 )
                      //               : Container()
                      //         ],
                      //       ),
                      //     ),
                      //     onPressed: !isBusy
                      //         ? () {
                      //             if (_formKey.currentState.validate()) {
                      //               model
                      //                   .login(_emailController.text.trim(),
                      //                       _passwordController.text)
                      //                   .then((value) {
                      //                 if (value == null)
                      //                   Navigator.pushReplacement(
                      //                       context,
                      //                       MaterialPageRoute(
                      //                           builder: (context) =>
                      //                               HomePage()));
                      //                 else {
                      //                   Scaffold.of(context)
                      //                       .showSnackBar(ErrorSnackBar(
                      //                     content: Text(value),
                      //                   ));
                      //                 }
                      //               });
                      //             }
                      //           }
                      //         : null,
                      //   ),
                      // ),
                      SizedBox(
                        height: 8,
                      ),
                      Builder(
                        builder: (BuildContext context) => FlatButton(
                          child: Text(
                            'Sign Up',
                            style: UnderdogTheme.outlineButtonText,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          onPressed: !isBusy
                              ? () {
                                  _navigateToRegisterPage(context);
                                }
                              : null,
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
        ..showSnackBar(SuccessSnackBar(content: Text('$result')));
    }
  }
}
