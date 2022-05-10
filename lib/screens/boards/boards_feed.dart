import 'package:flutter/material.dart';
import 'package:guam_community_client/screens/boards/posts/post_list.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:guam_community_client/styles/fonts.dart';
import 'package:provider/provider.dart';
import 'package:guam_community_client/providers/posts/posts.dart';

class BoardsFeed extends StatefulWidget {
  final int boardId;

  BoardsFeed({this.boardId});

  @override
  State<BoardsFeed> createState() => _BoardsFeedState();
}

class _BoardsFeedState extends State<BoardsFeed> {
  List _posts = [];
  int _beforePostId;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  ScrollController _scrollController = ScrollController();

  void _firstLoad() async {
    setState(() => _isFirstLoadRunning = true);
    try {
      _posts = await context.read<Posts>().fetchPosts(widget.boardId);
    } catch (err) {
      print('알 수 없는 오류가 발생했습니다.');
    }
    setState(() => _isFirstLoadRunning = false);
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _scrollController.position.extentAfter < 300) {
      setState(() => _isLoadMoreRunning = true);
      _beforePostId = _posts.last.id;
      try {
        final fetchedPosts = await context.read<Posts>().addPosts(
          boardId: widget.boardId,
          beforePostId: _beforePostId,
        );
        if (fetchedPosts.length > 0) {
          setState(() => _posts.addAll(fetchedPosts));
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() => _hasNextPage = false);
        }
      } catch (err) {
        print('알 수 없는 오류가 발생했습니다.');
      }
      setState(() => _isLoadMoreRunning = false);
    }
  }

  @override
  void initState() {
    _firstLoad();
    _scrollController = ScrollController()..addListener(_loadMore);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isFirstLoadRunning
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () => context.read<Posts>().fetchPosts(widget.boardId),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  PostList(_posts),
                  if (_isLoadMoreRunning == true)
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (_hasNextPage == false)
                    Container(
                      color: GuamColorFamily.purpleLight2,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Center(child: Text(
                        '모든 게시글을 불러왔습니다!',
                        style: TextStyle(
                          fontSize: 13,
                          color: GuamColorFamily.grayscaleGray2,
                          fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                        ),
                      )),
                    ),
                ],
              ),
            ),
        );
  }
}
