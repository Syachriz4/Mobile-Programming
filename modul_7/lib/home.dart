import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ini Halaman Utama"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text("Ini adalah halaman Utama", style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/tujuan',
                );
              },
              child: const Text("Ke Halaman Tujuan"),
            ),
          ),
        ],
      ),
    );
  }
}
