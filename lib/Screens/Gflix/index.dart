import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/toprated.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/trending.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/tv.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:tmdb_api/tmdb_api.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  List trendingmovies = [];
  List topratedmovies = [];
  List tv = [];

  @override
  void initState() {
    super.initState();
    loadmovies();
  }

  loadmovies() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );

    Map trendingresult = await tmdbWithCustomLogs.v3.trending.getTrending();
    Map topratedresult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvresult = await tmdbWithCustomLogs.v3.tv.getPouplar();
    print((trendingresult));
    setState(() {
      trendingmovies = trendingresult['results'];
      topratedmovies = topratedresult['results'];
      tv = tvresult['results'];
    });
  }

  @override
  Widget build(BuildContext context) {
    //final auth = FirebaseAuth.instance;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: modified_text(text: 'GFlix Movie App'),
          backgroundColor: Colors.red,
        ),
        body: ListView(
          children: [
            TrendingMovies(
              trending: trendingmovies,
            ),
            TV(tv: tv),
            TopRatedMovies(
              toprated: topratedmovies,
            ),
            ElevatedButton(
              child: Text(
                'ออกจากระบบ',
                style: TextStyle(color: Colors.grey),
              ),
              onPressed: () {
                // auth.signOut().then((value) {
                //   Navigator.pushReplacement(context,
                //       MaterialPageRoute(builder: (context) {
                //     return WelcomeScreen();
                //   }));
                // });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
            )
          ],
        ));
  }
}
