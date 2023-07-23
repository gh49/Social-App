import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_broken/icon_broken.dart';
import 'package:social_app_g/layouts/cubit/cubit.dart';
import 'package:social_app_g/layouts/cubit/states.dart';
import 'package:social_app_g/models/post_data.dart';
import 'package:social_app_g/modules/post_view/post_screen.dart';
import 'package:social_app_g/shared/components/components.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {

      },
      builder:  (context, state) {
        return ConditionalBuilder(
            condition: SocialCubit.get(context).posts.isNotEmpty && SocialCubit.get(context).currentUser != null,
            builder: (context) => Column(
              children: [
                Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  elevation: 10.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomStart,
                    children: [
                      const Image(
                        image: NetworkImage("https://s.abcnews.com/images/Entertainment/HT-negan-walking-dead-jef-161026_4x3_992.jpg"),
                        fit: BoxFit.cover,
                        height: 300.0,
                        width: double.infinity,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Text(
                              "Connect with the world!",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 30.0,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 5
                                  ..color = Colors.black,
                              ),
                            ),
                            const Text(
                              "Connect with the world!",
                              style: TextStyle(
                                //color: Colors.white,
                                fontSize: 30.0,
                                letterSpacing: 5,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: SocialCubit.get(context).posts.length,
                  itemBuilder: (context, index) {
                    return buildPostItem(context, index, SocialCubit.get(context).posts[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10.0,);
                  },
                ),
              ],
            ),
            fallback: (context) => const Column(
              children: [
                SizedBox(height: 300,),
                Center(child: CircularProgressIndicator(),)
              ],
            )
        );
      },
    );
  }

  Widget buildPostItem(BuildContext context, int index, PostData postData) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            Row(
              children: [
                InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                        ),
                        Text(SocialCubit.get(context).likes[index].toString()),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {

                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          IconBroken.Chat,
                          color: Colors.brown,
                        ),
                        Text("0"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
            ),
            Row(
              children: [
                CircleAvatar(
                  radius: 17.0,
                  backgroundImage: NetworkImage(SocialCubit.get(context).currentUser!.image),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                TextButton(
                  child: const Text("Write a comment..."),
                  onPressed: () {
                    SocialCubit.get(context).getComments(SocialCubit.get(context).postIDList[index]).then((value) {
                      navigateTo(context, PostScreen(postData: postData, index: index,));
                    });
                  },
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      SocialCubit.get(context).likePost(SocialCubit.get(context).postIDList[index]);
                    },
                    icon: const Icon(
                      IconBroken.Heart,
                      color: Colors.red,
                      size: 30.0,)
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
