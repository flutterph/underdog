import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../underdog_theme.dart';
import '../widgets/superellipse_icon_button.dart';

class SubmitReportPage extends StatefulWidget {
  SubmitReportPage({Key key}) : super(key: key);

  _SubmitReportPageState createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _codeNameController = TextEditingController();
  TextEditingController _landmarkController = TextEditingController();
  TextEditingController _additionalInfoController = TextEditingController();
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 256),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let\'s Rescue!',
                  style: UnderdogTheme.pageTitle,
                ),
                SizedBox(
                  height: 64,
                ),
                Form(
                  key: _formKey,
                  autovalidate: false,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Material(
                        color: Colors.black12,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        child: InkWell(
                          onTap: _showImageSourceSelectionDialog,
                          child: SizedBox(
                            height: 256,
                            child: (_selectedImage == null)
                                ? Icon(Icons.add)
                                : Image.file(
                                    _selectedImage,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        controller: _codeNameController,
                        decoration: InputDecoration(
                            hintText: 'Give him or her a codename for now'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a codename';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _landmarkController,
                        decoration: InputDecoration(hintText: 'Landmark'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This will help rescuers find the dog or puppy faster';
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _additionalInfoController,
                        decoration: InputDecoration(
                            hintText:
                                '(Optional) Any other additional valuable information'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Text(
                        'Submit Report',
                        style: UnderdogTheme.raisedButtonText,
                      )),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Navigator.of(context).pop();
                    }
                  },
                ),
                SizedBox(
                  height: 64,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    var selectedImage = await ImagePicker.pickImage(source: source);

    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void _showImageSourceSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Choose a source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SuperellipseIconButton(
                bgColor: Colors.white,
                iconColor: Theme.of(context).accentColor,
                iconData: Icons.camera,
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
              ),
              SuperellipseIconButton(
                bgColor: Colors.white,
                iconColor: Theme.of(context).accentColor,
                iconData: Icons.image,
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
