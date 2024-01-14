import 'dart:convert';

import 'package:chatpi/api/api.dart';
import 'package:chatpi/main.dart';
import 'package:chatpi/models/chat_user.dart';
import 'package:chatpi/screens/profile_screen.dart';
import 'package:chatpi/widgets/chat_user_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];

  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: _isSearching
                ? TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Name, Email, ...'),
                    autofocus: true,
                    style: TextStyle(fontSize: 16, letterSpacing: 0.5),
                    onChanged: (val) {
                      _searchList.clear();

                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                  )
                : Text('Chat Pi'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: Icon(_isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                user: APIs.me,
                              )));
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 16, right: 8),
            child: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: Icon(Icons.add_comment_rounded),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  //if data is loading
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: CircularProgressIndicator());

                  //if some or all data is loaded then show it
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;

                      list = data
                              ?.map((e) => ChatUser.fromJson(e.data()))
                              .toList() ??
                          [];
                    }
                    if (list.isNotEmpty) {
                      return ListView.builder(
                          itemCount:
                              _isSearching ? _searchList.length : list.length,
                          padding: EdgeInsets.only(top: mq.height * 0.01),
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ChatUserCard(
                                user: _isSearching
                                    ? _searchList[index]
                                    : list[index]);
                            //return Text('Name: ${list[index]}');
                          });
                    } else {
                      return Center(
                          child: Text(
                        "No Connection found !!",
                        style: TextStyle(fontSize: 20),
                      ));
                    }
                }
              }),
        ),
      ),
    );
  }
}
