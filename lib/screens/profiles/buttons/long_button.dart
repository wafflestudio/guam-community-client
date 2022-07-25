import 'package:flutter/material.dart';
import 'package:guam_community_client/commons/icon_text.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';

class LongButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  LongButton({this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: GuamColorFamily.grayscaleGray6),
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
              style: TextStyle(
                fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                fontSize: 14,
                color: GuamColorFamily.grayscaleGray2,
              )
          ),
          IconText(
            iconSize: 18,
            iconColor: GuamColorFamily.grayscaleGray4,
            paddingBtw: 0,
            iconPath: 'assets/icons/right.svg',
          )
        ],
      ),
      onPressed: onPressed,
    );
  }
}
