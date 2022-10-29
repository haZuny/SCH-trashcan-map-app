import 'dart:io';

class TrashModel{
  late String id;
  late double latitude;
  late double longitude;
  late DateTime registeredTime;
  late String posDescription;
  File? image;

  TrashModel(String id, double latitude, double longitude, DateTime registeredTime, String posDescription,){
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.registeredTime = registeredTime;
    this.posDescription = posDescription;

  }
}