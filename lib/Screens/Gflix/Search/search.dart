import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Person/person_info.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';

class SearchList extends StatefulWidget {
  @override
  _SearchList createState() => new _SearchList();
}

class _SearchList extends State<SearchList> {
  bool widgetPresent;
  Widget appBarTitle = new Text(
    "Search Example",
    style: new TextStyle(color: Colors.white),
  );
  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final globalKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _controller = new TextEditingController();
  bool _isSearching;
  String _searchText = "";

  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  List searchresult = [];

  final auth = FirebaseAuth.instance;
  @override
  void initState() {
    widgetPresent = true;
    _isSearching = false;
    super.initState();
  }

  // _SearchListState() {
  //   _controller.addListener(() {
  //     if (_controller.text.isEmpty) {
  //       setState(() {
  //         _isSearching = false;
  //         _searchText = "";
  //       });
  //     } else {
  //       setState(() {
  //         _isSearching = true;
  //         _searchText = _controller.text;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        appBar: buildAppBar(context),
        body: new Container(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              searchresult == null &&
                      searchresult.isEmpty &&
                      searchresult.length == 0 &&
                      _controller.text.isEmpty
                  ? new Center(
                      child: CircularProgressIndicator(color: Colors.red[900]),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchresult.length,
                        itemBuilder: (BuildContext context, int index) {
                          String listData = searchresult[index]['title'] == null
                              ? searchresult[index]['name']
                              : searchresult[index]['title'];
                          print(searchresult[index]);
                          return new ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                searchresult[index]['media_type'] == 'movie'
                                    ? Icon(
                                        Icons.movie,
                                        color: Colors.white70,
                                      )
                                    : (searchresult[index]['media_type'] == 'tv'
                                        ? Icon(Icons.live_tv,
                                            color: Colors.white70)
                                        : Icon(Icons.person,
                                            color: Colors.white70)),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  listData.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              searchresult[index]['media_type'] == 'movie' ||
                                      searchresult[index]['media_type'] == 'tv'
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => new Description(
                                                id: searchresult[index]['id'],
                                                name: searchresult[index]
                                                            ['title'] ==
                                                        null
                                                    ? searchresult[index]
                                                        ['name']
                                                    : searchresult[index]
                                                        ['title'],
                                                bannerurl: searchresult[index]
                                                            ['backdrop_path'] ==
                                                        null
                                                    ? 'empty'
                                                    : 'https://image.tmdb.org/t/p/w500' +
                                                        searchresult[index]
                                                            ['backdrop_path'],
                                                posterurl: searchresult[index]
                                                            ['poster_path'] ==
                                                        null
                                                    ? 'empty'
                                                    : 'https://image.tmdb.org/t/p/w500' +
                                                        searchresult[index]
                                                            ['poster_path'],
                                                description: searchresult[index]
                                                    ['overview'],
                                                vote: searchresult[index]
                                                        ['vote_average']
                                                    .toString(),
                                                launchOn: searchresult[index]
                                                            ['release_date'] ==
                                                        null
                                                    ? searchresult[index]
                                                        ['first_air_date']
                                                    : searchresult[index]
                                                        ['release_date'],
                                                mediaType: searchresult[index]
                                                    ['media_type'],
                                              )))
                                  : Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => new PersonInfo(
                                                id: searchresult[index]['id'],
                                                name: searchresult[index]
                                                            ['title'] ==
                                                        null
                                                    ? searchresult[index]
                                                        ['name']
                                                    : searchresult[index]
                                                        ['title'],
                                                profilePath: searchresult[index]
                                                            ['profile_path'] ==
                                                        null
                                                    ? 'empty'
                                                    : 'https://image.tmdb.org/t/p/w500' +
                                                        searchresult[index]
                                                            ['profile_path'],
                                              )));
                            },
                          );
                        },
                      ),
                    )
            ],
          ),
        ));
  }

  Widget buildAppBar(BuildContext context) {
    return new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: TextField(
          autofocus: true,
          controller: _controller,
          style: new TextStyle(
            color: Colors.white,
          ),
          decoration: new InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: "Search movie...",
              hintStyle: new TextStyle(color: Colors.white)),
          onChanged: searchOperation,
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                widgetPresent = false;
                Navigator.pop(context);
              },
              child: modified_text(
                text: 'Cancel',
                color: Colors.white,
                size: 15,
              ))
        ]);
  }

  // void _handleSearchStart() {
  //   setState(() {
  //     _isSearching = true;
  //   });
  // }

  // void _handleSearchEnd() {
  //   setState(() {
  //     this.icon = new Icon(
  //       Icons.search,
  //       color: Colors.white,
  //     );
  //     this.appBarTitle = new Text(
  //       "Search Sample",
  //       style: new TextStyle(color: Colors.white),
  //     );
  //     _isSearching = false;
  //     _controller.clear();
  //   });
  // }

  void searchOperation(String searchText) async {
    searchresult.clear();
    TMDB tmdbWithCustomLogs = TMDB(
      ApiKeys(apikey, readaccesstoken),
      logConfig: ConfigLogger(
        showLogs: true,
        showErrorLogs: true,
      ),
    );
    Map searchresultMap =
        await tmdbWithCustomLogs.v3.search.queryMulti(searchText);
    if (widgetPresent) {
      setState(() {
        searchresult = searchresultMap['results'] ?? [];
      });
    }
  }
}
