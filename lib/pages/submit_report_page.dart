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
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 128,
          ),
          Text(
            'Let\'s Rescue!',
            style: UnderdogTheme.pageTitle,
          ),
          SizedBox(
            height: 128,
          ),
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              InkWell(
                onTap: _showImageSourceSelectionDialog,
                child: Container(
                  child: (_selectedImage == null)
                      ? Icon(Icons.add)
                      : Image.file(_selectedImage),
                ),
              ),
            ],
          )
        ],
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
          return Row(
            children: <Widget>[
              SuperellipseIconButton(
                color: Colors.amber,
                iconData: Icons.camera,
                onTap: () {
                  selectImage(ImageSource.camera);
                },
              ),
              SuperellipseIconButton(
                color: Colors.amber,
                iconData: Icons.image,
                onTap: () {
                  selectImage(ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }
}
