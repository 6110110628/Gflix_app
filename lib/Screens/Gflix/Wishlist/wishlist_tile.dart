import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/model/Favorite.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Wishlisttile extends StatefulWidget {
  // const Wishlisttile({Key key, this.wishlistResults}) : super(key: key);
  final Map wishlistResults; // use this
  const Wishlisttile({Key key, this.wishlistResults}) : super(key: key);

  @override
  _WishlisttileState createState() => _WishlisttileState();
}

class _WishlisttileState extends State<Wishlisttile> {
  CollectionReference _favCollection =
      FirebaseFirestore.instance.collection("wishlists");
  Favorite myFav = Favorite();
  final String apikey = '58872d641e47bcf01e8b47c75e020623';
  var today = DateTime.now();

  @override
  void initState() {
    super.initState();
    // loadData();
  }

  // Future<String> loadData() async {
  //   List results = await loadDataResults();
  //   if (results == null || results.length == 0) {
  //     results = await loadDataResults();
  //     return getData(results);
  //   } else {
  //     results = await loadDataResults();
  //     return getData(results);
  //   }
  // }

  // Future<String> getData(List results) async {
  //   print(results);
  //   print("^^^^^");
  //   dataMovies = results;
  //   print(dataMovies);
  //   print("<<<<<<<<");
  // }

  // Future<List> loadDataResults() async {
  //   final url =
  //       'https://api.themoviedb.org/3/search/movie?api_key=${apikey}&query=${widget.wishlistResults['name']}';
  //   final response = await http.get(Uri.parse(url));
  //   var temp = utf8.decode(response.bodyBytes);
  //   Map<String, dynamic> js = jsonDecode(temp);
  //   return js['results'];
  // }

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
                    text: "Delete your wishlist permanently?",
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
                          Navigator.pop(context);
                          await _favCollection
                              .doc(widget.wishlistResults["id"])
                              .delete()
                              .then((value) => Fluttertoast.showToast(
                                  msg: "Deleted",
                                  gravity: ToastGravity.CENTER));
                        } catch (e) {
                          Navigator.pop(context);
                          Fluttertoast.showToast(
                              msg: e.message, gravity: ToastGravity.CENTER);
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
    print("------------------");
    print(widget.wishlistResults['name']);
    print(widget.wishlistResults['email']);
    // print(this.dataMovies); //can't get value from list
    print("------------------");
    return InkWell(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                widget.wishlistResults['posterurl'],
                height: 150,
              ),
              Column(
                children: [
                  Text(
                    widget.wishlistResults['name'] != null
                        ? widget.wishlistResults['name']
                        : 'Loading',
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    // widget.wishlistResults['release'] != null
                    //     ? widget.wishlistResults['release']
                    //     : 'Loading',
                    "Added : " +
                        this.today.day.toString() +
                        " /" +
                        this.today.month.toString() +
                        " /" +
                        this.today.year.toString(),

                    style: TextStyle(fontSize: 15, color: Colors.grey[350]),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  _showDeleteDialog();
                },
                icon: const Icon(Icons.delete),
                color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => new Description(
                    id: widget.wishlistResults['movieId'],
                    name: widget.wishlistResults['name'] == null
                        ? 'loading'
                        : widget.wishlistResults['name'],
                    bannerurl: 'https://image.tmdb.org/t/p/w500' +
                        widget.wishlistResults['bannerurl'],
                    posterurl: 'https://image.tmdb.org/t/p/w500' +
                        widget.wishlistResults['posterurl'],
                    description: widget.wishlistResults['description'],
                    vote: widget.wishlistResults['vote'].toString(),
                    launchOn: widget.wishlistResults['launchOn'],
                    mediaType: widget.wishlistResults['mediaType'])));
      },
    );
  }
}
