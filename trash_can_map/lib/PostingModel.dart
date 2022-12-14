import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:io'; // 파일
import 'package:path_provider/path_provider.dart';

import 'package:device_info_plus/device_info_plus.dart';

class PostingModel {
  late String id;
  late String userDeviceId; // 작성자 기기번호
  late String title; // 제목
  late String content; // 본문
  String? registeredTime; // 등록일시(date 필드)

  String? tempPath;

  PostingModel(String id, String userDeviceId, String title, String content,
      {String? registeredTime, Image? image}) {

    this.id = id;
    this.userDeviceId = userDeviceId;
    this.title = title;
    this.registeredTime = registeredTime;
    this.content = content;
  }
}
