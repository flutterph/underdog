import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/breeds.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/pages/select_location_page.dart';
import 'package:underdog/service_locator.dart';
import 'package:underdog/viewmodels/submit_report_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';
import 'package:underdog/widgets/my_back_button.dart';

import '../constants.dart';
import '../underdog_theme.dart';
import '../view_utils.dart';

class SubmitReportPage extends StatefulWidget {
  const SubmitReportPage({Key key}) : super(key: key);

  @override
  _SubmitReportPageState createState() => _SubmitReportPageState();
}

class _SubmitReportPageState extends State<SubmitReportPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeNameController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    const double radius = 56;

    return ChangeNotifierProvider<SubmitReportModel>(
      builder: (BuildContext context) => locator<SubmitReportModel>(),
      child: Consumer<SubmitReportModel>(
        builder: (BuildContext context, SubmitReportModel model, Widget child) {
          final bool isBusy = model.state == PageState.Busy;

          return Scaffold(
            // resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: const MyBackButton(),
            ),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: <Widget>[
                    Material(
                      color: Colors.white,
                      child: Container(
                        height: MediaQuery.of(context).size.height -
                            Constants.PAGE_BOTTOM_BAR_SIZE,
                        width: double.infinity,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(radius),
                              bottomRight: Radius.circular(radius)),
                          side: BorderSide(color: Colors.white12)),
                    ),
                    Material(
                      color: UnderdogTheme.darkTeal,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.33,
                        width: double.infinity,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(radius),
                              bottomRight: Radius.circular(radius)),
                          side: BorderSide(color: Colors.white12)),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: Constants.PAGE_TOP_SPACING,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // ViewUtils.createTopSpacing(),
                            const Text(
                              'Let\'s Rescue!',
                              style: UnderdogTheme.pageTitle,
                            ),
                            SizedBox(
                              width: 300,
                              child: Form(
                                key: _formKey,
                                autovalidate: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: isBusy
                                          ? null
                                          : _showImageSourceSelectionDialog,
                                      child: Material(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Colors.black12)),
                                        child: (_selectedImage == null)
                                            ? Container(
                                                height: 300,
                                                width: 300,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      'Upload an image to help with the rescue',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black12,
                                                ),
                                              )
                                            : Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: FileImage(
                                                            _selectedImage))),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Center(
                                      child: Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 280),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              'CODENAME',
                                              style: UnderdogTheme.labelStyle,
                                            ),
                                            TextFormField(
                                              controller: _codeNameController,
                                              maxLines: 1,
                                              enabled: !isBusy,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      'Give him or her a codename for now'),
                                              validator: (String value) {
                                                if (value.isEmpty) {
                                                  return 'Please provide a codename';
                                                }

                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'BREED',
                                              style: UnderdogTheme.labelStyle,
                                            ),
                                            DropdownButton<String>(
                                              isExpanded: true,
                                              value: model.breed,
                                              items: breeds.map<
                                                      DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (String value) {
                                                setState(() {
                                                  model.breed = value;
                                                });
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'LAST SEEN',
                                              style: UnderdogTheme.labelStyle,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: (model.locationInfo ==
                                                          null)
                                                      ? Container()
                                                      : Text(
                                                          model.locationInfo
                                                              .addressLine,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons
                                                        .mapMarkerAlt,
                                                    color: UnderdogTheme.teal,
                                                  ),
                                                  onPressed: () {
                                                    final Future<LocationInfo>
                                                        result = Navigator.push(
                                                            context,
                                                            MaterialPageRoute<
                                                                    LocationInfo>(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    const SelectLocationPage()));

                                                    result.then(
                                                        (LocationInfo value) {
                                                      if (value != null) {
                                                        model
                                                            .updateLocationInfo(
                                                                value);
                                                      }
                                                    });
                                                  },
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'ADDITIONAL INFO',
                                              style: UnderdogTheme.labelStyle,
                                            ),
                                            TextFormField(
                                              controller:
                                                  _additionalInfoController,
                                              maxLines: 1,
                                              enabled: !isBusy,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      '(Optional) Any other additional valuable information'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: Constants
                                  .PAGE_BOTTOM_BAR_ITEMS_BOTTOM_PADDING),
                          child: Builder(
                            builder: (BuildContext context) => FittedBox(
                              child: AnimatedRaisedButton(
                                isBusy: isBusy,
                                label: !isBusy
                                    ? 'Submit Report'
                                    : 'Submitting Report',
                                delay: 125,
                                onPressed: isBusy
                                    ? null
                                    : () async {
                                        // await _showSubmissionSuccessDialog();

                                        if (_formKey.currentState.validate()) {
                                          if (_selectedImage != null) {
                                            if (model.locationInfo != null) {
                                              final String submitStatus =
                                                  await model.submitReport(
                                                      _selectedImage,
                                                      _codeNameController.text,
                                                      model.breed,
                                                      model.locationInfo
                                                          .addressLine,
                                                      model.locationInfo
                                                          .latitude,
                                                      model.locationInfo
                                                          .longitude,
                                                      _additionalInfoController
                                                          .text);

                                              if (submitStatus != null) {
                                                Scaffold.of(context)
                                                    .showSnackBar(
                                                  ErrorSnackBar(
                                                    content: Text(submitStatus),
                                                  ),
                                                );
                                              } else {
                                                // _showSubmissionSuccessDialog()
                                                //     .then((_) {
                                                Navigator.pop(
                                                    context,
                                                    LatLng(
                                                        model.locationInfo
                                                            .latitude,
                                                        model.locationInfo
                                                            .longitude));
                                                // });
                                              }
                                            } else {
                                              Scaffold.of(context).showSnackBar(
                                                const ErrorSnackBar(
                                                  content: Text(
                                                      'There was an error retrieving the location. Please turn on LOCATION service'),
                                                ),
                                              );
                                            }
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                              const ErrorSnackBar(
                                                content: Text(
                                                    'Please select an image with the dog in it'),
                                              ),
                                            );
                                          }
                                        }
                                      },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> selectImage(ImageSource source) async {
    final File selectedImage = await ImagePicker.pickImage(source: source);

    setState(() {
      _selectedImage = selectedImage;
    });
  }

  Future<void> _showImageSourceSelectionDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

  Future<void> _showSubmissionSuccessDialog() async {
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: const Text(
                'Success',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.green),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Image.asset(
                    'assets/illustrations/map_colour_800px.png',
                    scale: 4,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      'You have successfully submitted the report. Let\'s hope someone rescues the pup soon!',
                      textAlign: TextAlign.center),
                ],
              ),
              actions: <Widget>[
                AnimatedFlatButton(
                  label: 'Okay',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ]);
        });
  }
}
