import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kdh_homepage/util/MyColors.dart';

class MyCard extends StatelessWidget {
  final String title;
  final List<Widget> contents;
  final Widget? rightButton;
  final Widget? bottomButton;
  const MyCard(
      {Key? key, required this.title, required this.contents, this.rightButton, this.bottomButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List bottomButtonList = [];
    if(bottomButton != null) bottomButtonList.add(bottomButton);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(
          width: 0.5,
          color: MyColors.black,
        ),
      ),
      shadowColor: MyColors.black,
      elevation: 7,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 14, right: 14, top: 24, bottom: 30),
        child: FractionallySizedBox(
          widthFactor: 1.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cardTitle(title),
              const SizedBox(height: 10),
              ...contents,
              ...bottomButtonList,
            ],
          ),
        ),
      ),
    );
  }

  Widget cardTitle(String title) {
    List buttonList = [];
    if (rightButton != null) {
      buttonList.add(rightButton);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.gothicA1(
            color: MyColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        ...buttonList,
      ],
    );
  }
}