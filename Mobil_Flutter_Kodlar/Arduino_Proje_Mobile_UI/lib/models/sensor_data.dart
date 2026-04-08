class SensorData {
  final double temperature;
  final double humidity;
  final String status;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.status,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      temperature: json['temperature'].toDouble(),
      humidity: json['humidity'].toDouble(),
      status: json['status'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'status': status,
    };
  }
}
