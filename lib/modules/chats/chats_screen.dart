import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
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
                      Text(
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
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.symmetric(horizontal: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.0,
                        backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2GKFEBIQWx9fC7UARd8eXqklHE0ZpOSTk5A&usqp=CAU"),
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
                                    "Rick Grimes"
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.blue,
                                  size: 17,
                                ),
                              ],
                            ),
                            Text(
                              "April 16, 2023 at 2:00 pm",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 20.0,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert)
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
                    "Despite the darkness that consumed him, Negan taught me one invaluable lesson: The true test of a leader lies not in their ability to instill fear, but in their capacity to inspire hope even in the face of despair.",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage("https://www.looper.com/img/gallery/twd-season-9-left-a-negan-rick-scene-on-the-cutting-room-floor-and-rightfully-so/l-intro-1682966536.jpg"))
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
