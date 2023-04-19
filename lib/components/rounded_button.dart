import 'package:flutter/material.dart';
import 'package:gfood_app/constant.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
  final double borderRadius;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
    this.borderRadius = 29.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: press,
            child: Text(text, style: TextStyle(color: textColor))),
      ),
    );
  }
}
