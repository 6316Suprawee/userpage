import 'package:flutter/material.dart';
import 'package:wre_user/login and register/loginScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatelessWidget {
  final String email;
  final String token;

  const HomePage({Key? key, required this.email, required this.token})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(
                          token: '',
                        )),
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(width: 8.0),
          CircleAvatar(
            child: Text(
              email.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ),
          SizedBox(width: 8.0),
        ],
      ),
      body: Center(
        child: Text('Welcome $email'),
      ),
    );
  }
}
