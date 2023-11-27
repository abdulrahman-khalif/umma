import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:umma/ServerConfig.dart';
import 'package:umma/model/event.dart';
import 'package:umma/views/MainManue2.dart';
import 'package:umma/views/UpdateDetailsEvent.dart';

import 'MainManue.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/user.dart';
import 'NewEvent.dart';

class adminside extends StatefulWidget {
  final User user;
  const adminside({super.key, required this.user});

  @override
  State<adminside> createState() => _adminsideState();
}

class _adminsideState extends State<adminside> {
  //List<Event> eventList = <Event>[];

  String titlecenter = "No Events yet Uploaded to the database";

  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  List<Event> eventlist = <Event>[];
  @override
  void initState() {
    super.initState();
    _loadevents();
  }

  @override
  void dispose() {
    eventlist = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: const Text("Manage Events",
                style: TextStyle(
                  color: Colors.black,
                )),
            actions: [
              PopupMenuButton(
                  // add icon, by default "3 dot" icon
                  // icon: Icon(Icons.book)
                  itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("New Event"),
                  ),
                ];
              }, onSelected: (value) {
                if (value == 0) {
                  _AddNew_Event();
                  print("My account menu is selected.");
                } else if (value == 1) {
                  print("Settings menu is selected.");
                } else if (value == 2) {
                  print("Logout menu is selected.");
                }
              }),
            ]),
        body: eventlist.isEmpty
            ? Center(
                child: Container(
                  height: 64,
                  child: Column(children: [
                    Text(titlecenter),
                  ]),
                ),
              )
            : Column(children: [
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(eventlist.length, (index) {
                      return Card(
                        elevation: 8,
                        child: InkWell(
                          onTap: () {
                            _showDetails(index);
                          },
                          onLongPress: () {
                            _deleteDialog(index);
                          },
                          child: Column(children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Flexible(
                              flex: 6,
                              //image data:
                              child: CachedNetworkImage(
                                width: resWidth / 2,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${ServerConfig.SERVER}/assets/home_images/${eventlist[index].id}.png",
                                placeholder: (context, url) =>
                                    const LinearProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            Flexible(
                                flex: 4,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Text(
                                        truncateString(
                                            eventlist[index]
                                                .eventTitle
                                                .toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Due Date: ${truncateString(eventlist[index].duedate.toString(), 15)}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Event Date: ${truncateString(eventlist[index].eventDate.toString(), 15)}",
                                        style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ])))
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
              ]),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (widget.user.id != "na") {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (content) => NewEvent(
                              user: widget.user,
                            )));
                _loadevents();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Please login/register an account")));
              }
            },
            child: const Text(
              "+",
              style: TextStyle(fontSize: 32),
            )),
        drawer: widget.user.userType == "customer"
            ? MainManue2(user: widget.user)
            : MainManue(user: widget.user));
  }

  Future<void> _AddNew_Event() async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please login/register",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);

      return;
    }
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => NewEvent(
                  user: widget.user,
                )));
    _loadevents();
    // ProgressDialog progressDialog = ProgressDialog(
    //   context,
    //   blur: 10,
    //   message: const Text("Searching your current location"),
    //   title: null,
    // );

    // progressDialog.show();
    // if (await _checkPermissionGetLoc()) {
    //   progressDialog.dismiss();
    //   await Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //           builder: (content) => NewHome(
    //                 user: widget.user,
    //                 position: _position,
    //               )));
    //   _loadhome();
    // } else {
    //   Fluttertoast.showToast(
    //       msg: "Please allow the app to access the location",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       fontSize: 14.0);
    // }
  }

  void _loadevents() {
    if (widget.user.id == "0") {
      //check if the user is registered or not
      Fluttertoast.showToast(
          msg: "Please register an account first", //Show toast
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);

      return; //exit method if true
    }
    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}/php/loadevent.php?userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        log(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          log(response.body);
          if (extractdata['events'] != null) {
            log(response.body);
            eventlist = <Event>[];
            extractdata['events'].forEach((v) {
              eventlist.add(Event.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No Home Available";
            eventlist.clear();
          }
        }
      } else {
        titlecenter = "No Home Available";

        eventlist.clear();
      }

      setState(() {});
    });
  }

  Future<void> _showDetails(int index) async {
    Event event = Event.fromJson(eventlist[index].toJson());

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => UpdateDetailsEvent(
                  event: event,
                  user: widget.user,
                )));
    _loadevents();
  }

  void _deleteDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(
              truncateString(
                  "Delete ${(eventlist[index].eventTitle.toString())}", 15),
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
                  _deleteHomestay(index);
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

  void _deleteHomestay(int index) {
    try {
      http.post(Uri.parse("${ServerConfig.SERVER}/php/delete_event.php"),
          body: {
            "id": eventlist[index].id,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadevents();
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

String truncateString(String str, int size) {
  if (str.length > size) {
    str = str.substring(0, size);
    return "$str...";
  } else {
    return str;
  }
}
