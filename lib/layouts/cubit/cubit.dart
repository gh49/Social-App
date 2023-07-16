import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
      emit(SocialNewPostState());
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

  void initSocial() {
    getUser();
    emit(SocialAfterInitState());
  }

  File? profileImage;
  File? coverImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null) {
      profileImage = File(pickedImage.path);
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      print("No image is selected");
      emit(SocialProfileImagePickedErrorState());
    }
  }

  Future<void> getCoverImage() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null) {
      coverImage = File(pickedImage.path);
      emit(SocialCoverImagePickedSuccessState());
    }
    else {
      print("No image is selected");
      emit(SocialCoverImagePickedErrorState());
    }
  }

  String? profileImageURL;

  void uploadProfileImage() {
    if(profileImage == null) {
      print("Can't upload empty profile image");
      return;
    }
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
          value.ref.getDownloadURL().then((value) {
            emit(SocialUploadProfileImagePickedSuccessState());
            print(value);
            profileImageURL = value;
          }).catchError((error) {
            emit(SocialUploadProfileImagePickedErrorState());
          });
        })
        .catchError((error) {
          emit(SocialUploadProfileImagePickedErrorState());
        });
  }

  String? coverImageURL;

  void uploadCoverImage() {
    if(coverImage == null) {
      print("Can't upload empty cover image");
      return;
    }
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImagePickedSuccessState());
        print(value);
        coverImageURL = value;
      }).catchError((error) {
        emit(SocialUploadCoverImagePickedErrorState());
      });
    })
        .catchError((error) {
      emit(SocialUploadCoverImagePickedErrorState());
    });
  }

  void updateUser({
    required String name,
    required String bio,
}) {
    emit(SocialLoadingUpdateUserState());
    Map<String, dynamic> newData = currentUser!.toJson();

    if(profileImage != null) {
      uploadProfileImage();
      newData['image'] = profileImageURL;
    }
    if(coverImage != null) {
      uploadCoverImage();
      newData['cover'] = coverImageURL;
    }

    print(profileImageURL);
    print(coverImageURL);

    newData['name'] = name;
    newData['bio'] = bio;

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uID)
        .update(newData)
        .then((value) {
          getUser();
        })
        .catchError((error) {
          emit(SocialUpdateUserErrorState());
        });
  }
}