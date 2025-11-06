import 'package:flutter/material.dart';
import 'package:modul_10/viewmodel/fetchgame.dart';
import 'package:modul_10/model/detailgame.dart';
import 'package:readmore/readmore.dart';

class Detail extends StatelessWidget {
  final int gameTerpilih;
  const Detail({super.key, required this.gameTerpilih});
  
  Future<DetailGame> fetchData() async {
    final jsonData = await fetchDataFromAPI(gameTerpilih);
    return DetailGame.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.amberAccent.shade400,
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('Data tidak tersedia'));
            } else {
              final game = snapshot.data!;
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25)),
                          child: Image.network(
                            game.thumbnail,
                            fit: BoxFit.cover,
                            height: 300,
                          ),
                        ),
                        Positioned(
                          top: 40,
                          left: 15,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(25),
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.arrow_back_ios_new,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Game Title
                              Text(
                                game.title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              
                              // Genre
                              Text(
                                game.genre,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 15),
                              
                              // Description
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                child: ReadMoreText(
                                  game.description,
                                  trimLines: 3,
                                  colorClickableText: Colors.amberAccent.shade400,
                                  trimMode: TrimMode.Line,
                                  style: TextStyle(
                                    color: Colors.black54.withOpacity(0.8),
                                    height: 1.5,
                                    fontSize: 14,
                                  ),
                                  trimCollapsedText: ' more',
                                  trimExpandedText: ' less',
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Screenshots
                              const Text(
                                'Screenshots',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 200,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    _itemList(game.screenshots[0].image),
                                    const SizedBox(width: 15),
                                    _itemList(game.screenshots[1].image),
                                    const SizedBox(width: 15),
                                    _itemList(game.screenshots[2].image),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // System Requirements
                              SizedBox(
                                width: double.maxFinite,
                                child: Text(
                                  'Minimum System Requirements',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  _requirementRow('OS', game.minimum_system_requirements.os),
                                  _requirementRow('Processor', game.minimum_system_requirements.processor),
                                  _requirementRow('Memory', game.minimum_system_requirements.memory),
                                  _requirementRow('Graphics', game.minimum_system_requirements.graphics),
                                  _requirementRow('Storage', game.minimum_system_requirements.storage),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

SizedBox _itemList(String url) {
  return SizedBox(
    width: 250,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    )
  );
}

Row _requirementRow(String title, String value) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(flex: 3, child: Text(title, style: TextStyle(color: Colors.black54.withOpacity(0.8)))),
      Expanded(flex: 1, child: Text(':', style: TextStyle(color: Colors.black54.withOpacity(0.8)))),
      Expanded(flex: 8, child: Text(value, style: TextStyle(color: Colors.black54.withOpacity(0.8)))),
    ],
  );
}