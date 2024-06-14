import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More Info'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          child: const Column(children: [
            Card(
              elevation: 0,
              child: Column(
                children: [
                  Text(
                    "Welcome to AquaFlora: Your Smart Terrarium Companion",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  Text(
                      "Welcome to AquaFlora, the ultimate solution for maintaining the perfect environment for your terrarium! Whether you're a seasoned plant enthusiast or just starting out, AquaFlora makes it easy to nurture your green friends with precision and convenience."),
                ],
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.start),
                    title: Text('Introduction'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                    child: Text(
                        "AquaFlora is your all-in-one tool for managing the environmental parameters crucial for the health and growth of your plants. With our intuitive mobile app, you can monitor and control temperature, humidity, soil moisture, and light levels effortlessly."),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.autorenew_outlined),
                    title: Text('Auto Mode'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                    child: Text(
                        "Let AquaFlora take the wheel with our advanced Auto Mode feature. Simply set your desired environmental conditions, and AquaFlora will automatically adjust settings to maintain them. Sit back, relax, and watch your terrarium thrive without the hassle of constant manual adjustments."),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.tune),
                    title: Text('Manual Mode'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                    child: Text(
                        "For those who prefer a hands-on approach, AquaFlora offers Manual Mode, giving you full control over each environmental parameter. Adjust settings on the fly with ease, ensuring your plants receive the personalized care they need."),
                  )
                ],
              ),
            ),
            SizedBox(height: 5),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.star_border),
                    title: Text('Key Features'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                      child: Column(
                        children: [
                          Text(
                              '\u2022 Remote monitoring and control of temperature, humidity, soil moisture, and light levels'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              '\u2022 Auto Mode for hassle-free environmental management'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              '\u2022 Manual Mode for personalized control and fine-tuning'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                              '\u2022 Intuitive mobile app interface for easy navigation and usage'),
                        ],
                      ))
                ],
              ),
            ),
            SizedBox(height: 10),
            Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Experience the future of terrarium care with AquaFlora",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.person_outline),
                    title: Text('Contact Information'),
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 15.0, bottom: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                          ),
                          Text("Mobile : 1127192890"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("gmail : tharinduirushan3010@gmail.com"),
                          SizedBox(
                            height: 5,
                          )
                        ],
                      ))
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
