import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saitynai_front/signup.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Signin extends StatefulWidget {
  Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  // Future save() async {
  //   print('ATEJO' + user.email);
  //   var res = await http.post(Uri.parse('http://localhost:4000/api/login'),
  //       headers: <String, String>{
  //         'Context-Type': 'application/json;charSet=UTF-8'
  //       },
  //       body: <String, String>{
  //         'email': user.email,
  //         'password': user.password
  //       });

  //   print(res.body + 'responseT');
  //   Navigator.push(
  //       context, MaterialPageRoute(builder: (context) => Dashboard()));
  // }

  Future<User> save(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content: const Text('Logged in successfully!',
                    textAlign: TextAlign.center),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Continue", textAlign: TextAlign.center),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Dashboard(
                                id: jsonDecode(response.body)['user'],
                                authToken:
                                    jsonDecode(response.body)['token']))),
                  )),
                ],
              ),
          context: context);
      return User.fromJson(jsonDecode(response.body));
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
    // print(response.body + ' ZJBS');
    // return User.fromJson(jsonDecode(response.body));
  }

  User user = User(id: '', email: '', name: '', password: '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(237, 240, 242, 1),
        body: Stack(
          children: [
            Positioned(
                top: 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: SvgPicture.asset(
                      'top.svg',
                      fit: BoxFit.fill,
                    ))),
            Container(
              alignment: Alignment.center,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 120,
                    ),
                    Text(
                      "Sign in",
                      style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.blue),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            controller: TextEditingController(text: user.email),
                            onChanged: (value) {
                              user.email = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter something';
                              } else if (RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                return null;
                              } else {
                                return 'Enter valid email';
                              }
                            },
                            decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.email,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter Email',
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
                        )),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          child: TextFormField(
                            controller:
                                TextEditingController(text: user.password),
                            onChanged: (value) {
                              user.password = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter something';
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                icon: const Icon(
                                  Icons.vpn_key,
                                  color: Colors.blue,
                                ),
                                hintText: 'Enter Password',
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
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(55, 16, 16, 0),
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0))),
                            onPressed: () {
                              if (_formKey.currentState?.validate() == true) {
                                print('validation okTIKRAI');
                                print(user.email + user.password);
                                save(user.email, user.password);
                              } else {
                                print("not ok");
                              }
                            },
                            child: const Text(
                              "Sign in",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                      ),
                    ),
                    const Divider(
                      height: 20,
                      color: Color.fromRGBO(1, 1, 1, 0),
                    ),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "          Don't have an account ? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signup()));
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                    const Divider(
                      height: 40,
                      color: Color.fromRGBO(1, 1, 1, 0),
                    ),
                    SvgPicture.asset(
                      'twitter-logo-new.svg',
                      height: 150,
                      color: Colors.blue,
                    ),
                    const Divider(
                      height: 30,
                      color: Color.fromRGBO(1, 1, 1, 0),
                    ),
                    Text(
                      "Twitter 2.0",
                      style: GoogleFonts.pacifico(
                          fontWeight: FontWeight.bold,
                          fontSize: 50,
                          color: Colors.blue),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
