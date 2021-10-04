import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

class Review extends StatelessWidget {
  final Map reviewResults;
  const Review({Key key, this.reviewResults}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime created_at = DateTime.parse(reviewResults["created_at"]);
    String imgName;
    if (reviewResults["author_details"]["avatar_path"] != null) {
      var uriSplit = reviewResults["author_details"]["avatar_path"].split('/');
      int ind = uriSplit.length - 1;
      imgName = uriSplit[ind];
    }
    print(reviewResults);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: Colors.white70,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 5,
                child: Row(
                  children: [
                    SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: reviewResults["author_details"]["avatar_path"] ==
                                null
                            ? Image.asset(
                                'assets/images/avatar.png',
                                height: 50.0,
                                width: 50.0,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                width: 50.0,
                                height: 50.0,
                                imageUrl:
                                    "https://secure.gravatar.com/avatar/$imgName",
                                placeholder: (context, url) => Image.asset(
                                    'assets/images/avatar.png',
                                    height: 50.0,
                                    width: 50.0,
                                    fit: BoxFit.cover),
                                errorWidget: (context, url, error) =>
                                    Image.asset('assets/images/avatar.png',
                                        height: 50.0,
                                        width: 50.0,
                                        fit: BoxFit.cover),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        modified_text(
                            text: reviewResults["author_details"]["username"],
                            size: 15,
                            color: Colors.white),
                        modified_text(
                            text:
                                "${created_at.day}/${created_at.month}/${created_at.year}",
                            size: 13,
                            color: Colors.white60),
                      ],
                    )
                  ],
                ),
              ),
              Flexible(flex: 1, child: SizedBox()),
              Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      modified_text(
                          text: "rating", size: 13, color: Colors.white60),
                      modified_text(
                          text:
                              reviewResults["author_details"]["rating"] == null
                                  ? "-"
                                  : reviewResults["author_details"]["rating"]
                                      .toString(),
                          size: 20,
                          color: Colors.white),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          modified_text(
              text: reviewResults["content"] ?? " ",
              size: 15,
              color: Colors.white),
        ],
      ),
    );
  }
}
