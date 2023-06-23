/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';
import 'package:aabapay_app/screens/home/home.dart';
import 'package:aabapay_app/widgets/buttons.dart';
import 'package:aabapay_app/widgets/text_fields.dart';
import 'package:flutter/material.dart';
import 'package:aabapay_app/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_bloc.dart';
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_state.dart';
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_event.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final FeedbackPageBloc _FeedbackPageBloc = FeedbackPageBloc();
  TextEditingController feedbackEditingController = TextEditingController();
  String feedbckError = '';
  String rating = "4";

  @override
  void initState() {
    _FeedbackPageBloc.add(FeedbackPageLoadEvent());
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
                      selectedIndex: 0,
                      profileUpdatedFlag: false,
                      feedbackAddedFlag: false)),
              (Route<dynamic> route) => false),
        ),
        title: const Text("Feedback",
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontSize: 20)),
      ),
      body: Container(
        margin: EdgeInsets.all(8.0),
        child: BlocProvider(
          create: (_) => _FeedbackPageBloc,
          child: BlocListener<FeedbackPageBloc, FeedbackPageState>(
            listener: (context, state) {
              if (state is FeedbackPageAddedState) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => Home(
                            selectedIndex: 3,
                            profileUpdatedFlag: false,
                            feedbackAddedFlag: true)),
                    (Route<dynamic> route) => false);
              }
            },
            child: BlocBuilder<FeedbackPageBloc, FeedbackPageState>(
              builder: (context, state) {
                if (state is FeedbackPageInitialState ||
                    state is FeedbackPageLoadingState) {
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

  Widget _buildHome(BuildContext context, FeedbackPageState state) {
    return SingleChildScrollView(
      child: SafeArea(
          bottom: true,
          top: true,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              const SizedBox(height: 30),
              RatingBar(
                initialRating: 4,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star,
                    color: darkPrimaryColor,
                  ),
                  half: Icon(
                    Icons.star_half,
                    color: darkPrimaryColor,
                  ),
                  empty: Icon(
                    Icons.star_border,
                    color: Theme.of(context).buttonColor,
                  ),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (value) {
                  setState(() {
                    rating = value.toString();
                  });
                },
              ),
              const SizedBox(height: 30),
              TextField(
                autofocus: true,
                controller: feedbackEditingController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, height: 0.8),
                cursorHeight: 18,
                cursorColor: darkPrimaryColor,
                decoration: InputDecoration(
                    hintStyle:
                        TextStyle(fontSize: 18.0, color: darkPrimaryColor),
                    hintText: 'Please enter your feedback',
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: darkPrimaryColor, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: darkPrimaryColor, width: 1.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: darkPrimaryColor, width: 1.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: darkPrimaryColor, width: 1.0),
                    ),
                    errorText: feedbckError == "" ? null : feedbckError),
                minLines: 10,
                maxLines: 10,
              ),
              const SizedBox(height: 30),
              GradientButton(
                "Submit Feedback",
                () {
                  BlocProvider.of<FeedbackPageBloc>(context).add(
                      FeedbackPageSubmittedEvent(
                          feedbackEditingController.text, rating));
                },
              )
            ]),
          )),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator());
}
