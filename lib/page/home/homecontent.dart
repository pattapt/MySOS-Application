import 'package:flutter/material.dart';
import 'package:my_sos/page/widget/allcontact.dart';
import 'package:my_sos/page/widget/quickmenu.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});
  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with TickerProviderStateMixin {


  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);


    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MY SOS",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.only(left: 0, right: 35),
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  dividerColor: Colors.transparent,
                  indicator: CircleTabIndicator(
                      color: const Color.fromARGB(31, 24, 23, 23), radius: 4),
                  indicatorColor: Colors.transparent,
                  tabs: const [
                    Tab(
                      text: "สำคัญ",
                    ),
                    Tab(
                      text: "เหตุด่วน",
                    ),
                    Tab(
                      text: "การแพทย์",
                    ),
                    Tab(
                      text: "การเดินทาง",
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                height: 400,
                child: TabBarView(
                  controller: tabController,
                  children: [
                    QuickManu(quickMenuData: quickImportant),
                    QuickManu(quickMenuData: quickEmergency),
                    QuickManu(quickMenuData: quickMedical),
                    QuickManu(quickMenuData: quickTravel),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "เบอร์ติดต่ออื่น ๆ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const AllContact(),
            ],
          ),
        ),
      ),
    );
  }
}


class CircleTabIndicator extends Decoration {
  final Color color;
  double radius;

  CircleTabIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]){
    return _CirclePainter(color:color, radius:radius);
  }
}

class _CirclePainter extends BoxPainter{
  final double radius;
  late Color color;
  _CirclePainter({required this.color, required this.radius});

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration){
    final Offset circleOffset = offset + Offset(configuration.size!.width / 2, configuration.size!.height - radius - 5);
    final Paint paint = Paint()
      ..color = color;
    canvas.drawCircle(circleOffset, radius, paint);
  }
}
