import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:umma/views/MainManue.dart';
import 'package:http/http.dart' as http;
import 'package:umma/views/MainManue2.dart';
import 'package:umma/views/registeredEventDetails.dart';

import '../ServerConfig.dart';

import '../model/registered_event.dart';
import '../model/user.dart';

class event_registered extends StatefulWidget {
  final User user;
  event_registered({super.key, required this.user});

  @override
  State<event_registered> createState() => _event_registeredState();
}

class _event_registeredState extends State<event_registered> {
  List<Registered_event> registered_events = <Registered_event>[];
  String titlecenter = "";
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  TextEditingController searchController = TextEditingController();
  String search = "all";
  var seller;
  //for pagination
  var color;
  var numofpage, curpage = 1;
  int numberofresult = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadallevent("all", 1);
    });
  }

  @override
  void dispose() {
    registered_events = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 700) {
      resWidth = screenWidth;
      rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      rowcount = 3;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Events Registred List",
              style: TextStyle(
                color: Colors.black,
              )),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _loadSearchDialog();
              },
            ),
          ],
        ),
        body: registered_events.isEmpty
            ? Center(
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)))
            : Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(children: [
                    Text(
                      "Events : /($numberofresult found)",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: Rest_loadHome,
                        icon: const Icon(Icons.restart_alt_rounded)),
                  ]),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    children: List.generate(registered_events.length, (index) {
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
                              child: CachedNetworkImage(
                                width: resWidth / 2,
                                fit: BoxFit.cover,
                                imageUrl:
                                    "${ServerConfig.SERVER}/assets/home_images/${registered_events[index].eventId}.png",
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
                                            registered_events[index]
                                                .eventTitle
                                                .toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Date: ${registered_events[index].registeredDate}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      // Text(
                                      //   truncateString(
                                      //       registered_events[index]
                                      //           .eventDate
                                      //           .toString(),
                                      //       15),
                                      //   style: const TextStyle(
                                      //       fontSize: 14,
                                      //       fontWeight: FontWeight.bold),
                                      // ),
                                    ]))),
                          ]),
                        ),
                      );
                    }),
                  ),
                ),
                //pagination widget
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((curpage - 1) == index) {
                        //set current page number active
                        color = Colors.blue;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                        onPressed: () => {_loadallevent(search, index + 1)},
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ]),
        drawer: widget.user.userType == "customer"
            ? MainManue2(user: widget.user)
            : MainManue(user: widget.user));
  }

  void _loadallevent(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage ?? 1; //get total num of pages if not by default set to only 1

    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}/php/load_resgistered_event.php?search=$search&pageno=$pageno&userid=${widget.user.id}"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['events'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            registered_events = <Registered_event>[];
            extractdata['events'].forEach((v) {
              registered_events.add(Registered_event.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No data Available";
            registered_events.clear();
          }
        }
      } else {
        titlecenter = "No Home Available";
        registered_events.clear();
      }

      setState(() {});
    });
  }

  void _loadSearchDialog() {
    searchController.text = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                "Search ",
              ),
              content: SizedBox(
                //height: screenHeight / 4,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  const SizedBox(height: 5),
                ]),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    search = searchController.text;
                    Navigator.of(context).pop();
                    _loadallevent(search, 1);
                  },
                  child: const Text("Search"),
                ),
              ],
            );
          });
        });
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void Rest_loadHome() {
    if (search == "all") {
      Fluttertoast.showToast(
          msg: "The Home page has already reset to the default",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    } else {
      search = "all";
      _loadallevent(search, 1);
    }
  }

  void _showDetails(int index) async {
    if (widget.user.id == "0") {
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    Registered_event events =
        Registered_event.fromJson(registered_events[index].toJson());

    Timer(const Duration(seconds: 1), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => registeredEventDetails(
                    user: widget.user,
                    registered_event: events,
                  )));
    });
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
                  "Unregister for this event ${(registered_events[index].eventTitle.toString())}",
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
      http.post(Uri.parse("${ServerConfig.SERVER}/php/unregistered.php"),
          body: {
            "id": registered_events[index].id,
          }).then((response) {
        var data = jsonDecode(response.body);
        if (response.statusCode == 200 && data['status'] == "success") {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 14.0);
          _loadallevent("all", 1);
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
