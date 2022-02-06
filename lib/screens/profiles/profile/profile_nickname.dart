import 'package:flutter/material.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';


class ProfileNickname extends StatelessWidget {
  final String nickname;
  final bool isMe;

  ProfileNickname({this.nickname, this.isMe = true});

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
      // left 26 of icon text width to align nickname at center
      padding: EdgeInsets.fromLTRB((isMe ? 26+8 : 8).toDouble(), 16, 8, 16),
    );
  }
}
