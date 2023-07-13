import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:franata_test_kompetensi/constants/app_colors.dart';
import 'package:franata_test_kompetensi/constants/app_typography.dart';
import 'package:franata_test_kompetensi/models/weather_model.dart';
import 'package:franata_test_kompetensi/network/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPage extends StatefulWidget {
  // final String? q;
  const WeatherPage({
    Key? key,
    // this.q = '-7.305086, 112.661401',
  }) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String q = '';
  TextEditingController _q = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getQ();
  }

  void _getQ() async {
    final prefs = await SharedPreferences.getInstance();
    final String? latitude = prefs.getString('latitude');
    final String? longitude = prefs.getString('longitude');

    if (latitude != '' && longitude != '') {
    setState(() {
      q = latitude.toString() + ', ' + longitude.toString();
      _q = TextEditingController(text: q);
    });
    }
  }

  Future _getWeather(q) async {
    var res = await Network().getData(q);

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      Weather weatherRes = Weather.fromJson(data);

      return weatherRes;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    // _getWeather();
    return Scaffold(
      body: Container(
        width: double.infinity,
        // height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _q,
                onSubmitted: (value) {
                  setState(() {
                    q = _q.text;
                  });
                },
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintText: "Latitude, Longitude or city name.",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              q != '' ?
              FutureBuilder(
                future: _getWeather(q),
                builder: (context, snapshot) {
                  Weather dataWeather = snapshot.data as Weather;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data != null) {
                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                dataWeather.location.name,
                                style: headingSemiBold(black),
                              ),
                              Text(
                                dataWeather.location.region +
                                    ' / ' +
                                    dataWeather.location.country,
                                style: textLargeSemiBold(black),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        dataWeather.current.tempC
                                                .toStringAsFixed(0) +
                                            '°C',
                                        style: TextStyle(
                                          color: black,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.normal,
                                          fontSize: 48,
                                          letterSpacing: -0.04,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          // color: Colors.black,
                                          image: DecorationImage(
                                            image: NetworkImage('http:' +
                                                dataWeather
                                                    .current.condition.icon),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        dataWeather.current.condition.text,
                                        style: textLargeSemiBold(black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox(
                        child: Text('Lokasi tidak ditemukan'),
                      );
                    }
                  }
                },
              ) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
