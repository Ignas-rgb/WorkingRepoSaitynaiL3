import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saitynai_front/admin_responsive/admin_panel.dart';
import 'package:saitynai_front/comment.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/open_post/open_post_main.dart';
import 'package:saitynai_front/post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saitynai_front/responsive/mobile_body.dart';
import 'package:saitynai_front/see_posts_dashboard.dart';
import 'package:saitynai_front/signin.dart';
import 'package:saitynai_front/user.dart';
import 'package:http/http.dart' as http;

class MyDesktopBody extends StatefulWidget {
  List<Post> posts;
  String user;
  String role;
  String auth;
  String userId;
  MyDesktopBody(
      {Key? key,
      required this.posts,
      required this.user,
      required this.role,
      required this.auth,
      required this.userId})
      : super(key: key);

  @override
  State<MyDesktopBody> createState() => _MyDesktopBodyState();
}

class _MyDesktopBodyState extends State<MyDesktopBody> {
  List<Comment> _comments = [];

  Future<Post> postNewPost(String text, String user, String auth) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/api/posts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
      body: jsonEncode(<String, String>{'text': text, 'owner': user}),
    );
    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'Post created successfully',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Continue browsing",
                        textAlign: TextAlign.center),
                    onPressed: () => {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Dashboard(
                                    id: widget.userId, authToken: auth)));
                      })
                    },
                  )),
                ],
              ),
          context: context);
      return Post.fromJson(jsonDecode(response.body));
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Invalid post',
                  textAlign: TextAlign.center,
                ),
                content: Text('Error code: ' + response.body),
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

  Post newPost = Post(id: '', text: '', v: 0, owner: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 153, 255, 0),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int a) {
          if (a == 0) {
            showDialog(
                builder: (context) => AlertDialog(
                      title: const Text(
                        'Craft your post!',
                        textAlign: TextAlign.center,
                      ),
                      content: Column(children: [
                        Container(
                          width: 400,
                          child: TextFormField(
                            controller:
                                TextEditingController(text: newPost.text),
                            onChanged: (value) {
                              newPost.text = value;
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
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.blue)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.blue)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red))),
                          ),
                        ),
                      ]),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(55, 16, 16, 0),
                          child: SizedBox(
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0))),
                                onPressed: () {
                                  postNewPost(
                                      newPost.text, widget.user, widget.auth);
                                },
                                child: const Text(
                                  "Post!",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                )),
                          ),
                        ),
                      ],
                    ),
                context: context);
          } else if (a == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostsDashboard(
                        id: widget.userId, authToken: widget.auth)));
          }
        },
        backgroundColor: Color.fromRGBO(0, 153, 255, 1),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.post_add,
              color: Colors.black,
            ),
            label: "Create new post",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.receipt_long,
              color: Colors.black,
            ),
            label: "Your posts",
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
                itemCount: widget.posts.length,
                itemBuilder: (context, index) {
                  return getPostWindow(
                      widget.posts[index].id,
                      widget.posts[index].text,
                      widget.posts[index].owner,
                      widget.posts[index].date!);
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
                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onPressed: () {
                            showDialog(
                                builder: (context) => AlertDialog(
                                      title: const Text(
                                        'Craft your post!',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Column(children: [
                                        Container(
                                          width: 400,
                                          child: TextFormField(
                                            controller: TextEditingController(
                                                text: newPost.text),
                                            onChanged: (value) {
                                              newPost.text = value;
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
                                                        color: Colors.blue)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide: const BorderSide(
                                                        color: Colors.blue)),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide: const BorderSide(
                                                        color: Colors.red)),
                                                focusedErrorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                    borderSide: const BorderSide(
                                                        color: Colors.red))),
                                          ),
                                        ),
                                      ]),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
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
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        16.0))),
                                                onPressed: () {
                                                  postNewPost(newPost.text,
                                                      widget.user, widget.auth);
                                                },
                                                child: const Text(
                                                  "Post!",
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
                            "Create post",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )),
                    ),
                    const Divider(height: 20, color: Colors.white),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostsDashboard(
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
                        children: [
                          SvgPicture.asset(
                            'post.svg',
                            height: 45,
                            color: Colors.blue,
                          ),
                          const Divider(
                            indent: 8,
                          ),
                          Text(
                            "Your posts",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.aBeeZee(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    widget.role == 'admin'
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPanel(
                                          posts: widget.posts,
                                          user: widget.user,
                                          role: widget.role,
                                          auth: widget.auth,
                                          userId: widget.userId)));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: const Color.fromRGBO(188, 224, 247, 1),
                              onPrimary: Color.fromRGBO(255, 255, 255, 1),
                              shadowColor: Color.fromRGBO(255, 255, 255, 0),
                              onSurface: Color.fromRGBO(255, 255, 255, 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.security,
                                  size: 40,
                                  color: Colors.red,
                                ),
                                const Divider(
                                  indent: 8,
                                ),
                                Text(
                                  "Admin options",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.aBeeZee(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    const Divider(
                      height: 40,
                      color: Color.fromRGBO(0, 0, 0, 0),
                    )
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
            SizedBox(
                height: 50,
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)))),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                      },
                      child: const Icon(Icons.exit_to_app,
                          size: 20, color: Colors.black)),
                )),
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

  Padding getPostWindow(String id, String text, String owner, String date) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(188, 224, 247, 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 407,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Container(
              color: const Color.fromRGBO(205, 232, 250, 1),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 0, 10),
                      child: Row(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color.fromRGBO(55, 45, 155, 1),
                            ),
                            child: Center(
                              child: Text(
                                owner[0].toUpperCase() + owner[1].toUpperCase(),
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            indent: 35,
                          ),
                          Text(
                            '@ ' + owner,
                            style: GoogleFonts.encodeSans(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          SizedBox(
                            width: 80,
                            child: Text(
                              'Posted on: ' +
                                  date.substring(0, 10) +
                                  '     ' +
                                  date.substring(11, 16),
                              style: GoogleFonts.encodeSans(
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const Divider(
                            indent: 25,
                          )
                        ],
                      )),
                  Container(
                      height: 210,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                              child: Text(
                                text,
                                style: GoogleFonts.encodeSans(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 45,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ])),
                  const Divider(
                    height: 10,
                    color: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  Container(
                      height: 50,
                      child: SizedBox(
                        height: 35,
                        width: 150,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpenPostMain(
                                          id: id,
                                          text: text,
                                          auth: widget.auth,
                                          owner: owner,
                                          date: date,
                                          userId: widget.userId)));
                            },
                            child: const Text(
                              "Open post",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      )),
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
