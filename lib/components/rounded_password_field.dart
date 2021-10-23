import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final color;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: RequiredValidator(errorText: "กรุณาป้อนรหัสผ่านด้วยครับ"),
        obscureText: true,
        onChanged: onChanged,
        cursorColor: color, //kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: color,
            //kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
