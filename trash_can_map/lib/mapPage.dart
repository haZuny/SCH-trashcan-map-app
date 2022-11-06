//main.dart

import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 구글맵 api
import 'package:location/location.dart'; // 현재 좌표 구하기
import 'package:flutter/gestures.dart'; // 지도 제스처
import 'package:flutter/foundation.dart'; // 지도 제스처
import 'package:path_provider/path_provider.dart';
import 'TrascModel.dart'; // 휴지통 모델
import 'changePercentToFixel.dart'; // 화면 픽셀 계산
import 'package:flutter/services.dart'; // 진동
import 'mapPageDialog.dart'; // 다이얼로그 분리
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // 파일

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  Location location = new Location(); // 위치 클래스

  late LocationData currendLoc; // 사용자 현재 위치

  Completer<GoogleMapController> _mapController = Completer(); // 지도 컨트롤러

  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(126.734086, 127.269311)); // 지도 첫 위치

  TextEditingController searchingMapTextController =
      TextEditingController(); // 메인탭 지도 검색 텍스트필드 컨트롤러

  Color moveCurBtnColor = Colors.black26; // 플로팅 버튼 색상
  Color goNestBtnColor = Colors.black26; // 플로팅 버튼 색상
  Color addTraBtnColor = Colors.black26; // 플로팅 버튼 색상

  List<TrashModel> trashList = []; // 쓰레기통 리스트

  List<Marker> markerList = []; // 마커 리스트

  bool canAttTrash = true; // 휴지통 추가 가능 플래그

  TrashModel? addedTrash; // 추가되는 휴지통 정보 저장

  ImagePicker imagePicker = ImagePicker();

  TextEditingController textController = TextEditingController();
  Image image = Image.asset('lib/sub/imgNotLoad.png');
  ImagePicker imgPicker = ImagePicker();

  final String serverIP = 'http://220.69.208.121:8000/trash/'; // 서버 ip 주소

  // 상태 초기화
  @override
  initState() {
    super.initState();

    // get
    getTrashModel(trashList, markerList);
  }

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Image.asset(
              'lib/sub/title.png',
              width: changePercentSizeToPixel(context, 25, true),
            ),
            Image.asset(
              'lib/sub/logo.png',
              width: changePercentSizeToPixel(context, 15, true),
            )
          ]),
          backgroundColor: Colors.white,
        ),
        body: Stack(children: [
          // 지도
          GoogleMap(
            // 지도 형태
            mapType: MapType.normal,
            // 초기 위치
            initialCameraPosition: _initialPosition,
            // 현재 위치 파란점 표시
            myLocationEnabled: true,
            // 현재 위치 버튼 제거
            myLocationButtonEnabled: false,
            // 휴지통 위치 마커 추가
            markers: Set.from(markerList),
            // 줌 스크롤
            // zoomGesturesEnabled: true,
            // 제스처 인식 하도록
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
              new Factory<OneSequenceGestureRecognizer>(
                () => new EagerGestureRecognizer(),
              ),
            ].toSet(),
            // 생성자
            onMapCreated: (GoogleMapController controller) async {
              // 컨트롤러 초기화
              _mapController.complete(controller);
              // 현재 위치로 이동
              currendLoc = await location.getLocation();
              _moveLocation(currendLoc);
            },
          ),

          Positioned(
            child: Column(
              children: [
                // 현재 위치 이동 버튼
                GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.my_location,
                      size: 40,
                      color: moveCurBtnColor,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 60),
                  ),
                  onTap: () async {
                    // 깜빡임 구현
                    setState(() {
                      moveCurBtnColor = Colors.black87;
                    });
                    Future.delayed(Duration(milliseconds: 50), () {
                      setState(() {
                        moveCurBtnColor = Colors.black26;
                      });
                    });

                    // 현재 위치로 이동
                    currendLoc = await location.getLocation();
                    _moveLocation(currendLoc);
                  },
                ),

                // 가까운 쓰레기통 추천 버튼
                GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.near_me,
                      size: 40,
                      color: goNestBtnColor,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10),
                  ),
                  onTap: () async {
                    // 깜빡임 구현
                    setState(() {
                      goNestBtnColor = Colors.black87;
                    });
                    Future.delayed(Duration(milliseconds: 50), () {
                      setState(() {
                        goNestBtnColor = Colors.black26;
                      });
                    });

                    // 가장 가까운 쓰레기통 구함
                    currendLoc = await location.getLocation();
                    late Marker marker;
                    double minDistance = 9999999;
                    int minIdx = 0;
                    for (int i = 0; i < markerList.length; i++) {
                      double distance = sqrt(pow(
                              currendLoc.latitude! -
                                  markerList[i].position.latitude,
                              2) +
                          pow(
                              currendLoc.longitude! -
                                  markerList[i].position.longitude,
                              2));
                      if (distance < minDistance) {
                        minDistance = distance;
                        marker = markerList[i];
                        minIdx = i;
                      }
                    }
                    // 이동
                    final GoogleMapController controller =
                        await _mapController.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                        bearing: 0,
                        target: LatLng(marker.position.latitude!,
                            marker.position.longitude!),
                        zoom: 18,
                      ),
                    ));
                    // 팝업 띄우기
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            MakerClickDialog(trashList[minIdx]));
                  },
                ),

                // 쓰레기통 추가 버튼
                GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.loupe,
                      size: 40,
                      color: addTraBtnColor,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10),
                  ),
                  onTap: () async {
                    if (canAttTrash) {
                      canAttTrash = false;
                      // 깜빡임 구현
                      setState(() {
                        addTraBtnColor = Colors.black87;
                      });
                      Future.delayed(Duration(milliseconds: 50), () {
                        setState(() {
                          addTraBtnColor = Colors.black26;
                        });
                      });

                      // 휴지통 추가 안내 다이얼로그
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddTrashDialog();
                          });

                      // 현재 위치로 이동
                      currendLoc = await location.getLocation();
                      _moveLocation(currendLoc);
                      // 마커 리스트에 추가
                      markerList.add(Marker(
                          markerId: MarkerId("-1"),
                          position: LatLng(
                              currendLoc.latitude!, currendLoc.longitude!),
                          draggable: true,

                          // 추가 마커 한번 터치
                          onTap: () {
                            HapticFeedback.vibrate();
                            setState(() {
                              setState(() {
                                markerList.removeLast();
                              });
                              canAttTrash = true;
                            });
                          },

                          // 추가마커 드래그 시작
                          onDragStart: (LatLag) => HapticFeedback.vibrate(),

                          // 추가마커 드래그 끝
                          onDragEnd: (LatLng pos) {
                            setState(() {
                              markerList.removeLast();
                            });
                            canAttTrash = true;

                            // 다이얼로그 생성
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return GetInputAddTrashDialog(
                                      pos, trashList, markerList);
                                }).then((value) {
                              if (trashList.length > markerList.length) {
                                TrashModel trash = trashList.last;
                                setState(() {
                                  markerList
                                      .add(getDefauldMarker(trash, context));
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("오류"),
                                        content: Text("정보를 제대로 입력해주세요."),
                                        backgroundColor: Colors.white70,
                                      );
                                    });
                              }
                            });
                          }));
                    }
                  },
                ),
              ],
            ),
          )
        ]));
  }

  // get메소드, 정보 받아와서 마커, 쓰레기 리스트 수정
  Future<int> getTrashModel(
      List<TrashModel> trashList2, List<Marker> markerList2) async {
    var dio = new Dio();
    var response = await dio.get(serverIP);
    var getData = response.data;

    trashList.clear();
    markerList.clear();

    setState(() {
      for (var trash in getData) {
        trashList.add(TrashModel(
          trash['id'].toString(),
          trash['latitude'],
          trash['longitude'],
          trash['posDescription'],
          registeredTime: trash['registeredTime'],
        ));

        markerList.add(getDefauldMarker(trashList.last, context));
      }
    });

    return 0;
  }

// 지정 위치로 이동 함수
  void _moveLocation(LocationData loc) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(loc.latitude!, loc.longitude!),
        zoom: 18,
      ),
    ));
  }
}

// Get 메소드
Future<dynamic> getTrashImage(TrashModel trash) async {
  var dio = Dio();
  var res = await http.get(Uri.parse('http://220.69.208.121:8000/trash/${trash.id}'));

  // 바이트 어레이 전환
  // print('니가 그렇게 잘나가?');
  // print("씨발");
  // Uint8List bytes = base64.decode(res.body);
  // print(bytes);
  // print("씨발");



  Image img = Image.memory(base64Decode(res.body));

  return 'a';
}

Marker getDefauldMarker(TrashModel trash, BuildContext context) {
  var serverIP = 'http://127.0.0.1:8000/trash/';
  return Marker(
      markerId: MarkerId(trash.id),
      position: LatLng(trash.latitude, trash.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      // 마커 클릭
      onTap: () async {
        var newTrash = TrashModel(trash.id, trash.latitude, trash.longitude, trash.posDescription, image: await getTrashImage(trash));

          showDialog(
              context: Scaffold.of(context).context,
              builder: (context) {
                return MakerClickDialog(newTrash);
              });
      });
}
