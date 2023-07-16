import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/UserData.dart';
import 'package:social_app_g/modules/chats/chats_screen.dart';
import 'package:social_app_g/modules/feed/feed_screen.dart';
import 'package:social_app_g/modules/new_post/new_post_screen.dart';
import 'package:social_app_g/modules/settings/settings_screen.dart';
import 'package:social_app_g/modules/users/users_screen.dart';

import '../../shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitState());
  static SocialCubit get(context) => BlocProvider.of(context);

  UserData? currentUser;

  List<Widget> screens = [
    FeedScreen(),
    ChatsScreen(),
    NewPostScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = [
    "Feed",
    "Chats",
    "New Post",
    "Users",
    "Settings",
  ];

  int screenIndex = 0;

  void changeBottomNavigation(int index) {
    if(index == 2)
      emit(SocialNewPostNavigation());
    else {
      screenIndex = index;
      emit(SocialChangeBottomNavigation());
    }
  }

  void getUser() {
    emit(SocialGetUserLoadingState());
    if(FirebaseAuth.instance.currentUser == null) {
      emit(SocialGetUserErrorState(""));
      print("User is null");
      currentUser = null;
    }
    else
      FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).get()
      .then((value) {
        currentUser = UserData.fromJson(value.data()!);
        print(currentUser.toString());
        print(FirebaseAuth.instance.currentUser!.emailVerified);
        emit(SocialGetUserSuccessState());
      }).catchError((error) {
        emit(SocialGetUserErrorState(error.toString()));
        FirebaseAuth.instance.signOut();
        print(error.toString());
        currentUser = null;
      });
  }
}