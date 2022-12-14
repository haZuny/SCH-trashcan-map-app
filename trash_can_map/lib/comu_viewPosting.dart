import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'PostingModel.dart';
import 'changePercentToFixel.dart';

import 'comu_index_myPostingList.dart';
import 'comu_createPosting.dart';
import 'comu_editPosting.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'PostingModel.dart';

class ViewPostingPage extends StatefulWidget {
  late String id;
  List<PostingModel> postingList = [];

  // 생성자
  ViewPostingPage(String id, List<PostingModel> postingList) {
    this.id = id;
    this.postingList = postingList;
  }

  @override
  State createState() => _ViewPostingPage(id, postingList);
}

class _ViewPostingPage extends State {
  PostingModel posting =
      new PostingModel('', '', '', '', registeredTime: ''); // 게시글 리스트
  late String id;
  final String serverIP = 'http://220.69.208.121:8000/posting/'; // 서버 ip 주소
  String deviceId = '';
  List<PostingModel> postingList = [];

  // 생성자
  _ViewPostingPage(String id, List<PostingModel> postingList) {
    this.id = id;
    this.postingList = postingList;
    setDeviceId();
    setPostingModel(id);
  }

  // 상태 초기화
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
                width: changePercentSizeToPixel(context, 100, true),
                child: Text(
                  "😀😊😁😄",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              // 제목
              Container(
                child: Text(
                  textAlign: TextAlign.center,
                  posting.title,
                  style: TextStyle(fontSize: 20),
                ),
                width: changePercentSizeToPixel(context, 100, true),
                padding: EdgeInsets.only(left: 30, top: 50, bottom: 10),
              ),
              Divider(indent: 30, endIndent: 30, color: Colors.black45),

              // 내용
              Container(
                child: Text(
                  posting.content,
                  style: TextStyle(fontSize: 17),
                ),
                width: changePercentSizeToPixel(context, 100, true),
                padding: EdgeInsets.only(left: 50, top: 20, right: 50),
              ),

              // 작성 시간
              Container(
                child: Text(
                  textAlign: TextAlign.right,
                  posting.registeredTime!.split('T')[0],
                  style: TextStyle(fontSize: 13),
                ),
                width: changePercentSizeToPixel(context, 100, true),
                padding: EdgeInsets.only(left: 50, top: 50, right: 50),
              ),

              // 작성자
              Container(
                child: Text(
                  textAlign: TextAlign.right,
                  '작성자: ' + posting.userDeviceId,
                  style: TextStyle(fontSize: 13),
                ),
                width: changePercentSizeToPixel(context, 100, true),
                padding:
                    EdgeInsets.only(left: 50, top: 10, right: 50, bottom: 50),
              ),

              // 수정 삭제 버튼
              this.deviceId == posting.userDeviceId
                  ? Container(
                      padding: EdgeInsets.only(bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 수정버튼
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                new EditPosting(posting)))
                                    .then((value) {
                                  setPostingModel(id);
                                });
                              },
                              child: Text("수정")),

                          // 삭제버튼
                          ElevatedButton(
                              onPressed: () async {
                                await deletePostingModel(posting.id);
                                Navigator.pop(context);
                              },
                              child: Text("삭제")),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  // get메소드, 게시글 정보 받아옴
  Future<PostingModel> setPostingModel(String id) async {
    var dio = new Dio();
    var response = await dio.get(serverIP + id);
    var getData = response.data[0];
    print(getData);

    PostingModel posting = new PostingModel(
      getData['id'].toString(),
      getData['userDeviceId'],
      getData['title'],
      getData['content'],
      registeredTime: getData['registeredTime'],
    );

    setState(() {
      this.posting = posting;
    });
    return posting;
  }

  // delete메소드
  Future<void> deletePostingModel(String id) async {
    var dio = new Dio();
    var response = await dio.delete(serverIP + id);
  }

  // 기기 고유 아이디 획득
  Future<String> setDeviceId() async {
    var android = await DeviceInfoPlugin().androidInfo;
    setState(() {
      this.deviceId = android.device;
    });
    return android.device;
  }
}
