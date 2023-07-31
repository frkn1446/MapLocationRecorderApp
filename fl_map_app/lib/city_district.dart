import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, String>> getCityAndDistrict(
    double latitude, double longitude) async {
  String YOUR_API_KEY = '';
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$YOUR_API_KEY';

  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final results = data['results'] as List<dynamic>;
        if (results.isNotEmpty) {
          String city = '';
          String district = '';
          city = data['results'][0]['address_components'][4]['long_name'];
          print('city: ' + city);
          district = data['results'][0]['address_components'][3]['long_name'];
          print('district: ' + district);

          return {'city': city, 'district': district};
        }
      }
    } else {
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }
  return {'city': '', 'district': ''};
}
