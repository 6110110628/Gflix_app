import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/description.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

class TopRatedMovies extends StatelessWidget {
  final List toprated;

  const TopRatedMovies({Key key, this.toprated}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          modified_text(
            text: 'Top Rated Movies',
            size: 26,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: toprated.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Description(
                                    id: toprated[index]['id'],
                                    name: toprated[index]['title'] == null
                                        ? toprated[index]['name']
                                        : toprated[index]['title'],
                                    bannerurl:
                                        'https://image.tmdb.org/t/p/w500' +
                                            toprated[index]['backdrop_path'],
                                    posterurl:
                                        'https://image.tmdb.org/t/p/w500' +
                                            toprated[index]['poster_path'],
                                    description: toprated[index]['overview'],
                                    vote: toprated[index]['vote_average']
                                        .toString(),
                                    launchOn:
                                        toprated[index]['release_date'] == null
                                            ? toprated[index]['first_air_date']
                                            : toprated[index]['release_date'],
                                    mediaType: 'movie')));
                      },
                      child: Container(
                        width: 140,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500' +
                                          toprated[index]['poster_path']),
                                ),
                              ),
                              height: 200,
                            ),
                            SizedBox(height: 10),
                            Container(
                              child: modified_text(
                                size: 15,
                                text: toprated[index]['title'] != null
                                    ? toprated[index]['title']
                                    : 'Loading',
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
