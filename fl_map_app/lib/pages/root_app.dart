import 'package:flutter/material.dart';
import 'map_page.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(context),
      // bottomNavigationBar: getFooter(),
      // body: getBody(),
    );
  }
}

getAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black,
    elevation: 0,
    title: Text(
      "My Saved Locations",
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          // Yeni sayfayı açmak için Navigator.push kullanılır
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapPage(), // Yeni sayfanın oluşturulacağı sınıf
            ),
          );
        },
        icon: Icon(
          Icons.add_box,
          size: 27,
        ),
      ),
    ],
  );
}
