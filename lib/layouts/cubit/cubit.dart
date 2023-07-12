import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/UserData.dart';

import '../../shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());
  static SocialCubit get(context) => BlocProvider.of(context);

  UserData? currentUser;

  void getUser() {
    emit(SocialGetUserLoadingState());

    FirebaseFirestore.instance.collection("users").doc(uIDGlobal).get()
    .then((value) {
      currentUser = UserData.fromJson(value.data()!);
      print(currentUser.toString());
      print(FirebaseAuth.instance.currentUser!.emailVerified);
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
      print(error.toString());
    });
  }
}