import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    Key? key,
    required this.iconData,
    required this.hintText,
    this.inputType,
    this.obscureText = false,
    this.onPressedEye,
    this.controller,
    this.validator,
  }) : super(key: key);

  final IconData iconData;
  final String hintText;
  final TextInputType? inputType;
  final bool obscureText;
  final void Function()? onPressedEye;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shadowColor: Colors.indigoAccent.withOpacity(0.6),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          // vertical: 10,
        ),
        child: TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(
              iconData,
              color: Colors.deepPurpleAccent,
              size: 30,
              shadows: [
                Shadow(
                  color: Colors.deepPurpleAccent.withOpacity(0.2),
                  offset: Offset(-3, 3),
                ),
              ],
            ),
            suffixIcon: hintText.toLowerCase() == 'password'
                ? IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.deepPurpleAccent,
                    ),
                    onPressed: onPressedEye,
                  )
                : null,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: inputType ?? TextInputType.text,
          obscureText: obscureText,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
