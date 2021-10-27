import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Wishlist/components/wishlist_tile.dart';
import 'package:flutter_auth/Screens/Gflix/index.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

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
        backgroundColor: Colors.red[900],
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Wish list'),
            Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
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
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder(
            stream: result.snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.red[900]));
              }
              if (snapshot.data.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      modified_text(
                        text: 'Your wishlist is empty.',
                        color: Colors.white,
                      )
                    ],
                  ),
                );
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
