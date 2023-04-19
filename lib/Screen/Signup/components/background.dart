import 'package:flutter/material.dart';
import 'package:gfood_app/Screen/Login/login.dart';
import 'package:gfood_app/Screen/Signup/components/or_divider.dart';
import 'package:gfood_app/Screen/Signup/components/social_icon.dart';
import 'package:gfood_app/components/already_have_an_account.dart';
import 'package:gfood_app/components/rounded_button.dart';
import 'package:gfood_app/components/rounded_input_field.dart';
import 'package:gfood_app/components/rounded_password_field.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.12),
            const Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Image.asset(
              "assets/icons/xd.png",
              height: size.height * 0.35,
              width: size.width * 3,
            ),
            SizedBox(height: size.height * 0.01),
            RoundedInputField(
              hintText: "Your Email",
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.01),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            SizedBox(height: size.height * 0.01),
            RoundedButton(text: "SIGNUP", press: () {}),
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
            ),
            const OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialIcon(
                  iconScr: "assets/icons/facebook.png",
                  press: () {},
                ),
                SocialIcon(
                  iconScr: "assets/icons/google.png",
                  press: () {},
                ),
                SocialIcon(
                  iconScr: "assets/icons/twitter.png",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
