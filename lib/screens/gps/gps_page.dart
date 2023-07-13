import 'package:flutter/material.dart';
import 'package:franata_test_kompetensi/constants/app_colors.dart';
import 'package:franata_test_kompetensi/constants/app_typography.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GpsPage extends StatefulWidget {
  const GpsPage({Key? key}) : super(key: key);

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  String lat = '';
  String lon = '';

  Future<LocationData> _getCurrentLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return Future.error('Location service are disable');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permission are denied');
      }
    }

    return _locationData = await location.getLocation();
  }

  void writeLocation(latitude, longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('latitude', latitude.toString());
    await prefs.setString('longitude', longitude.toString());
  }

  void readLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final String? latitude = prefs.getString('latitude');
    final String? longitude = prefs.getString('longitude');

    setState(() {
        lat = latitude!;
        lon = longitude!;
    });
  }

  void resetLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('latitude', '');
    await prefs.setString('longitude', '');
    setState(() {
      lat = '';
      lon = '';
    });
  }

  @override
  void initState() {
    super.initState();
    readLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Current Coordinat',
                  style: headingSemiBold(black),
                ),
                Text(
                  'Latitude : ' + lat,
                  style: headingRegular(black),
                ),
                Text(
                  'Longitude : ' + lon,
                  style: headingRegular(black),
                ),
                const SizedBox(
                  height: 25,
                ),
                lat == '' && lon == ''
                    ? ElevatedButton(
                        onPressed: () {
                          _getCurrentLocation().then((value) {
                            writeLocation(value.latitude, value.longitude);
                            setState(() {
                              lat = '${value.latitude}';
                              lon = '${value.longitude}';
                            });
                          });
                        },
                        child: Text(
                          'Get Current Location',
                          style: headingSemiBold(white),
                        ),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          resetLocation();
                          setState(() {
                            lat = '';
                            lon = '';
                          });
                        },
                        child: Text(
                          'Reset',
                          style: headingSemiBold(white),
                        ),
                      ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
