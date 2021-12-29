import 'package:flutter/material.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';

class ProfileEditSkillSetLabel extends StatelessWidget {
  final int nSkillSet;

  ProfileEditSkillSetLabel(this.nSkillSet);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '내 기술 스택',
            style: TextStyle(
              fontSize: 16,
              height: 25.6/16,
              fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
              color: GuamColorFamily.grayscaleGray1,
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 4)),
          Text(
            '$nSkillSet',
            style: TextStyle(
              fontSize: 12,
              height: 19.2/12,
              fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
              color: GuamColorFamily.purpleCore,
            ),
          ),
        ],
      ),
    );
  }
}
