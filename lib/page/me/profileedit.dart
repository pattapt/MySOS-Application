import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class EditProfileContent extends StatefulWidget {
  const EditProfileContent({super.key});
  @override
  State<EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<EditProfileContent> with TickerProviderStateMixin {
  bool isLoadPage = true;
  DateTime currentDate = DateTime.now();
  File? image;
  bool isShowImg = false;
  late SharedPreferences prefs;
  final panelController = PanelController();
  final textControllerName = TextEditingController();
  final textControllerLName = TextEditingController();
  final textControllerWeight = TextEditingController();
  final textControllerHeight = TextEditingController();
  final textControllerDisease = TextEditingController();
  final textControllerAddress = TextEditingController();
  final textControllerAbout = TextEditingController();
  int? genderSelectID = 0, bloodSelectID = 0, yaerSelectID = 2023, donationID = 0;
  List booldGroup = ["เลือกหมู่เลือดของคุณ", "A", "B", "AB", "O"];
  List genderGroup = ["เลือกเพศของคุณ", "ชาย", "หญิง"];
  List<int> yearList = [];
  String? imagePath = "";
  
  @override
  void initState() {
    isLoadPage = false;
    super.initState();

    getYear();
    getAccountData();
  }

  void getYear(){
    DateTime now = DateTime.now();
    int currentYear = now.year;
    for (int i = currentYear; i >= currentYear - 120; i--){
      yearList.add(i);
    }
    setState(() {
      yaerSelectID = currentYear;
      yearList = yearList;
    });
  }


  Future<void> getAccountData() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      textControllerName.text = prefs.containsKey("_name")
           ? prefs.getString("_name")!
           : "";
      textControllerLName.text = prefs.containsKey("_lastname")
            ? prefs.getString("_lastname")!
            : "";
      yaerSelectID = prefs.containsKey("_birthyear")
            ? prefs.getInt("_birthyear")!
            : 2023;
      textControllerDisease.text = prefs.containsKey("_disease")
            ? prefs.getString("_disease")!
            : "";
      textControllerAbout.text = prefs.containsKey("_about")
            ? prefs.getString("_about")!
            : "";
      textControllerAddress.text = prefs.containsKey("_address")
            ? prefs.getString("_address")!
            : "";
      genderSelectID = prefs.containsKey("_gender")
            ? prefs.getInt("_gender")!
            : 0;
      textControllerWeight.text = prefs.containsKey("_weight")
            ? prefs.getInt("_weight")!.toString()
            : "0";
      textControllerHeight.text = prefs.containsKey("_heigth")
            ? prefs.getInt("_heigth")!.toString()
            : "0";
      bloodSelectID = prefs.containsKey("_blood")
            ? prefs.getInt("_blood")!
            : 0;
      donationID = prefs.containsKey("_organ_donation")
            ? (prefs.getBool("_organ_donation")! == false) ? 0 : 1
            : 0;
      imagePath = prefs.containsKey("_profile_path")
           ? prefs.getString("_profile_path")!
           : null;
      if(imagePath != null && imagePath != ""){
        checkFileExists(imagePath!);
      }
    });
  }


  Future<void> saveProfile() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("_name")) {
      await prefs.setString("_name", textControllerName.text);
    }
    if (prefs.containsKey("_lastname")) {
      await prefs.setString("_lastname", textControllerLName.text);
    }
    if (prefs.containsKey("_gender")) {
      await prefs.setInt("_gender", genderSelectID!);
    }
    if (prefs.containsKey("_birthyear")) {
      await prefs.setInt("_birthyear", yaerSelectID!);
    }
    if (prefs.containsKey("_blood")) {
      await prefs.setInt("_blood", bloodSelectID!);
    }
    if (prefs.containsKey("_weight")) {
      await prefs.setInt("_weight", textControllerWeight.text.isNotEmpty ? int.parse(textControllerWeight.text) : 0);
    }
    if (prefs.containsKey("_heigth")) {
      await prefs.setInt("_heigth", textControllerHeight.text.isNotEmpty ? int.parse(textControllerHeight.text) : 0);
    }
    if (prefs.containsKey("_disease")) {
      await prefs.setString("_disease", textControllerDisease.text);
    }
    if (prefs.containsKey("_organ_donation")) {
      await prefs.setBool("_organ_donation", donationID == 0 ? false : true);
    }
    if (prefs.containsKey("_about")) {
      await prefs.setString("_about", textControllerAbout.text);
    }
    if (prefs.containsKey("_address")) {
      await prefs.setString("_address", textControllerAddress.text);
    }
    if (this.image != null) {
      String imagePath = await saveImageToLocal(image!);
      if (prefs.containsKey("_profile_path")) {
        await prefs.setString("_profile_path", imagePath);
      }
    }
    panelController.close();
    Navigator.of(context).pop();
  }

  Future<void> checkFileExists(String filePath) async {
    File file = File(filePath);
    bool check = await file.exists();
    setState(() {
      isShowImg = check;
    });
  }

  Future<String> saveImageToLocal(File imageFile) async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile/$timestamp.jpg';

    // Create the directory if it doesn't exist
    await Directory('${directory.path}/profile').create(recursive: true);

    await imageFile.copy(imagePath);
    return imagePath;
  }


  Future pickImage(ImageSource s) async{
    try{
      final image = await ImagePicker().pickImage(source: s);
      if(image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    }on PlatformException catch(e){
      print(e);
    }
  }

  Future<ImageSource?> showImageSource(BuildContext context) async{
    if(Platform.isIOS){
      return showCupertinoModalPopup<ImageSource>(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text("กล้องถ่ายรูป"),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text("คลังภาพ"),
            ),
          ],
        ),
      );
    }else{
      return showModalBottomSheet(
        context: context,
        builder: (context) => Column(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("กล้องถ่ายรูป"),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("คลังภาพ"),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        )
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    
    if(isLoadPage){
      return Container(
        color: Colors.white,
      ); 
    }else{
      return Scaffold(
        body: SlidingUpPanel(
          defaultPanelState: PanelState.CLOSED,
          controller: panelController,
          minHeight: 0,
          maxHeight: 300,
          color: Colors.transparent,
          onPanelClosed: () {
            setState(() {});
          },
          panel: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const BarIndicator(),
                  const SizedBox(height: 10),
                  const Text(
                    "ยืนยันการแก้ไขข้อมูลใช่หรือไม่",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.orange,
                    ),
                    onPressed: () {
                      saveProfile();
                    },
                    child: Text(
                      'ยืนยันการแก้ไข',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      panelController.close();
                    },
                    child: Text(
                      'ยกเลิก',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle onTap event here
                              print('Text tapped!');
                              panelController.open();
                            },
                            child: Text(
                              'บันทึก',
                              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if(image == null && (imagePath == null || imagePath == "" || !isShowImg)) ClipOval(
                                child: Image.asset(
                                  'assets/images/emergency_icon/SOS.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if(image == null && (imagePath != null && imagePath != "") && isShowImg) ClipOval(
                                child: Image.file(
                                  File(imagePath!),
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if(image != null) ClipOval(
                                child: Image.file(
                                  image!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              GestureDetector(
                                onTap: () async{
                                  // Handle onTap event here
                                  final source = await showImageSource(context);
                                  if(source == null) return;
                                  pickImage(source);
                                },
                                child: Text(
                                  'เลือกภาพใหม่',
                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "ข้อมูลทั่วไป",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                controller: textControllerName,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'ชื่อ',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                controller: textControllerLName,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'นามสกุล',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(right: 8.0),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: textControllerWeight,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'น้ำหนัก',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                controller: textControllerHeight,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'ส่วนสูง',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "เลือกปีเกิด",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      const SizedBox(height: 10),
                      if(yearList.isNotEmpty) Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          focusColor: Colors.black12,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          value: yaerSelectID,
                          style: GoogleFonts.prompt(color: Colors.black, fontSize: 16),
                          items: yearList.asMap().entries.map((entry) {
                            final int value = entry.value;
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()+" "),
                            );
                          }).toList(),
                          underline: Container(),
                          onChanged: (val) {
                            setState(() {
                              yaerSelectID = val; // Update the selected value
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          focusColor: Colors.black12,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          value: genderSelectID,
                          style: GoogleFonts.prompt(color: Colors.black, fontSize: 16),
                          items: genderGroup.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final String value = entry.value;
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(value),
                            );
                          }).toList(),
                          underline: Container(),
                          onChanged: (val) {
                            setState(() {
                              genderSelectID = val; // Update the selected value
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          focusColor: Colors.black12,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          value: bloodSelectID,
                          style: GoogleFonts.prompt(color: Colors.black, fontSize: 16),
                          items: booldGroup.asMap().entries.map((entry) {
                            final int index = entry.key;
                            final String value = entry.value;
                            return DropdownMenuItem<int>(
                              value: index,
                              child: Text(value),
                            );
                          }).toList(),
                          underline: Container(),
                          onChanged: (val) {
                            setState(() {
                              bloodSelectID = val; // Update the selected value
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          focusColor: Colors.black12,
                          icon: const Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          isExpanded: true,
                          value: donationID,
                          style: GoogleFonts.prompt(color: Colors.black, fontSize: 16),
                          items: const [
                            DropdownMenuItem(
                              value: 0,
                              child: Text("ฉันไม่ใช่ผู้บริจาคอวัยวะ"),
                            ),
                            DropdownMenuItem(
                              value: 1,
                              child: Text("ฉันเป็นผู้บริจาคอวัยวะ"),
                            ),
                          ],
                          underline: Container(),
                          onChanged: (val) {
                            setState(() {
                              bloodSelectID = val; // Update the selected value
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "ข้อมูลเกี่ยวกับฉัน",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: textControllerDisease,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'โรคประจำตัว',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: textControllerAbout,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'เกี่ยวกับฉัน',
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        margin: const EdgeInsets.only(right: 8.0),
                        child: TextField(
                          controller: textControllerAddress,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'ที่อยู่',
                          ),
                        ),
                      ),
                      const SizedBox(height: 350),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

    }
    


  }
}


class BarIndicator extends StatelessWidget{
  const BarIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding : const EdgeInsets.all(8.0),
        child: Container(
          height: 5,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}