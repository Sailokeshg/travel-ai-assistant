import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/app_constants.dart';

class RecommendationService {
  static Future<String> getRecommendation(String userInput) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_input': userInput}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'];
    } else {
      throw Exception('Backend error: ${response.statusCode}');
    }
  }
}
