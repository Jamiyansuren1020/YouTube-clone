import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_clone/data.dart';
import 'package:youtube_clone/screens/navbar_screen.dart';
import 'package:youtube_clone/widgets/widgets.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {

  ScrollController? _scrollToTopController;

  @override
  void initState() {
    super.initState();
    _scrollToTopController = ScrollController();
  }

  @override
  void dispose() {
    _scrollToTopController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
      .read(miniPlayerControllerProvider)
      .state
      .animateToHeight(state: PanelState.MAX),
      child: Scaffold(
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            controller: _scrollToTopController,
            shrinkWrap: true,
            slivers: [
              SliverToBoxAdapter(
                child: Consumer(builder: (context, watch, _) {
                  final selectedVideo = watch(selectedVideoProvider).state;
                  return SafeArea(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Image.network(
                              selectedVideo!.thumbnailUrl,
                              height: 220,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            IconButton(
                              onPressed: () {
                                context
                                    .read(miniPlayerControllerProvider)
                                    .state
                                    .animateToHeight(state: PanelState.MIN);
                              },
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                              ),
                              iconSize: 30,
                            )
                          ],
                        ),
                        const LinearProgressIndicator(
                          value: 0.4,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ),
                        VideoInfo(video: selectedVideo)
                      ],
                    ),
                  );
                }),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                final video = suggestedVideos[index];
                return VideoCard(
                video: video, 
                hasPadding: true,
                onTap: () => _scrollToTopController!.animateTo(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeIn
                ),
                );
              }, childCount: suggestedVideos.length))
            ],
          ),
        ),
      ),
    );
  }
}
