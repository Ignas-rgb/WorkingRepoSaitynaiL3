import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/open_post/open_post_secondary.dart';
import 'package:saitynai_front/post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saitynai_front/see_posts_dashboard.dart';
import 'package:saitynai_front/user.dart';
import 'package:http/http.dart' as http;

class MyDesktopPosts extends StatefulWidget {
  List<Post> posts;
  String user;
  String role;
  String auth;
  String userId;
  MyDesktopPosts(
      {Key? key,
      required this.posts,
      required this.user,
      required this.role,
      required this.auth,
      required this.userId})
      : super(key: key);

  @override
  State<MyDesktopPosts> createState() => _MyDesktopPostsState();
}

List<Post> getUserPosts(List<Post> posts, String owner) {
  List<Post> usrPsts = [];
  int j = 0;
  for (var i = 0; i < posts.length; i++) {
    if (posts[i].owner == owner) {
      usrPsts.add(posts[i]);
      j++;
    }
  }
  if (j == 0) {
    usrPsts.add(Post(id: '_0_', text: '', v: 0, owner: ''));
    return usrPsts;
  } else {
    return usrPsts;
  }
}

class _MyDesktopPostsState extends State<MyDesktopPosts> {
  Post newPost = Post(id: '', text: '', v: 0, owner: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 153, 255, 0),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int a) {
          if (a == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Dashboard(id: widget.userId, authToken: widget.auth)));
          }
        },
        backgroundColor: Color.fromRGBO(0, 153, 255, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add, color: Color.fromRGBO(0, 0, 0, 0)),
            label: " ",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add, color: Color.fromRGBO(0, 0, 0, 0)),
            label: " ",
          ),
        ],
      ),
      appBar: AppBar(
          foregroundColor: Color.fromRGBO(237, 240, 242, 0),
          backgroundColor: Color.fromRGBO(0, 153, 255, 0),
          shadowColor: Color.fromRGBO(0, 153, 255, 0.0),
          toolbarHeight: 120,
          flexibleSpace: Stack(children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: SvgPicture.asset(
                  'top.svg',
                  fit: BoxFit.fill,
                )),
            Positioned(
                left: 20,
                top: 40,
                child: Container(
                  height: 80,
                  width: 280,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 224, 247, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      "YOUR POSTS",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 45,
                          color: Colors.black),
                    ),
                  ),
                )),
            widget.role == 'admin'
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'twitter-logo-new.svg',
                          height: 80,
                          color: const Color.fromRGBO(55, 45, 155, 1),
                          alignment: Alignment.center,
                        ),
                        Text(
                          " ADMIN",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'twitter-logo-new.svg',
                          height: 90,
                          color: const Color.fromRGBO(55, 45, 155, 1),
                          alignment: Alignment.center,
                        ),
                        Text(
                          "EXPANDED ",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.aBeeZee(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: const Color.fromRGBO(55, 45, 155, 1)),
                        ),
                      ],
                    ),
                  ),
            getHeaderRow(widget.user)
          ])),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // First column

            Expanded(
              child: ListView.builder(
                itemCount: getUserPosts(widget.posts, widget.user).length,
                itemBuilder: (context, index) {
                  return getUserPosts(widget.posts, widget.user)[0].id != '_0_'
                      ? getPostWindow(
                          getUserPosts(widget.posts, widget.user)[index],
                          widget.auth)
                      : const Text('No Posts',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 50));
                },
              ),
            ),

            // second column
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 185,
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(188, 224, 247, 1),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      'twitter-logo-new.svg',
                      height: 40,
                      alignment: Alignment.center,
                    ),
                    const Divider(height: 20, color: Colors.white),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Dashboard(
                                      id: widget.userId,
                                      authToken: widget.auth)));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromRGBO(188, 224, 247, 1),
                          onPrimary: Color.fromRGBO(255, 255, 255, 1),
                          shadowColor: Color.fromRGBO(255, 255, 255, 0),
                          onSurface: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(
                              indent: 15,
                            ),
                            const Icon(Icons.home,
                                size: 30, color: Colors.blue),
                            const Divider(
                              indent: 35,
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Home",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black),
                                )),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding getHeaderRow(String name) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              height: 50,
              width: 250,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(55, 45, 155, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  name.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.encodeSans(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                    color: const Color.fromRGBO(188, 224, 247, 0.9),
                  ),
                ),
              ),
            ),
            const Divider(
              indent: 20,
            )
          ],
        ));
  }

  Future deletePost(Post post, String auth) async {
    String id = post.id;
    String idMod = id.replaceAll(' ', '');
    var url = 'http://localhost:4000/api/posts/' + idMod;
    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text(
                  response.body,
                  textAlign: TextAlign.center,
                ),
                content: const Text(''),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Close", textAlign: TextAlign.center),
                    onPressed: () => Navigator.pop(context),
                  )),
                ],
              ),
          context: context);
      throw Exception(['failed', response.body]);
    }
  }

  Future editPost(Post editedText, String auth, Post post) async {
    String id = post.id;
    String idMod = id.replaceAll(' ', '');
    var url = 'http://localhost:4000/api/posts/' + idMod;
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
      body: jsonEncode(<String, String>{'text': editedText.text}),
    );

    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'Post edited successfully',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Continue", textAlign: TextAlign.center),
                    onPressed: () => {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostsDashboard(
                                    id: widget.userId, authToken: auth)));
                      })
                    },
                  )),
                ],
              ),
          context: context);
      return 'Success';
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                title: Text(
                  response.body,
                  textAlign: TextAlign.center,
                ),
                content: const Text(''),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Close", textAlign: TextAlign.center),
                    onPressed: () => Navigator.pop(context),
                  )),
                ],
              ),
          context: context);
      throw Exception(['failed', response.body]);
    }
  }

  Padding getPostWindow(Post post, String auth) {
    Post editingPost = Post(id: '', text: '', date: '', v: 0, owner: '');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(188, 224, 247, 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 280,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Container(
              color: const Color.fromRGBO(205, 232, 250, 1),
              child: Column(
                children: [
                  Container(
                      height: 170,
                      color: const Color.fromRGBO(220, 235, 245, 1),
                      child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: [
                            Center(
                              child: SvgPicture.asset(
                                'twitter-logo-new.svg',
                                height: 150,
                                color: const Color.fromRGBO(1, 1, 1, 0.1),
                              ),
                            ),
                            Positioned(
                              right: 20,
                              child: SizedBox(
                                width: 80,
                                child: Text(
                                  'Posted on: ' +
                                      post.date!.substring(0, 10) +
                                      '     ' +
                                      post.date!.substring(11, 16),
                                  style: GoogleFonts.encodeSans(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                              child: Text(
                                post.text,
                                style: GoogleFonts.encodeSans(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 40,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ])),
                  const Divider(
                    height: 10,
                    color: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 50,
                          child: SizedBox(
                            height: 30,
                            width: 108,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.green,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16)))),
                                onPressed: () {
                                  showDialog(
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Enter new post text!',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Column(children: [
                                              Container(
                                                width: 400,
                                                child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              editingPost.text),
                                                  onChanged: (value) {
                                                    editingPost.text = value;
                                                  },
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Enter something';
                                                    }
                                                    return null;
                                                  },
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                      icon: const Icon(
                                                        Icons.text_fields,
                                                        color: Colors.blue,
                                                      ),
                                                      hintText: 'Craft post',
                                                      enabledBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16),
                                                          borderSide: const BorderSide(
                                                              color:
                                                                  Colors.blue)),
                                                      focusedBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16),
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .blue)),
                                                      errorBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  16),
                                                          borderSide: const BorderSide(
                                                              color:
                                                                  Colors.red)),
                                                      focusedErrorBorder: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(16),
                                                          borderSide: const BorderSide(color: Colors.red))),
                                                ),
                                              ),
                                            ]),
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        55, 16, 16, 0),
                                                child: SizedBox(
                                                  height: 50,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          primary: Colors.blue,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0))),
                                                      onPressed: () {
                                                        editPost(editingPost,
                                                            widget.auth, post);
                                                      },
                                                      child: const Text(
                                                        "Edit post!",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                      context: context);
                                },
                                child: const Text(
                                  "Edit post",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14),
                                )),
                          )),
                      const Divider(
                        indent: 25,
                      ),
                      SizedBox(
                          height: 50,
                          child: SizedBox(
                            height: 30,
                            width: 108,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0))),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OpenPostSecondary(
                                                  id: post.id,
                                                  text: post.text,
                                                  auth: widget.auth,
                                                  owner: post.owner,
                                                  date: post.date!,
                                                  userId: widget.userId)));
                                },
                                child: const Text(
                                  "Open post",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                )),
                          )),
                      const Divider(
                        indent: 25,
                      ),
                      SizedBox(
                          height: 50,
                          child: SizedBox(
                            height: 30,
                            width: 108,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0))),
                                onPressed: () {
                                  showDialog(
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                              'Are you sure?',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: const Text(
                                              'Deletion is not reversible!',
                                              textAlign: TextAlign.center,
                                            ),
                                            actions: [
                                              Center(
                                                  child: ElevatedButton(
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                  textAlign: TextAlign.center,
                                                ),
                                                onPressed: () {
                                                  deletePost(post, auth);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PostsDashboard(
                                                                  id: widget
                                                                      .userId,
                                                                  authToken: widget
                                                                      .auth)));
                                                },
                                              )),
                                            ],
                                          ),
                                      context: context);
                                },
                                child: const Text(
                                  "Remove post",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12),
                                )),
                          )),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    color: Color.fromRGBO(0, 0, 0, 0),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
