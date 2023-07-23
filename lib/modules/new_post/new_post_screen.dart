import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';

class NewPostScreen extends StatelessWidget {
  NewPostScreen({super.key});

  final TextEditingController textCtrlr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        actions: [
          TextButton(
              onPressed: () {
                String dateTime = DateTime.now().toString();

                if(SocialCubit.get(context).postImage != null) {
                  SocialCubit.get(context).uploadPostImage(
                      dateTime: dateTime,
                      text: textCtrlr.text,
                  );
                }
                else {
                  SocialCubit.get(context).createNewPost(
                      dateTime: dateTime,
                      text: textCtrlr.text
                  );
                }
              },
              child: const Text(
                "POST",
              )),
        ],
      ),
      body: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is SocialCreatePostLoadingState)
                  const LinearProgressIndicator(),
                if(state is SocialCreatePostLoadingState)
                  const SizedBox(height: 20.0,),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.0,
                      backgroundImage: NetworkImage(SocialCubit.get(context).currentUser!.image),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Text(
                          SocialCubit.get(context).currentUser!.name
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    controller: textCtrlr,
                    keyboardType: TextInputType.multiline,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "What's in your mind",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if(SocialCubit.get(context).postImage != null)
                  Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(SocialCubit.get(context).postImage!),
                          )
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.highlight_remove_outlined, size: 40.0,),
                      color: Colors.red,
                      onPressed: () {
                        SocialCubit.get(context).removePostImage();
                      },
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      SocialCubit.get(context).getPostImage();
                    }, 
                    child: const Row(
                      children: [
                        Icon(IconBroken.Image_2),
                        SizedBox(width: 5.0,),
                        Text("Add photo"),
                      ],
                    )
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
