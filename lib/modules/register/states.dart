abstract class RegisterState {}

class RegisterInitState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterSuccessState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  String error;

  RegisterErrorState(this.error);
}

class CreateUserSuccessState extends RegisterState {}

class CreateUserErrorState extends RegisterState {
  String error;

  CreateUserErrorState(this.error);
}

class ChangePasswordVisibilityState extends RegisterState {}