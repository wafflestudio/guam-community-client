import 'package:flutter/material.dart';
import '../../../commons/common_text_button.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:io' show Platform;
import '../edit/profile_edit_img_modal.dart';

class ProfileImgEditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CommonTextButton(
      text: '프로필 사진 변경',
      fontSize: 12,
      fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
      textColor: GuamColorFamily.purpleCore,
      onPressed: () {
        if (Platform.isAndroid) {
          showMaterialModalBottomSheet(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              )
            ),
            context: context,
            builder: (_) => ProfileEditImgModal()
          );
        } else {
        showCupertinoModalBottomSheet(
            context: context,
            builder: (_) => ProfileEditImgModal()
          );
        }
      },
    );
  }
}
