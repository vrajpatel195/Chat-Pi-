import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatpi/main.dart';
import 'package:chatpi/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/chat_screen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: mq.width * .03, vertical: 4),
        color: Colors.blue.shade100,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: ListTile(
              //leading: CircleAvatar(child: Icon(CupertinoIcons.person)),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(mq.height * 0.3),
                child: CachedNetworkImage(
                  width: mq.height * .055,
                  height: mq.height * .055,
                  imageUrl: widget.user.image,
                  // placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(widget.user.about, maxLines: 1),
              trailing: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: Colors.greenAccent.shade700,
                    borderRadius: BorderRadius.circular(10)),
              )
              // trailing: Text(
              //   '12:00 PM',
              //   style: TextStyle(color: Colors.black54),
              // ),

              ),
        ));
  }
}
