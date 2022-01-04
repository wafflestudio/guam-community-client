import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guam_community_client/commons/bottom_modal/bottom_modal_default.dart';
import 'package:guam_community_client/commons/custom_divider.dart';
import 'package:guam_community_client/providers/notifications/notifications.dart';
import 'package:guam_community_client/providers/user_auth/authenticate.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'notifications_body.dart';
import '../../commons/custom_app_bar.dart';

class NotificationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Notifications(
          authToken: context.read<Authenticate>().authToken),
        ),
      ],
      child: NotificationsAppScaffold(),
    );
  }
}


class NotificationsAppScaffold extends StatefulWidget {
  @override
  State<NotificationsAppScaffold> createState() => _NotificationsAppScaffoldState();
}

class _NotificationsAppScaffoldState extends State<NotificationsAppScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GuamColorFamily.grayscaleWhite,
      appBar: CustomAppBar(
        title: '알림',
        trailing: Padding(
          padding: EdgeInsets.only(right: 11),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: SvgPicture.asset('assets/icons/delete_outlined.svg'),
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
                  padding: EdgeInsets.only(left: 24, top: 24, right: 14, bottom: 21),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '알림을 모두 삭제하시겠어요?',
                            style: TextStyle(
                              fontSize: 18,
                              color: GuamColorFamily.grayscaleGray2,
                            ),
                          ),
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(fontSize: 16, color: GuamColorFamily.purpleCore),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(30, 26),
                              alignment: Alignment.centerRight,
                            ),
                            onPressed: () => Navigator.pop(context)
                          ),
                        ],
                      ),
                      CustomDivider(color: GuamColorFamily.grayscaleGray7),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          '알림을 삭제하면 다시 되돌릴 수 없습니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: GuamColorFamily.grayscaleGray2,
                            fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: (){},
                          child: Text(
                            '삭제하기',
                            style: TextStyle(fontSize: 16, color: GuamColorFamily.redCore),
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              )
            )
          ),
        )
      ),

      body: NotificationsBody(),
    );
  }
}
