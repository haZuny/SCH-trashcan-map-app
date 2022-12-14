import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'PostingModel.dart';
import 'changePercentToFixel.dart';

import 'comu_index_myPostingList.dart';
import 'comu_createPosting.dart';
import 'comu_viewPosting.dart';

class MyIndexPage extends StatefulWidget {
  String deviceId = '';

  MyIndexPage(String deviceId) {
    this.deviceId = deviceId;
  }

  @override
  State createState() => _MyIndexPage(deviceId);
}

class _MyIndexPage extends State {
  List<PostingModel> postingList = []; // 게시글 리스트
  String deviceId = '';
  final String serverIP = 'http://220.69.208.121:8000/posting/'; // 서버 ip 주소

  _MyIndexPage(String deviceId) {
    this.deviceId = deviceId;
  }

  // 상태 초기화
  @override
  initState() {
    super.initState();

    // get
    getMyPostingModel(postingList).then((value) => null);
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
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30, left: 10, bottom: 10),
                width: changePercentSizeToPixel(context, 100, true),
                child: Text(
                  "내가 쓴 글 목록",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                color: Colors.black54,
                indent: 20,
                endIndent: 20,
              ),
              Container(
                height: 20,
              ),
              Expanded(
                // 리스트뷰
                child: ListView.builder(
                    scrollDirection: Axis
                        .vertical, //vertical : 수직으로 나열 / horizontal : 수평으로 나열
                    itemCount: postingList.length, //리스트의 개수
                    itemBuilder: (BuildContext context, int index) {
                      // 각 항목
                      return Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: Card(
                          child: ListTile(
                            title: Text(
                                postingList[postingList.length - index - 1]
                                    .title),
                            trailing: Text(
                                postingList[postingList.length - index - 1]
                                    .registeredTime!
                                    .split('T')[0]),
                            subtitle: Text('작성자: ' +
                                postingList[postingList.length - index - 1]
                                    .userDeviceId),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => new ViewPostingPage(
                                          postingList[postingList.length -
                                                  index -
                                                  1]
                                              .id,
                                          postingList))).then(
                                  (value) async => await getMyPostingModel(postingList));
                            },
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // get메소드, 게시글 전체 정보 받아옴
  Future<int> getMyPostingModel(List<PostingModel> postingList) async {
    var dio = new Dio();
    var response = await dio.get(serverIP);
    var getData = response.data;

    postingList.clear();
    for (var posting in getData) {
      setState(() {
        if (posting['userDeviceId'].toString() == deviceId) {
          postingList.add(PostingModel(
            posting['id'].toString(),
            posting['userDeviceId'],
            posting['title'],
            posting['content'],
            registeredTime: posting['registeredTime'],
          ));
        }
      });
    }

    return 0;
  }
}
