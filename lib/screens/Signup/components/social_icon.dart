import 'package:flutter/material.dart';
import 'package:gfood_app/components/constant.dart';

class SocialIcon extends StatelessWidget {
  final String iconScr;
  final VoidCallback press;
  const SocialIcon({
    super.key,
    required this.iconScr,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Transform.translate(
        offset: const Offset(0, -20),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: kPrimaryLightColor,
            ),
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            iconScr,
            height: 50,
            width: 50,
          ),
        ),
      ),
    );
  }
}
