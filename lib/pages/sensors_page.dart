import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  String acelerometro = '', giroscopio = '', magnetometro = '', userAccel = '';
  late final StreamSubscription<AccelerometerEvent> _accelSub;
  late final StreamSubscription<GyroscopeEvent> _gyroSub;
  late final StreamSubscription<MagnetometerEvent> _magSub;

  @override
  void initState() {
    super.initState();
    _accelSub = SensorsPlatform.instance.accelerometerEventStream().listen((e) {
      if (!mounted) return;
      setState(() {
        acelerometro = 'Acelerómetro:\nX: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)}';
      });
    });

    _gyroSub = SensorsPlatform.instance.gyroscopeEventStream().listen((e) {
      if (!mounted) return;
      setState(() {
        giroscopio = 'Giroscopio:\nX: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)}';
      });
    });

    _magSub = SensorsPlatform.instance.magnetometerEventStream().listen((e) {
      if (!mounted) return;
      setState(() {
        magnetometro = 'Magnetómetro:\nX: ${e.x.toStringAsFixed(2)}\nY: ${e.y.toStringAsFixed(2)}\nZ: ${e.z.toStringAsFixed(2)}';
      });
    });
  }

  @override
  void dispose() {
    _accelSub.cancel();
    _gyroSub.cancel();
    _magSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4DFF4),
      appBar: AppBar(
        title: const Text('Sensores del Móvil'),
        backgroundColor: const Color(0xFFF4DFF4),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSensorCard(acelerometro, 'Acelerómetro'),
            const SizedBox(height: 10),
            _buildSensorCard(giroscopio, 'Giroscopio'),
            const SizedBox(height: 10),
            _buildSensorCard(magnetometro, 'Magnetómetro'),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorCard(String sensorData, String title) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 131, 66, 42),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sensorData,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
