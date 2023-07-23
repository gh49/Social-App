import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/post_data.dart';

class PostScreen extends StatelessWidget {
  final PostData postData;
  final int index;

  final TextEditingController commentCtrlr = TextEditingController();

  PostScreen({super.key,
    required this.postData,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    var cubit = SocialCubit.get(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {

        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage(postData.image),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                    postData.name
                                ),
                                const SizedBox(
                                  width: 5.0,
                                ),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.blue,
                                  size: 17,
                                ),
                              ],
                            ),
                            Text(
                              postData.dateTime,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert)
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300],
                    ),
                  ),
                  Text(
                    postData.text,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10.0,),
                  if(postData.postImage != null && postData.postImage!.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(postData.postImage!))
                      ),
                    ),
                  const SizedBox(height: 10.0,),
                  TextFormField(
                    controller: commentCtrlr,
                    keyboardType: TextInputType.multiline,

                    decoration: InputDecoration(
                      hintText: "Comment...",
                      focusColor: Colors.grey,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if(commentCtrlr.text.isEmpty) {
                            return;
                          }
                          SocialCubit.get(context).commentOnPost(SocialCubit.get(context).postIDList[index], commentCtrlr.text);
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))
                    ),
                  ),
                  const SizedBox(height: 15.0,),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cubit.comments.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> comment = cubit.comments[index];
                      return buildCommentItem(
                          context,
                          0,
                          comment['comment'],
                          comment['name'],
                          comment['image'],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 8.0,);
                    },
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildCommentItem(BuildContext context, int index, String comment, String name, String image) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18.0,
              backgroundImage: NetworkImage(image),
            ),
            const SizedBox(
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.blue,
                        size: 17,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5,),
                  Text(
                    comment,
                    style: const TextStyle(
                      fontSize: 13.0,
                    ),
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
