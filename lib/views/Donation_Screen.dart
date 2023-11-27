import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:umma/ServerConfig.dart';
import 'package:umma/model/event.dart';
import 'package:umma/model/user.dart';
import 'package:umma/stripe_payment/payment_managmer.dart';
import 'package:umma/views/customerScreen.dart';
import 'package:http/http.dart' as http;

class donationScreen extends StatefulWidget {
  final Event event;
  final User user;
  const donationScreen({super.key, required this.event, required this.user});

  @override
  State<donationScreen> createState() => _donationScreenState();
}

class _donationScreenState extends State<donationScreen> {
  final TextEditingController name_input = TextEditingController();
  final TextEditingController email_input = TextEditingController();

  final TextEditingController amount_input = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, resWidth;
  void initState() {
    super.initState();
    name_input.text = widget.user.name.toString();
    email_input.text = widget.user.email.toString();
    amount_input.text = "0";
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.90;
    }
    return Scaffold(
      appBar: AppBar(
          title: const Text("Donation",
              style: TextStyle(
                color: Colors.black,
              ))),
      body: Center(
          child: SingleChildScrollView(
        child: Column(children: [
          Card(
            elevation: 8,
            child: Container(
              height: screenHeight / 3,
              width: resWidth,
              child: CachedNetworkImage(
                width: resWidth,
                fit: BoxFit.cover,
                imageUrl:
                    "${ServerConfig.SERVER}/assets/profileimages/${widget.user.id}.png",
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Card(
            margin: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: name_input,
                        enabled: false,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "name must be longer than 3"
                            : null,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.person),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        controller: email_input,
                        textInputAction: TextInputAction.next,
                        enabled: false,
                        validator: (val) => val!.isEmpty ||
                                !val.contains("@") ||
                                !val.contains(".")
                            ? "enter a valid email"
                            : null,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            icon: Icon(Icons.email),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        controller: amount_input,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Enter the amount that you want to pay',
                            icon: Icon(Icons.monetization_on_rounded),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      minWidth: 115,
                      height: 50,
                      color: Theme.of(context).colorScheme.primary,
                      elevation: 10,
                      onPressed: () => amount(),
                      child: const Text(
                        'Donat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      )),
    );
  }

  amount() {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Do you wnat to donate to this Event?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  paymentmehtod();
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void paymentmehtod() {
    int payment = int.parse(amount_input.text);
    if (payment > 0) {
      PaymentManager.makePayment(int.parse(amount_input.text), "MYR");

      String payment = amount_input.text;

      http.post(Uri.parse("${ServerConfig.SERVER}/php/donations.php"), body: {
        "userid": widget.user.id,
        "username": widget.user.name,
        "eventid": widget.event.id,
        "eventname": widget.event.eventTitle,
        "amount": payment,
        "state": "success",
      }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Timer(
              const Duration(seconds: 6),
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (content) =>
                          customer_screen(user: widget.user))));

          return;
        } else {
          Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          return;
        }
      });
    } else {
      Fluttertoast.showToast(
          msg: "Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
  }
}
