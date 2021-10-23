import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/Description/description.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';

class KnownFor extends StatelessWidget {
  const KnownFor({Key key, this.knownFor}) : super(key: key);
  final List knownFor;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          modified_text(
            text: 'Known For',
            size: 20,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
              height: 220,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: knownFor.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new Description(
                                      id: knownFor[index]['id'],
                                      name: knownFor[index]['title'] == null
                                          ? knownFor[index]['name']
                                          : knownFor[index]['title'],
                                      bannerurl: knownFor[index]
                                                  ['backdrop_path'] ==
                                              null
                                          ? 'empty'
                                          : 'https://image.tmdb.org/t/p/w500' +
                                              knownFor[index]['backdrop_path'],
                                      posterurl: knownFor[index]
                                                  ['poster_path'] ==
                                              null
                                          ? 'empty'
                                          : 'https://image.tmdb.org/t/p/w500' +
                                              knownFor[index]['poster_path'],
                                      description: knownFor[index]['overview'],
                                      vote: knownFor[index]['vote_average']
                                          .toString(),
                                      launchOn: knownFor[index]
                                                  ['release_date'] ==
                                              null
                                          ? knownFor[index]['first_air_date']
                                          : knownFor[index]['release_date'],
                                      mediaType: knownFor[index]['media_type'],
                                    )));
                      },
                      child: Container(
                        width: 105,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: knownFor[index]['poster_path'] == null
                                  ? Image.asset(
                                      'assets/images/cast.png',
                                      height: 150.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      'https://image.tmdb.org/t/p/w500' +
                                          knownFor[index]['poster_path'],
                                      height: 150.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                child: Text(
                              knownFor[index]['title'] == null
                                  ? knownFor[index]['name']
                                  : knownFor[index]['title'],
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
