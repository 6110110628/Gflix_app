import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

class TV extends StatelessWidget {
  final List tv;

  const TV({Key key, this.tv}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          modified_text(
            text: 'Popular Series',
            size: 25,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
              // color: Colors.red,
              height: 200,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tv.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              print("index : $index");
                              return new Description(
                                  id: tv[index]['id'],
                                  name: tv[index]['title'] == null
                                      ? tv[index]['name']
                                      : tv[index]['title'],
                                  bannerurl: tv[index]['backdrop_path'] == null
                                      ? 'empty'
                                      : 'https://image.tmdb.org/t/p/w500' +
                                          tv[index]['backdrop_path'],
                                  posterurl: tv[index]['poster_path'] == null
                                      ? 'empty'
                                      : 'https://image.tmdb.org/t/p/w500' +
                                          tv[index]['poster_path'],
                                  description: tv[index]['overview'],
                                  vote: tv[index]['vote_average'].toString(),
                                  launchOn: tv[index]['release_date'] == null
                                      ? tv[index]['first_air_date']
                                      : tv[index]['release_date'],
                                  mediaType: 'tv');
                            }));
                          },
                          child: Container(
                            // color: Colors.green,
                            width: 250,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500' +
                                                tv[index]['backdrop_path']),
                                        fit: BoxFit.cover),
                                  ),
                                  height: 140,
                                ),
                                SizedBox(height: 5),
                                Container(
                                    child: Text(
                                  tv[index]['original_name'] != null
                                      ? tv[index]['original_name']
                                      : 'Loading',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        )
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}
