import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Malang',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text('25°C', style: TextStyle(fontSize: 100, color: Colors.black)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  harian('Senin', Icons.sunny, '26°C'),
                  harian('Selasa', Icons.cloudy_snowing, '24°C'),
                  harian('Rabu', Icons.cloud, '23°C'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Container harian (String text, IconData icon, String suhu) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(text, style: TextStyle(fontSize: 20, color: Colors.black)),
        Icon(icon, size: 50, color: Colors.black),
        Text(suhu, style: TextStyle(fontSize: 20, color: Colors.black)),
      ],
    ),
  );
}
