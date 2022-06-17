import 'dart:convert';
import 'dart:io' show File;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import '../mixins/toast.dart';

class HttpRequest with Toast {
  // TODO: Remove immigrationAuthority & @isHttps param after immigrationAuthority is merged to gateway

  final String gatewayAuthority = "guam.jon-snow-korea.com";
  final String immigrationAuthority = "guam-immigration.jon-snow-korea.com";
  final String s3BaseAuthority = "https://guam.s3.ap-northeast-2.amazonaws.com/";

  Future get({bool isHttps = false, String authority, String path, dynamic queryParams, String authToken}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path, queryParams)
          : Uri.http(authority ?? gatewayAuthority, path, queryParams);

      final response = await http.get(
        uri,
        headers: {'Content-Type': "application/json", 'Authorization': 'Bearer $authToken'},
      );

      return response;
    } catch (e) {
      print("Error on GET request: $e");
      showToast(success: false, msg: e);
    }
  }

  Future post({bool isHttps = false, String authority, String path, String authToken, dynamic queryParams, dynamic body}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path, queryParams)
          : Uri.http(authority ?? gatewayAuthority, path, queryParams);

      final response = await http.post(
        uri,
        headers: {'Content-Type': "application/json", 'Authorization': 'Bearer $authToken'},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      print("Error on POST request: $e");
      showToast(success: false, msg: e);
    }
  }

  // pluralImage boolean 으로 "images" or "image" 구분.
  Future postMultipart({bool isHttps = false, String authority, String path, String authToken, Map<String, dynamic> fields, List<File> files, bool pluralImages=true}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path)
          : Uri.http(authority ?? gatewayAuthority, path);

      http.MultipartRequest request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = 'Bearer $authToken';
      fields.entries.forEach((e) => request.fields[e.key] = e.value);

      if (files != null)
        files.forEach((e) async {
          final multipartFile = http.MultipartFile(
              pluralImages ? "images" : "image",
              e.readAsBytes().asStream(),
              e.lengthSync(),
              filename: e.path.split("/").last,
              contentType: MediaType("image", "${p.extension(e.path)}")
          );
          request.files.add(multipartFile);
        });
      http.Response response = await http.Response.fromStream(await request.send());
      return response;
    } catch (e) {
      print("Error on POST Multipart request: $e");
      showToast(success: false, msg: e);
    }
  }

  Future patch({bool isHttps = false, String authority, String path, String authToken, dynamic body}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path)
          : Uri.http(authority ?? gatewayAuthority, path);

      final response = await http.patch(
        uri,
        headers: {'Content-Type': "application/json", 'Authorization': 'Bearer $authToken'},
        body: jsonEncode(body),
      );

      return response;
    } catch (e) {
      print("Error on PUT request: $e");
      showToast(success: false, msg: e);
    }
  }

  Future patchMultipart({bool isHttps = false, String authority, String path, String authToken, Map<String, dynamic> fields, List<File> files}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path)
          : Uri.http(authority ?? gatewayAuthority, path);

      http.MultipartRequest request = http.MultipartRequest("PATCH", uri);
      request.headers['Authorization'] = 'Bearer $authToken';
      fields.entries.forEach((e) => request.fields[e.key] = e.value);

      if (files != null)
        files.forEach((e) async {
          final multipartFile = http.MultipartFile(
            "profileImage",
            e.readAsBytes().asStream(),
            e.lengthSync(),
            filename: e.path.split("/").last,
            contentType: MediaType("image", "${p.extension(e.path)}"),
          );
          request.files.add(multipartFile);
        });
      http.Response response = await http.Response.fromStream(await request.send());
      return response;
    } catch (e) {
      print("Error on PATCH Multipart request: ${e.toString()}");
      showToast(success: false, msg: e.toString());
    }
  }

  Future delete({bool isHttps = false, String authority, String path, dynamic queryParams, String authToken}) async {
    try {
      final uri = isHttps
          ? Uri.https(authority ?? gatewayAuthority, path, queryParams)
          : Uri.http(authority ?? gatewayAuthority, path, queryParams);

      final response = await http.delete(
        uri,
        headers: {'Content-Type': "application/json", 'Authorization': 'Bearer $authToken'},
      );

      return response;
    } catch (e) {
      print("Error on DELETE request: $e");
      showToast(success: false, msg: e);
    }
  }
}
