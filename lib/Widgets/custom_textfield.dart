import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          label: Text(hintText),
          labelStyle: TextStyle(color: Colors.orange),
          focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                   color: Colors.orange, // Orange border when focused
                ),
                ),
          border: const OutlineInputBorder(

              borderSide: BorderSide(
                color: Colors.black38,
              )),
          enabledBorder: const OutlineInputBorder(

              borderSide: BorderSide(
                color: Colors.black38,
              ))),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your $hintText';
        }
        return null;
      },
      maxLines: maxLines,
      cursorColor: Colors.orange,
    );
  }
}