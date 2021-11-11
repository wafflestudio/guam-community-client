import 'package:flutter/material.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';

class ProfileNickname extends StatelessWidget {
  final String nickname;

  ProfileNickname(this.nickname);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Text(
        nickname,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: GuamFontFamily.SpoqaHanSansNeoMedium,
            fontSize: 18,
            color: GuamColorFamily.grayscaleGray2,
            height: 28.8/18
        ),
      ),
      padding: EdgeInsets.fromLTRB((36+8).toDouble(), 16, 8, 16), // left 36 to align nickname at center
    );
  }
}