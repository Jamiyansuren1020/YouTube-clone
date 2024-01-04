import 'package:flutter/material.dart';
import 'package:youtube_clone/data.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoInfo extends StatelessWidget {
  final Video video;
  const VideoInfo({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.title,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${video.viewCount} views \u2022 ${timeago.format(video.timestamp)}',
            style:
                Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),
          ),
          const Divider(),
          _ActionsRow(video: video),
          const Divider(),
          _AuthorInfo(user: video.author),
          const Divider()
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final Video video;
  const _ActionsRow({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildAction(context, Icons.thumb_up_outlined, video.likes),
        _buildAction(context, Icons.thumb_down_outlined, video.dislikes),
        _buildAction(context, Icons.reply_outlined, 'Share'),
        _buildAction(context, Icons.download_outlined, 'Download'),
        _buildAction(context, Icons.library_add_outlined, 'Save'),
      ],
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
        onTap: () {},
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon),
            const SizedBox(
              height: 6,
            ),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Colors.white),
            )
          ],
        ));
  }
}

class _AuthorInfo extends StatefulWidget {
  final User user;

  const _AuthorInfo({Key? key, required this.user}) : super(key: key);

  @override
  State<_AuthorInfo> createState() => _AuthorInfoState();
}

class _AuthorInfoState extends State<_AuthorInfo> {
  bool subscribed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          foregroundImage: NetworkImage(widget.user.profileImageUrl),
        ),
        const SizedBox(width: 8),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
                child: Text(
              widget.user.username,
              overflow: TextOverflow.ellipsis,
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 15),
            )),
            Flexible(
                child: Text('${widget.user.subscribers} Subscribers',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontSize: 14)))
          ],
        )
        ),
        TextButton(
          onPressed: () {
            setState(() {
              subscribed = !subscribed;
            },);
          },
          child: Text(subscribed ? 'SUBSCRIBE' : 'SUBSCRIBED', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),))
      ],
    );
  }
}
