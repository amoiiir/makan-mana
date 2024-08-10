import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:toastification/toastification.dart';

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
    FortuneItem(
        child: Text('1st Suggestion',
            style: TextStyle(color: Colors.white, fontSize: 20))),
    FortuneItem(
        child: Text('2nd Suggestion',
            style: TextStyle(color: Colors.white, fontSize: 20))),
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
              const Text('Put at least 2 suggestions!!',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 30),
              _fortuneWheel(),
              const SizedBox(height: 30),
              _spinButton()
            ],
          ),
        ));
  }

  Container _spinButton() {
    return Container(
      margin: const EdgeInsets.only(left: 60, right: 60),
      child: Visibility(
        visible: items.length >= 2,
        child: ElevatedButton(
          onPressed: () {
            //spin the wheel
            var randNum = Random().nextInt(items.length);
            selected.add(randNum);
            var result = (items[randNum].child as Text).data;
            debugPrint('Result: $result');
            if (result == '1st Suggestion' || result == '2nd Suggestion') {
              //show error dialog
              _showToast(context, "Please add more suggestions!!");
              return;
            }
            //add delay
            Future.delayed(const Duration(seconds: 5), () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Result'),
                    content: Text("We are going to eat at $result"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            });
          },
          style: ButtonStyle(
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            elevation: WidgetStateProperty.all(5),
          ),
          child: const Text(
            'Spin the wheel',
            style: TextStyle(
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Container _fortuneWheel() {
    return Container(
      height: 300,
      child: Visibility(
        visible: items.length >= 2,
        child: FortuneWheel(
          selected: selected.stream,
          items: items,
          physics: NoPanPhysics(),
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
      ),
    );
  }

  Container _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            color: const Color(0xff1D1617).withOpacity(0.11),
            spreadRadius: 0.0,
            blurRadius: 20,
            offset: const Offset(0, 3))
      ]),
      child: TextField(
        controller: myController,
        onSubmitted: (text) {
          //should not be empty
          if (text.isEmpty) {
            _showToast(context, "Suggestion is empty!!");
            return;
          }
          // check the list if 1st and 2nd suggestion is still there
          debugPrint('Hello: ${(items[0].child as Text).data}');
          debugPrint('Value: ${(items[1].child as Text).data}');
          setState(() {
            if ((items[0].child as Text).data == '1st Suggestion') {
              items[0] = FortuneItem(
                  child: Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)));
              return;
            }
            if ((items[1].child as Text).data == '2nd Suggestion') {
              items[1] = FortuneItem(
                  child: Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20)));
              return;
            } else {
              items.add(FortuneItem(
                  child: Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 20))));
            }
          });
          myController.clear();
        },
        decoration: InputDecoration(
          hintText: 'Restaurant suggestions',
          hintStyle: const TextStyle(
              color: Colors.grey, fontSize: 16, fontFamily: 'Poppins'),
          prefixIcon:
              const Icon(Icons.question_mark_outlined, color: Colors.grey),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white, width: 0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white, width: 0)),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message){
    toastification.show(
              context: context, // optional if you use ToastificationWrapper
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 5),
              title: Text(message),
              // you can also use RichText widget for title and description parameters
              alignment: Alignment.bottomCenter,
              direction: TextDirection.ltr,
              animationDuration: const Duration(milliseconds: 300),
              animationBuilder: (context, animation, alignment, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              icon: const Icon(Icons.error),
              showIcon: true, // show or hide the icon
              primaryColor: Colors.red[100],
              // backgroundColor: Colors.blue,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x07000000),
                  blurRadius: 16,
                  offset: Offset(0, 16),
                  spreadRadius: 0,
                )
              ],
              showProgressBar: false,
              closeButtonShowType: CloseButtonShowType.onHover,
              closeOnClick: true,
              pauseOnHover: true,
            );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Makan Mana?',
        style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Poppins',
            //call font styles from pubspec.yaml
            fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      elevation: 1,
      backgroundColor: Colors.white,
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: PopupMenuButton<int>(
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: (item) => handleClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(value: 0, child: Text('Modify Suggestions')),
              PopupMenuItem<int>(value: 1, child: Text('Clear Suggestions')),
            ],
          ),
        ),
      ],
    );
  }

  void handleClick(int item) {
    switch (item) {
      case 0:
        //allow user to modify the suggestions
        
      case 1:
        //check the current size of the items
        setState(() {
          items.clear();
          items.add(
            FortuneItem(
                child: Text('1st Suggestion',
                    style: TextStyle(color: Colors.white, fontSize: 20))),
          );
          items.add(
            FortuneItem(
                child: Text('2nd Suggestion',
                    style: TextStyle(color: Colors.white, fontSize: 20))),
          );
        });
        _showToast(context, "Suggestions cleared!!");
        //check the current size of the items
        break;
    }
  }
}
