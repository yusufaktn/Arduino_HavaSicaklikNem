import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sensor_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/sensor_data_view.dart';
import '../widgets/settings_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    final settings = context.read<SettingsProvider>();
    if (settings.isAutoRefresh) {
      _timer = Timer.periodic(
        Duration(seconds: settings.refreshInterval),
        (_) => _refreshData(),
      );
    }
  }

  Future<void> _refreshData() async {
    await context.read<SensorProvider>().fetchSensorData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => const SettingsDialog(),
    ).then((_) => _startTimer()); // Dialog kapandığında timer'ı yeniden başlat
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Settings değiştiğinde timer'ı yeniden başlat
    context.watch<SettingsProvider>();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final sensorProvider = context.watch<SensorProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.thermostat, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'Hava Durumu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.water_drop, color: Colors.blue),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          SensorDataView(
            sensorData: sensorProvider.sensorData,
            sensorDataList: sensorProvider.sensorDataList,
            lastUpdateTime: sensorProvider.lastUpdateTime,
            onRefresh: _refreshData,
          ),
          if (sensorProvider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.0),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
