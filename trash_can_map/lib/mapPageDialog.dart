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

class MapPageDialog {
  // 마커 클릭 다이알로그
  AlertDialog getClickMarkerDialog(BuildContext context, TrashModel trash) {
    AlertDialog returnDialog = AlertDialog(
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
                child: Image.asset(
                  'lib/sub/imgNotLoad.png',
                ))
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
      backgroundColor: Colors.white54,
    );

    return returnDialog;
  }

  // 휴지통 추가 다이얼로그
  AlertDialog getAddTrashDialog(BuildContext context) {
    AlertDialog returnDialog = AlertDialog(
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
      backgroundColor: Colors.white54,
      scrollable: true,
    );
    return returnDialog;
  }
}
