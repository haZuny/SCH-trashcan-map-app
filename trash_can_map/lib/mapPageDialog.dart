import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 구글맵 api
import 'package:location/location.dart'; // 현재 좌표 구하기
import 'package:flutter/gestures.dart'; // 지도 제스처
import 'package:flutter/foundation.dart'; // 지도 제스처
import 'package:path_provider/path_provider.dart';
import 'TrascModel.dart'; // 휴지통 모델
import 'changePercentToFixel.dart'; // 화면 픽셀 계산
import 'package:flutter/services.dart'; // 진동

import 'package:image_picker/image_picker.dart';
import 'dart:io'; // 파일
import 'mapPage.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import 'package:path/path.dart';

import 'package:device_info_plus/device_info_plus.dart';

Color bckColor = Colors.white;

// 마커 클릭 다이얼로그
class MakerClickDialog extends StatefulWidget {
  late List<TrashModel> trashList;
  late List<Marker> markerList;
  String deviceId = '';
  late TrashModel trash;

  MakerClickDialog(TrashModel trash, String deviceId,
      List<TrashModel> trashList, List<Marker> markerList) {
    this.trash = trash;
    this.deviceId = deviceId;
    this.trashList = trashList;
    this.markerList = markerList;
  }

  @override
  State createState() =>
      _MakerClickDialog(trash, deviceId, trashList, markerList);
}

class _MakerClickDialog extends State {
  late TrashModel trash;
  String serverIP = 'http://220.69.208.121:8000/trash/';
  String deviceId = '';

  late List<TrashModel> trashList;
  late List<Marker> markerList;

  // String serverIP = 'http://127.0.0.1:8000/trash/';

  _MakerClickDialog(TrashModel trash, String deviceId,
      List<TrashModel> trashList, List<Marker> markerList) {
    this.trash = trash;
    // setDeviceId();
    this.deviceId = deviceId;
    this.trashList = trashList;
    this.markerList = markerList;
    print("바보야");
    print(deviceId);
    print(this.deviceId);
    print(trash.deviceId);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        "휴지통",
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "위치: \t\t\t\t",
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
                Flexible(
                    child: Text(
                  trash.posDescription,
                )),
              ],
            ),
            Container(
              height: 20,
            ),
            Flexible(
                fit: FlexFit.tight,
                child: trash.image == null
                    ? Image.asset(
                        'lib/sub/imgNotLoad.png',
                      )
                    : trash.image!)
          ],
        ),
        width: changePercentSizeToPixel(context, 70, true),
        height: changePercentSizeToPixel(context, 40, false),
      ),

      actions: <Widget>[
        // 본인이 작성자일 때만 삭제버튼 활성화
        this.deviceId.compareTo(trash.deviceId) == 0
            ? new TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
                child: new Text("삭제"),
                onPressed: () async {
                  // marker 삭제
                  int i = 0;
                  for (i = 0; i < markerList.length; i++) {
                    if (markerList[i].markerId.value == trash.id) {
                      break;
                    }
                  }
                  setState(() {
                    markerList.removeAt(i);
                  });

                  // trash 삭제
                  i = 0;
                  for (i = 0; i < trashList.length; i++) {
                    if (trashList[i].id == trash.id) {
                      break;
                    }
                  }
                  setState(() {
                    trashList.removeAt(i);
                  });

                  deleteTrash(trash);

                  Navigator.pop(context);
                },
              )
            : Container(),

        new TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      backgroundColor: bckColor,
    );
  }

  // Get 메소드
  Future<Image> getTrashImage(TrashModel trash) async {
    final String serverIP =
        'http://220.69.208.121:8000/trash/${trash.id}'; // 서버 ip 주소
    // final String serverIP = 'http://127.0.0.1:8000/trash/${trash.id}'; // 서버 ip 주소
    var dio = Dio();
    var res = await dio.get(serverIP);
    var bytes = utf8.encode(res.data);

    Uint8List bytes2 = Uint8List.fromList(bytes);
    // XFile file = XFile.fromData(bytes2);
    Image img = Image.memory(bytes2);
    return img;
  }

  // Delete 메소드
  Future<int> deleteTrash(TrashModel trash) async {
    final String serverIP =
        'http://220.69.208.121:8000/trash/${trash.id}'; // 서버 ip 주소
    print(serverIP);
    print("아이피");
    // final String serverIP = 'http://127.0.0.1:8000/trash/${trash.id}'; // 서버 ip 주소
    var dio = Dio();
    await dio.head(serverIP);

    return 0;
  }

  // 디바이스 아이디 설정
  Future<String> setDeviceId() async {
    var android = await DeviceInfoPlugin().androidInfo;
    this.deviceId = android.device;
    return android.device;
  }
}

// 휴지통 추가 안내 다이얼로그
class AddTrashDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        "휴지통 추가",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        child: Flexible(
            child: Text(
          "빨간색 마크를 꾹 눌러 위치를 설정해 주세요. 취소하시려면 마크를 한번 터치해주세요.",
        )),
        width: changePercentSizeToPixel(context, 30, true),
        // height: changePercentSizeToPixel(
        //     context, 10, false),
      ),
      actions: <Widget>[
        new TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      backgroundColor: bckColor,
      scrollable: true,
    );
  }
}

// 휴지통 추가 정보 입력 다이얼로그
class GetInputAddTrashDialog extends StatefulWidget {
  late LatLng pos;
  late List<TrashModel> trashList;
  late List<Marker> markerList;
  late BuildContext context2;

  GetInputAddTrashDialog(LatLng pos, List<TrashModel> trashList,
      List<Marker> markerList, BuildContext context2) {
    this.pos = pos;
    this.trashList = trashList;
    this.markerList = markerList;
    this.context2 = context2;
  }

  @override
  State<GetInputAddTrashDialog> createState() =>
      _GetInputAddTrashDialog(pos, trashList, markerList, context2);
}

class _GetInputAddTrashDialog extends State<GetInputAddTrashDialog> {
  TextEditingController textController = TextEditingController();
  Image image = Image.asset('lib/sub/imgNotLoad.png');
  XFile? imgXFile;
  File? imgFile;
  ImagePicker imgPicker = ImagePicker();
  late LatLng pos; // 추가되는 위치
  late List<TrashModel> trashList; // 휴지통 리스트
  late List<Marker> markerList; // 마커 리스트
  late BuildContext context2;
  bool isImagePick = false; // 이미지 찍혔는지 플래그
  final String serverIP = 'http://220.69.208.121:8000/trash/'; // 서버 ip 주소
  String deviceId = '';

  _GetInputAddTrashDialog(LatLng pos, List<TrashModel> trashList,
      List<Marker> markerList, BuildContext context2) {
    this.pos = pos;
    this.trashList = trashList;
    this.markerList = markerList;
    this.context2 = context2;
    setDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      title: Text(
        "휴지통 추가",
        textAlign: TextAlign.center,
      ),
      content: Container(
        width: changePercentSizeToPixel(context, 70, true),
        height: changePercentSizeToPixel(context, 40, false),
        child: Column(
          children: [
            // 텍스트 필드
            Row(
              children: [
                Flexible(
                    child: Container(
                  child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: '위치를 자세히 설명해주세요.',
                        labelText: '위치 설명',
                      )),
                  margin: EdgeInsets.only(bottom: 20),
                ))
              ],
            ),
            // 이미지
            Flexible(fit: FlexFit.tight, child: image)
          ],
        ),
      ),
      // 버튼
      actions: <Widget>[
        // 사진 찍기 버튼
        TextButton(
          child: new Text("사진 찍기"),
          onPressed: () async {
            imgXFile =
                await imgPicker.pickImage(source: ImageSource.camera) as XFile?;
            imgFile = (File(imgXFile!.path));
            setState(() {
              image = Image.file(imgFile!);

              isImagePick = true;
            });
          },
        ),
        // 확인버튼
        TextButton(
          child: new Text("확인"),
          onPressed: () async {
            // 입력 잘 했나 확인
            if (textController.text == "") {
              print("종료1");
              Navigator.pop(context);
              return;
            } else if (!isImagePick) {
              print('종료2');
              Navigator.pop(context);
              return;
            } else {
              // 정보 전송
              sendTrashModel().then((value) {
                // 모델 생성
                TrashModel model = TrashModel(value.toString(), pos.latitude,
                    pos.longitude, textController.text, deviceId);

                // 리스트에 추가
                setState(() {
                  trashList.add(model);
                  print(model.id);
                });
                Navigator.pop(context);
              });
            }
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      backgroundColor: bckColor,
    );
  }

  // post 메소드
  Future<int> sendTrashModel() async {
    FormData formData = FormData.fromMap({
      'id': '',
      'latitude': '${pos.latitude}',
      'longitude': '${pos.longitude}',
      'registeredTime': '',
      'posDescription': '${textController.text}',
      'image': await MultipartFile.fromFile(imgFile!.path),
      'deviceId': '${this.deviceId}'
    });

    var dio = new Dio();
    var response = await dio.post(serverIP, data: formData);

    return response.data['id'];
  }

  Future<String> setDeviceId() async {
    var android = await DeviceInfoPlugin().androidInfo;
    this.deviceId = android.device;
    return android.device;
  }
}
