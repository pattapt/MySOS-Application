import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_sos/page/me/profileedit.dart';
import 'package:my_sos/page/widget/emergencycontact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});
  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> with TickerProviderStateMixin {
  late SharedPreferences prefs;
  late List<EmergencyContact> contacts;
  late String? profileName, profileLastname, profileBirthday, profileDisease, profileAbout, profileAddress, profileOrganDonation, profileWeight, profileHeight, profileBlood, profileGender, profileAge, imagePath;
  bool isLoading = true, isEdit = false, isAddpanelOpen = false, isEditpanelOpen = false;
  List booldGroup = ["ไม่ได้ระบุ", "A", "B", "AB", "O"];
  List genderGroup = ["ไม่ได้ระบุ", "ชาย", "หญิง"];
  late int currentEditID;
  bool isShowImg = false;
  List<String> relationType = [
      "ไม่ได้จัดประเภท",
      "หน่วยงาน",
      "ครอบครัว",
      "พ่อหรือแม่",
      "พี่น้อง",
      "คู่ชีวิต",
      "บุตร/หลาน",
    ];
  int? relationTypeid = 0;
  DateTime currentDate = DateTime.now();
  final panelController = PanelController();

  final textControllerName = TextEditingController();
  final textControllerPhone = TextEditingController();


  @override
  void initState() {
    super.initState();
    getEmerContact();
    initializeSharedPreferences();
    isEdit = false;
  }

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    profileName = prefs.containsKey("_name")
           ? prefs.getString("_name")!
           : "";
    profileLastname = prefs.containsKey("_lastname")
           ? prefs.getString("_lastname")!
           : "";
    profileBirthday = prefs.containsKey("_birthday")
           ? prefs.getString("_birthday")!
           : "";
    profileDisease = prefs.containsKey("_disease")
           ? prefs.getString("_disease")!
           : "";
    profileAbout = prefs.containsKey("_about")
           ? prefs.getString("_about")!
           : "";
    profileAddress = prefs.containsKey("_address")
           ? prefs.getString("_address")!
           : "";
    imagePath = prefs.containsKey("_profile_path")
           ? prefs.getString("_profile_path")!
           : null;
    profileGender = prefs.containsKey("_gender")
           ? genderGroup[prefs.getInt("_gender")!]
           : "ไม่ได้ระบุ";
    profileOrganDonation = prefs.containsKey("_organ_donation")
           ? (prefs.getBool("_organ_donation")! ? "เป็นผู้บริจาคอวัยวะ" : "ไม่เป็นผู้บริจาคอวัยวะ") : "ไม่เป็นผู้บริจาคอวัยวะ";
    profileWeight = prefs.containsKey("_weight")
           ? prefs.getInt("_weight")!.toString()
           : "0";
    profileHeight = prefs.containsKey("_heigth")
           ? prefs.getInt("_heigth")!.toString()
           : "0";
    profileBlood = prefs.containsKey("_blood")
           ? booldGroup[prefs.getInt("_blood")!]
           : "ไม่ได้ระบุ";
    setState(() {
      isLoading = false;
    });
    if(imagePath != null && imagePath != ""){
      checkFileExists(imagePath!);
    }
    int? birthdateString = prefs.getInt("_birthyear");
    int? ageInYears = currentDate.year - birthdateString!;
    profileAge = ageInYears.toString();
  }


  Future<void> checkFileExists(String filePath) async {
    File file = File(filePath);
    bool check = await file.exists();
    setState(() {
      isShowImg = check;
    });
  }
  

  void saveNewItem() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJsonString = prefs.getString("_emerct");
    bool newEdit = false;

    if (contactsJsonString != null) {
      List<dynamic> contactsJson = jsonDecode(contactsJsonString);
      List<EmergencyContact> storedContacts = contactsJson.map((json) => EmergencyContact.fromJson(json)).toList();
      if(isEditpanelOpen){
        // SAVE FROM EDIT
        storedContacts[currentEditID].title = textControllerName.text;
        storedContacts[currentEditID].phone = textControllerPhone.text;
        storedContacts[currentEditID].relation = relationTypeid!;
        newEdit = true;
      }else{
        int latestId = 0;
        for (EmergencyContact contact in storedContacts) {
          if (contact.id > latestId) {
            latestId = contact.id;
          }
        }
        storedContacts.add(EmergencyContact(
          id: latestId + 1,
          title: textControllerName.text,
          relation: relationTypeid!,
          phone: textControllerPhone.text,
        ));

      }
      List<Map<String, dynamic>> contactsJsonSave = storedContacts.map((contact) => contact.toJson()).toList();
      await prefs.setString("_emerct", jsonEncode(contactsJsonSave));
      panelController.close();
      textControllerPhone.clear();
      textControllerName.clear();
      relationTypeid = 0;
      setState(() {
        isEdit = false;
        contacts = storedContacts;
      });
      
    }
  }

  void removeItem(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJsonString = prefs.getString("_emerct");

    if (contactsJsonString != null) {
      List<dynamic> contactsJson = jsonDecode(contactsJsonString);
      List<EmergencyContact> storedContacts =
          contactsJson.map((json) => EmergencyContact.fromJson(json)).toList();
      storedContacts.removeWhere((element) => element.id == id);
      List<Map<String, dynamic>> contactsJsonSave =
          storedContacts.map((contact) => contact.toJson()).toList();
      await prefs.setString("_emerct", jsonEncode(contactsJsonSave));

      setState(() {
        contacts = storedContacts;
      });
    }
  }

  void editItem(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJsonString = prefs.getString("_emerct");

    if (contactsJsonString != null) {
      List<dynamic> contactsJson = jsonDecode(contactsJsonString);
      List<EmergencyContact> storedContactsCache = contactsJson.map((json) => EmergencyContact.fromJson(json)).toList();

      List<EmergencyContact> filteredContacts = storedContactsCache.where((contact) => contact.id == id).toList();
      var selectedContact = filteredContacts.isNotEmpty ? filteredContacts.first : null;
      panelController.open();
      setState(() {
        int selectedIndex = storedContactsCache.indexOf(selectedContact!);
        isEditpanelOpen = true;
        relationTypeid = selectedContact.relation;
        textControllerName.text = selectedContact.title;
        textControllerPhone.text = selectedContact.phone;
        currentEditID = selectedIndex;
      });
    }
  }


  Future<void> getEmerContact() async {
    prefs = await SharedPreferences.getInstance();
    String? contactsJsonString = prefs.getString("_emerct");

    if (contactsJsonString != null) {
      List<dynamic> contactsJson = jsonDecode(contactsJsonString);
      List<EmergencyContact> storedContacts =
          contactsJson.map((json) => EmergencyContact.fromJson(json)).toList();
      setState(() {
        contacts = storedContacts;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Container(
        color: Colors.white,
      );
    }else{
      return SlidingUpPanel(
        defaultPanelState: PanelState.CLOSED,
        controller: panelController,
        minHeight: 0,
        color: Colors.transparent,
        onPanelClosed: (){
          setState(() {
            isEditpanelOpen = false;
          });
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BarIndicator(),
                const SizedBox(height: 10),
                Text(
                  isEditpanelOpen ? "แก้ไขข้อมูลเบอร์โทรศัพท์ติดต่อฉุกเฉิน" : "เพิ่มข้อมูลเบอร์โทรศัพท์ติดต่อฉุกเฉิน",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: textControllerName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'ชื่อผู้ติดต่อ',
                    suffixIcon: IconButton(
                      onPressed: (){
                        textControllerName.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: textControllerPhone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'หมายเลขโทรศัพท์',
                    counterText: "",
                    suffixIcon: IconButton(
                      onPressed: (){
                        textControllerPhone.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: DropdownButton(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    focusColor: Colors.black12,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 36,
                    isExpanded: true,
                    value: relationTypeid,
                    style: GoogleFonts.prompt(color: Colors.black, fontSize: 16),
                    items: relationType.asMap().entries.map((entry) {
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
                        relationTypeid = val; // Update the selected value
                      });
                      print(val);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    saveNewItem();
                  },
                  child: Text(
                    'บันทึกข้อมูล',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
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
                        const Text(
                          "ฉัน",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                        ),
                        GestureDetector(
                          onTap: () async{
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileContent()));
                          },
                          child: const Text(
                            'แก้ไขโปรไฟล์',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 255, 115, 0),
                      margin: const EdgeInsets.all(0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(imagePath != null && imagePath != "" && isShowImg) Expanded(
                            flex: 4,
                            child: Container(
                              height: 200,
                              margin: const EdgeInsets.only(right: 15),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                image: DecorationImage(
                                  image: FileImage(File(imagePath!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.only(top: 5, right: 5, bottom: 5, left: (imagePath == null || imagePath == "" || !isShowImg) ? 10 : 0,),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$profileName $profileLastname',
                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'อายุ $profileAge ปี กรุ๊ปเลือด $profileBlood',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'น้ำหนัก $profileWeight ก.ก. ส่วนสูง $profileHeight ซ.ม.',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    'เพศ : $profileGender',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  const Divider(
                                    color: Color.fromARGB(255, 230, 230, 230)
                                  ),
                                  Text(
                                    'โรคประจำตัว : $profileDisease',
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    profileOrganDonation!,
                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.person_3_outlined,
                          color: Colors.grey,
                          size: 22.0
                        ),
                        Text(
                          ' เกี่ยวกับฉัน',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Text(
                      profileAbout!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 93, 93, 93),
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 22.0
                        ),
                        Text(
                          ' ที่อยู่',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    Text(
                      profileAddress!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: const Color.fromARGB(255, 93, 93, 93),
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.phone_outlined,
                              color: Colors.grey,
                              size: 22.0
                            ),
                            Text(
                              ' รายชื่อติดต่อฉุกเฉิน',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            if(!isEdit) Container(
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    panelController.open();
                                  });
                                },
                                child: Text(
                                  "เพิ่ม",
                                  style: TextStyle(
                                    color: isEdit ? Colors.green :Colors.blue,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEdit = !isEdit;
                                });
                              },
                              child: Text(
                                isEdit ? "เสร็จสิ้น" : "แก้ไข",
                                style: TextStyle(
                                  color: isEdit ? Colors.green :Colors.red,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    MyEmergencyContact(isEdit: isEdit, recContacts: contacts, removeItem: removeItem, editItem: editItem),
                  ],
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