import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: camel_case_types
class modified_text extends StatelessWidget {
  final String text;
  final Color color;
  final double size;
  final weight;

  const modified_text({Key key, this.text, this.color, this.size, this.weight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          GoogleFonts.roboto(color: color, fontSize: size, fontWeight: weight),
    );
  }
}
