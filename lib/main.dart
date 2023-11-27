import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:umma/stripe_payment/stripe_keys.dart';
import 'package:umma/views/SplashScreen.dart';

void main() {
  Stripe.publishableKey = ApiKeys.publishablekey;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UMMA',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: const MySplaschScreen(),
    );
  }
}
