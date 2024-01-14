import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatpi/api/api.dart';
import 'package:chatpi/helper/dialog.dart';
import 'package:chatpi/main.dart';
import 'package:chatpi/models/chat_user.dart';
import 'package:chatpi/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title: const Text('Profile'),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
          floatingActionButton: Padding(
            padding: EdgeInsets.only(bottom: 16, right: 8),
            child: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () async {
                Dialogs.showProgressbar(context);
                await APIs.auth.signOut().then((value) async {
                  await GoogleSignIn().signOut().then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  });
                });
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
            ),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: mq.width,
                      height: mq.height * .03,
                    ),
                    Stack(
                      children: [
                        _image != null
                            ? ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.3),
                                child: Image.file(File(_image!),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * 0.3),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  // placeholder: (context, url) => CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: CircleBorder(),
                            color: Colors.white,
                            child: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: mq.height * .03,
                    ),
                    Text(
                      widget.user.email,
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field!',
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'ex. Vraj Patel',
                          label: Text('Name')),
                    ),
                    SizedBox(
                      height: mq.height * .02,
                    ),
                    TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? "",
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Required Field!',
                      decoration: InputDecoration(
                          prefixIcon:
                              Icon(Icons.info_outline, color: Colors.blue),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'ex. Feeling Happy',
                          label: Text('About')),
                    ),
                    SizedBox(
                      height: mq.height * .05,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: StadiumBorder(),
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Profile Updated Successfully!');
                          });
                        }
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 28,
                      ),
                      label: Text(
                        'UPDATE',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .05),
            children: [
              Text('Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //Pick for gallery button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          print(
                              'image path: ${image.path} -- MimeType: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/gallery.png')),

                  //Pick for Camera button
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(mq.width * .3, mq.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
// Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          print('image path: ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset('assets/camera.png'))
                ],
              )
            ],
          );
        });
  }
}
