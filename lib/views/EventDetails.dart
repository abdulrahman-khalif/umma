import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:umma/views/Donation_Screen.dart';
import 'package:umma/views/Events_Registred.dart';
import '../ServerConfig.dart';
import '../model/event.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

class EventDetails extends StatefulWidget {
  final User user;
  final Event event;

  const EventDetails({
    super.key,
    required this.user,
    required this.event,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
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
                          "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}.png",
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
                          "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}_2.png",
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
                          "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}_3.png",
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
                                '${widget.event.eventTitle}',
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Date: ${widget.event.eventDate}',
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
                          '${widget.event.eventDesc}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Due Date:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.event.duedate}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Speaker:',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          ' ${widget.event.speaker}',
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
                                  top: 0, right: 0, left: 20),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  makeDonation();
                                },
                                icon: const Icon(
                                  Icons
                                      .payments_outlined, // Replace 'Icons.payment' with the desired icon
                                  size: 20, // Adjust the size as needed
                                ),
                                label: const Text("Donation"),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 0, right: 0, left: 40),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  InsertRegisterEvent();
                                },
                                icon: const Icon(
                                  Icons
                                      .done_all_rounded, // Replace 'Icons.payment' with the desired icon
                                  size: 20, // Adjust the size as needed
                                ),
                                label: const Text("Register"),
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

  void InsertRegisterEvent() {
    String userid = widget.user.id.toString();
    String eventid = widget.event.id.toString();
    String event_Tital = widget.event.eventTitle.toString();
    String eventdesc = widget.event.eventDesc.toString();
    String speaker = widget.event.speaker.toString();

    http.post(
      Uri.parse("${ServerConfig.SERVER}/php/insertRegisterEvent.php"),
      body: {
        "userid": userid,
        "eventid": eventid,
        "event_title": event_Tital,
        "event_desc": eventdesc,
        "speaker": speaker,
      },
    ).then((response) {
      var data = jsonDecode(response.body);
      log(response.body);

      if (response.statusCode == 200) {
        if (data['status'] == "success") {
          log(response.body);
          Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
          );
          Navigator.of(context).pop();
          MaterialPageRoute(
            builder: (content) => event_registered(user: widget.user),
          );
        } else if (data['status'] == "already_registered") {
          Fluttertoast.showToast(
            msg: "You are already registered for this event",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Failed to connect to the server",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0,
        );
      }
    });
  }

  void makeDonation() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => donationScreen(
                  user: widget.user,
                  event: widget.event,
                )));
  }
}
