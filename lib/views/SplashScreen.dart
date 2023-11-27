//import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';

import 'LoginScreen.dart';

class MySplaschScreen extends StatefulWidget {
  const MySplaschScreen({super.key});

  @override
  State<MySplaschScreen> createState() => _MySplaschScreen();
}

class _MySplaschScreen extends State<MySplaschScreen> {
  @override
  void initState() {
    super.initState();

    // User user = User(
    //     id: "0",
    //     email: "unregistered",
    //     name: "unregistered",
    //     address: "na",
    //     phone: " - ",
    //     regdate: "0");

    Timer(
        const Duration(seconds: 6),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/most-beautiful-mosques.jpg"),
              fit: BoxFit.cover,
            )),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("UMMA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    )),
                CircularProgressIndicator(
                  color: Colors.green,
                  backgroundColor: Colors.grey,
                ),
                Text(
                  "Version 1.0.0b",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )));
  }
}
