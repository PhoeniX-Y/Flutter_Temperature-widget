import 'package:flutter/material.dart';
import 'temperature_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Widget Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semi-Circular Temperature Widget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SemiCircularTemperatureWidget(
              temperature: 25.0,
              radius: 150,
              strokeWidth: 15,
              backgroundColor: Colors.grey[200]!,
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap to toggle between °C and °F',
              style: TextStyle(fontSize: 26),
            ),
          ],
        ),
      ),
    );
  }
}
