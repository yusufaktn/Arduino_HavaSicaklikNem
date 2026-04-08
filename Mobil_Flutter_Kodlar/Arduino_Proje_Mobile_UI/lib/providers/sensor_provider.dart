import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/sensor_data.dart';
import '../services/esp8266_service.dart';

class SensorProvider with ChangeNotifier {
  final Esp8266Service _esp8266Service;
  SensorData? _sensorData;
  List<SensorData> _sensorDataList = [];
  bool _isLoading = false;
  String _lastUpdateTime = '';

  SensorProvider(this._esp8266Service);

  SensorData? get sensorData => _sensorData;
  List<SensorData> get sensorDataList => _sensorDataList;
  bool get isLoading => _isLoading;
  String get lastUpdateTime => _lastUpdateTime;

  Future<void> fetchSensorData() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final data = await _esp8266Service.getSensorData();
      final newData = SensorData.fromJson(data);

      if (_sensorData != null &&
          _sensorData!.temperature == newData.temperature &&
          _sensorData!.humidity == newData.humidity) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      _sensorData = newData;
      if (newData.temperature != 0 && newData.humidity != 0) {
        _sensorDataList.add(_sensorData!);
        _lastUpdateTime = DateFormat('HH:mm:ss').format(DateTime.now());
      }

      if (_sensorDataList.length > 20) {
        _sensorDataList.removeAt(0);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
