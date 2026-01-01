import 'dart:convert';
import 'package:http/http.dart' as http;

class NominatimService {
  static const String _baseUrl = 'https://nominatim.openstreetmap.org/search';

  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'q': query,
        'format': 'json',
        'addressdetails': '1',
        'limit': '5',
      },
    );

    try {
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'WysX App', // Required by Nominatim usage policy
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load places');
      }
    } catch (e) {
      // In a real app, log this error
      return [];
    }
  }
}
