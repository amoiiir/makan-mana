import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  //selection
  StreamController<int> selected = StreamController<int>();
  final myController = TextEditingController();

  List<FortuneItem> items = [
              FortuneItem(child: Text('KFC', style: TextStyle(color: Colors.white, fontSize: 20))),
              FortuneItem(child: Text('McDonalds', style: TextStyle(color: Colors.white, fontSize: 20))),
              // FortuneItem(child: Text('Pizza Hut', style: TextStyle(color: Colors.white, fontSize: 20))),
              // FortuneItem(child: Text('Subway', style: TextStyle(color: Colors.white, fontSize: 20))),
              // FortuneItem(child: Text('Starbucks', style: TextStyle(color: Colors.white, fontSize: 20))),
              // FortuneItem(child: Text('Nandos', style: TextStyle(color: Colors.white, fontSize: 20))),
            ];

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.blueGrey[50],
      //kenapa bila nak tambah banyak kena dalam children
      body: SingleChildScrollView(
        child: Column(
          children: [
            _searchBar(),
            const SizedBox(height: 15),
            const Text('Put at least 2 suggestions!!', style: TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Poppins')),
            const SizedBox(height: 30),
            _fortuneWheel(),
            const SizedBox(height: 30),
            _spinButton()
          ],
        ),
      )
    );
  }

  Container _spinButton() {
    return Container(
            margin: const EdgeInsets.only(left: 60, right: 60),
            child: ElevatedButton(
              onPressed: (){
                //spin the wheel
                selected.add(Random().nextInt(items.length));
              },
              style: ButtonStyle(
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                elevation: WidgetStateProperty.all(5),
              ),
              child: const Text(
                'Spin the wheel',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          );
  }

  Container _fortuneWheel() {
    return Container(
          height: 300,
          child: FortuneWheel(
            selected: selected.stream,
            items: items,
            physics: CircularPanPhysics(
              duration: const Duration(seconds: 5),
              curve: Curves.decelerate
            ),
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: Colors.red,
                  width: 30.0,
                ),
                )
            ],
          ),
        );
  }

  Container _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            spreadRadius: 0.0,
            blurRadius: 20,
            offset: const Offset(0, 3)
          )
        ]
      ),
      child: TextField( 
        controller: myController,
        onSubmitted: (text) {
          debugPrint('Restaurant suggestion: $myController');
          setState(() {
            items.add(FortuneItem(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20))));
          });
          myController.clear();
        },
        decoration: InputDecoration(
          hintText: 'Restaurant suggestions',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Poppins'
          ),
          prefixIcon: const Icon(Icons.question_mark_outlined, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 0)
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white, width: 0)
          )
        ),
      ),
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