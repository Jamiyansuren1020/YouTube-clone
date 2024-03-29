import 'package:flutter/material.dart';
import '../data.dart';

class CustomSliverAppBar extends StatelessWidget {
  const CustomSliverAppBar({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
            floating: true,
            leadingWidth: 100,
            leading: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Image.asset('assets/youtube_logo.png'),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.cast)),
              IconButton(onPressed: () {}, icon: Icon(Icons.notifications_outlined)),
              IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              IconButton(onPressed: () {}, 
              iconSize: 40,
                                           icon: CircleAvatar(
                foregroundImage: NetworkImage(currentUser.profileImageUrl) ,
              )),
            ],
          );
  }
}