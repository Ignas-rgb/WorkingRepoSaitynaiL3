import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/post.dart';
import 'package:http/http.dart' as http;
import 'package:saitynai_front/responsive/desktop_body.dart';
import 'package:saitynai_front/responsive/mobile_body.dart';
import 'package:saitynai_front/responsive/responsive_layout.dart';
import 'package:saitynai_front/see_posts_dashboard.dart';
import 'package:saitynai_front/signin.dart';
import 'package:saitynai_front/user.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

class AdminPanel extends StatefulWidget {
  List<Post> posts;
  String user;
  String role;
  String auth;
  String userId;
  AdminPanel(
      {Key? key,
      required this.posts,
      required this.user,
      required this.role,
      required this.auth,
      required this.userId})
      : super(key: key);

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  List<User> _users = [];

  Future update(String auth) async {
    final response = await http.get(
      Uri.parse('http://localhost:4000/api/users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
    );
    if (response.statusCode == 200) {
      List<User> users = (json.decode(response.body) as List)
          .map((i) => User.fromJson(i))
          .toList();
      setState(() {
        _users = users;
      });
      return users;
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

    update(widget.auth);
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
            Positioned(
                left: 20,
                top: 60,
                child: Container(
                  height: 65,
                  width: 270,
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(188, 224, 247, 1),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      "ADMIN PANEL",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.firaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 38,
                          color: Colors.black),
                    ),
                  ),
                )),
            Positioned(
              top: 5,
              left: 5,
              child: SvgPicture.asset(
                'twitter-logo-new.svg',
                height: 40,
                color: const Color.fromRGBO(55, 45, 155, 1),
                alignment: Alignment.center,
              ),
            ),
            getHeaderRow(widget.user)
          ])),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            return getPostWindow(_users[index], widget.auth);
          },
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

  Future deleteUser(User user, String auth) async {
    String id = user.id;
    String idMod = id.replaceAll(' ', '');
    var url = 'http://localhost:4000/api/users/' + idMod;
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

  Future editUser(User editedUser, String auth, String userId) async {
    String idMod = userId.replaceAll(' ', '');
    var url = 'http://localhost:4000/api/users/' + idMod;
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
      body: jsonEncode(
          <String, String>{'name': editedUser.name!, 'role': editedUser.role!}),
    );

    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content: const Text(
                  'User edited successfully',
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
                                builder: (context) => AdminPanel(
                                    posts: widget.posts,
                                    user: widget.user,
                                    role: widget.role,
                                    auth: widget.auth,
                                    userId: widget.userId)));
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

  Padding getPostWindow(User user, String auth) {
    User editingUser =
        User(id: '', name: '', email: '', password: '', role: '');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: const BoxDecoration(
              color: Color.fromRGBO(188, 224, 247, 1),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          height: 170,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Container(
              color: const Color.fromRGBO(205, 232, 250, 1),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    color: const Color.fromRGBO(220, 235, 245, 1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 30),
                          child: user.role == 'admin'
                              ? SizedBox(
                                  width: 180,
                                  child: Text(
                                    '@ ' + user.name!,
                                    style: GoogleFonts.encodeSans(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 23,
                                      color: Colors.purple,
                                    ),
                                  ))
                              : SizedBox(
                                  width: 180,
                                  child: Text(
                                    '@ ' + user.name!,
                                    style: GoogleFonts.encodeSans(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  )),
                        ),
                        Spacer(),
                        Column(children: [
                          Divider(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                            width: 170,
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
                                              'Edit user`s name',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: Column(children: [
                                              Container(
                                                width: 400,
                                                child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              editingUser.name),
                                                  onChanged: (value) {
                                                    editingUser.name = value;
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
                                                      hintText:
                                                          'Edit user`s name',
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
                                              Container(
                                                width: 400,
                                                child: TextFormField(
                                                  controller:
                                                      TextEditingController(
                                                          text:
                                                              editingUser.role),
                                                  onChanged: (value) {
                                                    editingUser.role = value;
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
                                                        Icons
                                                            .admin_panel_settings_outlined,
                                                        color: Colors.blue,
                                                      ),
                                                      hintText:
                                                          'Edit user`s role: user/admin',
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
                                              )
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
                                                        editUser(
                                                            editingUser,
                                                            widget.auth,
                                                            user.id);
                                                      },
                                                      child: const Text(
                                                        "Edit user!",
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
                                  "Edit user",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                )),
                          ),
                          Divider(
                            height: 5,
                          ),
                          SizedBox(
                              height: 50,
                              child: user.role == 'admin'
                                  ? const SizedBox(
                                      height: 35,
                                      width: 170,
                                    )
                                  : SizedBox(
                                      height: 35,
                                      width: 170,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0))),
                                          onPressed: () {
                                            showDialog(
                                                builder:
                                                    (context) => AlertDialog(
                                                          title: const Text(
                                                            'Are you sure?',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          content: const Text(
                                                            'Deletion is not reversible!',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          actions: [
                                                            Center(
                                                                child:
                                                                    ElevatedButton(
                                                              child: const Text(
                                                                "Yes",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                              onPressed: () {
                                                                deleteUser(
                                                                    user, auth);
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => AdminPanel(
                                                                            posts:
                                                                                widget.posts,
                                                                            user: widget.user,
                                                                            role: widget.role,
                                                                            auth: widget.auth,
                                                                            userId: widget.userId)));
                                                              },
                                                            )),
                                                          ],
                                                        ),
                                                context: context);
                                          },
                                          child: const Text(
                                            "Remove user",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20),
                                          )),
                                    )),
                          Divider(
                            height: 10,
                          )
                        ]),
                        Divider(indent: 20),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
