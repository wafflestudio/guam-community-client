import 'package:flutter/material.dart';
import 'package:guam_community_client/helpers/http_request.dart';
import 'package:guam_community_client/helpers/svg_provider.dart';
import 'package:guam_community_client/screens/profiles/profiles_app.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class CommonImgNickname extends StatelessWidget {
  final int userId;
  final String imgUrl;
  final String nickname;
  final HexColor nicknameColor;
  final bool profileClickable;

  CommonImgNickname({this.userId, this.imgUrl, this.nickname, this.nicknameColor, this.profileClickable=true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: profileClickable
          ? () => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => ProfilesApp(userId: userId)),
      )
          : null,
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: imgUrl != null
                    ? NetworkImage(HttpRequest().s3BaseAuthority + imgUrl)
                    : SvgProvider('assets/icons/profile_image.svg')
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              nickname ?? "",
              style: TextStyle(
                fontSize: 12,
                fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                color: nicknameColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
