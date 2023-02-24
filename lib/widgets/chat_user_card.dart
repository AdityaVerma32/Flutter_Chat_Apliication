import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../main.dart';

class ChatUserCard extends StatefulWidget {
  const ChatUserCard({super.key});

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
              leading: CircleAvatar(child: Icon(Icons.person)),
              title: Text("Welcome"),
              subtitle: Text("Come in"),
              trailing: Text(
                "12:00 PM",
                style: TextStyle(color: Colors.black54),
              ),
            )));
  }
}
