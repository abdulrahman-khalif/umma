import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:umma/model/registered_event.dart';
import 'package:umma/views/Events_Registred.dart';

import 'package:umma/views/adminScreen.dart';
import '../ServerConfig.dart';

import '../model/user.dart';
import 'package:http/http.dart' as http;

class registeredEventDetails extends StatefulWidget {
  final User user;

  final Registered_event registered_event;

  const registeredEventDetails({
    super.key,
    required this.user,
    required this.registered_event,
  });

  @override
  State<registeredEventDetails> createState() => _registeredEventDetailsState();
}

class _registeredEventDetailsState extends State<registeredEventDetails> {
  late double screenHeight, screenWidth, resWidth;
  @override
  void initState() {
    super.initState();
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
          title: const Text("Details",
              style: TextStyle(
                color: Colors.black,
              )),
        ),
        body: Column(children: [
          SizedBox(
            height: 250,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Card(
                elevation: 8,
                child: Container(
                    height: screenHeight / 3,
                    width: 350,
                    child: CachedNetworkImage(
                      width: resWidth,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${ServerConfig.SERVER}/assets/home_images/${widget.registered_event.eventId}.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
              Card(
                elevation: 8,
                child: Container(
                    height: screenHeight / 3,
                    width: 350,
                    child: CachedNetworkImage(
                      width: resWidth,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${ServerConfig.SERVER}/assets/home_images/${widget.registered_event.eventId}_2.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
              Card(
                elevation: 8,
                child: Container(
                    height: screenHeight / 3,
                    width: 350,
                    child: CachedNetworkImage(
                      width: resWidth,
                      fit: BoxFit.cover,
                      imageUrl:
                          "${ServerConfig.SERVER}/assets/home_images/${widget.registered_event.eventId}_3.png",
                      placeholder: (context, url) =>
                          const LinearProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )),
              ),
            ]),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Stack(children: [
              Container(
                  padding: const EdgeInsets.only(top: 30, right: 40, left: 20),
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.registered_event.eventTitle}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Date: ${widget.registered_event.registeredDate}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ]),

                        const SizedBox(height: 8),

                        const Text(
                          'Event Description',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.registered_event.eventDesc}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),

                        const Text(
                          'Speaker:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          ' ${widget.registered_event.speaker}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 0, left: 40),
                              child: ElevatedButton(
                                onPressed: () {
                                  _deleteDialog();
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  fixedSize: Size(250,
                                      20), // Set the background color to red
                                ),
                                child: const Text("UnRegister"),
                              ),
                            ),
                          ],
                        ),

                        // Expanded(
                        //     child: Align(
                        //   alignment: FractionalOffset.bottomCenter,
                        //   child: SizedBox(
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //       children: [
                        //         IconButton(
                        //             iconSize: 22,
                        //             onPressed: makePhoneCall,
                        //             icon: const Icon(Icons.call)),
                        //         IconButton(
                        //             iconSize: 22,
                        //             onPressed: makemessage,
                        //             icon: const Icon(Icons.message)),
                        //         // IconButton(
                        //         //     iconSize: 22,
                        //         //     onPressed: whatsapp,
                        //         //     icon: const Icon(Icons.whatsapp)),
                        //         IconButton(
                        //             iconSize: 22,
                        //             onPressed: onRoute,
                        //             icon: const Icon(Icons.map)),
                        //         IconButton(
                        //             iconSize: 22,
                        //             onPressed: onShowMap,
                        //             icon: const Icon(Icons.maps_home_work))
                        //       ],
                        //     ),
                        //   ),
                        // )),
                      ])),
            ]),
          ),
        ]));
  }

  void _deleteDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              truncateString(
                  "Unregister for this event ${(widget.registered_event.eventTitle.toString())}",
                  25),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _deleteHomestay();
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

  void _deleteHomestay() {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}/php/unregistered.php"),
          body: {
            "id": widget.registered_event.id,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (content) => event_registered(user: widget.user)));

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
    } catch (e) {
      print(e.toString());
    }
  }
}
