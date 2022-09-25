import 'package:flutter/material.dart';
import 'package:guam_community_client/commons/custom_app_bar.dart';
import 'package:guam_community_client/providers/user_auth/authenticate.dart';
import 'package:guam_community_client/screens/boards/posts/preview/post_preview.dart';
import 'package:guam_community_client/styles/colors.dart';
import 'package:provider/provider.dart';
import '../../../commons/back.dart';
import '../../../commons/guam_progress_indicator.dart';
import '../../../styles/fonts.dart';


class MyPosts extends StatefulWidget {
  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  List? _myPosts = [];
  int _currentPage = 1;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  bool _showBackToTopButton = false;
  ScrollController _scrollController = ScrollController();

  void _firstLoad() async {
    setState(() => _isFirstLoadRunning = true);
    try {
      await context.read<Authenticate>().fetchMyPosts();
      _myPosts = context.read<Authenticate>().myPosts;
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
      try {
        _currentPage ++;
        final fetchedMyPosts = await context.read<Authenticate>().addMyPosts(
          beforePostId: _currentPage,
        );
        if (fetchedMyPosts != null && fetchedMyPosts.length > 0) {
          setState(() => _myPosts!.addAll(fetchedMyPosts));
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

  void _scrollToTop() => _scrollController
      .animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.linear);

  @override
  void initState() {
    _firstLoad();
    _scrollController = ScrollController()
      ..addListener(_loadMore)
      ..addListener(() {
        setState(() {
          if (_scrollController.offset >= 100) {
            _showBackToTopButton = true; // show the back-to-top button
          } else {
            _showBackToTopButton = false; // hide the back-to-top button
          }
        });
      });
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
        ? Center(child: guamProgressIndicator())
        : Scaffold(
            appBar: CustomAppBar(
              leading: Back(),
              title: "내가 쓴 글",
            ),
            body: RefreshIndicator(
              color: Color(0xF9F8FFF), // GuamColorFamily.purpleLight1
              onRefresh: () async => _firstLoad(),
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.only(top: 18),
                color: GuamColorFamily.purpleLight3,
                child: ListView.builder(
                    controller: _scrollController,
                    itemCount: (_myPosts!.isEmpty || _isLoadMoreRunning || (!_hasNextPage && _currentPage > 2))
                        ? _myPosts!.length + 1 : _myPosts!.length,
                    itemBuilder: (context, index){
                      if(index == 0 && _myPosts!.isEmpty) return Center(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.1),
                          child: Text(
                            '아직 작성된 글이 없습니다.',
                            style: TextStyle(
                              fontSize: 16,
                              color: GuamColorFamily.grayscaleGray4,
                              fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                            ),
                          ),
                        ),
                      );
                      // index == 0 -> header
                      else if(index == _myPosts!.length){
                        if(_isLoadMoreRunning) return Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: guamProgressIndicator(size: 40),
                        );
                        else return Container(
                          color: GuamColorFamily.purpleLight2,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Center(child: Text(
                            '작성글을 모두 불러왔습니다!',
                            style: TextStyle(
                              fontSize: 13,
                              color: GuamColorFamily.grayscaleGray2,
                              fontFamily: GuamFontFamily.SpoqaHanSansNeoRegular,
                            ),
                          )),
                        );
                      }
                      else return PostPreview(index, _myPosts![index], _firstLoad);
                    }),
              ),
            ),
            floatingActionButton: _showBackToTopButton == false
                ? null
                : FloatingActionButton(
                    mini: true,
                    onPressed: _scrollToTop,
                    backgroundColor: GuamColorFamily.purpleLight1,
                    child: Icon(Icons.arrow_upward, size: 20, color: GuamColorFamily.grayscaleWhite),
                  ),
    );
  }
}
