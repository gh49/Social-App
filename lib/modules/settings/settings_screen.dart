import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/UserData.dart';
import 'package:social_app_g/modules/edit_profile/edit_profile_screen.dart';
import 'package:social_app_g/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        UserData userData = SocialCubit.get(context).currentUser!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 180.0,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.0),
                              topRight: Radius.circular(4.0),
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(userData.cover))
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    CircleAvatar(
                      radius: 55.0,
                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(userData.image),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                userData.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                userData.bio,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              "231",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Posts",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              "5642",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Followers",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              "104",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              "Following",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        onTap: () {

                        },
                      ),
                    ),
                  ],
                ),
              ),
              MyButton(
                  text: "Edit Profile",
                  onPressed: () {
                    navigateTo(context, EditProfileScreen());
                  })
            ],
          ),
        );
      },
    );
  }
}
