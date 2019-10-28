import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/breeds.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/pages/select_location_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/submit_report_model.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';

import '../underdog_theme.dart';

class SubmitReportPage extends StatefulWidget {
  SubmitReportPage({Key key}) : super(key: key);

  _SubmitReportPageState createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _codeNameController = TextEditingController();
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
                        height: 8,
                      ),
                      SizedBox(
                        width: 280,
                        child: Form(
                          key: _formKey,
                          autovalidate: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: _showImageSourceSelectionDialog,
                                child: Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(color: Colors.black12)),
                                  child: (_selectedImage == null)
                                      ? Container(
                                          height: 280,
                                          width: 280,
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                        )
                                      : Container(
                                          height: 280,
                                          width: 280,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: FileImage(
                                                      _selectedImage))),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  'CODENAME',
                                  style: UnderdogTheme.labelStyle,
                                ),
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
                              SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  'BREED',
                                  style: UnderdogTheme.labelStyle,
                                ),
                              ),
                              DropdownButton<String>(
                                value: model.breed,
                                items: breeds
                                    .map<DropdownMenuItem<String>>((value) {
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
                              SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  'LAST SEEN',
                                  style: UnderdogTheme.labelStyle,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: (model.locationInfo == null)
                                        ? Container()
                                        : Text(model.locationInfo.addressLine),
                                  ),
                                  IconButton(
                                    icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                                    onPressed: () {
                                      final result = Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SelectLocationPage()));

                                      result.then((value) {
                                        if (value != null) {
                                          model.updateLocationInfo(
                                              value as LocationInfo);
                                        }
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Center(
                                child: Text(
                                  'ADDITIONAL INFO',
                                  style: UnderdogTheme.labelStyle,
                                ),
                              ),
                              TextFormField(
                                controller: _additionalInfoController,
                                maxLines: 1,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: InputDecoration(
                                    hintText:
                                        '(Optional) Any other additional valuable information'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      AnimatedRaisedButton(
                        isBusy: model.state == PageState.Busy,
                        label: (model.state == PageState.Idle)
                            ? 'Submit Report'
                            : 'Submitting Report',
                        delay: 125,
                        onPressed: (model.state == PageState.Busy)
                            ? null
                            : () async {
                                if (_formKey.currentState.validate()) {
                                  if (_selectedImage != null) {
                                    if (model.locationInfo != null) {
                                      final submitStatus =
                                          await model.submitReport(
                                              _selectedImage,
                                              _codeNameController.text,
                                              model.breed,
                                              model.locationInfo.addressLine,
                                              model.locationInfo.latitude,
                                              model.locationInfo.longitude,
                                              _additionalInfoController.text);

                                      if (submitStatus != null) {
                                        Scaffold.of(context).showSnackBar(
                                          ErrorSnackBar(
                                            content: Text(submitStatus),
                                          ),
                                        );
                                      } else {
                                        Navigator.pop(context, true);
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                        ErrorSnackBar(
                                          content: Text(
                                              'There was an error retrieving the location. Please turn on LOCATION service'),
                                        ),
                                      );
                                    }
                                  } else {
                                    Scaffold.of(context).showSnackBar(
                                      ErrorSnackBar(
                                        content: Text(
                                            'Please select an image with the dog in it'),
                                      ),
                                    );
                                  }
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Choose a source'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.cameraRetro,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Camera',
                          style: UnderdogTheme.raisedButtonText,
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.camera);
                  }),
              SizedBox(
                width: 8,
              ),
              RaisedButton(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.images,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            'Gallery',
                            style: UnderdogTheme.raisedButtonText,
                          ),
                        ],
                      )),
                  onPressed: () {
                    Navigator.pop(context);
                    selectImage(ImageSource.gallery);
                  }),
            ],
          ),
        );
      },
    );
  }
}
