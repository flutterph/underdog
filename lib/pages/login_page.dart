import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:underdog/hero_tag.dart';
import 'package:underdog/pages/register_page.dart';
import 'package:underdog/underdog_theme.dart';
import 'package:underdog/viewmodels/login_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';
import 'package:underdog/widgets/slide_left_page_route.dart';
import 'package:underdog/widgets/success_snackbar.dart';

import '../service_locator.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController =
      TextEditingController(text: 'oliatienza@gmail.com');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      builder: (BuildContext context) => locator<LoginModel>(),
      child: Consumer<LoginModel>(
        builder: (BuildContext context, LoginModel model, Widget child) {
          final bool isBusy = model.state == PageState.Busy;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 256),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/illustrations/dog_colour_800px.png',
                            // colorBlendMode: BlendMode.modulate,
                            // color: UnderdogTheme.teal,
                          ),
                          const SizedBox(height: 64),
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
                          const SizedBox(height: 8),
                          TextFormField(
                            enabled: !isBusy,
                            controller: _emailController,
                            decoration: const InputDecoration(
                                hintText: 'E-mail',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16)),
                            validator: (String value) {
                              if (value.isNotEmpty) {
                                final bool emailValid = RegExp(
                                        r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
                                    .hasMatch(value);

                                return emailValid
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
                            decoration: const InputDecoration(
                                hintText: 'Password',
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16)),
                            validator: (String value) {
                              if (value.isNotEmpty) {
                                if (value.length < 8)
                                  return 'Must be 8 or more characters';

                                return null;
                              }

                              return 'You cannot leave this field blank';
                            },
                          ),
                          const SizedBox(height: 24),
                          Builder(
                            builder: (BuildContext context) =>
                                AnimatedRaisedButton(
                              isBusy: isBusy,
                              label: !isBusy ? 'Log In' : 'Logging In',
                              delay: 125,
                              onPressed: !isBusy
                                  ? () {
                                      if (_formKey.currentState.validate()) {
                                        model
                                            .login(_emailController.text.trim(),
                                                _passwordController.text)
                                            .then((String value) {
                                          if (value == null)
                                            Navigator.pushReplacement(
                                                context,
                                                SlideLeftPageRoute<void>(
                                                    page: const HomePage()));
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
                          const SizedBox(height: 8),
                          Builder(
                            builder: (BuildContext context) =>
                                AnimatedFlatButton(
                              label: 'Sign Up',
                              delay: 250,
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
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigateToRegisterPage(BuildContext context) async {
    final String result = await Navigator.push(
        context, SlideLeftPageRoute<String>(page: const RegisterPage()));

    if (result != null) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SuccessSnackBar(content: Text('$result')));
    }
  }
}
