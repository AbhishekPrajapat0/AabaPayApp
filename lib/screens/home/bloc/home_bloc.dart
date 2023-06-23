/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/screens/home/bloc/home_event.dart';
import 'package:aabapay_app/screens/home/bloc/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState()) {
    on<HomeSlideEvent>((event, emit) async {});
  }
}
