import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

class CheckGPS extends StatefulWidget {
  const CheckGPS({super.key});
  @override
  State<CheckGPS> createState() => _CheckGPSState();
}

class _CheckGPSState extends State<CheckGPS> with TickerProviderStateMixin {
  int currentPage = 0;
  List lottie = [
    "assets/animation/97930-loading.json",
    "assets/animation/97853-on-off-switch-green.json",
    "assets/animation/75031-precise-location.json",
  ];
  List title = [
    "กำลังค้นหาสถานพยาบาลใกล้คุณ",
    "กรุณาเปิดใช้งาน GPS",
    "อนุญาติให้เข้าถึงตำแหน่งที่ตั้ง",
  ];
  List subTitle = [
    "กำลังค้นหาสถานพยาบาลใกล้คุณ กรุณารอสักครู่",
    "เพื่อเริ่มต้นใช้งานการค้นหาสถานพยาบาลใกล้คุณ กรุณาเปิดการใช้งาน GPS",
    "อนุญาติให้เราเข้าถึงตำแหน่งที่ตั้งของคุณ เพื่อค้นหาสานพยาบาลใกล้คุณ",
  ];


  @override
  void initState() {
    checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Lottie.asset(
              lottie[currentPage],
              width: 350,
              fit: BoxFit.fill,
            ),
            const Spacer(),
            Text(
              title[currentPage],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subTitle[currentPage],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }


  Future<void> checkPermission() async {
    int page = 0;
    try{
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        page = 1;
      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            page = 2;
          }
        }
        if (permission == LocationPermission.deniedForever) {
          page = 2;
        }
      }
    }catch(e){
      page = 0;
    }
    setState(() {
      currentPage = page;
    });
  }

}
