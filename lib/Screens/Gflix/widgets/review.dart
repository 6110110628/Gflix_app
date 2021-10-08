import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

class Review extends StatefulWidget {
  const Review({Key key, this.reviewResults}) : super(key: key);
  final Map reviewResults;
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String firstHalf;
  String secondHalf;
  bool flag = true;

  @override
  void initState() {
    super.initState();
    if (widget.reviewResults["content"].length > 200) {
      firstHalf = widget.reviewResults["content"].substring(0, 200);
      secondHalf = widget.reviewResults["content"]
          .substring(200, widget.reviewResults["content"].length);
    } else {
      firstHalf = widget.reviewResults["content"];
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime created_at = DateTime.parse(widget.reviewResults["created_at"]);
    String imgName;
    if (widget.reviewResults["author_details"]["avatar_path"] != null) {
      var uriSplit =
          widget.reviewResults["author_details"]["avatar_path"].split('/');
      int ind = uriSplit.length - 1;
      imgName = uriSplit[ind];
    }
    print(widget.reviewResults);
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
                        child: widget.reviewResults["author_details"]
                                    ["avatar_path"] ==
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
                            text: widget.reviewResults["author_details"]
                                ["username"],
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
                          text: widget.reviewResults["author_details"]
                                      ["rating"] ==
                                  null
                              ? "-"
                              : widget.reviewResults["author_details"]["rating"]
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
          // modified_text(
          //     text: widget.reviewResults["content"] ?? " ",
          //     size: 15,
          //     color: Colors.white),
          Container(
            padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: secondHalf == null
                ? new Text(firstHalf)
                : new Column(
                    children: <Widget>[
                      modified_text(
                          text: flag
                              ? (firstHalf + "...")
                              : (firstHalf + secondHalf),
                          size: 15,
                          color: Colors.white),
                      new InkWell(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            modified_text(
                                text: flag ? "show more" : "show less",
                                size: 15,
                                color: Colors.yellow),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
