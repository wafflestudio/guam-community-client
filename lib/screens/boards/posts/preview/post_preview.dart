import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guam_community_client/commons/custom_divider.dart';
import 'package:guam_community_client/models/boards/post.dart';
import 'package:guam_community_client/providers/posts/posts.dart';
import 'package:guam_community_client/screens/boards/posts/detail/post_detail.dart';
import 'package:guam_community_client/screens/boards/posts/preview/post_preview_interest.dart';
import 'package:guam_community_client/screens/boards/posts/post_info.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:provider/provider.dart';
import '../../../../providers/home/home_provider.dart';

class PostPreview extends StatelessWidget {
  final Post post;

  PostPreview(this.post);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: EdgeInsets.only(left: 24, right: 24, top: 12),
        decoration: BoxDecoration(
          color: GuamColorFamily.grayscaleWhite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: context.read<Posts>(),
                  child: PostDetail(post),
                )
              )
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PostPreviewBanner(post),
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    if (post.pictures.length > 0)
                      IconButton(
                        padding: EdgeInsets.only(right: 4),
                        constraints: BoxConstraints(),
                        icon: SvgPicture.asset(
                          'assets/icons/picture.svg',
                          color: GuamColorFamily.grayscaleGray5,
                          width: 20,
                          height: 20,
                        ),
                      ),
                    Text(
                      post.title,
                      style: TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: CustomDivider(color: GuamColorFamily.grayscaleGray7),
              ),
              PostPreviewInterest(post),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  post.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    height: 20.8/13,
                    fontSize: 13,
                    fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                    color: GuamColorFamily.grayscaleGray3,
                  ),
                ),
              ),
              Row(
                children: [
                  Text(
                    post.boardType,
                    style: TextStyle(
                      fontSize: 12,
                      height: 19.2/12,
                      fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                      color: GuamColorFamily.grayscaleGray4,
                    ),
                  ),
                  Spacer(),
                  Text(
                    (DateTime.now().minute - post.createdAt.minute).toString() + "분 전",
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                      color: GuamColorFamily.grayscaleGray4,
                    ),
                  )
                ],
              ),
              PostInfo(
                post: post,
                iconColor: GuamColorFamily.grayscaleGray4,
              )
            ],
          ),
        ),
      ),
    );
  }
}
