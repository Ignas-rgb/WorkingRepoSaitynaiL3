import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:saitynai_front/dashboard.dart';
import 'package:saitynai_front/signin.dart';
import 'package:saitynai_front/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  // Future save() async {
  //   var res = await http.post(Uri.parse('http://localhost:4000/api/register'),
  //       headers: <String, String>{
  //         'Context-Type': 'application/json;charSet=UTF-8'
  //       },
  //       body: <String, String>{
  //         'name': user.name,
  //         'email': user.email,
  //         'password': user.password
  //       });
  //   print(res.body);
  //   if (res.body != '') {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => Signin()));
  //   }
  // }

  Future<User> save(String email, String password, String name) async {
    final response = await http.post(
      Uri.parse('http://localhost:4000/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
          <String, String>{'email': email, 'password': password, 'name': name}),
    );
    if (response.statusCode == 200) {
      showDialog(
          builder: (context) => AlertDialog(
                title: const Text(
                  'Success!',
                  textAlign: TextAlign.center,
                ),
                content:
                    const Text('Account created successfully. Please log in'),
                actions: [
                  Center(
                      child: ElevatedButton(
                    child: const Text("Move to Login screen",
                        textAlign: TextAlign.center),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signin())),
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
                      "Sign up",
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
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: user.name),
                              onChanged: (value) {
                                user.name = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter something';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  icon: const Icon(
                                    Icons.text_fields,
                                    color: Colors.blue,
                                  ),
                                  hintText: 'Enter username',
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
                            ))),
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
                              if (_formKey.currentState!.validate()) {
                                save(user.email, user.password, user.name!);
                                //save(user.email, user.password, user.name);
                              } else {
                                print("not ok");
                              }
                            },
                            child: const Text(
                              "Sign up",
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
                          "          Already have an account ? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Signin()));
                          },
                          child: const Text(
                            "Sign in",
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
