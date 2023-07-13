abstract class SocialStates {}

class SocialInitState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  String error;

  SocialGetUserErrorState(this.error);
}

class SocialChangeBottomNavigation extends SocialStates {}