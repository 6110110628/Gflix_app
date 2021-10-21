import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

import '../description.dart';

class TrendingMovies extends StatelessWidget {
  final List trending;

  const TrendingMovies({Key key, this.trending}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          modified_text(
            text: 'Trending Movies',
            size: 26,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trending.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Description(
                                      id: trending[index]['id'],
                                      name: trending[index]['title'] == null
                                          ? trending[index]['name']
                                          : trending[index]['title'],
                                      bannerurl:
                                          'https://image.tmdb.org/t/p/w500' +
                                              trending[index]['backdrop_path'],
                                      posterurl: trending[index]
                                                  ['poster_path'] ==
                                              null
                                          ? 'empty'
                                          : 'https://image.tmdb.org/t/p/w500' +
                                              trending[index]['poster_path'],
                                      description: trending[index]['overview'],
                                      vote: trending[index]['vote_average']
                                          .toString(),
                                      launchOn: trending[index]
                                                  ['release_date'] ==
                                              null
                                          ? trending[index]['first_air_date']
                                          : trending[index]['release_date'],
                                      mediaType: trending[index]['media_type'],
                                    )));
                      },
                      child: Container(
                        alignment: Alignment.topRight,
                        width: 170,
                        child: Column(
                          children: [
                            Stack(
                              fit: StackFit.loose,
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500' +
                                        trending[index]['poster_path'],
                                    height: 223.0,
                                    width: 150.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                    bottom: -20,
                                    left: -15,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        letterSpacing: -8,
                                        fontSize: 80,
                                        color: Colors.white,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(3.0, 3.0),
                                            blurRadius: 10.0,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                                child: Text(
                              trending[index]['title'] == null
                                  ? trending[index]['name']
                                  : trending[index]['title'],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ))
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
