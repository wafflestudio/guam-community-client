import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guam_community_client/commons/back.dart';
import 'package:guam_community_client/commons/bottom_modal/bottom_modal_default.dart';
import 'package:guam_community_client/commons/bottom_modal/bottom_modal_with_alert.dart';
import 'package:guam_community_client/commons/common_text_field.dart';
import 'package:guam_community_client/commons/custom_app_bar.dart';
import 'package:guam_community_client/models/messages/message.dart';
import 'package:guam_community_client/models/profiles/profile.dart';
import 'package:guam_community_client/providers/messages/messages.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../providers/user_auth/authenticate.dart';
import 'message_detail_body.dart';

class MessageDetail extends StatefulWidget {
  final List<Message> messages;
  final Profile otherProfile;

  MessageDetail(this.messages, this.otherProfile);

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  bool commentImageExist = false;

  void addMessageImage() {
    setState(() => commentImageExist = true);
  }

  void removeMessageImage() {
    setState(() => commentImageExist = false);
  }

  @override
  Widget build(BuildContext context) {
    Authenticate authProvider = context.read<Authenticate>();

    return Portal(
      child: Scaffold(
        backgroundColor: GuamColorFamily.grayscaleWhite,
        appBar: CustomAppBar(
          title: widget.otherProfile.nickname,
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
                builder: (context) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => Messages(authProvider)),
                  ],
                  child: Builder(
                    builder: (context) {
                      return SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(left: 24, top: 24, bottom: 21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BottomModalWithAlert(
                                funcName: '삭제하기',
                                title: '쪽지함을 삭제하시겠어요?',
                                body: '삭제된 쪽지는 복원할 수 없습니다.',
                                func: () async => await context.read<Messages>()
                                    .deleteMessageBox(widget.otherProfile.id)
                                    .then((successful) async {
                                  context.read<Messages>().fetchMessageBoxes();
                                  if (successful) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await context.read<Messages>().fetchMessageBoxes();
                                  }
                                }),
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
                      );
                    }
                  )
                )
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          color: Color(0xF9F8FFF), // GuamColorFamily.purpleLight1
          onRefresh: () => context.read<Messages>().getMessages(widget.otherProfile.id),
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(bottom: 70),
                child: Column(
                  children: [
                    ...widget.messages.map((msg) => MessageDetailBody(msg, widget.otherProfile))
                  ]
                ),
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.only(bottom: 10),
          color: GuamColorFamily.grayscaleWhite,
          child: CommonTextField(
            sendButton: '전송',
            onTap: null,
            mentionList: [],
            addImage: addMessageImage,
            removeImage: removeMessageImage,
            editTarget: null,
          ),
        ),
      ),
    );
  }
}
