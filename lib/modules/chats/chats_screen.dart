import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/user_data.dart';
import 'package:social_app_g/modules/chats/in_chat_screen.dart';
import 'package:social_app_g/shared/components/components.dart';
import 'package:social_app_g/shared/components/constants.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return ConditionalBuilder(
            condition: cubit.allUsers.length > 0,
            builder: (context) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cubit.allUsers.length,
                itemBuilder: (context, index) {
                  UserData otherUser = cubit.allUsers[index];
                  return buildChatItem(context, otherUser);
                },
                separatorBuilder: (context, index) {
                  return myDivider();
                },
              );
            },
            fallback: (context) {
              return Center(child: CircularProgressIndicator(),);
            }
        );
      },
    );
  }

  Widget buildChatItem (BuildContext context, UserData otherUser) {
    String name = otherUser.name;
    String image = otherUser.image;
    return InkWell(
      onTap: () {
        navigateTo(context, InChatScreen(otherUser: otherUser));
      },
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(image),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 20.0
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
