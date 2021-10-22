import 'package:flutter/material.dart';
import 'package:flutter_auth/Screens/Gflix/utils/text.dart';
import 'package:flutter_auth/Screens/Person/person_info.dart';

class Cast extends StatelessWidget {
  const Cast({Key key, this.casts}) : super(key: key);
  final List casts;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          modified_text(
            text: 'Cast',
            size: 20,
            color: Colors.white,
          ),
          SizedBox(height: 10),
          Container(
              height: 220,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: casts.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new PersonInfo(
                                      id: casts[index]['id'],
                                      name: casts[index]['title'] == null
                                          ? casts[index]['name']
                                          : casts[index]['title'],
                                      profilePath: casts[index]
                                                  ['profile_path'] ==
                                              null
                                          ? 'empty'
                                          : 'https://image.tmdb.org/t/p/w500' +
                                              casts[index]['profile_path'],
                                    )));
                      },
                      child: Container(
                        width: 105,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: casts[index]['profile_path'] == null
                                  ? Image.asset(
                                      'assets/images/cast.png',
                                      height: 150.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      'https://image.tmdb.org/t/p/w500' +
                                          casts[index]['profile_path'],
                                      height: 150.0,
                                      width: 100.0,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                child: Text(
                              casts[index]['name'] != null
                                  ? casts[index]['name']
                                  : 'Loading',
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
