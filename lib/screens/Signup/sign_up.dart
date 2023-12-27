import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/constant.dart';
import 'package:gfood_app/screens/Login/login.dart';
import 'package:gfood_app/components/already_have_an_account.dart';
import 'package:gfood_app/components/rounded_button.dart';
import 'package:gfood_app/components/rounded_input_field.dart';
import 'package:gfood_app/components/rounded_password_field.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gfood_app/screens/Restaurant/home_screen.dart';
import 'package:gfood_app/screens/Welcome/welcome_screen.dart';
import 'package:gfood_app/screens/mainframe.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TextEditingController _userNameController = TextEditingController();

  Future<void> _signUp() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Show a dialog to inform the user about email verification
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Email Verification"),
            content: const Text(
                "A verification email has been sent to your email address. Please verify your email before proceeding."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        const snackBar = SnackBar(
          content: Text("The email is already in use."),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        print("Error signing up: ${e.message}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp(); // Initialize Firebase app
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        titleSpacing: 24.0,
        centerTitle: false,
        toolbarHeight: 96.0,
        backgroundColor: black,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 180),
                    RoundedInputField(
                      hintText: "Enter Your Email",
                      controller: _emailController,
                      validator: (email) =>
                          email!.isEmpty && !EmailValidator.validate(email)
                              ? 'Please Enter Valid Email'
                              : null,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedPasswordField(
                      controller: _passwordController,
                      validator: (password) =>
                          password!.isEmpty || password.length < 6
                              ? 'Please Enter a Valid Password'
                              : null,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: size.height * 0.02),
                    RoundedButton(
                      text: "SIGN UP",
                      press: _signUp,
                    ),
                    SizedBox(height: size.height * 0.01),
                    AlreadyHaveAnAccountCheck(
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginScreen();
                            },
                          ),
                        );
                      },
                      login: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
