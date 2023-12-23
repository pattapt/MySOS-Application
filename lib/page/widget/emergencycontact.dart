import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyEmergencyContact extends StatefulWidget {
  final bool isEdit;
  final Function(int) removeItem;
  final Function(int) editItem;
  final List<EmergencyContact> recContacts;
  const MyEmergencyContact({Key? key, required this.isEdit, required this.recContacts, required this.removeItem, required this.editItem}) : super(key: key);
  @override
  State<MyEmergencyContact> createState() => _MyEmergencyContactState();
}

class _MyEmergencyContactState extends State<MyEmergencyContact> {
  late SharedPreferences prefs;
  late List<EmergencyContact> contacts;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.recContacts.length,
      itemBuilder: (context, index) {
        final item = widget.recContacts[index];
        return ContactMenuContent(
          id: item.id,
          title: item.title,
          relation: item.relation,
          phone: item.phone,
          isEdit: widget.isEdit,
          onRemove: () => widget.removeItem(item.id),
          onEdit: () => widget.editItem(item.id),
        );
      },
    );
  }
}

class EmergencyContact {
  late String title;
  late int relation;
  late String phone;
  final int id;
  EmergencyContact({
    required this.id,
    required this.title,
    required this.relation,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'relation': relation,
      'phone': phone,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      title: json['title'],
      relation: json['relation'],
      phone: json['phone'],
    );
  }
}

class ContactMenuContent extends StatelessWidget {
  const ContactMenuContent({
    Key? key,
    required this.id,
    required this.title,
    required this.relation,
    required this.phone,
    required this.isEdit,
    required this.onRemove,
    required this.onEdit,
  }) : super(key: key);

  final String phone, title;
  final int relation, id;
  final bool isEdit;
  final VoidCallback onRemove;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    List relationType = [
      "ไม่ได้จัดประเภท",
      "หน่วยงาน",
      "ครอบครัว",
      "พ่อหรือแม่",
      "พี่น้อง",
      "คู่ชีวิต",
      "บุตร/หลาน",
    ];

    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () {
          _callNumber(phone);
        },
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ความัมพันธ์: " + relationType[relation] + " โทร: " + phone,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isEdit)
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      _callNumber(phone);
                    },
                  ),
                if (isEdit)
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: onEdit,
                  ),
                if (isEdit)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: onRemove, // Call the onRemove callback
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callNumber(number) async {
    launchUrl(Uri.parse('tel:$number'));

    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
