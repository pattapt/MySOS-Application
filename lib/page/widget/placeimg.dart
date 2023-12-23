import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:my_sos/model/GooglePlace.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceIMGCard extends StatefulWidget {
  final List<Photo>? photos;
  const PlaceIMGCard({Key? key, required this.photos}) : super(key: key);

  @override
  State<PlaceIMGCard> createState() => _PlaceIMGCardState();
}

class _PlaceIMGCardState extends State<PlaceIMGCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        height: 300,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(
            width: 10,
          ),
          itemCount: widget.photos!.length,
          itemBuilder: (context, index) {
            final item = widget.photos![index];
            return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  "https://maps.googleapis.com/maps/api/place/photo?maxwidth=500&photoreference=${item.photoReference}&key=",
                  fit: BoxFit.cover,
                  height: 300,
                  width: 150,
                ));
          },
        ),
      ),
    );
  }
}
