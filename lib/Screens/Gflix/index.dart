import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Wishlist/wishList.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/toprated.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/trending.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/tv.dart';
import 'package:flutter_auth/Screens/Gflix/widgets/upcoming.dart';
import 'package:flutter_auth/Screens/Login/components/facebook_login_controller.dart';
import 'package:flutter_auth/Screens/Login/components/google_sign_in.dart';
import 'package:flutter_auth/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tmdb_api/tmdb_api.dart';
import 'package:flutter_auth/Screens/Gflix/Search/search.dart';

class IndexScreen extends StatefulWidget {
  @override
  _IndexScreenState createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen> {
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  final String readaccesstoken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODg3MmQ2NDFlNDdiY2YwMWU4YjQ3Yzc1ZTAyMDYyMyIsInN1YiI6IjYxM2U3ZTVjOTE3NDViMDA5MWU3OGI5NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.q-bvvinn7hwRIRHRRQtfgQRWsbhITyfALcho9Y8zhJk';
  List trendingmovies = [], topratedmovies = [], tv = [], upcoming = [];
  bool shimmer = false;
  final auth = FirebaseAuth.instance;
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
    Map upcomingresult =
        await tmdbWithCustomLogs.v3.movies.getUpcoming(region: 'US');
    Map topratedresult = await tmdbWithCustomLogs.v3.movies.getTopRated();
    Map tvresult = await tmdbWithCustomLogs.v3.tv.getPouplar();

    print((trendingresult));
    setState(() {
      trendingmovies = trendingresult['results'];
      upcoming = upcomingresult['results'];
      topratedmovies = topratedresult['results'];
      tv = tvresult['results'];
    });
  }

  _showUserInfoDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 24.0),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                modified_text(
                  text: "User Information",
                  size: 25,
                  color: Colors.red[900],
                  weight: FontWeight.w700,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        auth.currentUser.photoURL,
                      ),
                    ),
                    SizedBox(
                      width: 24,
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                modified_text(
                    text: "Name : ${auth.currentUser.displayName}",
                    size: 16,
                    color: Colors.black),
                SizedBox(
                  height: 10,
                ),
                modified_text(
                    text: "Email : ${auth.currentUser.email}",
                    size: 16,
                    color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.red[900],
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: _showLogoutDialog,
                    ),
                    SizedBox(
                      width: 24,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _showUserInfoNoImageDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 0.0, 24.0),
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close))
                  ],
                ),
                modified_text(
                  text: "User Information",
                  size: 25,
                  color: Colors.red[900],
                  weight: FontWeight.w700,
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(
                        'assets/images/avatar.png',
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 10,
                ),
                modified_text(
                    text: "Email : ${auth.currentUser.email}",
                    size: 16,
                    color: Colors.black),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      color: Colors.red[900],
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: _showLogoutDialog,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                modified_text(text: "Log Out", size: 25, color: Colors.black),
                SizedBox(
                  height: 15,
                ),
                modified_text(
                    text: "Are you sure you want to log out?",
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
                      color: Colors.red[900],
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Text(
                        'Log Out',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      onPressed: () {
                        final facebookProvider =
                            Provider.of<FacebookSignInController>(context,
                                listen: false);
                        final googleProvider =
                            Provider.of<GoogleSignInProvider>(context,
                                listen: false);
                        if (facebookProvider.userData != null) {
                          facebookProvider.logOut().then((value) {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }), (Route<dynamic> route) => false);
                          });
                        } else if (googleProvider.user != null) {
                          googleProvider.googleLogout().then((value) {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }), (Route<dynamic> route) => false);
                          });
                        } else if (googleProvider.user == null) {
                          auth.signOut().then((value) {
                            Navigator.pop(context);
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) {
                              return WelcomeScreen();
                            }), (Route<dynamic> route) => false);
                          });
                        }
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
    return Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     setState(() {
        //       shimmer = !shimmer;
        //     });
        //   },
        //   child: Icon(Icons.change_circle_outlined),
        //   backgroundColor: Colors.pink,
        // ),
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (auth.currentUser.photoURL != null) {
                    _showUserInfoDialog();
                  } else {
                    _showUserInfoNoImageDialog();
                  }
                },
              );
            },
          ),
          title: IconButton(
            iconSize: 50,
            icon: Image.asset(
              'assets/images/gflix.png',
              height: 40.0,
              width: 70.0,
              fit: BoxFit.contain,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return IndexScreen();
              }), (Route<dynamic> route) => false);
            },
          ),
          backgroundColor: Colors.red[900],
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return WishList();
                  })),
                  icon: Icon(Icons.favorite),
                ),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SearchList();
                          },
                        ),
                      );
                    })
              ],
            ),
          ],
        ),
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            trendingmovies.isEmpty || trendingmovies == null || shimmer == true
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white60,
                        highlightColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              height: 28,
                              width: 200,
                            ),
                            SizedBox(height: 11),
                            Container(
                              height: 270,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(width: 20),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 223,
                                        width: 150,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 223,
                                        width: 150,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 223,
                                        width: 150,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                : TrendingMovies(
                    trending: trendingmovies,
                  ),
            upcoming.isEmpty || upcoming == null || shimmer == true
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white60,
                        highlightColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              height: 28,
                              width: 200,
                            ),
                            SizedBox(height: 11),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              height: 230,
                              width: 400,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        )),
                  )
                : Upcoming(
                    upcoming: upcoming,
                  ),
            tv.isEmpty || tv == null || shimmer == true
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white60,
                        highlightColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              height: 29,
                              width: 200,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 200,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 140,
                                        width: 250,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 140,
                                        width: 250,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 140,
                                        width: 250,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 150,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                : TV(tv: tv),
            topratedmovies.isEmpty || topratedmovies == null || shimmer == true
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Shimmer.fromColors(
                        baseColor: Colors.white60,
                        highlightColor: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              height: 28,
                              width: 200,
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 271,
                              child: ListView(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                children: [
                                  SizedBox(width: 14),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 200,
                                        width: 133,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 200,
                                        width: 133,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 200,
                                        width: 133,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white60,
                                        ),
                                        height: 20,
                                        width: 100,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  )
                : TopRatedMovies(
                    toprated: topratedmovies,
                  ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  child: SvgPicture.asset(
                    'assets/icons/tmdb_full_logo.svg',
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Flexible(
                  flex: 4,
                  child: modified_text(
                    text:
                        'GFlix application uses the TMDB API but is not endorsed or certified by TMDB.',
                    size: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
