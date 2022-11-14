import 'package:flutter/material.dart';
import 'package:guam_community_client/providers/recruit/recruit.dart';
import 'package:provider/provider.dart';

import '../../../commons/custom_divider.dart';
import '../../../providers/user_auth/authenticate.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';

class ProjectCreationModal extends StatelessWidget {
  final Map input;

  ProjectCreationModal(this.input);

  @override
  Widget build(BuildContext context) {
    Authenticate authProvider = context.read<Authenticate>();
    final List<String> _periods = ['미정', '1개월 미만', '3개월 미만', '6개월 미만', '6개월 이상'];
    String _title = input['title'];
    int _due = input['due'];
    String _serverStack = input['SERVER']['techStack'];
    int _serverHeadCount = input['SERVER']['headCount'];
    String _webStack = input['WEB']['techStack'];
    int _webHeadCount = input['WEB']['headCount'];
    String _mobileStack = input['MOBILE']['techStack'];
    int _mobileHeadCount = input['MOBILE']['headCount'];
    String _designerStack = input['DESIGNER']['techStack'];
    int _designerHeadCount = input['DESIGNER']['headCount'];

    /// Modal 본문 내용
    String _body =
    '''
    프로젝트명
      - $_title
    
    기간
      - ${_periods[_due] ?? ''}
      
    포지션
      - Server : ${_serverHeadCount != 0 ? '$_serverStack ($_serverHeadCount)' : ''}
      - Web : ${_webHeadCount != 0 ? '$_webStack ($_webHeadCount)' : ''}
      - Mobile : ${_mobileHeadCount != 0 ? '$_mobileStack ($_mobileHeadCount)' : ''}
      - Designer : ${_designerHeadCount != 0 ? ' $_designerStack ($_designerHeadCount)' : ''}
    ''';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Recruit(authProvider)),
      ],
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 24, top: 24, right: 18, bottom: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '프로젝트 만들기',
                        style: TextStyle(fontSize: 18, color: GuamColorFamily.grayscaleGray2),
                      ),
                      TextButton(
                        child: Text(
                          '돌아가기',
                          style: TextStyle(fontSize: 16, color: GuamColorFamily.redCore),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size(30, 26),
                          alignment: Alignment.centerRight,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  CustomDivider(color: GuamColorFamily.grayscaleGray7),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      _body,
                      style: TextStyle(fontSize: 14, height: 1.6, fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        '생성',
                        style: TextStyle(fontSize: 16, color: GuamColorFamily.purpleCore),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
