import 'package:cloud_firestore/cloud_firestore.dart';
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
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }
}