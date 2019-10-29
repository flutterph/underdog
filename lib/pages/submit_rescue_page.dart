import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/pages/select_location_page.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/scale_page_route.dart';

import '../underdog_theme.dart';

class SubmitRescuePage extends StatefulWidget {
  const SubmitRescuePage({Key key, this.report}) : super(key: key);

  final Report report;

  @override
  _SubmitRescuePageState createState() => _SubmitRescuePageState();
}

class _SubmitRescuePageState extends State<SubmitRescuePage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  File _selectedImage1;
  // File _selectedImage2;

  @override
  Widget build(BuildContext context) {
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
                  'Thank you!',
                  style: UnderdogTheme.pageTitle,
                ),
                const SizedBox(height: 8),
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
                            child: (_selectedImage1 == null)
                                ? Container(
                                    height: 280,
                                    width: 280,
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
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  )
                                : Container(
                                    height: 280,
                                    width: 280,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: FileImage(_selectedImage1))),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'LAST SEEN',
                            style: UnderdogTheme.labelStyle,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            // ! Fix when model is ready
                            // Expanded(
                            //   child: (model.locationInfo == null)
                            //       ? Container()
                            //       : Text(model.locationInfo.addressLine),
                            // ),
                            IconButton(
                              icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                              onPressed: () {
                                final Future<LocationInfo> result =
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<LocationInfo>(
                                            builder: (BuildContext context) =>
                                                const SelectLocationPage()));

                                result.then((LocationInfo value) {
                                  if (value != null) {}
                                });
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Text(
                            'ADDITIONAL INFO',
                            style: UnderdogTheme.labelStyle,
                          ),
                        ),
                        TextFormField(
                          controller: _additionalInfoController,
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                              hintText:
                                  '(Optional) Any other additional valuable information'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ! Fix when model is ready
                const SizedBox(height: 16),
                AnimatedRaisedButton(
                  label: 'Submit Rescue',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  delay: 125,
                ),
                const SizedBox(height: 8),
                AnimatedFlatButton(
                  label: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  delay: 250,
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    final File selectedImage = await ImagePicker.pickImage(source: source);

    setState(() {
      _selectedImage1 = selectedImage;
    });
  }

  void _showImageSourceSelectionDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Choose a source'),
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
                        const SizedBox(height: 8),
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
              const SizedBox(width: 8),
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
                          const SizedBox(height: 8),
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
