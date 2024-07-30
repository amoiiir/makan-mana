import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Makan Mana?',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontFamily: 'Poppins',
          //call font styles from pubspec.yaml
          fontWeight: FontWeight.bold
        ),
      ),
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
    );
  }
}