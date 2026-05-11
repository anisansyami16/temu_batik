import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

class TemuBatikApp extends StatelessWidget {
  const TemuBatikApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temu Batik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.brown, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
