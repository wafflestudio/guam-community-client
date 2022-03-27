import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guam_community_client/commons/back.dart';
import 'package:guam_community_client/commons/bottom_modal/bottom_modal_default.dart';
import 'package:guam_community_client/commons/common_text_field.dart';
import 'package:guam_community_client/commons/custom_app_bar.dart';
import 'package:guam_community_client/models/messages/message.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'message_detail_body.dart';

class MessageDetail extends StatefulWidget {
  final List<Message> messages;
  final String otherName;

  MessageDetail(this.messages, this.otherName);

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  bool commentImageExist = false;

  void addCommentImage() {
    setState(() => commentImageExist = true);
  }

  void removeCommentImage() {
    setState(() => commentImageExist = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuamColorFamily.grayscaleWhite,
      appBar: CustomAppBar(
        title: widget.otherName,
        leading: Back(),
        trailing: Padding(
          padding: EdgeInsets.only(right: 11),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: SvgPicture.asset('assets/icons/more.svg'),
            onPressed: () => showMaterialModalBottomSheet(
              context: context,
              useRootNavigator: true,
              backgroundColor: GuamColorFamily.grayscaleWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )
              ),
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 24, top: 24, bottom: 21),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BottomModalDefault(
                        text: '쪽지 삭제하기',
                        onPressed: (){},
                      ),
                      BottomModalDefault(
                        text: '신고하기',
                        onPressed: (){},
                      ),
                      BottomModalDefault(
                        text: '차단하기',
                        onPressed: (){},
                      ),
                    ],
                  ),
                ),
              )
            )
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 70),
          child: Column(
            children: [
              ...widget.messages.map((msg) => MessageDetailBody(msg))
            ]
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.only(bottom: 10),
        color: GuamColorFamily.grayscaleWhite,
        child: CommonTextField(
          sendButton: '전송',
          onTap: null,
          addImage: addCommentImage,
          removeImage: removeCommentImage,
          editTarget: null,
        ),
      ),
    );
  }
}
