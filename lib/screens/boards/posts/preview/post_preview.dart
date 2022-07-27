import 'package:flutter/material.dart';
import 'package:guam_community_client/commons/guam_progress_indicator.dart';
import 'package:guam_community_client/mixins/toast.dart';
import 'package:guam_community_client/models/boards/post.dart';
import 'package:guam_community_client/providers/messages/messages.dart';
import 'package:guam_community_client/providers/posts/posts.dart';
import 'package:guam_community_client/screens/app/tab_item.dart';
import 'package:guam_community_client/screens/boards/posts/detail/post_detail.dart';
import 'package:guam_community_client/screens/boards/posts/preview/post_preview_home_tab.dart';
import 'package:guam_community_client/screens/boards/posts/preview/post_preview_search_tab.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:provider/provider.dart';
import '../../../../providers/home/home_provider.dart';
import '../../../../providers/user_auth/authenticate.dart';

class PostPreview extends StatelessWidget with Toast {
  final int idx;
  final Post post;
  final Function refreshPost;

  PostPreview(this.idx, this.post, this.refreshPost);

  @override
  Widget build(BuildContext context) {
    Posts postProvider = context.read<Posts>();
    Authenticate authProvider = context.read<Authenticate>();

    Future<Post> _getPost(int id) {
      return Future.delayed(Duration(seconds: 0), () async {
        Post _post = await postProvider.getPost(id);
        return _post;
      });
    }

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
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => Posts(authProvider)),
                    ChangeNotifierProvider(create: (_) => Messages(authProvider)),
                  ],
                  child: FutureBuilder(
                    future: _getPost(post.id),
                    builder: (_, AsyncSnapshot<Post> snapshot) {
                      if (snapshot.hasData) {
                        return PostDetail(index: idx, post: snapshot.data, refreshPost: refreshPost);
                      } else if (snapshot.hasError) {
                        Navigator.pop(context);
                        postProvider.fetchPosts(0);
                        showToast(success: false, msg: '게시글을 찾을 수 없습니다.');
                        return null;
                      } else {
                        return Center(child: guamProgressIndicator());
                      }
                    }
                  ),
                ),
              ),
            );
          },
          child: TabItem.values[context.read<HomeProvider>().idx] == TabItem.search
              ? PostPreviewSearchTab(post)
              : PostPreviewHomeTab(idx, post, refreshPost)
        ),
      ),
    );
  }
}
