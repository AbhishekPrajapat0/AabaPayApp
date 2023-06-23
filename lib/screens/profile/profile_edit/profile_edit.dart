/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_bloc.dart';
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_state.dart';
import 'package:aabapay_app/screens/profile/profile_edit/bloc/profile_edit_event.dart';

class ProfileEdit extends StatefulWidget {
  User user;
  ProfileEdit(this.user);
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final ProfileEditBloc _ProfileEditBloc = ProfileEditBloc();
  TextEditingController firstNameEditingController = TextEditingController();
  TextEditingController lastNameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController pincodeEditingController = TextEditingController();
  String firstNameError = '';
  String lastNameError = '';
  String emailError = '';
  String pincodeError = '';

  @override
  void initState() {
    _ProfileEditBloc.add(ProfileEditLoadEvent(widget.user));
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
            onPressed: () => Navigator.of(context).pop()),
        title: const Text("Edit Profile",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _ProfileEditBloc,
          child: BlocListener<ProfileEditBloc, ProfileEditState>(
            listener: (context, state) {
              if (state is ProfileEditUpdatedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Home(
                            selectedIndex: 3,
                            profileUpdatedFlag: true,
                            feedbackAddedFlag: false)),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<ProfileEditBloc, ProfileEditState>(
              builder: (context, state) {
                if (state is ProfileEditInitialState ||
                    state is ProfileEditLoadingState) {
                  return _buildLoading();
                } else {
                  if (state is ProfileEditLoadedState) {
                    firstNameEditingController.text = state.user.firstName;
                    lastNameEditingController.text = state.user.lastName;
                    emailEditingController.text = state.user.email;
                    pincodeEditingController.text = state.user.pincode;
                  }
                  if (state is ProfileEditErrorState) {
                    firstNameError = state.firstNameErrorMessage;
                    lastNameError = state.lastNameErrorMessage;
                    emailError = state.emailErrorMessage;
                    pincodeError = state.pincodeErrorMessage;
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

  Widget _buildHome(BuildContext context, ProfileEditState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 10),
              BorderedTextField("First Name", firstNameEditingController,
                  autoFocus: true, errorMsg: firstNameError),
              const SizedBox(height: 20),
              BorderedTextField("Last Name", lastNameEditingController,
                  errorMsg: lastNameError),
              const SizedBox(height: 20),
              BorderedTextField("E-mail", emailEditingController,
                  errorMsg: emailError),
              const SizedBox(height: 20),
              BorderedTextField("Pin Code", pincodeEditingController,
                  textInputType: TextInputType.number, errorMsg: pincodeError),
              const SizedBox(height: 50),
              GradientButton(
                "Update Profile",
                () {
                  BlocProvider.of<ProfileEditBloc>(context).add(
                      ProfileEditSubmittedEvent(
                          firstNameEditingController.text,
                          lastNameEditingController.text,
                          emailEditingController.text,
                          pincodeEditingController.text));
                },
              )
            ]),
          )),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
