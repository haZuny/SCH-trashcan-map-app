import 'package:flutter/material.dart';
import 'mapPage.dart';
import 'comu_index.dart';

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
      home: const MainPage(title: 'Trash Can Map'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});

  final String title;

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
          color: const Color(0xffC9D3F0),
          child: TabBar(
            controller: tabController,
            tabs: [
              Tab(
                  icon: Icon(
                Icons.map,
                color: mapIconColor,
              )),
              Tab(
                icon: Icon(Icons.forum, color: comuIconColor),
              )
            ],
            indicatorColor: Color(0xffC9D3F0),
          ),
        ));
  }
}
