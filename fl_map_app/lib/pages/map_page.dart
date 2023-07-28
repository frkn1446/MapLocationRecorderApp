import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? selectedPoint;

  // Yeni fonksiyon oluştur
  void _onRegisterButtonPressed() {
    if (selectedPoint != null) {
      _showDialogForTextEntry(
          context, selectedPoint!.latitude, selectedPoint!.longitude);
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

void _showDialogForTextEntry(BuildContext context, double lat, double lng) {
  String? enteredText;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Konumu hatırlamak için anahtar kelime giriniz\n"),
        // content: TextField(
        //   onChanged: (value) {
        //     enteredText = value;
        //   },
        //   decoration: InputDecoration(
        //     hintText: "Ahatar kelime",
        //   ),
        // ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Latitude: $lat"),
            Text("Longitude: $lng"),
            SizedBox(height: 16), // Araya boşluk ekleyebilirsiniz
            TextField(
              onChanged: (value) {
                enteredText = value;
              },
              decoration: InputDecoration(
                hintText: "Anahtar kelime",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pencereyi kapat
            },
            child: Text("Kaydetmeden çık"),
          ),
          TextButton(
            onPressed: () {
              if (enteredText != null && enteredText!.isNotEmpty) {
                print("Entered text: $enteredText");
              }
              Navigator.pop(context); // Pencereyi kapat
            },
            child: Text("Kaydet"),
          ),
        ],
      );
    },
  );
}
