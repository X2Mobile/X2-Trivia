import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isPassword,
  }) : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      enableSuggestions: !isPassword,
      autocorrect: !isPassword,
      decoration: InputDecoration(
        labelText: hint,
        // suffixIcon: IconButton(
        //   icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
        //   onPressed: () {},
        // ),
      ),
      controller: controller,
    );
  }
}
