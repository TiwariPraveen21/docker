// States
abstract class AuthState {}

class InitialState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String message;

  AuthSuccessState(this.message);
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}