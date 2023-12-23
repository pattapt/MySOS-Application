import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_sos/page/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;

  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, keepPage: false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  itemCount: onboardData.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) => OnboardContent(
                    image: onboardData[index].image,
                    animation: onboardData[index].animation,
                    title: onboardData[index].title,
                    description: onboardData[index].description,
                  ),
                ),
              ),
              Row(
                children: [
                  ...List.generate(onboardData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Dotindicator(isActive: index == pageIndex),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 60, 
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(pageIndex == onboardData.length - 1){
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool('onboard', true);
                          await Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        }
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300), 
                          curve: Curves.ease
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.arrow_forward, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      )
    );
  }
}

class Dotindicator extends StatelessWidget {
  const Dotindicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
        color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Onboard{
  final String image;
  final String animation;
  final String title;
  final String description;

  Onboard({
    required this.image,
    required this.animation,
    required this.title,
    required this.description
  });
}


final List<Onboard> onboardData = [
  Onboard(
    title: 'ยินดีต้อนรับเข้าสู่ My SOS',
    description: 'แอพพลิเคชั่นที่จะรวมความช่วยเหลือฉุกเฉินสำหรับคุณไว้ในที่เดียว',
    image: 'assets/images/emergency_icon/SOS.png',
    animation: 'assets/animation/42618-welcome.json',
  ),
  Onboard(
    title: 'หมดปัญหาเรื่องโทรผิด',
    description: 'เรามีข้อมูลเบอร์โทรติดต่อกับสายด่วนเฉพาะทางที่พร้อมให้บริการช่วยเหลือคุณอยู่ตลอดเวลา การใช้งานก็ง่ายเพียงแค่กดความช่วยเหลือที่ต้องการ เท่านี้ก็รอคุยกับเจ้าหน้าที่ได้เลย',
    image: 'assets/images/emergency_icon/SOS.png',
    animation: 'assets/animation/114380-ambulancia.json',
  ),
  Onboard(
    title: 'ข้อมูลติดต่อฉุกเฉิน',
    description: 'เพิ่มข้อมูลติดต่อฉุกเฉินของคุณไว้ในแอพของเราสิ หากเกิดอะไรขึ้นมาผู้ที่ช่วยเหลือคุณก็ยังมีข้อมูลสำหรับติดต่อกับคนใกล้ชิดของคุณได้!',
    image: 'assets/images/emergency_icon/SOS.png',
    animation: 'assets/animation/95755-hospital-preloaded.json',
  ),
];


class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.animation,
  });

  final String image, animation, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Lottie.asset(
          animation,
          width: 350,
          fit: BoxFit.fill,
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description,
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}