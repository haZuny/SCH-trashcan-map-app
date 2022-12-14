import 'package:flutter/material.dart';
import 'mapPage.dart';
import 'comu_index.dart';
import 'changePercentToFixel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xffC9D3F0),
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {

  @override
  State<MainPage> createState() => _MainPage();
}

// 구현
class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  // 탭 컨트롤러
  late TabController tabController;

  // 탭바 아이콘 색상
  Color mapIconColor = Colors.black87;
  Color comuIconColor = Colors.black26;

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      int pageNum = tabController.index;
      setState(() {
        if (pageNum == 0) {
          mapIconColor = Colors.black87;
          comuIconColor = Colors.black26;
        } else {
          mapIconColor = Colors.black26;
          comuIconColor = Colors.black87;
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: TabBarView(
          children: [MapPage(), IndexPage()],
          controller: tabController,
        ),
        bottomNavigationBar: Container(
          // 네비게이터 꾸미기
          decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 0.1,
                ),
              )),
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  icon: Icon(
                    Icons.pin_drop,
                    color: mapIconColor,
                    size: changePercentSizeToPixel(context, 10, true),
                  )),
              Tab(
                icon: Icon(
                  Icons.forum,
                  color: comuIconColor,
                  size: changePercentSizeToPixel(context, 10, true),
                ),
              )
            ],
            // indicatorColor: Color(0xffC9D3F0),
            indicatorColor: Colors.black,

            isScrollable: false,
          ),
        ));
  }
}
