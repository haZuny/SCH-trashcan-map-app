//main.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 구글맵 api
import 'package:location/location.dart'; // 현재 좌표 구하기
import 'package:flutter/gestures.dart'; // 지도 제스처
import 'package:flutter/foundation.dart'; // 지도 제스처
import 'TrascModel.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPage();
}

class _MapPage extends State<MapPage> {
  // 위치 클래스
  Location location = new Location();

  // 사용자 현재 위치
  late LocationData currendLoc;

  // 지도 컨트롤러
  Completer<GoogleMapController> _mapController = Completer();

  // 지도 첫 위치
  final CameraPosition _initialPosition =
      CameraPosition(target: LatLng(126.734086, 127.269311));

  // 메인탭 지도 검색 텍스트필드 컨트롤러
  TextEditingController searchingMapTextController = TextEditingController();

  // 플로팅 버튼 색상
  Color moveCurBtnColor = Colors.black26;
  Color addTraBtnColor = Colors.black26;

  // 쓰레기통 리스트
  Set<TrashModel> trashList = Set();

  // 마커 리스트
  List<Marker> markerList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    trashList.add(TrashModel(
        '1', 37.390044125547675, 126.81151201344588, DateTime.now()));
    trashList.add(
        TrashModel('2', 37.39019780692878, 126.81173240672312, DateTime.now()));
    trashList.add(TrashModel(
        '3', 37.389893506516614, 126.81160330525684, DateTime.now()));
    trashList.add(
        TrashModel('4', 37.38976810517254, 126.81206942919309, DateTime.now()));
    trashList.add(TrashModel(
        '1', 37.389764733403986, 126.81136648780914, DateTime.now()));

    for (TrashModel trash in trashList) {
      markerList.add(Marker(
          markerId: MarkerId(trash.id),
          position: LatLng(trash.latitude, trash.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure),
        onTap: (){

        }
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Row(children: [
            // 검색 택스트 필드
            Expanded(
              child: TextField(
                controller: searchingMapTextController,
                // 모양잡기
                decoration: const InputDecoration(
                  hintText: '장소, 주소 입력',
                  labelText: '검색',
                ),
              ),
            ),
            // 검색 버튼
            GestureDetector(
                child: Positioned(
                  child: Icon(
                    Icons.search,
                    color: Colors.black87,
                  ),
                ),
                onTap: () {
                  setState(() {
                    searchingMapTextController.text = "";
                  });
                })
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
                // 현재 위치로
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

                // 쓰레기통 추가
                GestureDetector(
                  child: Container(
                    child: Icon(
                      Icons.loupe,
                      size: 40,
                      color: addTraBtnColor,
                    ),
                    margin: EdgeInsets.only(left: 10, top: 10),
                  ),
                  onTap: () {
                    // 깜빡임 구현
                    setState(() {
                      addTraBtnColor = Colors.black87;
                    });
                    Future.delayed(Duration(milliseconds: 50), () {
                      setState(() {
                        addTraBtnColor = Colors.black26;
                      });
                    });
                  },
                ),
              ],
            ),
          )
        ]));
  }

  void _moveLocation(LocationData loc) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(loc.latitude!, loc.longitude!),
        zoom: 20,
      ),
    ));
  }
}
