import 'dart:convert';
//import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:umma/ServerConfig.dart';
import 'package:umma/model/event.dart';
import 'package:umma/model/user.dart';
import 'package:umma/views/adminScreen.dart';

class UpdateDetailsEvent extends StatefulWidget {
  final Event event;
  final User user;
  const UpdateDetailsEvent(
      {super.key, required this.event, required this.user});

  @override
  State<UpdateDetailsEvent> createState() => _UpdateDetailsEventState();
}

class _UpdateDetailsEventState extends State<UpdateDetailsEvent> {
  late double screenHeight, screenWidth, resWidth;
  int rowcount = 2;
  // File? _imageone;
  // File? _imagetwo;
  // File? _imagetree;
  // bool _isChecked = false;
  var m1 = false, m2 = false, m3 = false;
  var pathAsset = "assets/images/camera.png";

  final TextEditingController _TitalController = TextEditingController();
  final TextEditingController _DecController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _DueDateController = TextEditingController();
  final TextEditingController _SpeakerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void initState() {
    super.initState();
    _TitalController.text = widget.event.eventTitle.toString();
    _DecController.text = widget.event.eventDesc.toString();
    _SpeakerController.text = widget.event.speaker.toString();
    _dataController.text = widget.event.eventDate.toString();
    _DueDateController.text = widget.event.duedate.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
    } else {
      resWidth = screenWidth * 0.75;
    }
    return Scaffold(
        appBar: AppBar(
            title: const Text("Details/Update",
                style: TextStyle(
                  color: Colors.black,
                ))),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(
            height: 250,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),

              //show image 2

              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}_2.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),

              //show image 3

              Card(
                elevation: 8,
                child: Container(
                  height: screenHeight / 3,
                  width: resWidth,
                  child: CachedNetworkImage(
                    width: resWidth,
                    fit: BoxFit.cover,
                    imageUrl:
                        "${ServerConfig.SERVER}/assets/home_images/${widget.event.id}_3.png",
                    placeholder: (context, url) =>
                        const LinearProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  child: Column(children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Event Detailes",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        // user start register

                        TextFormField(
                            controller: _TitalController,
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? " Event name must be longer than 3"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Event Title:',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.title),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _DecController,
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty
                                ? "Event description must be not empty"
                                : null,
                            maxLines: 4,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Event Description:',
                                alignLabelWithHint: true,
                                labelStyle: TextStyle(),
                                icon: Icon(
                                  Icons.description,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),

                        Row(
                          children: [
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: true,
                                  validator: (val) => val!.isEmpty
                                      ? "set date for this event"
                                      : null,
                                  controller: _dataController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Date',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.date_range),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            ),
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  enabled: true,
                                  validator: (val) => val!.isEmpty
                                      ? "Due date for this Event"
                                      : null,
                                  controller: _DueDateController,
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                      labelText: 'Due date',
                                      labelStyle: TextStyle(),
                                      icon: Icon(Icons.date_range),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2.0),
                                      ))),
                            )
                          ],
                        ),
                        Row(children: [
                          Flexible(
                            flex: 5,
                            child: TextFormField(
                                controller: _SpeakerController,
                                textInputAction: TextInputAction.next,
                                validator: (val) => val!.isEmpty
                                    ? "Enter Presenter for this event"
                                    : null,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText:
                                        'Speakers or Presenters for this Event.',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.mic),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    ))),
                          ),
                        ]),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            child: const Text('Update Event'),
                            onPressed: () => {UpdateEventDialog()},
                          ),
                        ),
                      ]),
                    )),
              ])))
        ])));
  }

  UpdateEventDialog() {
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
              "Update this Event Stay?",
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
                  UpdateHomeStay();
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

  void UpdateHomeStay() {
    String event_Tital = _TitalController.text;
    String eventdesc = _DecController.text;
    String speaker = _SpeakerController.text;
    String event_date = _dataController.text;
    String duedate = _DueDateController.text;
    http.post(Uri.parse("${ServerConfig.SERVER}/php/update_event.php"), body: {
      "eventid": widget.event.id,
      "userid": widget.user.id,
      "event_title": event_Tital,
      "event_desc": eventdesc,
      "speaker": speaker,
      "event_date": event_date,
      "duedate": duedate,
    }).then((response) {
      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 14.0);
        Navigator.of(context).pop();
        MaterialPageRoute(builder: (content) => adminside(user: widget.user));
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
  }
}
