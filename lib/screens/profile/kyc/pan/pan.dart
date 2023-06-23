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
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_state.dart';
import 'package:aabapay_app/screens/profile/kyc/pan/bloc/pan_event.dart';
import 'package:image_picker/image_picker.dart';

class Pan extends StatefulWidget {
  @override
  _PanState createState() => _PanState();
}

class _PanState extends State<Pan> {
  final PanBloc _panBloc = PanBloc();
  TextEditingController panNumberController = TextEditingController();
  String numberError = '';
  String photoError = '';

  @override
  void initState() {
    _panBloc.add(PanLoadEvent());
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
        title: const Text("Pan Card Verification",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _panBloc,
          child: BlocListener<PanBloc, PanState>(
            listener: (context, state) {
              if (state is PanNumberVerifiedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Kyc()),
                    (Route<dynamic> route) => false);
              }
              if (state is PanPhotoVerifiedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Kyc()),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<PanBloc, PanState>(
              builder: (context, state) {
                if (state is PanErrorState) {
                  numberError = state.numberError;
                  photoError = state.photoError;
                }
                if (state is PanInitialState || state is PanLoadingState) {
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

  Widget _buildHome(BuildContext context, PanState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            SizedBox(height: 10),
            panNumber(),
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
                Expanded(
                  flex: 4,
                  child: Text(''),
                ),
                Expanded(
                  flex: 10,
                  child: panPhotoButton(context, state),
                ),
                Expanded(
                  flex: 4,
                  child: Text(''),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(''),
                ),
                Expanded(
                  flex: 10,
                  child: panPhotoContainer(context, state),
                ),
                Expanded(
                  flex: 4,
                  child: Text(''),
                ),
              ],
            ),
            Text(
              photoError,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30),
            submitPhoto(context, state),
          ])),
    );
  }

  Widget panNumber() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: BorderedTextField('Pan Number', panNumberController,
              textInputType: TextInputType.text),
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

  Widget submitNumber(BuildContext context, PanState state) {
    return Container(
      //   width: 300,
      height: 50,
      child: GradientButton("Verify Pan Number", () {
        numberError = '';
        photoError = '';
        BlocProvider.of<PanBloc>(context).add(PanNumberSubmittedEvent(
          panNumberController.text,
        ));
      }, isLoading: (state is PanNumberSubmittedState) ? true : false),
    );
  }

  Widget panPhotoButton(BuildContext context, PanState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Pan Card',
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => bottomSheetForPan(),
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

  Widget panPhotoContainer(BuildContext context, PanState state) {
    return panPhoto == null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForPan(),
              child: Container(
                  child: Image.asset(
                'assets/images/pan.png',
              )),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForPan(),
              child: Container(
                  height: 200,
                  child: Image.file(File(panPhoto!.path), fit: BoxFit.fill)),
            ),
          );
  }

  XFile? panPhoto;
  dynamic panPhotoPickerFunction(
      ImageSource source, BuildContext context, PanState state) async {
    XFile? front = await ImagePicker().pickImage(source: source);
    panPhoto = front;
    setState(() {});
  }

  bottomSheetForPan() {
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
                          getImageFromCameraForPan();
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
                          getImageFromGalleryForPan();
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

  Future getImageFromCameraForPan() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return;

      setState(() => this.panPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageFromGalleryForPan() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;

      setState(() => this.panPhoto = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget submitPhoto(BuildContext context, PanState state) {
    return Container(
      height: 50,
      child: GradientButton("Verify Pan Card", () {
        numberError = '';
        photoError = '';
        if (panPhoto != null) {
          final panBytes = File(panPhoto!.path).readAsBytesSync();
          String panBase64Image = base64Encode(panBytes);

          BlocProvider.of<PanBloc>(context)
              .add(PanPhotoSubmittedEvent(panBase64Image));
        } else {
          BlocProvider.of<PanBloc>(context)
              .add(PanErrorEvent('', 'Please upload pan card photo'));
        }
      }, isLoading: (state is PanPhotoSubmittedState) ? true : false),
    );
  }

//XFile replaces PickedFile
// ImagePicker.getImage replaces ImagePicker().pickImage

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
