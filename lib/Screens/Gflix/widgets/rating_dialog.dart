import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/review_tile.dart';
import 'package:flutter_auth/model/RatingReview.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyDialog extends StatefulWidget {
  final int movieId;
  const MyDialog({Key key, this.movieId}) : super(key: key);

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  final auth = FirebaseAuth.instance;
  String email;

  TextEditingController _controller;
  final formKey = GlobalKey<FormState>();
  RatingReview myReview = RatingReview();

  final Future<FirebaseApp> firebasereview = Firebase.initializeApp();
  CollectionReference _reviewCollection =
      FirebaseFirestore.instance.collection("reviews");
  @override
  void initState() {
    _controller = TextEditingController();
    myReview.rating = 6.0;
    myReview.movieId = widget.movieId;
    myReview.text = '';
    myReview.email = 'realchanin@gmail.com';
    myReview.date = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebasereview,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return AlertDialog(
              scrollable: true,
              content: Column(
                children: [
                  RatingBar(
                    initialRating: 3,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      half: Icon(Icons.star_half, color: Colors.amber),
                      empty: Icon(Icons.star_border, color: Colors.amber),
                    ),
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    onRatingUpdate: (rating) {
                      setState(() {
                        myReview.rating = rating * 2;
                        print("rating: ${rating * 2}");
                      });
                    },
                  ),
                  modified_text(
                    text: 'Rating: ${myReview.rating}',
                    size: 14,
                    color: Colors.black,
                  ),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      labelText: 'Tell us your comments',
                    ),
                    onChanged: (String text) {
                      myReview.text = text;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    onPressed: () async {
                      myReview.date = DateTime.now();
                      _reviewCollection.add({
                        "movieId": myReview.movieId,
                        "email": myReview.email,
                        "text": myReview.text,
                        "rating": myReview.rating,
                        "date": myReview.date
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
