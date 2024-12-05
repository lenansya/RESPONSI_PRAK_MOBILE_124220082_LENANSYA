import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = 'https://www.amiiboapi.com/';

  static Future<List<dynamic>> getData(String endpoint) async {
    try {
      final response = await http.get(Uri.parse(baseUrl + endpoint));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['amiibo'] ?? []; // Disesuaikan dengan struktur API
      } else {
        throw Exception("Failed to load data! Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching data: $e");
    }
  }

  static Future<Map<String, dynamic>> getDetailData(String endpoint, int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$endpoint/$id'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to load data! Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching detail data: $e");
    }
  }
}
