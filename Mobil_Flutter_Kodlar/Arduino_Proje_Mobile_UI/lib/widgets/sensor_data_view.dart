import 'package:flutter/material.dart';

import '../models/sensor_data.dart';
import 'current_data_card.dart';
import 'empty_sensor_card.dart';
import 'humidity_chart.dart';
import 'temperature_chart.dart';

class SensorDataView extends StatelessWidget {
  final SensorData? sensorData;
  final List<SensorData> sensorDataList;
  final String lastUpdateTime;
  final Future<void> Function() onRefresh;

  const SensorDataView({
    super.key,
    required this.sensorData,
    required this.sensorDataList,
    required this.lastUpdateTime,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (sensorData != null && !(sensorData!.temperature == 0 && sensorData!.humidity == 0))
              CurrentDataCard(data: sensorData!)
            else
              const EmptySensorCard(),
            const SizedBox(height: 20),
            _buildGraphHeader(),
            const SizedBox(height: 16),
            _buildGraphs(),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Grafikler',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Son güncelleme: $lastUpdateTime',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildGraphs() {
    if (sensorDataList.isEmpty) {
      return const Center(
        child: Text(
          'Henüz veri yok',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Column(
      children: [
        TemperatureChart(data: sensorDataList),
        const SizedBox(height: 20),
        HumidityChart(data: sensorDataList),
      ],
    );
  }
}
