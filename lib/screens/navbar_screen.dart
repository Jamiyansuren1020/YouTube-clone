import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_clone/screens/video_screen.dart';
import '../data.dart';
import 'home_screen.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  static const double _playerMinHeight = 60;

  int _selectedIndex = 0;

  final _screens = [
    const HomeScreen(),
    const Scaffold(body: Center(child: Text('Explore'))),
    const Scaffold(body: Center(child: Text('Add'))),
    const Scaffold(body: Center(child: Text('Subscriptions'))),
    const Scaffold(body: Center(child: Text('Library'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniPlayerController = watch(miniPlayerControllerProvider).state;
          return Stack(
              children: _screens
                  .asMap()
                  .map((index, screen) => MapEntry(
                        index,
                        Offstage(
                            offstage: _selectedIndex != index, child: screen),
                      ))
                  .values
                  .toList()
                ..add(Offstage(
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                      controller: miniPlayerController,
                      minHeight: _playerMinHeight,
                      maxHeight: MediaQuery.of(context).size.height,
                      builder: ((height, percentage) {
                        if (selectedVideo == null) {
                          return const SizedBox.shrink();
                        }
                        if(height <= _playerMinHeight +50){
                        return Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      selectedVideo.thumbnailUrl,
                                      height: _playerMinHeight - 4,
                                      width: 120,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                              child: Text(
                                            selectedVideo.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                          Flexible(
                                              child: Text(
                                            selectedVideo.author.username,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ))
                                        ],
                                      ),
                                    )),
                                    IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.play_arrow)),
                                    IconButton(
                                        onPressed: () {
                                          context
                                              .read(selectedVideoProvider)
                                              .state = null;
                                        },
                                        icon: const Icon(Icons.close)),
                                  ],
                                ),
                                const LinearProgressIndicator(
                                  value: 0.4,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                )
                              ],
                            ));}
                            return VideoScreen();
                      })),
                )));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          selectedFontSize: 10,
          unselectedFontSize: 10,
          onTap: (i) => setState(() {
                _selectedIndex = i;
              }),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined),
                activeIcon: Icon(Icons.explore),
                label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                activeIcon: Icon(Icons.add_circle),
                label: 'Add'),
            BottomNavigationBarItem(
                icon: Icon(Icons.subscriptions_outlined),
                activeIcon: Icon(Icons.subscriptions),
                label: 'Subscriptions'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined),
                activeIcon: Icon(Icons.video_library),
                label: 'Library')
          ]),
    );
  }
}
