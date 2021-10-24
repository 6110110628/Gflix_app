import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:tmdb_api/tmdb_api.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({Key key}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';

  List<Widget> card = [];
  List upcoming;
  @override
  void initState() {
    loadUpcoming();
    super.initState();
  }

  loadUpcoming() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map upcomingresult =
        await tmdbWithCustomLogs.v3.movies.getUpcoming(region: 'US');
    setState(() {
      upcoming = upcomingresult['results'];
    });
    cardWidget();
  }

  cardWidget() {
    print('cardWidget()');
    upcoming.forEach((element) {
      card.add(InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new Description(
              id: element['id'],
              name:
                  element['title'] == null ? element['name'] : element['title'],
              bannerurl: element['backdrop_path'] == null
                  ? 'empty'
                  : 'https://image.tmdb.org/t/p/w500' +
                      element['backdrop_path'],
              posterurl: element['poster_path'] == null
                  ? 'empty'
                  : 'https://image.tmdb.org/t/p/w500' + element['poster_path'],
              description: element['overview'],
              vote: element['vote_average'].toString(),
              launchOn: element['release_date'] == null
                  ? element['first_air_date']
                  : element['release_date'],
              mediaType: 'movie',
            );
          }));
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.dstATop),
                  image: element['backdrop_path'] == null
                      ? (element['poster_path'] == null
                          ? Image.asset(
                              'assets/images/cast.png',
                              fit: BoxFit.contain,
                            )
                          : NetworkImage('https://image.tmdb.org/t/p/w500' +
                              element['poster_path']))
                      : NetworkImage('https://image.tmdb.org/t/p/w500' +
                          element['backdrop_path']),
                  fit: BoxFit.cover)),
          alignment: Alignment.topLeft,
          padding: EdgeInsets.all(5),
          // color: Colors.green,
          width: 400,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: element['poster_path'] == null
                          ? Image.asset(
                              'assets/images/cast.png',
                              fit: BoxFit.contain,
                            )
                          : NetworkImage('https://image.tmdb.org/t/p/w500' +
                              element['poster_path']),
                      fit: BoxFit.cover),
                ),
                height: 200,
                width: 140,
              ),
              SizedBox(width: 15),
              Container(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        element['title'] != null ? element['title'] : 'Loading',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      element['release_date'] == null
                          ? ' '
                          : element['release_date'].substring(8, 10) +
                              '/' +
                              element['release_date'].substring(5, 7) +
                              '/' +
                              element['release_date'].substring(0, 4),
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 15)
                    //  modified_text(text: ,color: Colors.white,size: 15)
                  ],
                ),
              )
            ],
          ),
        ),
      ));
    });
    print('Card length : ${card.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          modified_text(
            text: 'Upcoming Movies',
            size: 25,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          card == null || card.isEmpty
              ? Container()
              : ImageSlideshow(
                  width: 400,
                  height: 230,
                  initialPage: 0,
                  indicatorColor: Colors.red,
                  indicatorBackgroundColor: Colors.grey,
                  children: card,
                  onPageChanged: (value) {
                    print('Page changed: $value');
                  },
                  autoPlayInterval: 5000,
                  isLoop: true,
                ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
