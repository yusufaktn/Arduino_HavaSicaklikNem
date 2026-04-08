import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http; // "as http" önemli!

class Esp8266Service {
  final String baseUrl;
  final http.Client client;

  Esp8266Service({required this.baseUrl, http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> getSensorData() async {
    final uri = Uri.parse('$baseUrl/data');

    try {
      final response = await client.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return _parseResponse(response.body);
      } else {
        return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Bağlantı hatası'};
      }
    } on SocketException {
      return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Bağlantı bekleniyor...'};
    } on TimeoutException {
      return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Bağlantı bekleniyor...'};
    } on FormatException {
      return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Veri hatası'};
    } catch (e) {
      return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Bağlantı bekleniyor...'};
    }
  }

  Map<String, dynamic> _parseResponse(String body) {
    try {
      return json.decode(body) as Map<String, dynamic>;
    } on FormatException {
      return {'temperature': 0.0, 'humidity': 0.0, 'status': 'Veri hatası'};
    }
  }

  String _handleStatusCode(int code) {
    const statusCodes = {
      503: 'Cihaz sensör verisi alamıyor',
      404: 'Endpoint bulunamadı',
      500: 'Sunucu iç hatası'
    };
    return statusCodes[code] ?? 'Bilinmeyen hata (Kod: $code)';
  }
}
