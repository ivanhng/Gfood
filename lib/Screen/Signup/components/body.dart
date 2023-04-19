import 'package:flutter/material.dart';
import 'package:gfood_app/Screen/Signup/components/background.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: const <Widget>[],
        ),
      ),
    );
  }
}
