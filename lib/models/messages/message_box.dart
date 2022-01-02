import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../profiles/profile.dart';

class MessageBox extends ChangeNotifier {
  final int id;
  final Profile otherProfile; // 상대방 프로필
  final String lastContent; // 가장 마지막으로 보낸 메시지 (사진만 있는 경우 '사진'으로 보냄)
  final DateTime createdAt;

  MessageBox({
    this.id,
    this.otherProfile,
    this.lastContent,
    this.createdAt,
  });

  factory MessageBox.fromJson(Map<String, dynamic> json) {
    Profile otherProfile;

    if (json['profile'] != null) {
      otherProfile = Profile.fromJson(json['otherProfile']);
    }

    return MessageBox(
      id: json['id'],
      otherProfile: otherProfile,
      lastContent: json['lastContent'],
      createdAt: json['createdAt'],
    );
  }
}
