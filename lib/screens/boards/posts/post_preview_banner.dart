import 'package:flutter/material.dart';
import 'package:guam_community_client/models/boards/post.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class PostPreviewBanner extends StatelessWidget {
  final Post post;

  PostPreviewBanner(this.post);

  colorOfInterest(String interest) {
    HexColor textColor;

    switch (interest) {
      case '개발': textColor = GuamColorFamily.purpleCore; break;
      case '데이터분석': textColor = GuamColorFamily.greenCore; break;
      case '디자인': textColor = GuamColorFamily.pinkCore; break;
      case '기획/마케팅': textColor = GuamColorFamily.blueCore; break;
      default: textColor = GuamColorFamily.orangeCore; break;
    }
    return textColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 17,
          child: TextButton(
            onPressed: () {},
            child: Text(
              "#" + post.interest,
              style: TextStyle(
                fontSize: 12,
                color: colorOfInterest(post.interest),
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        Spacer(),
        Text(
          (DateTime.now().minute - post.createdAt.minute).toString() + "분 전",
          style: TextStyle(
            fontSize: 10,
            fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
            color: GuamColorFamily.grayscaleGray4,
          ),
        )
      ],
    );
  }
}
