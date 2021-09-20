import 'package:flutter/material.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
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
        cursorColor: Color.fromRGBO(255, 0, 0, 1), //kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Color.fromRGBO(255, 0, 0, 1), //kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
