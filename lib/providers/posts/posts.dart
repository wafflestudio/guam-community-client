import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:guam_community_client/models/boards/comment.dart';
import '../../helpers/decode_ko.dart';
import '../../helpers/http_request.dart';
import '../../models/boards/post.dart';
import '../user_auth/authenticate.dart';

class Posts with ChangeNotifier {
  Authenticate _authProvider;
  List<Post> _posts;
  List<Comment> _comments;
  int boardId = 0; // default : 피드게시판
  bool loading = false;

  Posts(Authenticate authProvider) {
    _authProvider = authProvider;
    fetchPosts(boardId);
  }

  List<Post> get posts => _posts;
  List<Comment> get comments => _comments;

  Future fetchPosts(int boardId) async {
    loading = true;
    try {
      await HttpRequest()
          .get(
        path: "community/api/v1/posts",
        queryParams: {"boardId": boardId.toString()},
        authToken: await _authProvider.getFirebaseIdToken(),
      ).then((response) async {
        if (response.statusCode == 200) {
          final jsonUtf8 = decodeKo(response);
          final List<dynamic> jsonList = json.decode(jsonUtf8)["content"];
          _posts = jsonList.map((e) => Post.fromJson(e)).toList();
          loading = false;
          // TODO: set fcm token when impl. push notification
          // setMyFcmToken();
        } else {
          final jsonUtf8 = decodeKo(response);
          final String err = json.decode(jsonUtf8)["message"];
          // TODO: show toast after impl. toast
          // showToast(success: false, msg: err);
        }
      });
      loading = false;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  Future<bool> createPost({Map<String, dynamic> fields, dynamic files}) async {
    bool successful = false;
    loading = true;

    try {
      String authToken = await _authProvider.getFirebaseIdToken();

      if (authToken.isNotEmpty) {
        await HttpRequest()
            .postMultipart(
          path: "/community/api/v1/posts",
          authToken: authToken,
          fields: fields,
          files: files,
        ).then((response) async {
          if (response.statusCode == 200) {
            final jsonUtf8 = decodeKo(response);
            final Map<String, dynamic> jsonData = json.decode(jsonUtf8);
            print(jsonData);
            successful = true;
            loading = false;
            // TODO: set fcm token when impl. push notification
            // setMyFcmToken();
          } else {
            final jsonUtf8 = decodeKo(response);
            print(jsonUtf8);
            // final String err = json.decode(jsonUtf8)["error"];
            // TODO: show toast after impl. toast
            // showToast(success: false, msg: err);
          }
        });
        loading = false;
      }
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return successful;
  }

  Future<Post> getPost(int postId) async {
    Post post;
    loading = true;

    try {
      await HttpRequest()
          .get(
        path: "community/api/v1/posts/$postId",
      ).then((response) {
        if (response.statusCode == 200) {
          final jsonUtf8 = decodeKo(response);
          final Map<String, dynamic> jsonData = json.decode(jsonUtf8);
          post = Post.fromJson(jsonData);
        } else {
          final jsonUtf8 = decodeKo(response);
          final String err = json.decode(jsonUtf8)["message"];
          // showToast(success: false, msg: err);
        }
      });
    } catch (e) {
      print(e);
    } finally {
      loading = false;
      notifyListeners();
    }
    return post;
  }

  Future fetchComments(int postId) async {
    List<Comment> comments;
    try {
      loading = true;
      await HttpRequest()
          .get(
        path: "community/api/v1/posts/$postId/comments",
        authToken: await _authProvider.getFirebaseIdToken(),
      ).then((response) async {
        if (response.statusCode == 200) {
          final jsonUtf8 = decodeKo(response);
          final List<dynamic> jsonList = json.decode(jsonUtf8)["content"];
          comments = jsonList.map((e) => Comment.fromJson(e)).toList();
          loading = false;
          // TODO: set fcm token when impl. push notification
          // setMyFcmToken();
        } else {
          final jsonUtf8 = decodeKo(response);
          final String err = json.decode(jsonUtf8)["message"];
          // TODO: show toast after impl. toast
          // showToast(success: false, msg: err);
        }
      });
      loading = false;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
    return comments;
  }
}
