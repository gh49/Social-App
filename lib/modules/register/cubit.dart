import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/models/UserData.dart';
import 'package:social_app_g/modules/register/states.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  IconData passwordSuffix = Icons.visibility_off_outlined;
  bool hidePassword = true;

  void changePasswordVisibility() {
    hidePassword = !hidePassword;
    passwordSuffix = hidePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(ChangePasswordVisibilityState());
  }

  void userRegister({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    ).then((value) {
      emit(RegisterSuccessState());
      userCreate(
          uID: value.user!.uid,
          email: email,
          name: name,
          phoneNumber: phoneNumber,
      );
    }).catchError((error) {
      emit(RegisterErrorState(error));
    });
  }

  void userCreate({
    required String uID,
    required String email,
    required String name,
    required String phoneNumber,
  }) {
    UserData user = UserData(
        uID: uID,
        email: email,
        name: name,
        phoneNumber: phoneNumber
    );

    FirebaseFirestore.instance.
    collection("users").doc("uID").
    set(user.toJson()).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
}