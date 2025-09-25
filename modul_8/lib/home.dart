import 'package:flutter/material.dart';
import 'tujuan.dart';
import 'screen_arguments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var title, thumbnail, short_description, description;
  var genre, platform, release, cover, gameid, publisher;

  Future getGame(String gameid) async {
    print("this.gameid: $gameid");
    http.Response response = await http.get(
        Uri.parse('https://www.freetogame.com/api/game?id=$gameid')
    );

    var result = json.decode(response.body);
    print("this.gameid: ${result['genre'].runtimeType}");
    print("this.cover: ${result['screenshot'] ?? " ".runtimeType}");
    print("result: $result");
    setState(() {
            this.gameid = result['id'].toString();
      title = result['title'];
      thumbnail = result['thumbnail'];
      short_description = result['short_description'];
      description = result['description'];
      genre = result['genre'];
      platform = result['platform'];
      publisher = result['publisher'];
      release = result['release_date'];

      cover = result['screenshot']?.isNotEmpty == true
          ? result['screenshot'][0]['image']
          : thumbnail;

    });
  }

  @override
  void initState() {
    super.initState();
    getGame('452');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0081c9),
      body: SafeArea(
        child: Center(
          child: gameid == null
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Image.network(thumbnail),
                            const SizedBox(height: 15),
                            Text(title, style: const TextStyle(fontSize: 24)),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Genre: $genre"),
                                    Text("Platform: $platform"),
                                    Text("ID: $gameid"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Publisher: $publisher"),
                                    Text("Release: $release"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Tujuan.routeName,
                          arguments: ScreenArguments(
                            title,
                            short_description,
                            description,
                            cover,
                          ),
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
    );    
  }
}


