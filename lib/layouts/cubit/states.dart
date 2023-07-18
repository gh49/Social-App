abstract class SocialStates {}

class SocialInitState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  String error;

  SocialGetPostsErrorState(this.error);
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

class SocialUpdateUserErrorState extends SocialStates {
  String error;

  SocialUpdateUserErrorState(this.error);
}

class SocialLoadingUpdateUserState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {
  String error;

  SocialCreatePostErrorState(this.error);
}

class SocialPostImagePickedSuccessState extends SocialStates {}

class SocialPostImagePickedErrorState extends SocialStates {}

class SocialRemovePostImageState extends SocialStates {}

class SocialLikePostSuccessState extends SocialStates {}

class SocialLikePostErrorState extends SocialStates {}

class SocialCommentOnPostSuccessState extends SocialStates {}

class SocialCommentOnPostErrorState extends SocialStates {}