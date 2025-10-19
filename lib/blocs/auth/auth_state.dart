abstract class AuthState {
  final String message;
  AuthState({this.message = ""});
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess({String message = "Success"}) : super(message: message);
}

class AuthFailure extends AuthState {
  AuthFailure({required String message}) : super(message: message);
}