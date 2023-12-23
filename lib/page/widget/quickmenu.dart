import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickManu extends StatefulWidget {
  final List<QuickMenuItem> quickMenuData;
  const QuickManu({Key? key, required this.quickMenuData}) : super(key: key);

  @override
  State<QuickManu> createState() => _QuickManuState();
}

class _QuickManuState extends State<QuickManu> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: (widget.quickMenuData.length / 2).ceil(),
        itemBuilder: (context, index) {
          final item1 = widget.quickMenuData[index * 2];
          final item2 = (index * 2 + 1 < widget.quickMenuData.length)
              ? widget.quickMenuData[index * 2 + 1]
              : null;

          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: QuickMenuContent(
                    image: item1.image,
                    title: item1.title,
                    description: item1.description,
                    phone: item1.phone,
                  ),
                ),
              ),
              if (item2 != null)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: QuickMenuContent(
                    image: item2.image,
                    title: item2.title,
                    description: item2.description,
                    phone: item2.phone,
                  ),
                  ),
                ),
            ],
          );
        },
    );
  }
}


class QuickMenuItem{
  final String image;
  final String title;
  final String description;
  final String phone;

  QuickMenuItem({
    required this.image,
    required this.title,
    required this.description,
    required this.phone,
  });
}

class QuickMenuContent extends StatelessWidget {
  const QuickMenuContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.phone,
  });

  final String image, phone, title, description;

  @override
  Widget build(BuildContext context) {
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
          height: 180,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(image),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 1),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callNumber(number) async{
    launchUrl(Uri.parse('tel:$number'));

    await FlutterPhoneDirectCaller.callNumber(number);
  }
}


// ITEM LIST
final List<QuickMenuItem> quickImportant = [
  QuickMenuItem(
    title: 'แจ้งเหตุด่วน',
    description: 'แจ้งเหตุด่วนเหตุร้ายกับตำรวจ',
    image: 'assets/images/emergency_icon/cop1.png',
    phone: '191',
  ),
  QuickMenuItem(
    title: 'กู้ภัย ฉุกเฉิน',
    description: 'อุบัติเหตุฉุกเฉิน เร่งด่วน',
    image: 'assets/images/emergency_icon/hospital.png',
    phone: '1669',
  ),
  QuickMenuItem(
    title: 'เพลิงไม้',
    description: 'แจ้งเหตุเพลิงไหม้',
    image: 'assets/images/emergency_icon/fire.png',
    phone: '199',
  ),
  QuickMenuItem(
    title: 'อุบัติเหตุทางน้ำ',
    description: 'แจ้งอุบัติเหตุทางน้ำ / จมน้ำ',
    image: 'assets/images/emergency_icon/water.png',
    phone: '1196',
  ),
];

final List<QuickMenuItem> quickEmergency = [
  QuickMenuItem(
    title: 'สถานนีตำรวจ',
    description: 'ติดต่อสถานนีตำรวจ',
    image: 'assets/images/emergency_icon/cop1.png',
    phone: '191',
  ),
  QuickMenuItem(
    title: 'ภัยพิบัติ',
    description: 'แจ้งเหตุภัยพิบัติฉุกเฉิน',
    image: 'assets/images/emergency_icon/disaster.png',
    phone: '192',
  ),
  QuickMenuItem(
    title: 'เพลิงไม้',
    description: 'อัคคีภัย - สัตว์ร้ายบุกบ้าน',
    image: 'assets/images/emergency_icon/fire.png',
    phone: '199',
  ),
  QuickMenuItem(
    title: 'ศูนย์ปราบขโมยรถ (สตช.)',
    description: 'แจ้งเหตุรถหาย ถูกโขมย',
    image: 'assets/images/emergency_icon/car.png',
    phone: '1192',
  ),
];

final List<QuickMenuItem> quickMedical = [
  QuickMenuItem(
    title: 'อุบัติเหตุทางน้ำ',
    description: 'แจ้งเหตุอุบัติเหตุทางน้ำ / จมน้ำ',
    image: 'assets/images/emergency_icon/water.png',
    phone: '1196',
  ),
  QuickMenuItem(
    title: 'รถพยาบาลฉุกเฉิน',
    description: 'เมื่อเจอเหตุด่วนเหตุร้ายหรือผู้ได้รับบาดเจ็บ',
    image: 'assets/images/emergency_icon/hospital.png',
    phone: '1669',
  ),
  QuickMenuItem(
    title: 'หน่วยแพทย์กู้ชีวิต',
    description: 'หน่วยแพทย์กู้ชีวิต วชิรพยาบาล',
    image: 'assets/images/emergency_icon/koo.png',
    phone: '1554',
  ),
  QuickMenuItem(
    title: 'โรงพยาบาลตำรวจ',
    description: 'ติดต่อโรงพยาบาลตำรวจ',
    image: 'assets/images/emergency_icon/hospital1.png',
    phone: '1691',
  ),
];

final List<QuickMenuItem> quickTravel = [
  QuickMenuItem(
    title: 'วิทยุ จส.100',
    description: 'แจ้งเหตุอุบัติเหตุ / รถติด / เลี่ยงเส้นทาง',
    image: 'assets/images/emergency_icon/js.png',
    phone: '1137',
  ),
  QuickMenuItem(
    title: 'สายด่วนกรมทางหลวง',
    description: 'ติดต่อเจ้าหน้าที่กรมทางหลวง',
    image: 'assets/images/emergency_icon/car4.png',
    phone: '1586',
  ),
  QuickMenuItem(
    title: 'ศูนย์ควบคุมและสั่งการจราจรตำรวจ',
    description: 'ติดต่อเจ้าหน้าที่ศูนย์ควบคุมและสั่งการจราจรตำรวจ',
    image: 'assets/images/emergency_icon/koo.png',
    phone: '1554',
  ),
  QuickMenuItem(
    title: 'การรถไฟแห่งประเทศไทย',
    description: 'สอบถามสายรถไฟ ตั๋ว และอื่น ๆ',
    image: 'assets/images/emergency_icon/train.png',
    phone: '1690',
  ),
];