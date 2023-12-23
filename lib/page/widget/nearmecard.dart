import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_sos/model/GoogleNearMe.dart';
import 'package:my_sos/page/nearme/placeinfo.dart';
import 'package:url_launcher/url_launcher.dart';

class NearMeCard extends StatefulWidget {
  List<Result> apiResults;
  NearMeCard({Key? key, required this.apiResults}) : super(key: key);

  @override
  State<NearMeCard> createState() => _NearMeCardState();

  void getNearMyPlace(String s, String t) {}
}

class _NearMeCardState extends State<NearMeCard> {
  double lat = 13.736717;
  double lng = 100.523186;

  @override
  void initState() {
    getCurrentPostion(); 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.apiResults.length,
      itemBuilder: (context, index) {
        final item = widget.apiResults[index];
        if(item.businessStatus == 'CLOSED_PERMANENTLY') return null;
        return NearMeCardContent(
          title: item.name ?? '',
          description: item.vicinity ?? '',
          placeID: item.placeId ?? '',
          distance: calculateDistance(lat, lng, item.geometry?.location?.lat ?? 0, item.geometry?.location?.lng ?? 0),
          businessStatus: item.businessStatus ?? '',
        );
      },
    );
  }

  Future<void> getCurrentPostion() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lng = position.longitude;
    });
  }
  

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }


}

class NearMeCardContent extends StatelessWidget {
  const NearMeCardContent({
    super.key,
    required this.title,
    required this.description,
    required this.placeID,
    required this.distance,
    required this.businessStatus,
  });

  final String? placeID, title, description, businessStatus;
  final double? distance;

  @override
  Widget build(BuildContext context) {
    String distanceText = distance!.toStringAsFixed(2);

    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      child: GestureDetector(
        onTap: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceContent(placeID: placeID)));
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
                          title!,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            if(businessStatus == 'OPERATIONAL') const Text(
                              "เปิดอยู่ ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                              ),
                            ),
                            if(businessStatus == 'CLOSED_TEMPORARILY') const Text(
                              "ปิดแล้ว ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                              ),
                            ),
                            if(businessStatus == '') const Text(
                              "ไม่พบข้อมูล ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "| ห่างไป $distanceText ก.ม.",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          description!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: () async{
                    await Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceContent(placeID: placeID)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}