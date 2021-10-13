import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Review extends StatefulWidget {
  const Review({Key key, this.reviewResults, this.userEmail}) : super(key: key);
  final Map reviewResults;
  final String userEmail;
  @override
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String firstHalf;
  String secondHalf;
  bool flag = true;
  CollectionReference _reviewCollection =
      FirebaseFirestore.instance.collection("reviews");
  @override
  void initState() {
    super.initState();
    if (widget.reviewResults["content"].length > 200) {
      print(
          "${widget.reviewResults["author_details"]["username"]} lenght : ${widget.reviewResults["content"].length}");
      firstHalf = widget.reviewResults["content"].substring(0, 200);
      secondHalf = widget.reviewResults["content"]
          .substring(200, widget.reviewResults["content"].length);
    } else {
      print(
          "${widget.reviewResults["author_details"]["username"]} lenght : ${widget.reviewResults["content"].length}");
      firstHalf = widget.reviewResults["content"];
      secondHalf = "";
    }
    print(
        "${widget.userEmail} == ${widget.reviewResults["author_details"]["username"]}");
    print("Docs id : ${widget.reviewResults["id"]}");
  }

  void _showDeleteDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                modified_text(text: "Delete", size: 25, color: Colors.black),
                SizedBox(
                  height: 15,
                ),
                modified_text(
                    text: "Delete your review permanently?",
                    size: 15,
                    color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () async {
                        try {
                          await _reviewCollection
                              .doc(widget.reviewResults["id"])
                              .delete()
                              .then((value) => Fluttertoast.showToast(
                                  msg: "Deleted",
                                  gravity: ToastGravity.CENTER));
                        } catch (e) {
                          Fluttertoast.showToast(
                              msg: e.message, gravity: ToastGravity.CENTER);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        });
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
            child: secondHalf == ""
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      new modified_text(
                          text: firstHalf, size: 15, color: Colors.white),
                    ],
                  )
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
          ),

          Row(
            children: [
              widget.userEmail ==
                      widget.reviewResults["author_details"]["username"]
                  ? IconButton(
                      onPressed: () {
                        _showDeleteDialog();
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.white70,
                    )
                  : Container()
            ],
          )
        ],
      ),
    );
  }
}
