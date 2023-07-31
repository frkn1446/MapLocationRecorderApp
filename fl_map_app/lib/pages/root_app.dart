import 'package:flutter/material.dart';
import '../db_helper.dart';
import 'map_page.dart';

class RootApp extends StatefulWidget {
  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;

  Future<List<LocationData>> _locationDataFuture = _fetchLocationData();

  static Future<List<LocationData>> _fetchLocationData() async {
    try {
      List<LocationData> locationDataList = await instance.queryAll();
      return locationDataList;
    } catch (e) {
      print('Hata: $e');
      return [];
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _locationDataFuture = _fetchLocationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: getAppBar(context),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<List<LocationData>>(
      future: _locationDataFuture,
      builder:
          (BuildContext context, AsyncSnapshot<List<LocationData>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text('Veritabanında veri bulunamadı'),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _refreshData,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                LocationData data = snapshot.data![index];
                return ListTile(
                  title: Text('Şehir: ${data.city}'),
                  subtitle: Text(
                      'Semt: ${data.district}\nAnahtar Kelime: ${data.name}\nEnlem: ${data.latitude}\nBoylam: ${data.longitude}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ; // Veriyi silmek için bir fonksiyon çağırabilirsiniz
                    },
                  ),
                );
              },
            ),
          );
        }
      },
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MapPage(),
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
