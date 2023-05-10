import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wre_user/login and register/loginScreen.dart';
import 'package:wre_user/login and register/Register.dart';

class OTPPage extends StatefulWidget {
  final String otp;
  final String email;
  final String password;
  final String response;
  final String token;

  OTPPage({
    required this.otp,
    required this.email,
    required this.password,
    required this.response,
    required this.token,
  });

  @override
  _OTPPageState createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  Future<void> _submitForm() async {
    final response = await http.post(
      Uri.parse('http://13.250.14.61:8765/v1/otp'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'token': widget.token,
        'otp': _otpController.text,
      }),
    );

    print('Request Body: ${jsonEncode(<String, String>{
          'token': widget.token,
          'otp': _otpController.text
        })}');
    print('Response Body: ${response.body}');

    final responseData = json.decode(response.body);
    if (responseData['token'] != null) {
      // Send the token to the OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(
            token: '',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'An OTP has been sent to your email. Please enter the 6-digit OTP below to verify your account.',
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'OTP',
                ),
                // validator: (value) {
                //   if (value!.isEmpty) {
                //     return 'Please enter the OTP';
                //   }
                //   if (value.length != 6) {
                //     return 'OTP must be a 6-digit number';
                //   }
                //   return null;
                // },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('sumit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
