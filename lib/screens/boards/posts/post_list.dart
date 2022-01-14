import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guam_community_client/commons/custom_divider.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:guam_community_client/commons/icon_text.dart';
import 'package:guam_community_client/providers/posts/posts.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/screens/boards/posts/preview/post_preview.dart';

import '../../../commons/sub_headings.dart';

class PostList extends StatefulWidget {
  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  List<String> selectedInterests = [];

  void setInterests(String interest){
    setState(() => selectedInterests.contains(interest)
        ? selectedInterests.remove(interest)
        : selectedInterests.add(interest)
    );
  }

  @override
  void initState() {
    selectedInterests = ['#개발', '#데이터분석', '#디자인', '#기획/마케팅', '#기타'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final postsProvider = context.read<Posts>();

    return Container(
      decoration: BoxDecoration(color: GuamColorFamily.purpleLight3), // backgrounds color
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24, left: 22, right: 10, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SubHeadings("특별한 일이 있나요? ✨"),
                IconText(
                  text: "관심사 설정",
                  iconPath: 'assets/icons/setting.svg',
                  iconColor: GuamColorFamily.purpleLight1,
                  textColor: GuamColorFamily.purpleLight1,
                  onPressed: () => showMaterialModalBottomSheet(
                    context: context,
                    useRootNavigator: true,
                    // 완료 버튼의 특수 기능을 담지 못하는 isDismissible은 비활성화시킴.
                    isDismissible: false,
                    backgroundColor: GuamColorFamily.grayscaleWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )
                    ),
                    builder: (context) => StatefulBuilder(
                      // BottomSheet은 현재 파일의 StatefulWidget에 종속하지 않으므로
                      // 새롭게 context 및 state를 지정해줘야 한다.
                      builder: (BuildContext context, StateSetter myState) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(left: 24, top: 18, right: 18, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '관심사를 설정해주세요.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: GuamColorFamily.grayscaleGray2,
                                      ),
                                    ),
                                    TextButton(
                                      child: Text(
                                        '전체 해제',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: GuamColorFamily.purpleCore,
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size(30, 26),
                                        alignment: Alignment.centerRight,
                                      ),
                                      onPressed: () => myState(() => selectedInterests = [])
                                    ),
                                  ],
                                ),
                                CustomDivider(color: GuamColorFamily.grayscaleGray7),
                                Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      _interestType(context, myState, '#개발'),
                                      _interestType(context, myState, '#데이터분석'),
                                      _interestType(context, myState, '#디자인'),
                                      _interestType(context, myState, '#기획/마케팅'),
                                      _interestType(context, myState, '#기타'),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                      if (selectedInterests.isEmpty){
                                        myState(() => selectedInterests = ['#개발', '#데이터분석', '#디자인', '#기획/마케팅', '#기타']);
                                        // 전체 해제시키고 완료하면 전체 선택했을 때 결과로 보내주기
                                      }
                                    },
                                    child: Text(
                                      '완료',
                                      style: TextStyle(fontSize: 16, color: GuamColorFamily.purpleCore),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          )
                        );
                      }
                    )
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                ...postsProvider.posts.map((post) => PostPreview(post))
              ]
            ),
          )
        ],
      ),
    );
  }

  Widget _interestType(BuildContext context, StateSetter myState, String interest) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () =>
          myState(() => selectedInterests.contains(interest)
              ? selectedInterests.remove(interest)
              : selectedInterests.add(interest)
          ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 26,
                child: Text(
                  interest,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                    color: selectedInterests.contains(interest)
                        ? GuamColorFamily.purpleCore
                        : GuamColorFamily.grayscaleGray3,
                  )
                )
              ),
              if (selectedInterests.contains(interest))
                IconButton(
                  padding: EdgeInsets.only(right: 8),
                  constraints: BoxConstraints(),
                  icon: SvgPicture.asset('assets/icons/check.svg'),
                ),
            ],
          ),
        ),
      )
    );
  }
}
