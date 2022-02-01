import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';

class PostCreationCategory extends StatefulWidget {
  final Map input;
  final bool isBoardAnonymous;

  PostCreationCategory(this.input, this.isBoardAnonymous);

  @override
  _PostCreationCategoryState createState() => _PostCreationCategoryState();
}

class _PostCreationCategoryState extends State<PostCreationCategory> {
  @override
  void initState() {
    super.initState();
  }

  void setCategory(String category){
    setState(() => widget.input['category'] = category);
  }

  void initCategory(){
    setState(() => widget.input['category'] = '');
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isBoardAnonymous) {
      return Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '카테고리를 선택해주세요.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                  color: GuamColorFamily.grayscaleGray3,
                )
            ),
            if (widget.input['category'] == '')
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _categoryChip('개발'),
                    _categoryChip('데이터분석'),
                    _categoryChip('디자인'),
                    _categoryChip('기획/마케팅'),
                    _categoryChip('기타'),
                  ],
                ),
              ),
            if (widget.input['interest'] != '')
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Text(
                      "#" + widget.input['interest'],
                      style: TextStyle(
                          fontSize: 16, color: GuamColorFamily.blueCore),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () => initCategory(),
                      icon: SvgPicture.asset(
                        'assets/icons/cancel_outlined.svg',
                        color: GuamColorFamily.blueCore,
                        width: 20,
                        height: 20,
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _categoryChip(String interest) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: false,
        pressElevation: 2,
        labelPadding: EdgeInsets.symmetric(horizontal: 4),
        backgroundColor: GuamColorFamily.purpleLight3,
        onSelected: (e) => setCategory(interest),
        label: Text(
          "#" + interest,
          style: TextStyle(
            fontSize: 14,
            color: GuamColorFamily.purpleLight1,
          ),
        ),
      ),
    );
  }
}
