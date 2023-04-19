import 'package:flutter/material.dart';
import 'package:gfood_app/Screen/Login/login.dart';
import 'package:gfood_app/Screen/Signup/components/or_divider.dart';
import 'package:gfood_app/Screen/Signup/components/social_icon.dart';
import 'package:gfood_app/Screen/Signup/sign_up.dart';
import 'package:gfood_app/components/rounded_button.dart';
import 'package:gfood_app/constant.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    top: size.height * 0.1,
                    left: 135,
                    child: Image.asset(
                      "assets/images/Gfood.png",
                      width: size.width * 0.3,
                    ),
                  ),
                  Positioned(
                    child: Opacity(
                      opacity: 0.2, // adjust the opacity value as needed
                      child: Image.asset(
                        "assets/images/main_top.png",
                        width: size.width * 3,
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.25,
                    left: size.width * 0.35,
                    child: const Text(
                      "Welcome To GFOOD",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    top: size.height * 0.64,
                    left: size.width * 0.1,
                    child: RoundedButton(
                      text: "LOGIN",
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
                  ),
                  Positioned(
                    top: size.height * 0.74,
                    left: size.width * 0.1,
                    child: RoundedButton(
                      text: "SIGN UP",
                      color: kPrimaryLightColor,
                      textColor: Colors.white,
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
                  ),
                  Positioned(
                    top: size.height * 0.83,
                    left: size.width * 0.46,
                    child: const OrDivider(),
                  ),
                  Positioned(
                    top: size.height * 0.9,
                    left: size.width * 0.1,
                    child: Row(
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
