import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:umma/ServerConfig.dart';
import 'package:umma/model/donation.dart';
import 'package:umma/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:umma/views/Donation_details.dart';
import 'package:umma/views/MainManue.dart';
import 'package:umma/views/MainManue2.dart';

// ignore: must_be_immutable
class manage_donation extends StatefulWidget {
  final User user;
  const manage_donation({super.key, required this.user});

  @override
  State<manage_donation> createState() => _manage_donationState();
}

class _manage_donationState extends State<manage_donation> {
  List<Donation> donationlist = <Donation>[];
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
    _loaddonation("all", 1);
  }

  @override
  void dispose() {
    donationlist = [];
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
          title: const Text("Manage Donaation",
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
        body: donationlist.isEmpty
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
                        onPressed: Rest_load,
                        icon: const Icon(Icons.restart_alt_rounded)),
                  ]),
                ),
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: rowcount,
                    children: List.generate(donationlist.length, (index) {
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
                                        "${ServerConfig.SERVER}/assets/profileimages/${donationlist[index].userId}.png",
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
                                            donationlist[index]
                                                .userName
                                                .toString(),
                                            15),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "RM ${double.parse(donationlist[index].amount.toString())..toStringAsFixed(2)} ",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          )),
                                      Text(
                                          df.format(DateTime.parse(
                                              donationlist[index]
                                                  .date
                                                  .toString())),
                                          style: const TextStyle(
                                            fontSize: 12,
                                          )),
                                    ]),
                                  ),
                                )
                              ])));
                    }),
                  ),
                ),
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
                        onPressed: () => {_loaddonation(search, index + 1)},
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

  void _loaddonation(String search, int pageno) {
    curpage = pageno; //init current page
    numofpage ?? 1; //get total num of pages if not by default set to only 1

    http
        .get(
      Uri.parse(
          "${ServerConfig.SERVER}/php/load_donations.php?search=$search&pageno=$pageno"),
    )
        .then((response) {
      log(response.body);

      if (response.statusCode == 200) {
        log(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          if (extractdata['events'] != null) {
            numofpage = int.parse(jsondata['numofpage']);
            numberofresult = int.parse(jsondata['numberofresult']);
            donationlist = <Donation>[];
            extractdata['events'].forEach((v) {
              donationlist.add(Donation.fromJson(v));
            });
            titlecenter = "Found";
          } else {
            titlecenter = "No data Available";
            donationlist.clear();
          }
        }
      } else {
        titlecenter = "No Home Available";
        donationlist.clear();
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
                    _loaddonation(search, 1);
                  },
                  child: const Text("Search"),
                ),
              ],
            );
          });
        });
  }

  void Rest_load() {
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
      _loaddonation(search, 1);
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
    Donation donat = Donation.fromJson(donationlist[index].toJson());

    Timer(const Duration(seconds: 0), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (content) => donation_details(
                    user: widget.user,
                    donation: donat,
                  )));
    });
  }
}
