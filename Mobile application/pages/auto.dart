import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:smart_terrarium/services/notification.dart';

class AutoPage extends StatefulWidget {
  const AutoPage({super.key});

  @override
  State<AutoPage> createState() => AutoPageState();
}

class AutoPageState extends State<AutoPage> {
  final _database = FirebaseDatabase.instance.ref();
  bool _isOnline = false;
  bool _autoMode = false;
  String _humidity = "...";
  String _light = "...";
  String _moisture = "...";
  String _temperature = "...";

  @override
  void initState() {
    super.initState();
    _activateListners();
  }

  void _activateListners() {
    _database.child("Auto").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _autoMode = false;
        } else if (val == "1") {
          _autoMode = true;
        }
      });
    });
    _database.child("Online").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _isOnline = false;
          LocalNotificationService().showNotificationAndroid(
              "Device Offline", "Smart Terrarium has lost power");
        } else if (val == "1") {
          _isOnline = true;
        }
      });
    });
    _database.child("sensorReadings/humidity").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        _humidity = val;
      });
    });
    _database.child("sensorReadings/light").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        _light = val;
      });
    });
    _database.child("sensorReadings/moisture").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        _moisture = val;
      });
    });
    _database.child("sensorReadings/temperature").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        _temperature = val;
      });
    });
  }

  void toggleAuto(bool toggle) {
    _autoMode = toggle;
    _database.child("Auto").set(toggle ? "1" : "0");
  }

  void toggleOnline() {
    _isOnline = !_isOnline;
    _database.child("Online").set(_isOnline ? "1" : "0");
    Future.delayed(const Duration(milliseconds: 5000), () {
      _isOnline = !_isOnline;
      _database.child("Online").set(_isOnline ? "1" : "0");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Auto Mode',
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.5),
                  ),
                  const Spacer(),
                  TextButton(
                      onPressed: toggleOnline,
                      child: Row(
                        children: [
                          Icon(
                            Icons.trip_origin,
                            color: _isOnline ? Colors.green : Colors.red,
                            size: 10,
                          ),
                          const SizedBox(width: 5),
                          Text(_isOnline ? "Online" : "Offline")
                        ],
                      ))
                ],
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _autoMode ? "Disable Auto Mode" : "Enable Auto Mode",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _autoMode, onChanged: toggleAuto)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.water_drop_outlined),
                                const SizedBox(width: 16),
                                Text("Humidity",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.2)),
                              ],
                            ),
                            Text("$_humidity %",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.5)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_outline),
                                const SizedBox(width: 16),
                                Text("Light",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.2)),
                              ],
                            ),
                            Text("$_light lux",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.5)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.ac_unit_outlined),
                                const SizedBox(width: 16),
                                Text("Temperature",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.2)),
                              ],
                            ),
                            Text("$_temperature ℃",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.5)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.forest_outlined),
                                const SizedBox(width: 16),
                                Text("Moisture",
                                    style: DefaultTextStyle.of(context)
                                        .style
                                        .apply(fontSizeFactor: 1.2)),
                              ],
                            ),
                            Text("$_moisture %",
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .apply(fontSizeFactor: 1.5)),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
