import 'package:flutter/material.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:guam_community_client/commons/guam_progress_indicator.dart';
import 'package:guam_community_client/models/boards/post.dart';
import 'package:guam_community_client/providers/posts/posts.dart';
import 'package:guam_community_client/providers/user_auth/authenticate.dart';
import 'package:guam_community_client/screens/boards/posts/detail/post_detail.dart';
import 'package:guam_community_client/mixins/toast.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

class Share with Toast {
  BuildContext context;
  Share(this.context);

  Future<bool> initialize() async {
    bool dynamicLinkExists = await _getInitialLink();
    _addListener();

    return dynamicLinkExists;
  }

  Future<bool> _getInitialLink() async {
    final PendingDynamicLinkData initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      _navigateScreen(initialLink.link.path);
      return true;
    }

    return false;
  }

  void _addListener() {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      _navigateScreen(dynamicLinkData.link.path);
    }).onError((e) {
      print(e);
    });
  }

  void _navigateScreen(String dynamicLink) {
    Posts postProvider = context.read<Posts>();
    Authenticate authProvider = context.read<Authenticate>();
    String link = dynamicLink.split('/').last;
    // 페이지 이동
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => Posts(authProvider)),
          ],
          child: FutureBuilder(
            future: postProvider.getPost(int.parse(link)),
            builder: (_, AsyncSnapshot<Post> snapshot) {
              if (snapshot.hasData) {
                return PostDetail(post: snapshot.data);
              } else if (snapshot.hasError) {
                Navigator.pop(context);
                showToast(success: false, msg: '공유된 게시글을 찾을 수 없습니다.');
                return null;
              } else {
                return Center(child: guamProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String> _getShortLink(int id) async {

    String dynamicLinkPrefix = 'https://wafflestudio.page.link';
    final dynamicLinkParams = DynamicLinkParameters(
      uriPrefix: dynamicLinkPrefix,
      link: Uri.parse('https://guam.wafflestudio.com/posts/$id'),
      androidParameters: const AndroidParameters(
        packageName: 'com.wafflestudio.guam_community',
        minimumVersion: 23, // 수정 필요
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.wafflestudio.guam-community',
        minimumVersion: '0', // ios 버전 입력해주세요.
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        // 임시로 입력해놨습니다.
        title: "개발자 괌",
        imageUrl: Uri.parse("https://guam.wafflestudio.com/_next/static/media/favicon.e7a111af.svg"),
      ),
    );
    final unguessableDynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );

    return unguessableDynamicLink.shortUrl.toString();
  }

  void share(int id) async{
    // 클래스 이름이 겹쳐서 import ~ as 사용했습니다.
    share_plus.Share.share(
      await _getShortLink(id),
    );
  }
}