import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_auth/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: Color.fromRGBO(255, 0, 0, 1), //kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: Color.fromRGBO(255, 0, 0, 1), //kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: Color.fromRGBO(255, 0, 0, 1), //kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
