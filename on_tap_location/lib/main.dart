import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

Future<double> getAltitude(double lat, double long) async{
  double altitude = 0.0;
  Uri url = Uri.parse('https://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?lon=${long}&lat=${lat}&outtype=JSON');
  final response = await http.get(url);
  Map<String, dynamic> data = json.decode(response.body);
  altitude = data['elevation'];
  return altitude;
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const showMap(),
    );
  }
}

class showMap extends StatefulWidget {
  const showMap({Key? key}) : super(key: key);

  @override
  State<showMap> createState() => _showMap();
}

class _showMap extends State<showMap> {

  double _latitude=35.360862980688175, _longitude=138.73408865462008;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(_latitude,_longitude),
        minZoom: 1,
        maxZoom: 18,
        onTap: (polyline, tapPosition){
          double altitude;
          getAltitude(tapPosition.latitude, tapPosition.longitude).then((value){altitude = value; print('{\n\"longitude\":${tapPosition.longitude},\n\"latitude"\:${tapPosition.latitude},\n\"altitude"\:${altitude}\n},');});
        }
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        CircleLayerOptions(
            circles: [
              CircleMarker(
                  color: Colors.lightBlue.withOpacity(0.5),
                  point: LatLng(_latitude, _longitude),
                  radius: 10
              )
            ]
        ),
      ],
    );
  }
}