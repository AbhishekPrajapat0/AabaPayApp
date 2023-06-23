/* Tushar Ugale * Technicul.com */
import 'dart:io';
import 'dart:convert';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/profile/kyc/kyc.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_state.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/bloc/aadhar_event.dart';
import 'package:aabapay_app/screens/profile/kyc/aadhar/aadhar_check_otp/aadhar_check_otp.dart';
import 'package:image_picker/image_picker.dart';

class Aadhar extends StatefulWidget {
  final bool skipKyc;
  const Aadhar({Key? key, required this.skipKyc}) : super(key: key);

  @override
  _AadharState createState() => _AadharState();
}

class _AadharState extends State<Aadhar> {
  final AadharBloc _aadharBloc = AadharBloc();
  TextEditingController aadharNumberController = TextEditingController();
  String numberError = '';
  String photoError = '';

  @override
  void initState() {
    _aadharBloc.add(AadharLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Home(
                      selectedIndex: 3,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)),
              (Route<dynamic> route) => false),
        ),
        title: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text("Verify Aadhar Card",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 20)),
            ),
            Expanded(
                child: (widget.skipKyc == true
                    ? Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                          selectedIndex: 0,
                                          profileUpdatedFlag: false,
                                          feedbackAddedFlag: false)),
                                  (Route<dynamic> route) => false);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                'skip >',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: lightPrimaryColor,
                                  // decoration: TextDecoration.underline,
                                ),
                              ),
                            )))
                    : Text(''))),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _aadharBloc,
          child: BlocListener<AadharBloc, AadharState>(
            listener: (context, state) {
              if (state is AadharNumberVerifiedState) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AadharCheckOTP()));
              }
              if (state is AadharPhotoVerifiedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Kyc()),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<AadharBloc, AadharState>(
              builder: (context, state) {
                if (state is AadharErrorState) {
                  numberError = state.numberError;
                  photoError = state.photoError;
                }
                if (state is AadharInitialState ||
                    state is AadharLoadingState) {
                  return _buildLoading();
                } else {
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, AadharState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            SizedBox(height: 10),
            aadharNumber(),
            SizedBox(height: 20),
            submitNumber(context, state),
            SizedBox(height: 50),
            Center(
                child: Text(
              'OR',
              style: TextStyle(color: Colors.white, fontSize: 25),
            )),
            SizedBox(height: 50),
            Row(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: 1, child: Text('')),
                Expanded(
                  flex: 15,
                  child: aadharFrontPhotoButton(context, state),
                ),
                Expanded(flex: 1, child: Text('')),
                Expanded(
                  flex: 15,
                  child: aadharBackPhotoButton(context, state),
                ),
                Expanded(flex: 1, child: Text('')),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: aadharFrontPhotoContainer(context, state),
                ),
                Expanded(
                  flex: 1,
                  child: aadharBackPhotoContainer(context, state),
                ),
              ],
            ),
            Text(
              photoError,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30),
            submitPhotos(context, state),
          ])),
    );
  }

  Widget aadharNumber() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BorderedTextField('Aadhar Number', aadharNumberController,
              textInputType: TextInputType.number),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            numberError,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }

  Widget submitNumber(BuildContext context, AadharState state) {
    return Container(
      //   width: 300,
      height: 50,
      child: GradientButton("Request OTP", () {
        numberError = '';
        photoError = '';
        BlocProvider.of<AadharBloc>(context).add(AadharNumberSubmittedEvent(
          aadharNumberController.text,
        ));
      }, isLoading: (state is AadharNumberSubmittedState) ? true : false),
    );
  }

  Widget aadharFrontPhotoButton(BuildContext context, AadharState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Aadhar Card Front',
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => bottomSheetForFront(),
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 10),
              Text("Upload Image", style: TextStyle(fontSize: 12)),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: cardBackgroundColor,
              side: BorderSide(
                width: 0.3,
                color: Colors.white,
              )),
        ),
      ),
    ]);
  }

  Widget aadharBackPhotoButton(BuildContext context, AadharState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Aadhar Card Back',
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => bottomSheetForBack(),
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 5),
              Text("Upload Image", style: TextStyle(fontSize: 12)),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: cardBackgroundColor,
              side: BorderSide(
                width: 0.3,
                color: Colors.white,
              )),
        ),
      ),
    ]);
  }

  Widget aadharFrontPhotoContainer(BuildContext context, AadharState state) {
    return aadharFrontPhoto == null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForFront(),
              child: Container(
                  child: Image.asset(
                'assets/images/aadhar_front.png',
              )),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForFront(),
              child: Container(
                  height: 200,
                  child: Image.file(File(aadharFrontPhoto!.path),
                      fit: BoxFit.fill)),
            ),
          );
  }

  Widget aadharBackPhotoContainer(BuildContext context, AadharState state) {
    return aadharBackPhoto == null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForBack(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/aadhar_back.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForBack(),
              child: Container(
                  height: 200,
                  child: Image.file(File(aadharBackPhoto!.path),
                      fit: BoxFit.fill)),
            ),
          );
  }

  XFile? aadharFrontPhoto;
  dynamic aadharFrontPhotoPickerFunction(
      ImageSource source, BuildContext context, AadharState state) async {
    XFile? front = await ImagePicker().pickImage(source: source);
    aadharFrontPhoto = front;
    setState(() {});
  }

  bottomSheetForFront() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(height: 10),
                Text(
                  "Select Upload Option.",
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromCameraForFront();
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFD7DEDD)),
                              // color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 12, 10, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Camera",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromGalleryForFront();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD7DEDD)),
                            // color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Gallery",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageFromCameraForFront() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return;

      setState(() => this.aadharFrontPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageFromGalleryForFront() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;

      setState(() => this.aadharFrontPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  XFile? aadharBackPhoto;
  dynamic aadharBackPhotoPickerFunction(
      ImageSource source, BuildContext context, AadharState state) async {
    XFile? back = await ImagePicker().pickImage(source: source);
    aadharBackPhoto = back;
    setState(() {});
  }

  bottomSheetForBack() {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 7,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(height: 10),
                Text(
                  "Select Upload Option.",
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromCameraForBack();
                          Navigator.pop(context);
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFD7DEDD)),
                              // color: Colors.tealAccent,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 12, 10, 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera,
                                    color: Colors.black,
                                    size: 22,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Camera",
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          getImageFromGalleryForBack();
                          Navigator.pop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFD7DEDD)),
                            // color: Colors.tealAccent,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 10, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image_outlined,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  "Gallery",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageFromCameraForBack() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return;

      setState(() => this.aadharBackPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageFromGalleryForBack() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;

      setState(() => this.aadharBackPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget submitPhotos(BuildContext context, AadharState state) {
    return Container(
      height: 50,
      child: GradientButton("Verify Aadhar", () {
        numberError = '';
        photoError = '';
        if (aadharFrontPhoto != null && aadharBackPhoto != null) {
          final frontBytes = File(aadharFrontPhoto!.path).readAsBytesSync();
          String frontBase64Image = base64Encode(frontBytes);

          final backBytes = File(aadharBackPhoto!.path).readAsBytesSync();
          // String backBase64Image = "data:image/png;base64," + base64Encode(backBytes);
          String backBase64Image = base64Encode(backBytes);
          BlocProvider.of<AadharBloc>(context).add(
              AadharPhotoSubmittedEvent(frontBase64Image, backBase64Image));
        } else {
          BlocProvider.of<AadharBloc>(context)
              .add(AadharErrorEvent('', 'Please upload aadhar photos'));
        }
      }, isLoading: (state is AadharPhotoSubmittedState) ? true : false),
    );
  }

//XFile replaces PickedFile
// ImagePicker.getImage replaces ImagePicker().pickImage

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
