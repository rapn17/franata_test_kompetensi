import 'package:flutter/material.dart';
import 'package:franata_test_kompetensi/screens/galeri/galeri_page.dart';
import 'package:franata_test_kompetensi/screens/gps/gps_page.dart';
import 'package:franata_test_kompetensi/screens/notes/notes_page.dart';
import 'package:franata_test_kompetensi/screens/weather/weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.note)),
              Tab(icon: Icon(Icons.photo_album)),
              Tab(icon: Icon(Icons.gps_fixed)),
              Tab(icon: Icon(Icons.cloud)),
            ],
          ),
          title: const Text('Test Aplication'),
        ),
        body: const TabBarView(
          children: [
            NotePage(),
            GaleryPage(),
            GpsPage(),
            WeatherPage(),
          ],
        ),
      ),
    );
  }
}