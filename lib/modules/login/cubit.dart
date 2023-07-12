import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/modules/login/states.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  IconData passwordSuffix = Icons.visibility_off_outlined;
  bool hidePassword = true;

  void changePasswordVisibility() {
    hidePassword = !hidePassword;
    passwordSuffix = hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password
  }) {
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      emit(LoginSuccessState(value.user!.uid));
      print("Success emitted");
    }).catchError((error) {
      emit(LoginErrorState(error.toString()));
    });
  }
}