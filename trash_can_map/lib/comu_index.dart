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
              var res = await http.get(Uri.parse('http://172.30.1.58:8000/bins/5'));
              var res2 = await http.post(Uri.parse('http://172.30.1.58:8000/bins/'), body: json.encode({'id':'', 'x_location': '100.1234', 'y_location': '100.1234'}));
              print(json.decode(res.body));
              print(res2.statusCode);
              print(json.decode(res2.body));

          }, child: Text("버튼"))
        ],),),
      ));
    }
}