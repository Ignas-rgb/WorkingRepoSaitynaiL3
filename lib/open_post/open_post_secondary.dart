import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saitynai_front/admin_responsive/admin_panel.dart';
import 'package:saitynai_front/comment.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/post.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saitynai_front/responsive/mobile_body.dart';
import 'package:saitynai_front/see_posts_dashboard.dart';
import 'package:saitynai_front/user.dart';
import 'package:http/http.dart' as http;

class OpenPostSecondary extends StatefulWidget {
  String id, text, owner, date, auth, userId;
  OpenPostSecondary(
      {Key? key,
      required this.id,
      required this.text,
      required this.auth,
      required this.owner,
      required this.date,
      required this.userId})
      : super(key: key);

  @override
  State<OpenPostSecondary> createState() => _OpenPostSecondaryState();
}

class _OpenPostSecondaryState extends State<OpenPostSecondary> {
  Future<Comment> postNewComment(
      String newCommentText, String postId, String auth) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/api/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
      body: jsonEncode(
          <String, String>{'text': newCommentText, 'postId': postId}),
    );
    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'Comment created successfully',
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
                                builder: (context) => OpenPostSecondary(
                                    id: widget.id,
                                    text: widget.text,
                                    auth: widget.auth,
                                    owner: widget.owner,
                                    date: widget.date,
                                    userId: widget.userId)));
                      })
                    },
                  )),
                ],
              ),
          context: context);
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Invalid comment',
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

  List<Comment> _comments = [];

  Future openPost(String id, String auth) async {
    final response = await http.get(
      Uri.parse('http://localhost:4000/api/comments'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
    );

    if (response.statusCode == 200) {
      List<Comment> comments = (json.decode(response.body) as List)
          .map((i) => Comment.fromJson(i))
          .toList();
      setState(() {
        _comments = comments;
      });
      return comments;
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

  @override
  void initState() {
    super.initState();
    openPost(widget.id, widget.auth);
  }

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
          Center(
            child: SvgPicture.asset(
              'twitter-logo-new.svg',
              height: 80,
              color: const Color.fromRGBO(55, 45, 155, 1),
              alignment: Alignment.center,
            ),
          ),
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: getPostWindow(
              widget.id, widget.text, widget.owner, widget.date, _comments)),
    );
  }

  Padding getPostWindow(String id, String text, String owner, String date,
      List<Comment> comments) {
    List<Comment> filteredComments = [];
    for (var i = 0; i < comments.length; i++) {
      if (comments[i].postId == id) {
        filteredComments.add(comments[i]);
      }
    }

    Comment craftComment = Comment(id: '', text: '', date: '', postId: '');

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(188, 224, 247, 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: MediaQuery.of(context).size.height,
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
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.lightBlueAccent,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)))),
                        onPressed: () {
                          showDialog(
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Create your comment!',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Column(children: [
                                      Container(
                                        width: 400,
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: craftComment.text),
                                          onChanged: (value) {
                                            craftComment.text = value;
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
                                              hintText: 'Enter your comment',
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue)),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.blue)),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  borderSide: const BorderSide(
                                                      color: Colors.red)),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(16),
                                                      borderSide:
                                                          const BorderSide(
                                                              color:
                                                                  Colors.red))),
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
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.0))),
                                              onPressed: () {
                                                postNewComment(
                                                    craftComment.text,
                                                    id,
                                                    widget.auth);
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
                          "Comment",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                  const Divider(
                    height: 10,
                    color: Color.fromRGBO(0, 0, 0, 0),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredComments.length,
                      itemBuilder: (context, index) {
                        return getCommentWindow(filteredComments[index]);
                      },
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Future deleteComment(Comment comment, String auth) async {
    String id = comment.id;
    String idMod = id.replaceAll(' ', '');
    var url = 'http://localhost:4000/api/comments/' + idMod;
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

  Padding getCommentWindow(Comment comment) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            decoration: const BoxDecoration(
                color: Color.fromRGBO(205, 232, 250, 1),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            height: 40,
            child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Divider(
                          indent: 20,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width - 250,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(comment.text,
                                  style: const TextStyle(fontSize: 12)),
                            )),
                        Spacer(),
                        SizedBox(
                          height: 20,
                          width: 85,
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
                                                deleteComment(
                                                    comment, widget.auth);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OpenPostSecondary(
                                                                id: widget.id,
                                                                text:
                                                                    widget.text,
                                                                auth:
                                                                    widget.auth,
                                                                owner: widget
                                                                    .owner,
                                                                date:
                                                                    widget.date,
                                                                userId: widget
                                                                    .userId)));
                                              },
                                            )),
                                          ],
                                        ),
                                    context: context);
                              },
                              child: const Text(
                                "Remove",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 12),
                              )),
                        ),
                        const Divider(
                          indent: 30,
                        )
                      ],
                    )))));
  }
}
