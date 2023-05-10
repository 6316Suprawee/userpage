import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wre_user/Homepage/HomePage.dart';
import 'package:http/http.dart' as http;
import 'package:wre_user/login%20and%20register/Register.dart';
import 'package:wre_user/login and register/OTPPage.dart';

class LoginScreen extends StatefulWidget {
  final String token; // เพิ่ม parameter ใน constructor

  LoginScreen({required this.token}); // เพิ่ม constructor

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = "";
  String _response = "";
  String _token = "";

  @override
  void initState() {
    super.initState();
    _token = widget.token; // กำหนดค่า token จาก parameter ใน constructor
  }

  Future<void> _login() async {
    print(
        'Debug: email=${_idController.text}, password=${_passwordController.text}');
    final response = await http.post(
      Uri.parse('http://13.250.14.61:8765/v1/login'),
      body: jsonEncode(<String, String>{
        'email': _idController.text,
        'password': _passwordController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['token'] != null) {
        print('Response Body1: ${response.body}');
        setState(() {
          _email = jsonData['email'];

          _token = jsonData['token'];
          //jsonData['email'];
          // _response = jsonData['token'];
          // _token = _response;
        });
        print('Response Body2: ${response.body}');
        if (_token.isNotEmpty) {
          print('Response Body3: ${response.body}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                email: _email,
                token: _token,
              ),
            ),
          );
        } else {
          print('Response Body4: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid token'),
            ),
          );
        }
      } else {
        setState(() {
          _response = "Invalid email or password";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_response),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                hintText: 'ID',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            Text(
              _response,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: Text(
                'Create account',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
