import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'dart:io'; // 파일

class TrashModel{
  late String id;
  late double latitude;
  late double longitude;
  late DateTime registeredTime;
  late String posDescription;
  Image? image;

  TrashModel(String id, double latitude, double longitude, DateTime registeredTime, String posDescription, {Image? image}){
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.registeredTime = registeredTime;
    this.posDescription = posDescription;
    if (image== null)
      image = Image.asset('lib/sub/imgNotLoad.png');
    else
      this.image = image;

  }
}