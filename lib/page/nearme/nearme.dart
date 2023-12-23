import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_sos/model/GoogleNearMe.dart';
import 'package:my_sos/page/nearme/checkgps.dart';
import 'package:my_sos/page/widget/nearmecard.dart';
import 'package:http/http.dart' as http;

class NearMeContent extends StatefulWidget {
  const NearMeContent({Key? key}) : super(key: key);

  @override
  State<NearMeContent> createState() => _NearMeContentState();
}

class _NearMeContentState extends State<NearMeContent> {
  ScrollController scrollController = ScrollController();
  String? nextPageToken;
  List<Result> apiResults = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getNearMyPlace('hospital,pharmacy,doctor', 'โรงพยาบาล');
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      getNearMyPlace('hospital,pharmacy,doctor', 'โรงพยาบาล');
    }
  }

  @override
  Widget build(BuildContext context) {
    return (apiResults.isNotEmpty)
        ? NotificationListener<ScrollNotification>(
            child: SingleChildScrollView(
              controller: scrollController,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "สถานพยาบาลใกล้ฉัน",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                      ),
                      NearMeCard(apiResults: apiResults),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const CheckGPS();
  }

  Future<void> getNearMyPlace(String type, String keywords, {String? pageToken}) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    Position position = await _determinePosition();
    final lat = position.latitude;
    final lng = position.longitude;

    String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?';
    url += 'keyword=$keywords&location=$lat,$lng&rankby=distance&language=Th-th&type=$type';
    if (nextPageToken != null) {
      url += '&pagetoken=$nextPageToken';
    }
    url += '&key=';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      GoogleNearMe googleNearMe = googleNearMeFromJson(response.body);
      setState(() {
        apiResults.addAll(googleNearMe.results ?? []);
        nextPageToken = googleNearMe.nextPageToken;
        isLoading = false;
      });
    } else {
      print("ERROR");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
