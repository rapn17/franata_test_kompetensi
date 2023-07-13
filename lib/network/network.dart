// ignore_for_file: avoid_print

// import 'dart:convert';

// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Network {
  // dioGet(q) async {
  //   final String _url = "http://api.weatherapi.com/v1/current.json?key=2ca14e9960654a628f7112931231107&q="+ q +"&aqi=no";
  //   final dio = Dio();
  //   return await dio.get(_url);
  // }

  getData(q) async {
    final _baseUrl =
        "http://api.weatherapi.com/v1/current.json?key=2ca14e9960654a628f7112931231107&q=" +
            q +
            "&aqi=no";
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
