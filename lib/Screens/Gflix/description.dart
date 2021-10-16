import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/rating_dialog.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/review_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Description extends StatefulWidget {
  final String name, description, bannerurl, posterurl, vote, launchOn;
  final int id;

  const Description(
      {Key key,
      this.id,
      this.name,
      this.description,
      this.bannerurl,
      this.posterurl,
      this.vote,
      // ignore: non_constant_identifier_names
      this.launchOn})
      : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  final auth = FirebaseAuth.instance;
  List reviewsResultsTMDB;
  Map reviewsResultsGFlix;
  double _rating = 3.0;
  Query result;
  DateTime date;
  String firstHalf;
  String secondHalf;
  String userEmail;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  @override
  void initState() {
    loadReviews();
    result = FirebaseFirestore.instance
        .collection("reviews")
        .where("movieId", isEqualTo: widget.id);
    userEmail = auth.currentUser.email;
    super.initState();
  }

  Future<List> loadReviews() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map reviews = await tmdbWithCustomLogs.v3.movies.getReviews(widget.id);
    if (reviews == null) {
      reviews = await tmdbWithCustomLogs.v3.tv.getReviews(widget.id);
    }
    reviewsResultsTMDB = reviews['results'];
    List empty = [];
    if (reviewsResultsTMDB == null) {
      return empty;
    } else {
      return reviewsResultsTMDB;
    }
  }

  void _showRatingAppDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return MyDialog(movieId: widget.id);
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.red,
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: modified_text(
                      text: widget.name != null ? widget.name : 'Not Loaded',
                      size: 24,
                      color: Colors.white),
                  background: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: <Color>[Colors.black, Colors.transparent])),
                    child: Image.network(
                      widget.bannerurl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 10, top: 10),
                          child: modified_text(
                            text: 'Releasing On - ' + widget.launchOn,
                            size: 14,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 200,
                              width: 100,
                              child: Image.network(widget.posterurl),
                            ),
                          ),
                          Flexible(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: modified_text(
                                  text: widget.description,
                                  size: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            modified_text(
                                text: 'Review', size: 17, color: Colors.white),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Rating',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              onPressed: _showRatingAppDialog,
                            ),
                            modified_text(
                              text: '⭐ Average Rating - ' + widget.vote,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                        child: FutureBuilder(
                            future:
                                loadReviews(), // a previously-obtained Future<String> or null
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red));
                              }
                              if (snapshot.data.isEmpty) {
                                return SizedBox();
                              }
                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      modified_text(
                                        text: 'From  ',
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SvgPicture.asset(
                                        'assets/icons/tmdb_logo.svg',
                                        height: 15.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: reviewsResultsTMDB.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Review(
                                            reviewResults:
                                                reviewsResultsTMDB[index],
                                            userEmail: userEmail);
                                      }),
                                ],
                              );
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StreamBuilder(
                            stream: result.snapshots(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red));
                              }
                              if (snapshot.data.docs.isEmpty) {
                                return SizedBox();
                              }

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      modified_text(
                                        text: 'on  ',
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      modified_text(
                                        text: 'GFlix',
                                        size: 25,
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        reviewsResultsGFlix = {
                                          "id": snapshot
                                              .data.docs[index].reference.id,
                                          "content": snapshot.data.docs[index]
                                              ["text"],
                                          "author_details": {
                                            "username": snapshot
                                                .data.docs[index]["email"],
                                            "rating": snapshot.data.docs[index]
                                                ["rating"]
                                          },
                                          "created_at": snapshot
                                              .data.docs[index]["date"]
                                              .toDate()
                                              .toString()
                                        };
                                        return Review(
                                          reviewResults: reviewsResultsGFlix,
                                          userEmail: userEmail,
                                        );
                                      })
                                ],
                              );
                            }),
                      )
                    ]),
              ),
            ],
          )),
    );
  }
}
