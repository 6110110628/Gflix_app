import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/index.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/Description/components/cast.dart';
import 'package:flutter_auth/Screens/Gflix/Description/components/rating_dialog.dart';
import 'package:flutter_auth/Screens/Gflix/Description/components/review_tile.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Description extends StatefulWidget {
  final String name,
      description,
      bannerurl,
      posterurl,
      vote,
      launchOn,
      mediaType;
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
      this.launchOn,
      this.mediaType})
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
  List casts = [];
  Map reviewsResultsGFlix;
  Map castsResults;
  double _rating = 3.0;
  Query result;
  DateTime date;
  String firstHalf;
  String secondHalf;
  String userEmail;
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;
  String videoId;
  @override
  void initState() {
    loadReviews();
    loadVideo();
    loadCasts();
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

  loadCasts() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    if (widget.mediaType == 'tv') {
      castsResults = await tmdbWithCustomLogs.v3.tv.getCredits(widget.id);
    } else {
      castsResults = await tmdbWithCustomLogs.v3.movies.getCredits(widget.id);
    }

    setState(() {
      casts = castsResults['cast'];
    });
  }

  Future<List> loadVideoResults(String language) async {
    final videoURL =
        'https://api.themoviedb.org/3/${widget.mediaType}/${widget.id}/videos?api_key=$apikey&language=$language';
    final response = await http.get(Uri.parse(videoURL));
    var temp = utf8.decode(response.bodyBytes);
    Map<String, dynamic> js = jsonDecode(temp);
    // print('loadVideoResults : ' + js['results']);
    return js['results'];
  }

  Future<String> getVideoId(List results) async {
    List videoOfficial = results
        .where((element) =>
            element["site"] == "YouTube" &&
            (element["type"] == "Trailer" || element["type"] == "Teaser"))
        .toList();
    videoId = videoOfficial[0]["key"];
    // String videoLink = "https://youtu.be/" + videoOfficial[0]["key"];
    print("videoLink : https://youtu.be/" + videoId);
    return videoId;
  }

  Future<String> loadVideo() async {
    List results = await loadVideoResults('th-TH');
    if (results == null || results.length == 0) {
      results = await loadVideoResults('en-US');
      return getVideoId(results);
    } else {
      results = await loadVideoResults('th-TH');
      return getVideoId(results);
    }
  }

  Widget youtubePlayer() {
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoId,
      params: YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        modified_text(
          text: 'Trailer',
          size: 20,
          color: Colors.white,
        ),
        SizedBox(
          height: 10,
        ),
        YoutubePlayerIFrame(
          controller: _controller,
          aspectRatio: 16 / 9,
        ),
      ],
    );
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
                backgroundColor: Colors.red[900],
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                expandedHeight: 160.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: modified_text(
                            text: widget.name != null
                                ? widget.name
                                : 'Not Loaded',
                            size: widget.name.length > 20 ? 18 : 22,
                            color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 16),
                        child: Container(
                          height: 25,
                          width: 35,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) {
                                return IndexScreen();
                              }), (Route<dynamic> route) => false);
                            },
                            icon: Image.asset(
                              'assets/images/gflix.png',
                              height: 30.0,
                              width: 50.0,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  background: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                            colors: <Color>[Colors.black, Colors.transparent])),
                    child: widget.bannerurl == 'empty'
                        ? Container()
                        : Image.network(
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
                            text: widget.launchOn == 'unknown'
                                ? 'Releasing On : unknown'
                                : 'Releasing On : ' +
                                    widget.launchOn.substring(8, 10) +
                                    '/' +
                                    widget.launchOn.substring(5, 7) +
                                    '/' +
                                    widget.launchOn.substring(0, 4),
                            size: 14,
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Container(
                              height: 180,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: widget.posterurl == 'empty'
                                    ? Image.asset(
                                        'assets/images/cast.png',
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(widget.posterurl),
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                                padding: EdgeInsets.all(10),
                                child: modified_text(
                                  text: widget.description,
                                  size: 15,
                                  color: Colors.white,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: FutureBuilder(
                            future: loadVideo(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return youtubePlayer();
                              } else {
                                return Container();
                              }
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Cast(
                        casts: casts,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                modified_text(
                                    text: 'Review',
                                    size: 20,
                                    color: Colors.white),
                                modified_text(
                                  text: '⭐ Average Rating : ' + widget.vote,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              color: Colors.red[900],
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Text(
                                'Rating',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                              onPressed: _showRatingAppDialog,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
                        child: FutureBuilder(
                            future:
                                loadReviews(), // a previously-obtained Future<String> or null
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.red[900]));
                              }
                              if (snapshot.data.isEmpty) {
                                return SizedBox(
                                  height: 0,
                                );
                              }
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                      padding: EdgeInsets.only(top: 0),
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
                                        color: Colors.red[900]));
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
                                      Image.asset(
                                        'assets/images/gflix.png',
                                        height: 20.0,
                                        width: 40.0,
                                        fit: BoxFit.contain,
                                        color: Colors.red[900],
                                      ),
                                    ],
                                  ),
                                  ListView.builder(
                                      padding: EdgeInsets.only(top: 0),
                                      physics: BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        reviewsResultsGFlix = {
                                          "source": 'gflix',
                                          "id": snapshot
                                              .data.docs[index].reference.id,
                                          "content": snapshot.data.docs[index]
                                              ["text"],
                                          "author_details": {
                                            "username": snapshot
                                                .data.docs[index]["email"],
                                            "rating": snapshot.data.docs[index]
                                                ["rating"],
                                            "avatar_path": snapshot
                                                .data.docs[index]["photoURL"]
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
