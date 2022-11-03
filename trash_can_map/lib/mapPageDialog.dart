import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // 구글맵 api
import 'package:location/location.dart'; // 현재 좌표 구하기
import 'package:flutter/gestures.dart'; // 지도 제스처
import 'package:flutter/foundation.dart'; // 지도 제스처
import 'TrascModel.dart'; // 휴지통 모델
import 'changePercentToFixel.dart'; // 화면 픽셀 계산
import 'package:flutter/services.dart'; // 진동

import 'package:image_picker/image_picker.dart';
import 'dart:io'; // 파일
import 'mapPage.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';



Color bckColor = Colors.white;

// 마커 클릭 다이얼로그
class MakerClickDialog extends StatelessWidget {
  late TrashModel trash;

  MakerClickDialog(TrashModel trash) {
    this.trash = trash;
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
            Flexible(
                fit: FlexFit.tight,
                child: trash.image == null
                    ? Image.asset(
                        'lib/sub/imgNotLoad.png',
                      )
                    : Image.file(trash.image!))
          ],
        ),
        width: changePercentSizeToPixel(context, 70, true),
        height: changePercentSizeToPixel(context, 40, false),
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
    );
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

  GetInputAddTrashDialog(
      LatLng pos, List<TrashModel> trashList, List<Marker> markerList) {
    this.pos = pos;
    this.trashList = trashList;
    this.markerList = markerList;
  }

  @override
  State<GetInputAddTrashDialog> createState() =>
      _GetInputAddTrashDialog(pos, trashList, markerList);
}

class _GetInputAddTrashDialog extends State<GetInputAddTrashDialog> {
  TextEditingController textController = TextEditingController();
  Image image = Image.asset('lib/sub/imgNotLoad.png');
  File? imgFile;
  ImagePicker imgPicker = ImagePicker();
  late LatLng pos;  // 추가되는 위치
  late List<TrashModel> trashList;  // 휴지통 리스트
  late List<Marker> markerList; // 마커 리스트
  bool isImagePick = false; // 이미지 찍혔는지 플래그
    final String serverIP = 'http://172.30.1.58:8000/bins/';  // 서버 ip 주소

  _GetInputAddTrashDialog(
      LatLng pos, List<TrashModel> trashList, List<Marker> markerList) {
    this.pos = pos;
    this.trashList = trashList;
    this.markerList = markerList;
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
                    child: Container(child: TextField(
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
            final f = await imgPicker.getImage(source: ImageSource.camera);
            imgFile = (File(f!.path));
            setState(() {
              image = Image.file(imgFile!);

              isImagePick = true;
            });
          },
        ),
        // 확인버튼
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
            // 입력 잘 했나 확인
            if (!isImagePick)
              return;
            if (textController.text == "")
              return;

            // 모델 생성
            TrashModel model = TrashModel(
                (trashList.length + 1).toString(),
                pos.latitude,
                pos.longitude,
                DateTime.now(),
                textController.text,
                image: imgFile);

            // 리스트에 추가
              trashList.add(model);
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceAround,
      backgroundColor: bckColor,
    );
  }


  // post 메소드
  Future<int> sendTrashModel(TrashModel t) async {
    Uri url = Uri.parse(serverIP);
    late String id;
    late double latitude; // x좌표
    late double longitude;  //y좌표
    late DateTime registeredTime; // 등록일시(date 필드)
    late String posDescription; // 설명
    Image? image; // 이미지(파일필드)

    var response = await http.post(Uri.parse(serverIP), body: json.encode({'id':'',
      'latitude': '${pos.latitude}',
      'longitude': '${pos.longitude}',
    'registeredTime':'${DateTime.now()}',
    'posDesciption':'${textController.text}',
    'image':''}));

    print(response.statusCode);






    return 0;
  }
}
