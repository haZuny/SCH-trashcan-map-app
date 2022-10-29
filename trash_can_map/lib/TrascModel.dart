class TrashModel{
  late String id;
  late double latitude;
  late double longitude;
  late DateTime registeredTime;

  TrashModel(String id, double latitude, double longitude, DateTime registeredTime){
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.registeredTime = registeredTime;
  }
}