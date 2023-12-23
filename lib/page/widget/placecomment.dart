import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:my_sos/model/GooglePlace.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceComment extends StatefulWidget {
  final List<Review>? reviews;
  const PlaceComment({Key? key, required this.reviews}) : super(key: key);
  @override
  State<PlaceComment> createState() => _PlaceCommentState();
}

class _PlaceCommentState extends State<PlaceComment> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.reviews?.length,
        itemBuilder: (context, index) {
          final item = widget.reviews?[index];
          return CommentContent(
            image: item!.profilePhotoUrl ?? '',
            name: item.authorName ?? '',
            comment: item.text ?? '',
            time: item.relativeTimeDescription ?? '',
            rating: item.rating ?? 0,
          );
        },
    );
  }
}



class CommentContent extends StatelessWidget {
  const CommentContent({
    super.key,
    required this.image,
    required this.name,
    required this.comment,
    required this.time,
    required this.rating,
  });

  final String image, name, comment, time;
  final int rating;

  @override
  Widget build(BuildContext context) {
    final ScoreText = (rating != null) ? rating.toStringAsFixed(0) : '0.0';
    return Card(
      elevation: 4,
      color: Colors.white,
      margin: const EdgeInsets.all(5),
      child: GestureDetector(
        child: SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(image),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
                              itemSize: 15,
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
                        Text(
                          comment,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



}
