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
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_bloc.dart';
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_state.dart';
import 'package:aabapay_app/screens/profile/kyc/photo/bloc/photo_event.dart';
import 'package:image_picker/image_picker.dart';

class Photo extends StatefulWidget {
  @override
  _PhotoState createState() => _PhotoState();
}

class _PhotoState extends State<Photo> {
  final PhotoBloc _photoBloc = PhotoBloc();
  String photoError = '';

  @override
  void initState() {
    _photoBloc.add(PhotoLoadEvent());
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
        title: const Text("Selfie Verification",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _photoBloc,
          child: BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is PhotoVerifiedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Kyc()),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<PhotoBloc, PhotoState>(
              builder: (context, state) {
                if (state is PhotoErrorState) {
                  photoError = state.photoError;
                }
                if (state is PhotoInitialState || state is PhotoLoadingState) {
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

  Widget _buildHome(BuildContext context, PhotoState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Column(children: [
            SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(''),
                ),
                Expanded(
                  flex: 10,
                  child: photoButton(context, state),
                ),
                const Expanded(
                  flex: 4,
                  child: Text(''),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  flex: 4,
                  child: Text(''),
                ),
                Expanded(
                  flex: 10,
                  child: photoContainer(context, state),
                ),
                const Expanded(
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

  Widget photoButton(BuildContext context, PhotoState state) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        'Take a Selfie ',
        style: TextStyle(color: Colors.white),
      ),
      SizedBox(height: 10),
      SizedBox(
        height: 50.0,
        child: ElevatedButton(
          onPressed: () => bottomSheetForPhoto(),
          child: Row(
            children: [
              Icon(Icons.image),
              SizedBox(width: 10),
              Text("Upload Image", style: TextStyle(fontSize: 12)),
            ],
          ),
          style: ElevatedButton.styleFrom(
              primary: cardBackgroundColor,
              side: const BorderSide(
                width: 0.3,
                color: Colors.white,
              )),
        ),
      ),
    ]);
  }

  Widget photoContainer(BuildContext context, PhotoState state) {
    return photo == null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForPhoto(),
              child: Container(
                  child: Image.asset(
                'assets/images/selfie3.png',
              )),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => bottomSheetForPhoto(),
              child: Container(
                  height: 200,
                  child: Image.file(File(photo!.path), fit: BoxFit.fill)),
            ),
          );
  }

  XFile? photo;
  dynamic photoPickerFunction(
      ImageSource source, BuildContext context, PhotoState state) async {
    XFile? front = await ImagePicker().pickImage(source: source);
    photo = front;
    setState(() {});
  }

  bottomSheetForPhoto() {
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
                          getImageFromCameraForPhoto();
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
                          getImageFromGalleryForPhoto();
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

  Future getImageFromCameraForPhoto() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      if (image == null) return;

      setState(() => this.photo = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getImageFromGalleryForPhoto() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

      if (image == null) return;

      setState(() => this.photo = image);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget submitPhoto(BuildContext context, PhotoState state) {
    return Container(
      height: 50,
      child: GradientButton("Verify Your Photo", () {
        photoError = '';
        if (photo != null) {
          final photoBytes = File(photo!.path).readAsBytesSync();
          String photoBase64Image = base64Encode(photoBytes);

          BlocProvider.of<PhotoBloc>(context)
              .add(PhotoSubmittedEvent(photoBase64Image));
        } else {
          BlocProvider.of<PhotoBloc>(context)
              .add(PhotoErrorEvent('Please upload Selfie'));
        }
      }, isLoading: (state is PhotoSubmittedState) ? true : false),
    );
  }

//XFile replaces PickedFile
// ImagePicker.getImage replaces ImagePicker().pickImage

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
