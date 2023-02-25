import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_chat_app/Models/chat_user.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * 0.04, vertical: 4),
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: InkWell(
            onTap: () {},
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.width * 0.3),
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(child: Icon(Icons.error)),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(widget.user.about, maxLines: 1),
              trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(30)),
              ),
              /*  trailing: Text(
                "12:00 PM",
                style: TextStyle(color: Colors.black54),
              ), */
            )));
  }
}
