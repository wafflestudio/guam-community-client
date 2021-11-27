import 'package:flutter/material.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';

class ProfileEditLabel extends StatelessWidget {
  final String label;

  ProfileEditLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 84,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          height: 22/14,
          fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
          color: GuamColorFamily.grayscaleGray1,
        ),
      ),
    );
  }
}
