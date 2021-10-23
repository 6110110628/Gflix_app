import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final color;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        validator: MultiValidator([
          RequiredValidator(errorText: "กรุณาป้อนอีเมลด้วยครับ"),
          EmailValidator(errorText: "รูปแบบอีเมลไม่ถูกต้อง")
        ]),
        onChanged: onChanged,
        cursorColor: color, //kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: color, //kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
