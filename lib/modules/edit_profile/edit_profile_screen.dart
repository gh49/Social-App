import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/UserData.dart';
import 'package:social_app_g/shared/components/components.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  TextEditingController nameCtrlr = TextEditingController();
  TextEditingController bioCtrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          UserData userData = SocialCubit.get(context).currentUser!;
          File? newProfileImage = SocialCubit.get(context).profileImage;
          File? newCoverImage = SocialCubit.get(context).coverImage;

          nameCtrlr.text = userData.name;
          bioCtrlr.text = userData.bio;

          return Scaffold(
            appBar: AppBar(
              title: Text("Edit Profile"),
              actions: [
                TextButton(
                    onPressed: () {
                      SocialCubit.get(context).updateUser(
                          name: nameCtrlr.text,
                          bio: bioCtrlr.text,
                      );
                    },
                    child: Text(
                      "SAVE",
                    )),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is SocialLoadingUpdateUserState)
                    LinearProgressIndicator(),
                  SizedBox(height: 10.0,),
                  Container(
                    height: 180.0,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: ((newCoverImage == null) ? NetworkImage(userData.cover) : FileImage(newCoverImage)) as ImageProvider)
                                ),
                              ),
                              IconButton(
                                icon: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.edit, size: 20.0,),
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                              ),
                            ],
                          ),
                          alignment: Alignment.topCenter,
                        ),
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 55.0,
                              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundImage: ((newProfileImage == null) ? NetworkImage(userData.image) : FileImage(newProfileImage)) as ImageProvider
                              ),
                            ),
                            IconButton(

                              icon: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(Icons.edit, size: 20.0,),
                              ),
                              onPressed: () {
                                SocialCubit.get(context).getProfileImage();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Row(
                    children: [
                      if(SocialCubit.get(context).profileImage != null)
                        Expanded(
                          child: MyButton(
                              text: "Upload Profile",
                              height: 40.0,
                              onPressed: () {
                                SocialCubit.get(context).uploadProfileImage();
                              }
                          )
                      ),
                      SizedBox(width: 10,),
                      if(SocialCubit.get(context).coverImage != null)
                        Expanded(
                          child: MyButton(
                              text: "Upload Cover",
                              height: 40.0,
                              onPressed: () {
                                SocialCubit.get(context).uploadCoverImage();
                              }
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0,),
                  MyTFF(
                    controller: nameCtrlr,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icon(Icons.person),
                    labelText: "Name",
                    validator: (value) {

                    }
                  ),
                  SizedBox(height: 20.0,),
                  MyTFF(
                      controller: bioCtrlr,
                      prefixIcon: Icon(Icons.info_outline),
                      labelText: "Bio",
                      validator: (value) {

                      }
                  ),
                ],
              ),
            ),
          );
        });
  }
}
