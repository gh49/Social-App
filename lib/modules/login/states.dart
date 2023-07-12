
abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String uID;

  LoginSuccessState(this.uID);
}

class LoginErrorState extends LoginState {
  String? error;

  LoginErrorState(String error) {
    if(error.contains("user-not-found") || error.contains("wrong-password")) {
      this.error = "Email address and/or password is incorrect. Please try again.";
    }
    else {
      this.error = error;
    }
  }
}

class ChangePasswordVisibilityState extends LoginState {}