import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/modules/login/login_screen.dart';
import 'package:social_app_g/modules/new_post/new_post_screen.dart';
import 'package:social_app_g/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        print(state.toString());
        if(state is SocialInitState) {
          SocialCubit.get(context).initSocial();
        }
        if(state is SocialGetUserErrorState) {
          navigateAndFinish(context, LoginScreen());
          print(state.error.toString());
        }
        if(state is SocialNewPostState) {
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text(cubit.titles[cubit.screenIndex]),
            actions: [
              IconButton(
                  onPressed: (){
                  },
                  icon: Icon(IconBroken.Search)
              ),
              IconButton(
                  onPressed: (){
                  },
                  icon: Icon(IconBroken.Notification)
              ),
              IconButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut().then((value) {
                      navigateAndFinish(context, LoginScreen());
                    }).catchError((error) {
                      navigateAndFinish(context, LoginScreen());
                    });
                  },
                  icon: Icon(IconBroken.Logout)
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.screenIndex,
            onTap: (int index) {
              cubit.changeBottomNavigation(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(IconBroken.Home), label: ""),
              BottomNavigationBarItem(icon: Icon(IconBroken.Chat), label: ""),
              BottomNavigationBarItem(icon: Icon(IconBroken.Upload), label: ""),
              BottomNavigationBarItem(icon: Icon(IconBroken.User), label: ""),
              BottomNavigationBarItem(icon: Icon(IconBroken.Setting), label: ""),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ConditionalBuilder(
                  condition: SocialCubit.get(context).currentUser != null,
                  builder: (context) {
                    print("${FirebaseAuth.instance.currentUser!.email}: ${FirebaseAuth.instance.currentUser!.emailVerified}");
                    return Column(
                      children: [
                        if(!(FirebaseAuth.instance.currentUser!.emailVerified))
                          Container(
                            height: 40.0,
                            color: Colors.yellow.withOpacity(0.7),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Icon(
                                    Icons.info,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    "Please verify your account",
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                MyTextButton(
                                    text: "Request Verification",
                                    onPressed: () {
                                      FirebaseAuth.instance.currentUser!.sendEmailVerification()
                                          .then((value) {
                                        ShowToast(text: "Verification email sent successfully", state: ToastStates.SUCCESS, context: context);
                                      }).catchError((error) {
                                        print(error.toString());
                                      });
                                    })
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  fallback: (context) => Center(child: CircularProgressIndicator()),
                ),
                cubit.screens[cubit.screenIndex],
              ],
            ),
          ),
        );
      }
    );
  }
}
