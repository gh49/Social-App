
abstract class LoginState {}

class LoginInitState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {
  String? error;

  LoginErrorState(String error) {
    if(error.contains("user-not-found")) {
      this.error = "Email address and/or password is incorrect. Please try again.";
    }
    else {
      this.error = error;
    }
  }
}

class ChangePasswordVisibilityState extends LoginState {}