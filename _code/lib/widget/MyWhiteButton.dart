import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kdh_homepage/util/MyColors.dart';

class MyWhiteButton extends StatelessWidget {
  final String text;

  const MyWhiteButton(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0,
      child: Padding(
        padding: const EdgeInsets.only(left: 14, right: 14, top: 20),
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            text,
            style: GoogleFonts.gothicA1(
              color: MyColors.black,
              fontSize: 12,
              fontWeight: FontWeight.w600
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.only(top: 19, bottom: 19),
            primary: MyColors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: MyColors.black, width: 0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
