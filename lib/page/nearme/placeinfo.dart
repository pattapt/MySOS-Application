import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:my_sos/model/GooglePlace.dart';
import 'package:my_sos/page/widget/place.dart';

class PlaceContent extends StatefulWidget {
  final String? placeID;

  const PlaceContent({Key? key, required this.placeID}) : super(key: key);

  @override
  State<PlaceContent> createState() => _PlaceContentState();
}

class _PlaceContentState extends State<PlaceContent> with TickerProviderStateMixin {
  Result? apiResult;
  Position? position;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition().then((value) {
      setState(() {
        position = value;
      });
    });
    getPlaceInfo(widget.placeID!);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Lottie.asset(
                "assets/animation/97930-loading.json",
                width: 350,
                fit: BoxFit.fill,
              ),
              const Spacer(),
              Text(
                "กำลังโหลดข้อมูล",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "กำลังโหลดข้อมูลอยู่ กรุณารอสักครู่",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: PlaceContentPage(apiResults: apiResult, position: position, placeID: widget.placeID),
      );
    }
  }

  Future<void> getPlaceInfo(String placeID) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/details/json?fields=address_components,adr_address,business_status,formatted_address,name,geometry,permanently_closed,photo,wheelchair_accessible_entrance,current_opening_hours,formatted_phone_number,opening_hours,secondary_opening_hours,website,rating,reservable,reviews';
    url += '&place_id=$placeID&language=Th-th&key=';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      GooglePlace googlePlace = googlePlaceFromJson(response.body);
      setState(() {
        apiResult = googlePlace.result;
        isLoading = false; // Set isLoading to false when API call is completed
      });
    } else {
      print("ERROR");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
