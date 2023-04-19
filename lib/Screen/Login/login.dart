import 'package:flutter/material.dart';
import 'package:gfood_app/Screen/Home/home.dart';
import 'package:gfood_app/Screen/Signup/sign_up.dart';
import 'package:gfood_app/components/already_have_an_account.dart';
import 'package:gfood_app/components/rounded_button.dart';
import 'package:gfood_app/components/rounded_input_field.dart';
import 'package:gfood_app/components/rounded_password_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              onChanged: (value) {},
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MyHomePage();
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: size.height * 0.03,
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
            ),
          ],
        ),
      ),
    );
  }
}
