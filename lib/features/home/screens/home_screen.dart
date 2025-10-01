import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Text('Welcome to Home', style: TextStyle(color: color.primary)),
      ),
    );
  }
}
