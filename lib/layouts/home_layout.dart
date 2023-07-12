import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/modules/login/login_screen.dart';
import 'package:social_app_g/shared/components/components.dart';
import 'package:social_app_g/shared/components/constants.dart';
import 'package:social_app_g/shared/network/local/cache_helper.dart';

import '../models/UserData.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialGetUserErrorState) {
          navigateAndFinish(context, LoginScreen());
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Social App"),
        ),
        body: ConditionalBuilder(
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
      )
    );
  }
}
