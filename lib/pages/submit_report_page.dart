import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/breeds.dart';
import 'package:underdog/pages/select_location_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/submit_report_model.dart';

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
    return ChangeNotifierProvider<SubmitReportModel>(
      builder: (context) => locator<SubmitReportModel>(),
      child: Consumer<SubmitReportModel>(
        builder: (context, model, child) {
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
                            InkWell(
                              onTap: _showImageSourceSelectionDialog,
                              child: (_selectedImage == null)
                                  ? Container(
                                      height: 256,
                                      width: 256,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Upload an image to help with the rescue',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45),
                                          ),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    )
                                  : Container(
                                      height: 256,
                                      width: 256,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image:
                                                  FileImage(_selectedImage))),
                                    ),
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            TextFormField(
                              controller: _codeNameController,
                              maxLines: 1,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                  hintText:
                                      'Give him or her a codename for now'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please provide a codename';
                                }

                                return null;
                              },
                            ),
                            DropdownButton<String>(
                              value: model.breed,
                              items:
                                  breeds.map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  model.breed = value;
                                });
                              },
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: TextFormField(
                                    controller: _landmarkController,
                                    maxLines: 1,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration:
                                        InputDecoration(hintText: 'Landmark'),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'This will help rescuers find the dog or puppy faster';
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectLocationPage()));
                                  },
                                )
                              ],
                            ),
                            TextFormField(
                              controller: _additionalInfoController,
                              maxLines: 1,
                              textCapitalization: TextCapitalization.sentences,
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
                      Builder(
                        builder: (context) => RaisedButton(
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
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              if (_selectedImage != null) {
                                final submitStatus = await model.submitReport(
                                    _selectedImage,
                                    _codeNameController.text,
                                    model.breed,
                                    _landmarkController.text,
                                    14.4793,
                                    121.0198,
                                    _additionalInfoController.text);

                                if (submitStatus != null) {
                                  Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(submitStatus),
                                    ),
                                  );
                                } else {
                                  Navigator.pop(context);
                                }
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Please select an image with the dog in it'),
                                  ),
                                );
                              }
                            }
                          },
                        ),
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
        },
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
