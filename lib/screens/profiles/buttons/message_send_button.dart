import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guam_community_client/commons/bottom_modal/bottom_modal_with_message.dart';
import 'package:guam_community_client/models/profiles/profile.dart';
import 'package:guam_community_client/providers/messages/messages.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_auth/authenticate.dart';

class MessageSendButton extends StatelessWidget {
  final Profile? otherProfile;

  MessageSendButton(this.otherProfile);

  @override
  Widget build(BuildContext context) {
    Authenticate authProvider = context.read<Authenticate>();

    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: InkWell(
        child: Container(
          width: 103,
          height: 31,
          decoration: BoxDecoration(
            color: GuamColorFamily.purpleLight3,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                constraints: BoxConstraints(),
                padding: EdgeInsets.only(right: 4),
                icon: SvgPicture.asset(
                  'assets/icons/message_default.svg',
                  color: GuamColorFamily.purpleCore,
                ),
                onPressed: null,
              ),
              Text(
                '쪽지 보내기',
                style: TextStyle(
                  color: GuamColorFamily.purpleCore,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        onTap: () => showModalBottomSheet(
          context: context,
          useRootNavigator: true,
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          builder: (context) => MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => Messages(authProvider)),
            ],
            child: SingleChildScrollView(
              child: BottomModalWithMessage(
                funcName: '보내기',
                title: '${otherProfile!.nickname} 님에게 쪽지 보내기',
                profile: otherProfile,
                func: null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
