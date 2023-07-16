abstract class SocialStates {}

class SocialInitState extends SocialStates {}

class SocialAfterInitState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  String error;

  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavigation extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class SocialProfileImagePickedSuccessState extends SocialStates {}

class SocialProfileImagePickedErrorState extends SocialStates {}

class SocialCoverImagePickedSuccessState extends SocialStates {}

class SocialCoverImagePickedErrorState extends SocialStates {}

class SocialUploadProfileImagePickedSuccessState extends SocialStates {}

class SocialUploadProfileImagePickedErrorState extends SocialStates {}

class SocialUploadCoverImagePickedSuccessState extends SocialStates {}

class SocialUploadCoverImagePickedErrorState extends SocialStates {}

class SocialUpdateUserErrorState extends SocialStates {}

class SocialLoadingUpdateUserState extends SocialStates {}