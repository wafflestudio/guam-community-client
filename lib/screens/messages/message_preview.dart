import 'package:flutter/material.dart';
import 'package:guam_community_client/commons/guam_progress_indicator.dart';
import 'package:guam_community_client/helpers/http_request.dart';
import 'package:guam_community_client/helpers/svg_provider.dart';
import 'package:guam_community_client/mixins/toast.dart';
import 'package:guam_community_client/models/messages/message.dart' as Message;
import 'package:guam_community_client/models/messages/message_box.dart';
import 'package:guam_community_client/providers/messages/messages.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../commons/bottom_modal/bottom_modal_with_alert.dart';
import '../../providers/user_auth/authenticate.dart';
import 'message_detail.dart';

class MessagePreview extends StatelessWidget with Toast {
  final MessageBox messageBox;
  final bool editable;

  MessagePreview(this.messageBox, {this.editable=false});

  @override
  Widget build(BuildContext context) {
    Authenticate authProvider = context.read<Authenticate>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: GuamColorFamily.grayscaleGray7, width: 1.5),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 12, top: 6, bottom: 6),
          child: InkWell(
            onTap: !editable ? () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => Messages(authProvider)),
                  ],
                  child: FutureBuilder(
                    future: context.read<Messages>().getMessages(messageBox.otherProfile.id),
                    builder: (_, AsyncSnapshot<List<Message.Message>> snapshot) {
                      if (snapshot.hasData) {
                        return MessageDetail(snapshot.data, messageBox.otherProfile);
                      } else if (snapshot.hasError) {
                        Navigator.pop(context);
                        showToast(success: false, msg: '해당 쪽지를 찾을 수 없습니다.');
                        return null;
                      } else {
                        return Container(
                          color: GuamColorFamily.grayscaleWhite,
                          child: Center(child: guamProgressIndicator()),
                        );
                      }
                    },
                  ),
                ),
              ),
            ) : null,
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: messageBox.otherProfile.profileImg != null
                              ? NetworkImage(HttpRequest().s3BaseAuthority + messageBox.otherProfile.profileImg)
                              : SvgProvider('assets/icons/profile_image.svg')
                        ),
                      ),
                    ),
                    if (!messageBox.latestLetter.isRead)
                      Positioned(
                        top: 0,
                        child: CircleAvatar(
                          backgroundColor: GuamColorFamily.fuchsiaCore,
                          radius: 6,
                        )
                      ),
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          messageBox.otherProfile.nickname,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            fontFamily: GuamFontFamily.SpoqaHanSansNeoMedium,
                            color: GuamColorFamily.grayscaleGray2,
                          ),
                        ),
                        Text(
                          messageBox.latestLetter.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.6,
                            fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                            color: messageBox.latestLetter.isRead
                                ? GuamColorFamily.grayscaleGray4
                                : GuamColorFamily.grayscaleGray2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                if (editable)
                  MultiProvider(
                    providers: [
                      ChangeNotifierProvider(create: (_) => Messages(authProvider)),
                    ],
                    child: Builder(
                      builder: (context) {
                        return TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(23, 20),
                            textStyle: TextStyle(
                              fontSize: 12,
                              fontFamily: GuamFontFamily.SpoqaHanSansNeoMedium,
                              color: GuamColorFamily.redCore,
                            ),
                          ),
                          child: BottomModalWithAlert(
                            funcName: '삭제',
                            title: '쪽지함을 삭제하시겠어요?',
                            body: '삭제된 쪽지는 복원할 수 없습니다.',
                            func: () async => await context.read<Messages>()
                                .deleteMessageBox(messageBox.otherProfile.id)
                                .then((successful) async {
                                  context.read<Messages>().fetchMessageBoxes();
                                  if (successful) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await context.read<Messages>().fetchMessageBoxes();
                                  }
                              })
                          ),
                        );
                      }
                    ),
                  ),
                if (!editable)
                Padding(
                  padding: EdgeInsets.only(right: 10, top: 14, bottom: 15),
                  child: Text(
                    Jiffy(messageBox.latestLetter.createdAt).fromNow(),
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.6,
                      fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                      color: GuamColorFamily.grayscaleGray4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
