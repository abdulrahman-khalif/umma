import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:umma/views/EventDetails.dart';
import 'package:umma/views/MainManue.dart';
import 'package:http/http.dart' as http;
import 'package:umma/views/MainManue2.dart';

import '../ServerConfig.dart';
import '../model/event.dart';
import '../model/user.dart';

class customer_screen extends StatefulWidget {
  final User user;
  customer_screen({super.key, required this.user});

  @override
  State<customer_screen> createState() => _customer_screenState();
}

class _customer_screenState extends State<customer_screen> {
  List<Event> eventlist = <Event>[];
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
    eventlist = [];
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
          title: const Text("Event List",
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
        body: eventlist.isEmpty
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
                    children: List.generate(eventlist.length, (index) {
                      return Card(
                        elevation: 8,
                        child: InkWell(
                          onTap: () {
                            _showDetails(index);
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
                                      Text(
                                        truncateString(
                                            eventlist[index]
                                                .eventDate
                                                .toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        truncateString(
                                            eventlist[index].duedate.toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
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
          "${ServerConfig.SERVER}/php/loadallevent.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['events'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            eventlist = <Event>[];
            extractdata['events'].forEach((v) {
              eventlist.add(Event.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No data Available";
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
    Event events = Event.fromJson(eventlist[index].toJson());

    Timer(const Duration(seconds: 1), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => EventDetails(
                    user: widget.user,
                    event: events,
                  )));
    });
  }

  void loadSingleSeller(int index) {
    http.post(Uri.parse("${ServerConfig.SERVER}/php/load_seller_home.php"),
        body: {"sellerid": eventlist[index].userId}).then((response) {
      print(response.body);
      var jsonResponse = json.decode(response.body);
      if (response.statusCode == 200 && jsonResponse['status'] == "success") {
        seller = User.fromJson(jsonResponse['data']);
      }
    });
  }
}
