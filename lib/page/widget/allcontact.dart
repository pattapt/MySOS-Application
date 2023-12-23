import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class AllContact extends StatefulWidget {
  const AllContact({Key? key,}) : super(key: key);
  @override
  State<AllContact> createState() => _AllContactState();
}

class _AllContactState extends State<AllContact> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: quickMenuData.length,
        itemBuilder: (context, index) {
          final item = quickMenuData[index];
          return ContactMenuContent(
            image: item.image,
            title: item.title,
            description: item.description,
            phone: item.phone,
          );
        },
    );
  }
}


class Contact{
  final String image;
  final String title;
  final String description;
  final String phone;

  Contact({
    required this.image,
    required this.title,
    required this.description,
    required this.phone,
  });
}

class ContactMenuContent extends StatelessWidget {
  const ContactMenuContent({
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(image),
                ),
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
                          description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    _callNumber(phone);
                  },
                ),
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
final List<Contact> quickMenuData = [
  Contact(
    title: 'แจ้งเหตุด่วน',
    description: 'แจ้งเหตุด่วนเหตุร้ายกับตำรวจ',
    image: 'assets/images/emergency_icon/cop1.png',
    phone: '191',
  ),
  Contact(
    title: 'กู้ภัย ฉุกเฉิน',
    description: 'อุบัติเหตุฉุกเฉิน เร่งด่วน',
    image: 'assets/images/emergency_icon/hospital.png',
    phone: '1669',
  ),
  Contact(
    title: 'เพลิงไม้',
    description: 'แจ้งเหตุเพลิงไหม้',
    image: 'assets/images/emergency_icon/fire.png',
    phone: '199',
  ),
  Contact(
    title: 'อุบัติเหตุทางน้ำ',
    description: 'แจ้งอุบัติเหตุทางน้ำ / จมน้ำ',
    image: 'assets/images/emergency_icon/water.png',
    phone: '1196',
  ),
  Contact(
    title: 'สถานนีตำรวจท่องเที่ยว',
    description: 'ติดต่อสถานนีตำรวจท่องเที่ยว',
    image: 'assets/images/emergency_icon/cop2.png',
    phone: '1155',
  ),
  Contact(
    title: 'สายด่วนกรมทางหลวง',
    description: 'ติดต่อสายด่วนกรมทางหลวง',
    image: 'assets/images/emergency_icon/car.png',
    phone: '1586',
  ),
  Contact(
    title: 'การทางพิเศษแห่งประเทศไทย',
    description: 'ติดต่อการทางพิเศษแห่งประเทศไทย',
    image: 'assets/images/emergency_icon/car3.png',
    phone: '1543',
  ),
  Contact(
    title: 'ภัยพิบัติ',
    description: 'ติดต่อผู้ช่วยเหลือด้านภัยพิบัติ',
    image: 'assets/images/emergency_icon/disaster.png',
    phone: '192',
  ),
  Contact(
    title: 'มูลนิธิปอเต๊กตึ๊ง กทม.',
    description: 'ติดต่อการทางพิเศษแห่งประเทศไทย',
    image: 'assets/images/emergency_icon/por.png',
    phone: '1418',
  ),
  Contact(
    title: 'ตำรวจท่องเที่ยว',
    description: 'สายด่วนเหตุร้ายที่เกี่ยวข้องกับนักท่องเที่ยว',
    image: 'assets/images/emergency_icon/cop2.png',
    phone: '1155',
  ),
  Contact(
    title: 'ศูนย์ปราบขโมยรถ',
    description: 'แจ้งรถหาย ถูกโจรกรรม',
    image: 'assets/images/emergency_icon/car.png',
    phone: '1192',
  ),
  Contact(
    title: 'ตำรวจทางหลวง',
    description: 'ติดต่อเจ้าหน้าที่ตำรวจทางหลวง',
    image: 'assets/images/emergency_icon/car4.png',
    phone: '1193',
  ),
  Contact(
    title: 'สายด่วนแจ้งเหตุอาชญากรรม',
    description: 'ติดต่อกองปราบ สายด่วนแจ้งเหตุอาชญากรรม คดีร้ายแรงเป็นภัยต่อประเทศ',
    image: 'assets/images/emergency_icon/cop4.png',
    phone: '1195',
  ),
  Contact(
    title: 'ศูนย์ประชาบดี',
    description: 'เพื่อแจ้งบุคคลสูญหายเบอร์โทรฉุกเฉินเกี่ยวกับการเดินทาง',
    image: 'assets/images/emergency_icon/kidnap.png',
    phone: '1300',
  ),
  Contact(
    title: 'วิทยุ จส.100',
    description: 'เบอร์โทรฉุกเฉินแจ้งเหตุด่วนบนท้องเพื่อประสานงานต่อ',
    image: 'assets/images/emergency_icon/js.png',
    phone: '1137',
  ),
  Contact(
    title: 'กรมทางหลวงชนบท',
    description: 'ติดต่อเรื่องท้องถนนเฉพาะพื้นที่ต่างจังหวัด',
    image: 'assets/images/emergency_icon/car2.png',
    phone: '1146',
  ),
  Contact(
    title: 'ศูนย์ควบคุมและสั่งการจราจรตำรวจ',
    description: 'ติดต่อศูนย์ควบคุมและสั่งการจราจรตำรวจ',
    image: 'assets/images/emergency_icon/cop5.png',
    phone: '1197',
  ),
  Contact(
    title: 'การรถไฟแห่งประเทศไทย',
    description: 'สอบถามสายรถไฟ ตั๋ว และอื่น ๆ',
    image: 'assets/images/emergency_icon/train.png',
    phone: '1690',
  ),
  Contact(
    title: 'สายด่วนกรมทางหลวง',
    description: 'แจ้งปัญหาหรือสอบถามเกี่ยวกับการเดินทาง',
    image: 'assets/images/emergency_icon/car4.png',
    phone: '1586',
  ),
  Contact(
    title: 'การทางพิเศษแห่งประเทศไทย',
    description: 'ติดต่อการทางพิเศษแห่งประเทศไทย',
    image: 'assets/images/emergency_icon/car3.png',
    phone: '1543',
  ),
  Contact(
    title: 'หน่วยแพทย์กู้ชีวิต วชิรพยาบาล',
    description: 'ติดต่อหน่วยแพทย์กู้ชีวิต วชิรพยาบาล',
    image: 'assets/images/emergency_icon/koo.png',
    phone: '1554',
  ),
  Contact(
    title: 'โรงพยาบาลตำรวจ',
    description: 'ติดต่อโรงพยาบาลตำรวจ',
    image: 'assets/images/emergency_icon/hospital1.png',
    phone: '1691',
  ),
];
