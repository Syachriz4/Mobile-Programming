import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo GridView.builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(Title: 'Demo GridView.builder'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.Title});
  final String Title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List dataBerita = [];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  Future _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.freetogame.com/api/games'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          dataBerita = data.take(20).toList();
        });
      } else {
        throw Exception('Gagal load data dari FreeToGame API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.Title),
      ),
      body: ListView.builder(
        itemCount: dataBerita.length,
        itemBuilder: (context, index) {

          return _listItem(
            dataBerita[index]['thumbnail'] ?? 'https://www.freetogame.com/g/452/thumbnail.jpg',
            dataBerita[index]['title'] ?? 'Tidak ada Judul',
            dataBerita[index]['genre'] ?? 'Tidak ada Genre',
            dataBerita[index]['release_date'] ?? 'Tidak ada Tanggal Rilis',
          );

          // return Padding(
          //   padding: const EdgeInsets.all(8),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       border: Border.all(
          //         color: Theme.of(context).colorScheme.inversePrimary,
          //         width: 1,
          //       ),
          //     ),
          //     padding: const EdgeInsets.symmetric(vertical: 4),
          //     child: ListTile(
          //       title: Text(
          //         dataBerita[index]['title'] ?? 'Tidak ada Judul',
          //         maxLines: 3,
          //         overflow: TextOverflow.ellipsis,
          //         style: const TextStyle(
          //           fontSize: 20,
          //           fontWeight: FontWeight.bold,),
          //       ),
          //       subtitle: Text(
          //         dataBerita[index]['published_at'] ?? 'Tidak ada data',
          //         maxLines: 1,
          //         style: const TextStyle(fontSize: 16),
          //       ),
          //       leading: Image.network(
          //         dataBerita[index]['image'] ?? 'https://pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
          //         width: 100,
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // );
        },
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(8),
      //   child: GridView.builder(
      //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //       childAspectRatio: 1.25,
      //       crossAxisCount: 2,
      //       mainAxisSpacing: 10,
      //       crossAxisSpacing: 10,
      //     ),
      //     itemCount: dataBerita.length,
      //     itemBuilder: (context, index) {
      //       return ClipRRect(
      //         borderRadius: BorderRadius.circular(15),
      //         child: GridTile(
      //           footer: SizedBox(
      //             height: 65,
      //             child: GridTileBar(
      //               backgroundColor: Colors.black26.withAlpha(175),
      //               title: Text(
      //                 dataBerita[index]['title'] ?? 'Tanpa judul',
      //                 maxLines: 3,
      //                 overflow: TextOverflow.ellipsis,
      //               ),
      //             ),
      //           ),
      //           child: Image(
      //             image: NetworkImage(
      //               dataBerita[index]['image'] ?? 'https://pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
      //             ),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       );
      //     }
      //   ),
      // ),
    );
  }
}

Container _tombolBaca() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.orange,
      borderRadius: BorderRadius.circular(15),
    ),
    child: const Text(
      'Baca Info',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

Container _listItem(String url, String judul, String genre, String rilis) {
  return Container(
    padding: const EdgeInsets.all(15),
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(
            url,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                judul,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        genre,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rilis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  _tombolBaca()
                ],
              )
            ],
          ),
        ),
      ],
    )
  );
}

// Container listTile(Color warna, Color warnaAvatar, String judul, String subjudul, String gambar) {
//   return Container(
//     padding: const EdgeInsets.symmetric(vertical: 5),
//     child: ListTile(
//       tileColor: warna,
//       title: Text(
//         judul,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,),
//       ),
//       subtitle: Text(
//         subjudul,
//         style: const TextStyle(fontSize: 16),
//       ),
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundColor: warnaAvatar,
//         child: Image.asset(
//           gambar,
//           width: 35,
//           height: 35
//         ),
//       ),
//       trailing: Icon(
//         Icons.star,
//         color: Colors.orangeAccent.shade400,
//       ),
//     ),
//   );
// }

// ClipRRect tile(Color warnaKotak, String gambar, String judul) {
//   return ClipRRect(
//     borderRadius: BorderRadius.circular(10),
//     child: Container(
//       color: warnaKotak,
//       child: GridTile(
//         footer: SizedBox(
//           height: 45,
//           child: GridTileBar(
//             backgroundColor: Colors.black38,
//             title: Text(
//               judul,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//         child: Image.asset(
//           gambar,
//           scale: 4,
//         ),
//       ),
//     ),
//   );
// }
