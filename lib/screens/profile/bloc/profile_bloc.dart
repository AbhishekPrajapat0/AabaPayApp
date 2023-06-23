/* Tushar Ugale * Technicul.com */
import 'package:aabapay_app/models/user.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_event.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_state.dart';
import 'package:aabapay_app/screens/profile/bloc/profile_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileApi profileApi = ProfileApi();

  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileLoadEvent>((event, emit) async {
      await profileApi.getUserInfo().then((value) {
        User user = User.fromJson(value);
        emit(ProfileLoadedState(user));
      });
    });

    on<ProfileDeleteEvent>((event, emit) async {
      await profileApi.deleteAccount().then((value) async {
        if (value['message'].toString().toLowerCase() ==
            'User Deleted successfully'.toLowerCase()) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('accessToken', '');
          prefs.setString('mpin', '');
          emit(ProfileAccountDeletedState());
        }
      });
    });
  }
}
