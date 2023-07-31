import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fl_map_app/city_district.dart';

import '../db_helper.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? selectedPoint;

  void _onRegisterButtonPressed() {
    if (selectedPoint != null) {
      getCityAndDistrict(selectedPoint!.latitude, selectedPoint!.longitude)
          .then((result) {
        String city = result['city'] ?? '';
        String district = result['district'] ?? '';
        _showDialogForTextEntry(context, selectedPoint!.latitude,
            selectedPoint!.longitude, city, district);
      }).catchError((e) {
        print('Hata: $e');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lütfen bir nokta seçin"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 70, 70, 70),
        elevation: 0,
        title: Text(
          "Selected Location",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed:
                    _onRegisterButtonPressed, // Yeni fonksiyonu burada çağır
                icon: Icon(
                  Icons.app_registration_sharp,
                  size: 27,
                ),
              );
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(39.8697, 32.7446), // Başlangıçta gösterilecek konum
          zoom: 15.0, // Başlangıçta yakınlaştırma düzeyi
        ),
        markers: Set<Marker>.from(
          [
            if (selectedPoint != null)
              Marker(
                markerId: MarkerId('selected_point'),
                position: selectedPoint!,
                draggable: false,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
          ],
        ),
        onTap: (LatLng point) {
          setState(
            () {
              selectedPoint = point;
            },
          );
        },
      ),
    );
  }
}

void _showDialogForTextEntry(BuildContext context, double lat, double lng,
    String city, String district) {
  String? enteredText;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Konumu hatırlamak için anahtar kelime giriniz\n"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latitude: $lat"),
            Text("Longitude: $lng"),
            Text("City: $city"),
            Text("District: $district"),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                enteredText = value;
              },
              decoration: InputDecoration(
                hintText: "Anahtar kelime(GİRİLMELİ)",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pencereyi kapat
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: Text("Kaydetmeden çık"),
          ),
          TextButton(
            onPressed: () {
              if (enteredText != null && enteredText!.isNotEmpty) {
                print("Entered text: $enteredText");
                LocationData locationData = LocationData(
                  city: city,
                  district: district,
                  name: enteredText,
                  latitude: lat,
                  longitude: lng,
                );
                instance.insert(locationData).then(
                  (insertedId) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Veri Eklendi'),
                          content: Text('Veri başarıyla eklendi.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Diyalog kutusunu kapat
                                Navigator.pop(context); // Ana sayfaya dön
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ).catchError(
                  (error) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Hata'),
                          content:
                              Text('Veri eklenirken bir hata oluştu: $error'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Diyalog kutusunu kapat
                              },
                              child: Text('Tamam'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
                Navigator.pop(context); // Pencereyi kapat
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  return Colors.white;
                },
              ),
            ),
            child: Text("Kaydet"),
          ),
        ],
      );
    },
  );
}
