import 'package:flutter/material.dart';
import 'package:guam_community_client/commons/custom_divider.dart';
import 'package:guam_community_client/helpers/http_request.dart';
import 'package:guam_community_client/helpers/svg_provider.dart';
import 'package:guam_community_client/mixins/toast.dart';
import 'package:guam_community_client/models/notification.dart' as Notification;
import 'package:guam_community_client/screens/notifications/notifications_type.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import '../../models/boards/post.dart';
import '../../providers/posts/posts.dart';
import '../../providers/user_auth/authenticate.dart';
import '../boards/posts/detail/post_detail.dart';

class NotificationsPreview extends StatelessWidget with Toast {
  final Notification.Notification notification;

  NotificationsPreview(this.notification);

  @override
  Widget build(BuildContext context) {
    Posts postProvider = context.read<Posts>();
    Authenticate authProvider = context.watch<Authenticate>();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Container(
            padding: EdgeInsets.only(left: 12, top: 4, bottom: 4),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(create: (_) => Posts(authProvider)),
                      ],
                      child: FutureBuilder(
                        future: postProvider.getPost(int.parse(notification.linkUrl.split('/').last)),
                        builder: (_, AsyncSnapshot<Post> snapshot) {
                          if (snapshot.hasData) {
                            return PostDetail(snapshot.data);
                          } else if (snapshot.hasError) {
                            Navigator.pop(context);
                            postProvider.fetchPosts(0);
                            showToast(success: false, msg: '게시글을 찾을 수 없습니다.');
                            return null;
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: notification.writer.profileImg != null
                                  ? NetworkImage(HttpRequest().s3BaseAuthority +  notification.writer.profileImg)
                                  : SvgProvider('assets/icons/profile_image.svg')
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Positioned(
                          top: 0,
                          child: CircleAvatar(
                            backgroundColor: GuamColorFamily.fuchsiaCore,
                            radius: 4,
                          )
                        ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.79,
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              notification.writer.nickname,
                              style: TextStyle(
                                fontSize: 13,
                                color: notification.isRead
                                    ? GuamColorFamily.grayscaleGray3
                                    : GuamColorFamily.grayscaleGray1,
                              ),
                            ),
                            Text(
                              notificationsType(notification.kind),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                                color: notification.isRead
                                    ? GuamColorFamily.grayscaleGray3
                                    : GuamColorFamily.grayscaleGray1,
                              ),
                            ),
                          ],
                        ),
                        if (notification.body != null)
                          Text(
                            notification.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.6,
                              fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                              color: notification.isRead
                                  ? GuamColorFamily.grayscaleGray4
                                  : GuamColorFamily.grayscaleGray3,
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            Jiffy(notification.createdAt).fromNow(),
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
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 28),
          child: CustomDivider(color: GuamColorFamily.grayscaleGray7),
        )
      ],
    );
  }
}
