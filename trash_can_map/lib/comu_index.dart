import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class IndexPage extends StatelessWidget{
  String idF = '';
  String latF = "";
  String lonF = "";

    @override
    Widget build(BuildContext context){
      return(Scaffold(
        body: Container(child: Column(children: [
          ElevatedButton(onPressed: () async {
              var res = await http.get(Uri.parse('http://220.69.208.121:8000/bins/1'));
              var res2 = await http.post(Uri.parse('http://220.69.208.121:8000/bins/'), body: json.encode({'id':'', 'latitude': '500', 'longitude': '500', 'registeredTime':'ㅁ', 'posDescription':'aaa', }));
              print(json.decode(res.body));
              print(res2.statusCode);
              print(json.decode(res2.body));


          }, child: Text("버튼"))
        ],),),
      ));
    }
}