import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  final _database = FirebaseDatabase.instance.ref();
  bool _cameraVal = false;

  @override
  void initState() {
    super.initState();
    _activateListners();
  }

  void _activateListners() {
    _database.child("Camera").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _cameraVal = false;
        } else if (val == "1") {
          _cameraVal = true;
        }
      });
    });
  }

  void toggleCamera(bool toggle) {
    _cameraVal = toggle;
    _database.child("Camera").set(toggle ? "1" : "0");
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
              Text(
                'Camera',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.5),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _cameraVal ? "Disable Camera" : "Enable Camera",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _cameraVal, onChanged: toggleCamera)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
