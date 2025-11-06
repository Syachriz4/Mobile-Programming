import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        bottomNavigationBar:Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          color: Colors.black54,
          height: 125,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Icon(Icons.shuffle, color: Colors.white, size: 30,)),
                Expanded(child: Icon(Icons.skip_previous, color: Colors.white, size: 30,)),
                Flexible(fit: FlexFit.tight,flex: 2, child: Icon(Icons.play_circle_fill, color: Colors.white, size: 60,)),
                Expanded(child: Icon(Icons.skip_next, color: Colors.white, size: 30,)),
                Expanded(child: Icon(Icons.repeat, color: Colors.white, size: 30,)),
              ],
            ),
          ),
        ),
        body: Center(
          child: Text('Pemutar Music'),
        ),
      ),
    );
  }
}
