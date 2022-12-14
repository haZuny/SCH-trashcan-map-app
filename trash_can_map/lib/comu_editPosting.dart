import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'PostingModel.dart';
import 'changePercentToFixel.dart';

class EditPosting extends StatefulWidget {
  late PostingModel posting;

  EditPosting(PostingModel posting){
    this.posting = posting;
  }

  @override
  State createState() => _EditPosting(posting);
}

class _EditPosting extends State {
  List<PostingModel> postingList = []; // 게시글 리스트
  final String serverIP = 'http://220.69.208.121:8000/posting/'; // 서버 ip 주소
  String deviceId = '';
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();
  late PostingModel posting;

  // 생성자
  _EditPosting(PostingModel posting) {
    this.posting = posting;
  }

  // 상태 초기화
  @override
  initState() {
    super.initState();
    titleController.text = posting.title;
    contentController.text = posting.content;

    setDeviceId();
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
                  "글 수정",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 20,
              ),

              // 제목
              Container(
                child: Text(
                  "제목",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20),
                ),
                width: changePercentSizeToPixel(context, 100, true),
                padding: EdgeInsets.only(left: 20),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(20),
                child: TextField(
                  controller: contentController,
                  maxLines: null,
                  decoration: InputDecoration(hintText: "내용을 입력하세요"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 취소 버튼
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text("취소")),
                  
                  // 완료 버튼
                  ElevatedButton(onPressed: () async {
                    String title = titleController.text;
                    String content = contentController.text;
                    // 제목, 본문 빈칸 확인
                    if (title == '' || content == ''){
                      showDialog(context: context, builder: (BuildContext context){
                        return AlertDialog(content: Text("제목과 내용을 입력해주세요."),actions: [TextButton(onPressed: (){Navigator.pop(context);}, child: Text("확인"))],);
                      });
                    }
                    else{
                      await sendPostingModel(title, content, deviceId);
                      Navigator.pop(context);
                    }
                  }, child: Text("완료")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // put 메소드
  Future sendPostingModel(
      String title, String content, String userDeviceId) async {
    FormData formData = FormData.fromMap(
        {'title': title, 'content': content, 'userDeviceId': userDeviceId});

    var dio = new Dio();
    var response = await dio.put(serverIP + posting.id, data: formData);

    return response;
  }

  // 기기 고유 아이디 획득
  Future<String> setDeviceId() async {
    var android = await DeviceInfoPlugin().androidInfo;
    this.deviceId = android.device;
    return android.device;
  }
}
