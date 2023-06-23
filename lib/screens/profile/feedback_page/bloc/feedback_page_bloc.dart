/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_event.dart';
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_state.dart';
import 'package:aabapay_app/screens/profile/feedback_page/bloc/feedback_page_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackPageBloc extends Bloc<FeedbackPageEvent, FeedbackPageState> {
  final FeedbackPageApi feedbackPageApi = FeedbackPageApi();

  FeedbackPageBloc() : super(FeedbackPageInitialState()) {
    on<FeedbackPageLoadEvent>((event, emit) async {
      emit(FeedbackPageLoadedState());
    });

    on<FeedbackPageSubmittedEvent>((event, emit) async {
      await feedbackPageApi
          .storeFeedback(event.feedback, event.rating)
          .then((value) {
        emit(FeedbackPageAddedState());
      });
    });
  }
}
