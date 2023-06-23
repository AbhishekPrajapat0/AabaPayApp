/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/screens/login/login.dart';
import 'package:aabapay_app/screens/login/login_mpin/login_mpin.dart';
import 'package:aabapay_app/screens/profile/kyc/kyc.dart';
import 'package:aabapay_app/screens/profile/profile_edit/profile_edit.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:aabapay_app/constants/app_constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_bloc.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_state.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_event.dart';
import 'package:aabapay_app/screens/profile/feedback_page/feedback_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class Profile extends StatefulWidget {
  bool profileUpdatedFlag;
  bool feedbackAddedFlag;
  Profile({required this.profileUpdatedFlag, required this.feedbackAddedFlag});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileBloc _profileBloc = ProfileBloc();
  bool logoutPressed = false;
  ImagePicker picker = ImagePicker();
  User user = User(
      id: 0,
      firstName: '',
      lastName: '',
      mobile: '',
      email: '',
      pincode: '',
      reference: '');

  @override
  void initState() {
    _profileBloc.add(ProfileLoadEvent());

    if (widget.profileUpdatedFlag) {
      Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    if (widget.feedbackAddedFlag) {
      Fluttertoast.showToast(
          msg: "Feedback Added Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBackgroundColor,
      appBar: AppBar(
        backgroundColor: blackBackgroundColor,
        leading: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: SvgPicture.asset("assets/images/user.svg",
              height: 10, color: Colors.white),
        ),
        title: const Text("Profile",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _profileBloc,
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileAccountDeletedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Login(forgotMpinFlag: false)),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileInitialState ||
                    state is ProfileLoadingState) {
                  return _buildLoading();
                } else {
                  if (state is ProfileLoadedState) {
                    user = state.user;
                  }
                  return _buildHome(context, state);
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context, ProfileState state) {
    return SingleChildScrollView(
        child: SafeArea(
      bottom: true,
      top: true,
      child: Column(
        children: [
          header(),
          SizedBox(height: 10),
          pages(context, state),
          SizedBox(height: 10),
          logOut(),
        ],
      ),
    ));
  }

  Widget header() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: lightBlackBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                CircleAvatar(
                    radius: 30,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40)),
                // const SizedBox(height: 10),
                // GestureDetector(
                //   onTap: () async {},
                //   child: Text("Edit",
                //       style: TextStyle(
                //           color: lightWhiteColor,
                //           fontSize: 16,
                //           fontWeight: FontWeight.w500)),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(user.firstName + " " + user.lastName,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 5),
                Row(
                  children: [
                    Text("+91-" + user.mobile,
                        style: TextStyle(
                            color: lightWhiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Text(user.email,
                          style: TextStyle(
                              color: lightWhiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileEdit(user)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Icon(Icons.edit, size: 30, color: Colors.white),
                      )),
                ),
                SizedBox(
                  height: 35,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget pages(BuildContext context, ProfileState state) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: lightBlackBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          kyc(),
          changeMpin(),
          rateUs(),
          feedback(),
          aboutUs(),
          termsAndConditions(),
          privacyPolicy(),
          contactUs(),
          deleteAccount(context, state),
        ],
      ),
    );
  }

  Widget heightAndDivider() {
    return Column(
      children: [
        SizedBox(height: 7),
        Divider(color: Color.fromARGB(119, 245, 245, 245), thickness: 0.5),
        SizedBox(height: 7),
      ],
    );
  }

  Widget kyc() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Kyc()));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.verified_user_sharp,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("KYC",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget changeMpin() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginMpin(changeMpinFlag: true)));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.lock,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Change M-PIN",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget rateUs() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.grade,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text("Rate Us",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
        heightAndDivider()
      ],
    );
  }

  Widget feedback() {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => FeedbackPage()));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.feedback,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Feedback",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget aboutUs() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(AppConstants.ABOUT_URL));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.info,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("About Us",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget termsAndConditions() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(AppConstants.TERMS_URL));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.content_paste_search,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Terms & Conditions",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget privacyPolicy() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(AppConstants.PRIVACY_URL));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.admin_panel_settings,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Privacy Policy",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget contactUs() {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(AppConstants.CONTACT_URL));
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.contact_support,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Contact Us",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget deleteAccount(BuildContext context, ProfileState state) {
    return GestureDetector(
      onTap: () {
        confirmBox(context, state);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.dangerous,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text("Delete Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          heightAndDivider()
        ],
      ),
    );
  }

  Widget confirmBox(BuildContext ctx, ProfileState state) {
    var pageHeight = MediaQuery.of(ctx).size.height;
    var pageWidth = MediaQuery.of(ctx).size.width;

    Widget cancelButton = TextButton(
      style: ButtonStyle(
        side: MaterialStateProperty.all(const BorderSide(
            color: Colors.white, width: 0.5, style: BorderStyle.solid)),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pageWidth / 30, right: pageWidth / 30),
        child: Text(
          'Cancel',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      onPressed: () {
        Navigator.of(ctx).pop();
      },
    );

    Widget continueButton = TextButton(
      onPressed: () {
        BlocProvider.of<ProfileBloc>(ctx).add(ProfileDeleteEvent());
        Navigator.of(ctx).pop();
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(lightPrimaryColor),
        overlayColor: MaterialStateProperty.all(lightPrimaryColor),
        backgroundColor: MaterialStateProperty.all(lightPrimaryColor),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: pageWidth / 30, right: pageWidth / 30),
        child: Text(
          'Yes, Delete',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
              height: height - (height * 85 / 100),
              width: width,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child:
                            Text('Do you really want to delete this account?',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 177, 173, 173),
                                )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                            '* Please note, all your data and transactions will be lost.',
                            style: TextStyle(color: Colors.red, fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ));
        },
      ),
      backgroundColor: cardBackgroundColor,
      title: Center(
          child: Column(
        children: [
          Text("Delete Account", style: TextStyle(color: lightPrimaryColor)),
          const SizedBox(height: 10),
        ],
      )),
      // content: Text(""),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              cancelButton,
              continueButton,
            ],
          ),
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );

    return Text('');
  }

  Widget logOut() {
    return InkWell(
      onTap: () async {
        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setString('accessToken', '');
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => Login()),
        //     (Route<dynamic> route) => false);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        // decoration: BoxDecoration(
        //   color: lightBlackBackgroundColor,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Align(
          alignment: Alignment.center,
          child: InkWell(
            onTap: () async {
              setState(() {
                logoutPressed = true;
              });
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('accessToken', '');
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Login(forgotMpinFlag: false)),
                  (Route<dynamic> route) => false);
            },
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    darkPrimaryColor,
                    lightPrimaryColor,
                  ],
                ),
              ),
              child: Center(
                  child: logoutPressed
                      ? SizedBox(
                          child: CircularProgressIndicator(color: Colors.white),
                          height: 25,
                          width: 25,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Text('Sign Out',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ],
                        )),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
