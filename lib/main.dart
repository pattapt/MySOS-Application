import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sos/page/widget/emergencycontact.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_sos/page/onboarding/onboarding.dart';
import 'package:my_sos/page/home/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboard = prefs.getBool('onboard') ?? false;


  if (!prefs.containsKey("_name")) {
    await prefs.setString("_name", "ยังไม่ได้ระบุ");
  }
  if (!prefs.containsKey("_lastname")) {
    await prefs.setString("_lastname", "");
  }
  if (!prefs.containsKey("_gender")) {
    await prefs.setInt("_gender", 1);
  }
  if (!prefs.containsKey("_birthyear")) {
    await prefs.setInt("_birthyear", 2023);
  }
  if (!prefs.containsKey("_blood")) {
    await prefs.setInt("_blood", 1);
  }
  if (!prefs.containsKey("_weight")) {
    await prefs.setInt("_weight", 60);
  }
  if (!prefs.containsKey("_heigth")) {
    await prefs.setInt("_heigth", 180);
  }
  if (!prefs.containsKey("_disease")) {
    await prefs.setString("_disease", "ไม่มี");
  }
  if (prefs.containsKey("_organ_donation")) {
    await prefs.setBool("_organ_donation", false);
  }
  if (!prefs.containsKey("_about")) {
    await prefs.setString("_about", "ยังไม่ได้ระบุข้อมูลส่วนตัว");
  }
  if (!prefs.containsKey("_address")) {
    await prefs.setString("_address", "ยังไม่ได้ระบุข้อมูลที่อยู่");
  }
  if (!prefs.containsKey("_profile_path")) {
    await prefs.setString("_profile_path", "");
  }

  if (!prefs.containsKey("_emerct")) {
    List<EmergencyContact> contacts = [
      EmergencyContact(id: 1, title: "สถานีตำรวจ", relation: 1, phone: "191"),
      EmergencyContact(id: 2, title: "รถพยาบาลฉุกเฉิน", relation: 1, phone: "1669"),
    ];

    List<Map<String, dynamic>> contactsJson = contacts.map((contact) => contact.toJson()).toList();
    await prefs.setString("_emerct", jsonEncode(contactsJson));
  }
  

  runApp(MyApp(onboard: onboard));
}

class MyApp extends StatelessWidget {
  final bool onboard;
  const MyApp({
    Key? key,
    required this.onboard,
  }) : super(key: key);
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MY SOS',
      theme: _buildTheme(Brightness.light),
      home: onboard ? const HomePage() : const OnBoardingPage(),
    );
  }

  ThemeData _buildTheme(brightness) {
    var baseTheme = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 255, 255, 255), secondary: Color.fromARGB(255, 255, 255, 255),),
        useMaterial3: true,
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.promptTextTheme(baseTheme.textTheme),
    );
  }
}