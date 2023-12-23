import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_sos/model/GooglePlace.dart';
import 'package:my_sos/page/widget/placecomment.dart';
import 'package:my_sos/page/widget/placeimg.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceContentPage extends StatefulWidget {
  final Result? apiResults;
  final Position? position;
  final String? placeID;
  PlaceContentPage({Key? key, required this.apiResults, required this.position, required this.placeID}) : super(key: key);

  @override
  State<PlaceContentPage> createState() => _PlaceContentPageState();
}

class _PlaceContentPageState extends State<PlaceContentPage> {
  Result? apiResult;
  double lat = 13.736717;
  double lng = 100.523186;

  @override
  void initState() {
    super.initState();
    apiResult = widget.apiResults;
  }


  @override
  Widget build(BuildContext context) {
    final businessStatus = apiResult?.businessStatus ?? '';
    final distanceText = widget.position != null
        ? calculateDistance(
            widget.position!.latitude,
            widget.position!.longitude,
            apiResult?.geometry?.location?.lat ?? 0.0,
            apiResult?.geometry?.location?.lng ?? 0.0,
          ).toStringAsFixed(1)
        : '';
    final ScoreText = apiResult?.rating != null ? apiResult!.rating?.toStringAsFixed(2) : '0.0';

    return Stack(
      children: [
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(apiResult!.photos!.isNotEmpty) PlaceIMGCard(photos: apiResult?.photos ?? []),
                      Row(
                        children: [
                          if (businessStatus == 'OPERATIONAL')
                            Text(
                              "เปิดอยู่ ",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.green,
                              ),
                            ),
                          if (businessStatus == 'CLOSED_TEMPORARILY')
                            Text(
                              "ปิดแล้ว ",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.red,
                              ),
                            ),
                          if (businessStatus == '')
                            Text(
                              "ไม่พบข้อมูล ",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          Text(
                            "| ห่างไป $distanceText ก.ม.",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey
                            ),
                          ),
                        ],
                      ),
                      Text(
                        apiResult?.name ?? '',
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 1,
                            itemSize: 25,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {

                            },
                          ),
                          Text(
                            "$ScoreText คะแนน",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),

                      if(apiResult!.openingHours != null) const SizedBox(height: 10),
                      if(apiResult!.openingHours != null) Text(
                        "เวลาทำการ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(apiResult!.openingHours != null) for(var i = 0; i < apiResult!.openingHours!.weekdayText!.length; i++)
                        Text(
                          apiResult!.openingHours!.weekdayText![i],
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.normal,
                          ),
                        ),

                      const SizedBox(height: 10),
                      Text(
                        "ที่อยู่",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        apiResult!.formattedAddress ?? '',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                        ),
                      ),

                      if (apiResult!.formattedPhoneNumber != null) const SizedBox(height: 10),
                      if (apiResult!.formattedPhoneNumber != null) Text(
                        "เบอร์โทรศัพท์",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (apiResult!.formattedPhoneNumber != null)  Text(
                        apiResult!.formattedPhoneNumber ?? '',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                        ),
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "ทางเข็นวีลแชร์สำหรับผู้พิการ",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        (apiResult!.wheelchairAccessibleEntrance == true) ? "มี" : "ไม่มี",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.normal,
                        ),
                      ),

                      if(apiResult!.reviews!.isNotEmpty) const SizedBox(height: 10),
                      if(apiResult!.reviews!.isNotEmpty) Text(
                        "รีวิว",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(apiResult!.reviews!.isNotEmpty) PlaceComment(reviews: apiResult?.reviews ?? []),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Card(
            elevation: 4,
            color: Colors.white,
            margin: const EdgeInsets.all(15),
            child: GestureDetector(
              onTap: () {
              
              },
              child: SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ต้องการความช่วยเหลือใช่หรือไม่ ?",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "คุณสามารถกดปุ่มเพื่อนำทาง หรือโทรติดต่อได้เลย!",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.map_outlined),
                        onPressed: () {
                          openGoogleMaps(widget.placeID);
                        },
                      ),
                      if (apiResult!.formattedPhoneNumber != null) IconButton(
                        icon: const Icon(Icons.phone),
                        onPressed: () {
                          callNumber(apiResult!.formattedPhoneNumber);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadius = 6371; // in kilometers

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = pow(sin(dLat / 2), 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * pow(sin(dLon / 2), 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = earthRadius * c;
    return distance;
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  void callNumber(number) async{
    launchUrl(Uri.parse('tel:$number'));

    await FlutterPhoneDirectCaller.callNumber(number);
  }


  void openGoogleMaps(placeid) async {
    Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/place/?q=place_id:$placeid');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

}
