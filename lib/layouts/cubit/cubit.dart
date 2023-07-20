import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/message_data.dart';
import 'package:social_app_g/models/post_data.dart';
import 'package:social_app_g/models/user_data.dart';
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
    if(index == 2) {
      emit(SocialNewPostState());
      return;
    }
    if(index == 1) {
      getAllUsers();
    }
    screenIndex = index;
    emit(SocialChangeBottomNavigation());

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
  
  void uploadProfileImage() {
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadProfileImagePickedSuccessState());
        updateUser(name: currentUser!.name, bio: currentUser!.bio, image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImagePickedErrorState());
      });
    })
        .catchError((error) {
      emit(SocialUploadProfileImagePickedErrorState());
    });
  }
  
  void uploadCoverImage() {
    firebase_storage.FirebaseStorage.instance.ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImagePickedSuccessState());
        updateUser(name: currentUser!.name, bio: currentUser!.bio, cover: value);
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
    String? image,
    String? cover,
  }) {
    emit(SocialLoadingUpdateUserState());
    Map<String, dynamic> newData = currentUser!.toJson();
    
    if(image == null) {
      image = currentUser!.image;
    }
    if(cover == null) {
      cover = currentUser!.cover;
    }
    
    newData['image'] = image;
    newData['cover'] = cover;
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
      emit(SocialUpdateUserErrorState(error.toString()));
    });
  }

  File? postImage;

  Future<void> getPostImage() async {
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);

    if(pickedImage != null) {
      postImage = File(pickedImage.path);
      emit(SocialProfileImagePickedSuccessState());
    }
    else {
      print("No image is selected");
      emit(SocialProfileImagePickedErrorState());
    }
  }

  void uploadPostImage({
    required String dateTime,
    required String text,
  }) {
    emit(SocialCreatePostLoadingState());

    firebase_storage.FirebaseStorage.instance.ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(
            dateTime: dateTime,
            text: text,
            postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  void createNewPost({
    required String dateTime,
    required String text,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());
    PostData postData = PostData(
      uID: currentUser!.uID,
      name: currentUser!.name,
      image: currentUser!.image,
      dateTime: dateTime,
      text: text,
      postImage: postImage??"",
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(postData.toJson())
        .then((value) {
      emit(SocialCreatePostSuccessState());
      getPosts();
    })
        .catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  List<PostData> posts = [];
  List<String> postIDList = [];
  List<int> likes = [];

  void getPosts() {
    FirebaseFirestore.instance.
    collection('posts').
    get().
    then((value) {
      value.docs.forEach((element) {
        element.reference.
        collection('likes').
        get().
        then((value) {
          posts.add(PostData.fromJson(element.data()));
          postIDList.add(element.id);
          likes.add(value.docs.length);
          emit(SocialGetPostsSuccessState());
        }).
        catchError((error) {
          emit(SocialGetPostsErrorState(error.toString()));
        });
      });
      print("Get Posts Done");
      emit(SocialGetPostsSuccessState());
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  void likePost(String postID) {
    FirebaseFirestore.instance.
    collection('posts').
    doc(postID).
    collection('likes').
    doc(currentUser!.uID).
    set({
      'like': true,
    }).
    then((value) {
      emit(SocialLikePostSuccessState());
    }).
    catchError((error) {
      emit(SocialLikePostErrorState());
    });
  }

  void commentOnPost(String postID, String comment) {
    FirebaseFirestore.instance.
    collection('posts').
    doc(postID).
    collection('comments').
    add(
      {
        'name': currentUser!.name,
        'image': currentUser!.image,
        'comment': comment,
      }
    ).
    then((value) {
      emit(SocialCommentOnPostSuccessState());
      print("Commented successfully");
    }).
    catchError((error) {
      emit(SocialCommentOnPostErrorState());
      print(error.toString());
    });
  }

  List<Map<String, dynamic>> comments = [];

  Future<void> getComments(String postID) async {
   await FirebaseFirestore.instance.
    collection('posts').
    doc(postID).
    collection('comments').
    get().
    then((value) {
      comments = [];
      value.docs.forEach((element) {
        print(element.data());
        comments.add(element.data());
      });
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

  List<UserData> allUsers = [];

  void getAllUsers() {
    if(allUsers.isEmpty)
    FirebaseFirestore.instance.
    collection('users').
    get().
    then((value) {
      value.docs.forEach((element) {
        if(element.data()['uID'] != currentUser!.uID) {
          allUsers.add(UserData.fromJson(element.data()));
        }
      });
      print("Get Users Done");
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

  void sendMessage(String receiverUID, String dateTime, String text) {
    MessageData message = MessageData(
        senderUID: currentUser!.uID,
        receiverUID: receiverUID,
        dateTime: dateTime,
        text: text
    );

    FirebaseFirestore.instance.
    collection('users').
    doc(currentUser!.uID).
    collection('chats').
    doc(receiverUID).
    collection('messages').
    add(message.toJson()).then((value) {
      emit(SocialSendMessageSuccessState());
      print("Sent successfully");
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
  });

    FirebaseFirestore.instance.
    collection('users').
    doc(receiverUID).
    collection('chats').
    doc(currentUser!.uID).
    collection('messages').
    add(message.toJson()).then((value) {
      emit(SocialSendMessageSuccessState());
      print("Sent successfully");
    }).catchError((error) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageData> messages = [];

  void getMessages(String otherUserUID) {
    messages = [];
    FirebaseFirestore.instance.
    collection('users').
    doc(currentUser!.uID).
    collection('chats').
    doc(otherUserUID).
    collection('messages').
    snapshots(). 
    listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageData.fromJson(element.data()));
      }
      );
      sortMessages();
      emit(SocialReceiveMessagesSuccessState());
    });
  }

  //2023-07-20 17:16:05.626628
  void sortMessages() {
    List<DateTime> arnab = [];
    for(int i=0; i<messages.length; i++) {
      arnab.add(DateTime.parse(messages[i].dateTime));
    }

    for(int i=0; i<arnab.length; i++) {
      int min = i;
      for(int j=i; j<arnab.length; j++) {
        if(arnab[j].isBefore(arnab[i])) {
          min = j;
        }
      }
      DateTime tmp = arnab[i];
      arnab[i] = arnab[min];
      arnab[min] = tmp;

      MessageData tmp1 = messages[i];
      messages[i] = messages[min];
      messages[min] = tmp1;
    }

    print(messages);
  }
}