import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/register_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';

import '../hero_tag.dart';
import '../underdog_theme.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fnController = TextEditingController();
  final TextEditingController _lnController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final UnderlineInputBorder _enabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white70, width: 1));
  final UnderlineInputBorder _focusedBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2));
  final TextStyle _textStyle = TextStyle(color: Colors.white);
  final Color _cursorColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      builder: (BuildContext context) => locator<RegisterModel>(),
      child: Consumer<RegisterModel>(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                'Become a Rescuer',
                style: UnderdogTheme.pageTitle.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        builder: (BuildContext context, RegisterModel model, Widget child) {
          final bool isBusy = model.state == PageState.Busy;

          return Scaffold(
            backgroundColor: Theme.of(context).accentColor,
            body: Hero(
              tag: HeroTag.SIGN_UP,
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 280),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/illustrations/hiker_man_800px.png',
                            colorBlendMode: BlendMode.modulate,
                            color: UnderdogTheme.dirtyWhite,
                          ),
                          const SizedBox(height: 64),
                          child,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Expanded(
                                child: TextFormField(
                                  enabled: !isBusy,
                                  controller: _fnController,
                                  style: _textStyle,
                                  cursorColor: _cursorColor,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      enabledBorder: _enabledBorder,
                                      focusedBorder: _focusedBorder,
                                      hintText: 'First Name',
                                      hintStyle: UnderdogTheme.darkHintText,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16)),
                                  validator: (String value) {
                                    if (value.isNotEmpty) {
                                      return null;
                                    }

                                    return 'This field is required';
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  enabled: !isBusy,
                                  controller: _lnController,
                                  style: _textStyle,
                                  cursorColor: _cursorColor,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                      enabledBorder: _enabledBorder,
                                      focusedBorder: _focusedBorder,
                                      hintText: 'Last Name',
                                      hintStyle: UnderdogTheme.darkHintText,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 16)),
                                  validator: (String value) {
                                    if (value.isNotEmpty) {
                                      return null;
                                    }

                                    return 'This field is required';
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            enabled: !isBusy,
                            controller: _emailController,
                            style: _textStyle,
                            cursorColor: _cursorColor,
                            decoration: InputDecoration(
                                enabledBorder: _enabledBorder,
                                focusedBorder: _focusedBorder,
                                hintText: 'E-mail',
                                hintStyle: UnderdogTheme.darkHintText,
                                contentPadding: const EdgeInsets.symmetric(
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

                              return 'Please enter your registered e-mail';
                            },
                          ),
                          TextFormField(
                            enabled: !isBusy,
                            controller: _passwordController,
                            style: _textStyle,
                            cursorColor: _cursorColor,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: _enabledBorder,
                                focusedBorder: _focusedBorder,
                                hintText: 'Password (8 or more characters)',
                                hintStyle: UnderdogTheme.darkHintText,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16)),
                            validator: (String value) {
                              if (value.isNotEmpty) {
                                if (value.length < 8)
                                  return 'Must be 8 or more characters';

                                return null;
                              }

                              return 'Please enter your password';
                            },
                          ),
                          TextFormField(
                            enabled: !isBusy,
                            controller: _confirmPasswordController,
                            style: _textStyle,
                            cursorColor: _cursorColor,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: _enabledBorder,
                                focusedBorder: _focusedBorder,
                                hintText: 'Confirm Password',
                                hintStyle: UnderdogTheme.darkHintText,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16)),
                            validator: (String value) {
                              if (value != _passwordController.text)
                                return 'Passwords must match';

                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Builder(
                            builder: (BuildContext context) =>
                                AnimatedRaisedButton(
                              isBusy: isBusy,
                              label: !isBusy ? 'Register' : 'Registering',
                              color: Colors.white,
                              style: UnderdogTheme.darkRaisedButtonText,
                              delay: 125,
                              onPressed: isBusy
                                  ? null
                                  : () {
                                      if (_formKey.currentState.validate()) {
                                        model
                                            .registerUser(
                                                _emailController.text.trim(),
                                                _passwordController.text,
                                                _fnController.text,
                                                _lnController.text)
                                            .then(
                                          (String value) {
                                            if (value == null) {
                                              Navigator.pop(context,
                                                  'Successfully registered! Let\'s start rescuing');
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                ErrorSnackBar(
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
                          const SizedBox(height: 8),
                          AnimatedFlatButton(
                            label: 'Cancel',
                            delay: 250,
                            style: UnderdogTheme.darkFlatButtonText,
                            onPressed: isBusy
                                ? null
                                : () {
                                    Navigator.of(context).pop();
                                  },
                          ),
                        ],
                      ),
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
