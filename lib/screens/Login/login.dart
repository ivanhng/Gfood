import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/screens/Login/forgotpassword.dart';
import 'package:gfood_app/screens/Login/questionaire.dart';
import 'package:gfood_app/screens/Signup/sign_up.dart';
import 'package:gfood_app/components/already_have_an_account.dart';
import 'package:gfood_app/components/rounded_button.dart';
import 'package:gfood_app/components/rounded_input_field.dart';
import 'package:gfood_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:gfood_app/screens/mainframe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Login Function
  Future<void> _login() async {
    print("Login button pressed");
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {
        print("User logged in: ${user.email}");

        // Store the user's authentication token in SharedPreferences.
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('auth_token', user.uid);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainFrame(title: 'Home'),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      print("Error logging in: $e");
      _showErrorSnackBar(context, 'Wrong email or password');
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //dispose controllers when not in used to free up memory
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.1,
            ),
            const Text(
              "Login",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            Image.asset(
              "assets/images/main_top.png",
              height: size.height * 0.35,
              width: size.width * 3,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedInputField(
              hintText: "Your Email",
              controller: _emailController,
              validator: (email) =>
                  email!.isEmpty && !EmailValidator.validate(email)
                      ? 'Please Enter Your Email'
                      : null,
              onChanged: (value) {},
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            RoundedPasswordField(
              controller: _passwordController,
              validator: (password) => password!.isEmpty || password.length < 6
                  ? 'Please Enter a Valid Password'
                  : null,
              onChanged: (value) {},
            ),
            const SizedBox(
              height: 5,
            ),
            GestureDetector(
              child: const Text('Forgot Password?',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  )),

              //go to forgot password page when clicked
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            RoundedButton(
              text: "LOGIN",
              press: _login,
            ),
            const SizedBox(
              height: 10,
            ),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SignUpScreen();
                    },
                  ),
                );
              },
              login: true,
            ),
          ],
        ),
      ),
    );
  }
}
