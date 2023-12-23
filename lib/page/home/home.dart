import 'package:flutter/material.dart';
import 'package:my_sos/page/home/homecontent.dart';
import 'package:my_sos/page/sos/soscontent.dart';
import 'package:my_sos/page/me/profile.dart';
import 'package:my_sos/page/nearme/nearme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List pageList = [
    const HomeContent(),
    const SOSContent(),
    const NearMeContent(),
    const ProfileContent(),
  ];
  int currentIndexPage = 0;
  void changePageIndex(int index) {
    setState(() {
      currentIndexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[currentIndexPage],
      floatingActionButton: currentIndexPage == 0
        ? FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () async {
              changePageIndex(1);
            },
            tooltip: 'Help',
            child: const Icon(Icons.emergency, color: Colors.white,),
          )
        : null,
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        onTap: changePageIndex,
        currentIndex: currentIndexPage,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.emergency), label: "Help"),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Me"),
        ],
      ),
    );
  }
}