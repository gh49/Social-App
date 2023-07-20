import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/message_data.dart';
import 'package:social_app_g/models/user_data.dart';
import 'package:social_app_g/shared/components/constants.dart';

class InChatScreen extends StatelessWidget {
  UserData otherUser;
  TextEditingController messageCtrlr = TextEditingController();
  InChatScreen({super.key, required this.otherUser});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(otherUser.uID);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {

          },
          builder: (context, state) {
            var cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(otherUser.image),
                    ),
                    SizedBox(width: 15.0,),
                    Text(
                        otherUser.name
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: cubit.messages.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15.0,);
                        },
                        itemBuilder: (context, index) {
                          MessageData message = cubit.messages[index];
                          if(message.senderUID == cubit.currentUser!.uID) {
                            return buildMessageItem(message, true);
                          }
                          return buildMessageItem(message, false);
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: messageCtrlr,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  cubit.sendMessage(
                                    otherUser.uID,
                                    DateTime.now().toString(),
                                    messageCtrlr.text,
                                  );
                                  messageCtrlr.text = "";
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(35.0)),
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }
    );
  }

  Widget buildMessageItem(MessageData message, bool isCurrentUser) {
    Map<String, dynamic> currentUserMessageSettings = {
      'alignment': AlignmentDirectional.centerEnd,
      'color': Colors.blue.withOpacity(0.8),
      'borderRadius': BorderRadiusDirectional.only(
        bottomStart: Radius.circular(10.0),
        topStart: Radius.circular(10.0),
        topEnd: Radius.circular(10.0),
      ),
    };
    Map<String, dynamic> otherUserMessageSettings = {
      'alignment': AlignmentDirectional.centerStart,
      'color': Colors.grey[300],
      'borderRadius': BorderRadiusDirectional.only(
        bottomEnd: Radius.circular(10.0),
        topStart: Radius.circular(10.0),
        topEnd: Radius.circular(10.0),
      ),
    };
    Map<String, dynamic> userMessageSettings;
    if(isCurrentUser)
      userMessageSettings = currentUserMessageSettings;
    else
      userMessageSettings = otherUserMessageSettings;

    return Align(
      alignment: userMessageSettings['alignment'],
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: userMessageSettings['color'],
          borderRadius: userMessageSettings['borderRadius'],
        ),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  // Widget buildCurrentUserMessageItem() {
  //   return Align(
  //     alignment: AlignmentDirectional.centerEnd,
  //     child: Container(
  //       padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
  //       decoration: BoxDecoration(
  //         color: Colors.blue.withOpacity(0.8),
  //         borderRadius: BorderRadiusDirectional.only(
  //           bottomStart: Radius.circular(10.0),
  //           topStart: Radius.circular(10.0),
  //           topEnd: Radius.circular(10.0),
  //         ),
  //       ),
  //       child: Text(
  //         "Hello, I'm rick",
  //         style: TextStyle(
  //           fontSize: 20.0,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
