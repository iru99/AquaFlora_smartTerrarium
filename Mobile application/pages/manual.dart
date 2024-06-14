import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ManualPage extends StatefulWidget {
  const ManualPage({super.key});

  @override
  State<ManualPage> createState() => ManualPageState();
}

class ManualPageState extends State<ManualPage> {
  final _database = FirebaseDatabase.instance.ref();
  bool _fanVal = false;
  bool _ledVal = false;
  bool _mistVal = false;
  bool _pumpVal = false;

  @override
  void initState() {
    super.initState();
    _activateListners();
  }

  void _activateListners() {
    _database.child("Manual/Fan").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _fanVal = false;
        } else if (val == "1") {
          _fanVal = true;
        }
      });
    });
    _database.child("Manual/LED").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _ledVal = false;
        } else if (val == "1") {
          _ledVal = true;
        }
      });
    });
    _database.child("Manual/Mist").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _mistVal = false;
        } else if (val == "1") {
          _mistVal = true;
        }
      });
    });
    _database.child("Manual/Pump").onValue.listen((event) {
      final String val = event.snapshot.value.toString();
      setState(() {
        if (val == "0") {
          _pumpVal = false;
        } else if (val == "1") {
          _pumpVal = true;
        }
      });
    });
  }

  void toggleFan(bool toggle) {
    _fanVal = toggle;
    _database.child("Manual/Fan").set(toggle ? "1" : "0");
  }

  void toggleLED(bool toggle) {
    _ledVal = toggle;
    _database.child("Manual/LED").set(toggle ? "1" : "0");
  }

  void toggleMist(bool toggle) {
    _mistVal = toggle;
    _database.child("Manual/Mist").set(toggle ? "1" : "0");
  }

  void togglePump(bool toggle) {
    _pumpVal = toggle;
    _database.child("Manual/Pump").set(toggle ? "1" : "0");
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
                'Manual Mode',
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
                        _fanVal ? "Turn off Fan" : "Turn on Fan",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _fanVal, onChanged: toggleFan)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fanVal ? "Turn off Lights" : "Turn on Lights",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _ledVal, onChanged: toggleLED)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fanVal ? "Turn off Mist" : "Turn on Mist",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _mistVal, onChanged: toggleMist)
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fanVal ? "Turn off Pump" : "Turn on Pump",
                        style: DefaultTextStyle.of(context)
                            .style
                            .apply(fontSizeFactor: 1.2),
                      ),
                      Switch(value: _pumpVal, onChanged: togglePump)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
