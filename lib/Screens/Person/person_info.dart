import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/description.dart';
import 'package:flutter_auth/Screens/Gflix/index.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/knownfor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonInfo extends StatefulWidget {
  final String name, profilePath;
  final int id;

  const PersonInfo({Key key, this.id, this.name, this.profilePath})
      : super(key: key);
  @override
  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  Map personDetails, personExternalIds;
  List combinedCredits = [], knowFor = [], sortByReleaseDate = [], acting = [];
  String gender = '',
      birthDay,
      placeOfBirth,
      linkUrl,
      facebookId,
      instagramId,
      twitterId;
  int age;

  @override
  void initState() {
    loadPersonDetails();
    laodCombineCredits();
    super.initState();
  }

  loadPersonDetails() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    personDetails = await tmdbWithCustomLogs.v3.people.getDetails(widget.id);
    personExternalIds =
        await tmdbWithCustomLogs.v3.people.getExternalIds(widget.id);
    setState(() {
      placeOfBirth = personDetails['place_of_birth'] ?? '-';
      linkUrl = personDetails['homepage'];
      facebookId = personExternalIds['facebook_id'];
      twitterId = personExternalIds['twitter_id'];
      instagramId = personExternalIds['instagram_id'];
      if (personDetails['gender'] == 0) {
        gender = '-';
      } else if (personDetails['gender'] == 1) {
        gender = 'Female';
      } else if (personDetails['gender'] == 2) {
        gender = 'Male';
      } else if (personDetails['gender'] == 3) {
        gender = 'Non-Binary';
      }
      if (personDetails['birthday'] != null) {
        birthDay = personDetails['birthday'].substring(8, 10) +
            '/' +
            personDetails['birthday'].substring(5, 7) +
            '/' +
            personDetails['birthday'].substring(0, 4);
        age = DateTime.now().year -
            int.parse(personDetails['birthday'].substring(0, 4));
      }
    });
  }

  Future<List> laodCombineCredits() async {
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map combinedCreditsResults =
        await tmdbWithCustomLogs.v3.people.getCombinedCredits(widget.id);
    setState(() {
      combinedCredits = combinedCreditsResults['cast'];

      acting = combinedCredits
          .map((e) => {
                'id': e['id'],
                'poster_path': e['poster_path'],
                'backdrop_path': e['backdrop_path'],
                'overview': e['overview'],
                'vote_average': e['vote_average'],
                'release_date': e['release_date'] == null
                    ? e['first_air_date']
                    : e['release_date'],
                'media_type': e['media_type'],
                'year': e['release_date'] == null || e['release_date'] == ""
                    ? (e['first_air_date'] == "" || e['first_air_date'] == null
                        ? 10000
                        : int.parse(e['first_air_date'].substring(0, 4)))
                    : int.parse(e['release_date'].substring(0, 4)),
                'title': e['title'] == null ? e['name'] : e['title'],
                'character': e['character'] == null ? 'unknow' : e['character']
              })
          .toList();
      acting.sort((a, b) => (b['year']).compareTo(a['year']));
      knowFor = combinedCredits
          .where((element) => element['popularity'] >= 10)
          .toList();
    });
    return knowFor;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: modified_text(
                    text: widget.name != null ? widget.name : 'Not Loaded',
                    size: widget.name.length > 20 ? 18 : 22,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 0),
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
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.black,
        body: ListView(padding: EdgeInsets.all(10), children: [
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Flexible(
                child: Container(
                  width: 150,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: widget.profilePath == 'empty'
                              ? Image.asset(
                                  'assets/images/cast.png',
                                  fit: BoxFit.contain,
                                )
                              : Image.network(widget.profilePath),
                        ),
                      ]),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Birthday',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                    modified_text(
                      text: (birthDay ?? '-') +
                          (age == null ? ' ' : ' ($age years old)'),
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Gender',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                    modified_text(
                      text: gender,
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Place of Birth',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 15)),
                    modified_text(
                      text: placeOfBirth ?? ' ',
                      size: 15,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        facebookId != null
                            ? SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: IconButton(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    await launch(
                                        'https://www.facebook.com/$facebookId');
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/facebook-square.svg',
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                    color: Colors.white54,
                                  ),
                                ),
                              )
                            : Container(),
                        facebookId != null
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        twitterId != null
                            ? SizedBox(
                                height: 27.0,
                                width: 30.0,
                                child: IconButton(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    await launch(
                                        'https://twitter.com/$twitterId');
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/twitter-official.svg',
                                    height: 27.0,
                                    fit: BoxFit.cover,
                                    color: Colors.white54,
                                  ),
                                ),
                              )
                            : Container(),
                        twitterId != null
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        instagramId != null
                            ? SizedBox(
                                height: 27.0,
                                width: 30.0,
                                child: IconButton(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async {
                                    await launch(
                                        'https://instagram.com/$instagramId');
                                  },
                                  icon: SvgPicture.asset(
                                    'assets/icons/instagram-icon.svg',
                                    height: 27.0,
                                    fit: BoxFit.cover,
                                    color: Colors.white54,
                                  ),
                                ),
                              )
                            : Container(),
                        instagramId != null
                            ? SizedBox(
                                width: 10,
                              )
                            : Container(),
                        linkUrl != null
                            ? SizedBox(
                                height: 27.0,
                                width: 30.0,
                                child: IconButton(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(0),
                                    onPressed: () async {
                                      await launch(linkUrl);
                                    },
                                    icon: Icon(
                                      Icons.link,
                                      size: 30,
                                      color: Colors.white54,
                                    )),
                              )
                            : Container(),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          KnownFor(
            knownFor: knowFor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
            child: FutureBuilder(
                future:
                    laodCombineCredits(), // a previously-obtained Future<String> or null
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(color: Colors.red));
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          modified_text(
                            text: 'Acting',
                            size: 20,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.only(top: 0),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: acting.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: 40,
                                            child: modified_text(
                                              text:
                                                  acting[index]['year'] == 10000
                                                      ? '-'
                                                      : acting[index]['year']
                                                          .toString(),
                                              size: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    acting[index]['title'].toString().length +
                                                acting[index]['character']
                                                    .toString()
                                                    .length >
                                            30
                                        ? (Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 18,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      alignment:
                                                          Alignment.topLeft),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                new Description(
                                                                  id: acting[
                                                                          index]
                                                                      ['id'],
                                                                  name: acting[
                                                                          index]
                                                                      ['title'],
                                                                  bannerurl: acting[index]
                                                                              [
                                                                              'backdrop_path'] ==
                                                                          null
                                                                      ? 'empty'
                                                                      : 'https://image.tmdb.org/t/p/w500' +
                                                                          acting[index]
                                                                              [
                                                                              'backdrop_path'],
                                                                  posterurl: acting[index]
                                                                              [
                                                                              'poster_path'] ==
                                                                          null
                                                                      ? 'empty'
                                                                      : 'https://image.tmdb.org/t/p/w500' +
                                                                          acting[index]
                                                                              [
                                                                              'poster_path'],
                                                                  description: acting[
                                                                          index]
                                                                      [
                                                                      'overview'],
                                                                  vote: acting[
                                                                              index]
                                                                          [
                                                                          'vote_average']
                                                                      .toString(),
                                                                  launchOn: acting[index]['release_date'] ==
                                                                              null ||
                                                                          acting[index]['release_date'] ==
                                                                              ""
                                                                      ? 'unknown'
                                                                      : acting[
                                                                              index]
                                                                          [
                                                                          'release_date'],
                                                                  mediaType: acting[
                                                                          index]
                                                                      [
                                                                      'media_type'],
                                                                )));
                                                  },
                                                  child: Text(
                                                    acting[index]['title'] ==
                                                            null
                                                        ? " "
                                                        : (acting[index][
                                                                        'title']
                                                                    .toString()
                                                                    .length >
                                                                40
                                                            ? acting[index][
                                                                        'title']
                                                                    .toString()
                                                                    .substring(
                                                                        0, 40) +
                                                                '...'
                                                            : acting[index]
                                                                    ['title']
                                                                .toString()),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red[400]),
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              acting[index]['character'] ==
                                                          null ||
                                                      acting[index]
                                                              ['character'] ==
                                                          ""
                                                  ? SizedBox()
                                                  : modified_text(
                                                      text: 'as ' +
                                                          acting[index]
                                                                  ['character']
                                                              .toString(),
                                                      size: 15,
                                                      color: Colors.white,
                                                    )
                                            ],
                                          ))
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 18,
                                                child: TextButton(
                                                  style: TextButton.styleFrom(
                                                      minimumSize: Size.zero,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      alignment:
                                                          Alignment.topLeft),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                new Description(
                                                                  id: acting[
                                                                          index]
                                                                      ['id'],
                                                                  name: acting[
                                                                          index]
                                                                      ['title'],
                                                                  bannerurl: acting[index]
                                                                              [
                                                                              'backdrop_path'] ==
                                                                          null
                                                                      ? 'empty'
                                                                      : 'https://image.tmdb.org/t/p/w500' +
                                                                          acting[index]
                                                                              [
                                                                              'backdrop_path'],
                                                                  posterurl: acting[index]
                                                                              [
                                                                              'poster_path'] ==
                                                                          null
                                                                      ? 'empty'
                                                                      : 'https://image.tmdb.org/t/p/w500' +
                                                                          acting[index]
                                                                              [
                                                                              'poster_path'],
                                                                  description: acting[
                                                                          index]
                                                                      [
                                                                      'overview'],
                                                                  vote: acting[
                                                                              index]
                                                                          [
                                                                          'vote_average']
                                                                      .toString(),
                                                                  launchOn: acting[index]['release_date'] ==
                                                                              null ||
                                                                          acting[index]['release_date'] ==
                                                                              ""
                                                                      ? 'unknown'
                                                                      : acting[
                                                                              index]
                                                                          [
                                                                          'release_date'],
                                                                  mediaType: acting[
                                                                          index]
                                                                      [
                                                                      'media_type'],
                                                                )));
                                                  },
                                                  child: Text(
                                                    acting[index]['title'] ==
                                                            null
                                                        ? " "
                                                        : acting[index]['title']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red[400]),
                                                    softWrap: false,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              acting[index]['character'] ==
                                                          null ||
                                                      acting[index]
                                                              ['character'] ==
                                                          ""
                                                  ? SizedBox()
                                                  : modified_text(
                                                      text: ' as ' +
                                                          acting[index]
                                                                  ['character']
                                                              .toString(),
                                                      size: 15,
                                                      color: Colors.white,
                                                    )
                                            ],
                                          )
                                  ],
                                ),
                                index < acting.length - 1
                                    ? (acting[index + 1]['year'] !=
                                            acting[index]['year']
                                        ? Divider(
                                            color: Colors.white70,
                                          )
                                        : SizedBox(
                                            height: 10,
                                          ))
                                    : SizedBox(
                                        height: 10,
                                      )
                              ],
                            );
                          }),
                    ],
                  );
                }),
          ),
        ]),
      ),
    );
  }
}
