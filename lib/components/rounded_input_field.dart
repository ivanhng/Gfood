import 'package:flutter/material.dart';
import 'package:gfood_app/common/styles.dart';
import 'package:gfood_app/components/text_field_container.dart';
import 'package:gfood_app/components/constant.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator; // Add this line
  const RoundedInputField({
    super.key,
    required this.hintText,
    this.icon = Icons.person,
    required this.onChanged,
    this.validator,
    required this.controller, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        // Use TextFormField instead of TextField
        onChanged: onChanged,
        controller: controller, // Pass the 'controller' to the TextField
        validator: validator, // Pass the validator to TextFormField
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: black,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
