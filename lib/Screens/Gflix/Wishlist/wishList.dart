import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Wishlist/wishlist_tile.dart';

class WishList extends StatefulWidget {
  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  Query result;
  String userEmail;
  Map wishListFromFirebase;
  final auth = FirebaseAuth.instance;
  void initState() {
    userEmail = auth.currentUser.email;
    result = FirebaseFirestore.instance
        .collection("wishlists")
        .where("email", isEqualTo: userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Wish list'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: result.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.red));
              }
              if (snapshot.data.docs.isEmpty) {
                return SizedBox();
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          wishListFromFirebase = {
                            "id": snapshot.data.docs[index].reference.id,
                            "email": snapshot.data.docs[index]["email"],
                            "bannerurl": snapshot.data.docs[index]["bannerurl"],
                            "posterurl": snapshot.data.docs[index]["posterurl"],
                            "movieId": snapshot.data.docs[index]["movieId"],
                            "name": snapshot.data.docs[index]["name"],
                            "description": snapshot.data.docs[index]
                                ["description"],
                            "vote": snapshot.data.docs[index]["vote"],
                            "launchOn": snapshot.data.docs[index]["launchOn"],
                            "mediaType": snapshot.data.docs[index]["mediaType"],
                          };
                          return Wishlisttile(
                            wishlistResults:
                                wishListFromFirebase, //wishlistResults
                          );
                        })
                  ],
                ),
              );
            }),
      ),
    );
  }
}
