import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:underdog/data/models/location_info.dart';
import 'package:underdog/data/models/report.dart';
import 'package:underdog/pages/select_location_page.dart';
import 'package:underdog/view_utils.dart';
import 'package:underdog/viewmodels/submit_rescue_model.dart';
import 'package:underdog/widgets/animated_flat_button.dart';
import 'package:underdog/widgets/animated_outline_button.dart';
import 'package:underdog/widgets/animated_raised_button.dart';
import 'package:underdog/widgets/error_snackbar.dart';
import 'package:underdog/widgets/my_back_button.dart';

import '../constants.dart';
import '../service_locator.dart';
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
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  final UnderlineInputBorder _enabledBorder = UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white70, width: 1));
  final UnderlineInputBorder _focusedBorder = const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2));
  File _selectedImage;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SubmitRescueModel>(
      builder: (BuildContext context) => locator<SubmitRescueModel>(),
      child: Consumer<SubmitRescueModel>(
        builder: (BuildContext context, SubmitRescueModel model, Widget child) {
          final bool isBusy = model.state == PageState.Busy;

          return Scaffold(
            backgroundColor: UnderdogTheme.teal,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.white),
              leading: const MyBackButton(),
            ),
            extendBodyBehindAppBar: true,
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    Constants.PAGE_BOTTOM_BAR_SIZE,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: Constants.PAGE_BOTTOM_BAR_SIZE,
                      child: Container(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height -
                              Constants.PAGE_BOTTOM_BAR_SIZE,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ViewUtils.createTopSpacing(),
                            Text(
                              'You\'re a hero',
                              style: UnderdogTheme.pageTitle
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 300,
                              child: Form(
                                key: _formKey,
                                autovalidate: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: !isBusy
                                          ? _showImageSourceSelectionDialog
                                          : null,
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
                                                      'Upload proof of rescue (ideally a picture of you with the dog)',
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
                                                  color: Colors.white12,
                                                  // borderRadius:
                                                  //     BorderRadius.circular(16),
                                                ),
                                              )
                                            : Container(
                                                height: 300,
                                                width: 300,
                                                decoration: BoxDecoration(
                                                    // borderRadius:
                                                    //     BorderRadius.circular(16),
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
                                          children: <Widget>[
                                            Text(
                                              'FOUND AT',
                                              style:
                                                  UnderdogTheme.darkLabelStyle,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
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
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                ),
                                                IconButton(
                                                  icon: Icon(
                                                    FontAwesomeIcons
                                                        .mapMarkerAlt,
                                                    color:
                                                        UnderdogTheme.darkTeal,
                                                  ),
                                                  onPressed: !isBusy
                                                      ? () {
                                                          final Future<
                                                                  LocationInfo>
                                                              result =
                                                              Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute<
                                                                          LocationInfo>(
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          const SelectLocationPage()));

                                                          result.then(
                                                              (LocationInfo
                                                                  value) {
                                                            if (value != null) {
                                                              model
                                                                  .updateLocationInfo(
                                                                      value);
                                                            }
                                                          });
                                                        }
                                                      : null,
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'CONTACT NO.',
                                              style:
                                                  UnderdogTheme.darkLabelStyle,
                                            ),
                                            TextFormField(
                                              enabled: !isBusy,
                                              controller: _contactNoController,
                                              maxLines: 1,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  enabledBorder: _enabledBorder,
                                                  focusedBorder: _focusedBorder,
                                                  hintText: '09xxxxxxxxx',
                                                  hintStyle: UnderdogTheme
                                                      .darkHintText),
                                              validator: (String value) {
                                                if (value.length != 11 ||
                                                    int.tryParse(value) ==
                                                        null) {
                                                  return 'Please enter a valid mobile number';
                                                } else if (value.isEmpty) {
                                                  return 'This field is required';
                                                }

                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              'ADDITIONAL INFO',
                                              style:
                                                  UnderdogTheme.darkLabelStyle,
                                            ),
                                            TextFormField(
                                              enabled: !isBusy,
                                              controller:
                                                  _additionalInfoController,
                                              maxLines: 1,
                                              textCapitalization:
                                                  TextCapitalization.sentences,
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  enabledBorder: _enabledBorder,
                                                  focusedBorder: _focusedBorder,
                                                  hintText:
                                                      '(Optional) Any other additional valuable information',
                                                  hintStyle: UnderdogTheme
                                                      .darkHintText),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom:
                                Constants.PAGE_BOTTOM_BAR_ITEMS_BOTTOM_PADDING),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FittedBox(
                              child: AnimatedOutlineButton(
                                label: 'Cancel',
                                color: Colors.white,
                                style: UnderdogTheme.darkFlatButtonText,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                delay: 250,
                              ),
                            ),
                            const SizedBox(width: 8),
                            FittedBox(
                              child: AnimatedRaisedButton(
                                label: isBusy
                                    ? 'Submitting Rescue'
                                    : 'Submit Rescue',
                                color: UnderdogTheme.darkTeal,
                                isBusy: isBusy,
                                style: UnderdogTheme.raisedButtonText,
                                onPressed: isBusy
                                    ? null
                                    : () async {
                                        // await _showSubmissionSuccessDialog();

                                        if (_formKey.currentState.validate()) {
                                          final String result =
                                              await model.submitRescue(
                                                  widget.report.uid,
                                                  _selectedImage,
                                                  model
                                                      .locationInfo.addressLine,
                                                  model.locationInfo.latitude,
                                                  model.locationInfo.longitude,
                                                  _additionalInfoController
                                                      .text,
                                                  _contactNoController.text);

                                          if (result != null) {
                                            Scaffold.of(context).showSnackBar(
                                              ErrorSnackBar(
                                                content: Text(result),
                                              ),
                                            );
                                          } else {
                                            // await _showSubmissionSuccessDialog();
                                            Navigator.pop(context, true);
                                          }
                                        }
                                      },
                                delay: 125,
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

  void _showImageSourceSelectionDialog() {
    showDialog<void>(
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
                children: <Widget>[
                  Image.asset(
                    'assets/illustrations/pet_toys_colour_800px.png',
                    scale: 4,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'You have successfully submitted the rescue. Thank you so much for helping a dog find his/her forever home!',
                    textAlign: TextAlign.center,
                  ),
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
