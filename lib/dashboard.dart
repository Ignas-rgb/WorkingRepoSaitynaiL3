import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:saitynai_front/post.dart';
import 'package:http/http.dart' as http;
import 'package:saitynai_front/responsive/desktop_body.dart';
import 'package:saitynai_front/responsive/mobile_body.dart';
import 'package:saitynai_front/responsive/responsive_layout.dart';
import 'package:saitynai_front/user.dart';
import 'package:fake_async/fake_async.dart';
import 'package:test/test.dart';

class Dashboard extends StatefulWidget {
  String id;
  String authToken;
  List<Post>? poster;
  Dashboard({Key? key, required this.id, required this.authToken})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Post> _posts = [];
  List<String> _user = [];
  String userName = '';
  String userRole = '';

  Future update(String auth, String id) async {
    final response = await http.get(
      Uri.parse('http://localhost:4000/api/posts/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
    );

    String idMod = id.replaceAll(' ', '');
    var url2 = 'http://localhost:4000/api/users/' + idMod;
    final response2 = await http.get(
      Uri.parse(url2),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': auth
      },
    );
    if (response2.statusCode == 200) {
      String _userName = jsonDecode(response2.body)['name'];
      String _userRole = jsonDecode(response2.body)['role'];
      List<Post> posts = (json.decode(response.body) as List)
          .map((i) => Post.fromJson(i))
          .toList();
      setState(() {
        _posts = posts;
        userName = _userName;
        userRole = _userRole;
      });
      return posts;
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
    //getUser(widget.authToken, widget.id);
    update(widget.authToken, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
        mobileBody: MyMobileBody(
          posts: _posts,
          user: userName,
          role: userRole,
          auth: widget.authToken,
          userId: widget.id,
        ),
        desktopBody: MyDesktopBody(
          posts: _posts,
          user: userName,
          role: userRole,
          auth: widget.authToken,
          userId: widget.id,
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(

  //       body:Column(children: [
  //       //Header(),
  //       Text("Dashboard",
  //           style: GoogleFonts.pacifico(
  //               fontWeight: FontWeight.bold, fontSize: 50, color: Colors.blue)),
  //       Text(
  //         widget.authToken,
  //       ),
  //       SizedBox(
  //           height: 200,
  //           child: Center(
  //               child: ListView.builder(
  //                   itemCount: posters.length,
  //                   itemBuilder: (context, i) {
  //                     return Text(
  //                       posters[i].text,
  //                       style: TextStyle(fontSize: 50),
  //                     );
  //                   }))),
  //     //Footer(),
  //     ]),
  //   );
  // }
}
