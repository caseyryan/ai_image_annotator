import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Image Annotator'),
      ),
      body: Center(
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(20.0),
          minScale: 0.1,
          maxScale: 5.0,
          child: Container(
            width: 2000.0,
            height: 5000.0,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.red],
                stops: <double>[0.0, 1.0],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
