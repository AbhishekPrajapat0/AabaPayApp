/* Tushar Ugale * Technicul.com */
abstract class ConfirmMpinState {}

class ConfirmMpinInitialState extends ConfirmMpinState {}

class ConfirmMpinValidState extends ConfirmMpinState {}

class ConfirmMpinErrorState extends ConfirmMpinState {
  final String mpinError;
  ConfirmMpinErrorState(this.mpinError);
}

class ConfirmMpinLoadingState extends ConfirmMpinState {}
