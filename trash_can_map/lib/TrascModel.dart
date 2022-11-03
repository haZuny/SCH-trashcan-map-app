import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:io'; // 파일
import 'package:path_provider/path_provider.dart';

class TrashModel{
  late String id;
  late double latitude; // x좌표
  late double longitude;  //y좌표
  late DateTime registeredTime; // 등록일시(date 필드)
  late String posDescription; // 설명
  File? image; // 이미지(파일필드)

  String? tempPath;

  TrashModel(String id, double latitude, double longitude, DateTime registeredTime, String posDescription, {File? image}) {
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.registeredTime = registeredTime;
    this.posDescription = posDescription;
    getTempPath().then((value) => this.tempPath = value);
    if (image== null){
      this.image = File(('${tempPath}/lib/sub/imgNotLoad.png'));
      print(tempPath);
      print("출력");
      print(this.image!.path);
    }
    else
      this.image = image;

  }

  Future<String> getTempPath() async {
      String tempPath = (await getTemporaryDirectory()).path;
      return tempPath;
  }
}