import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:umma/views/adminScreen.dart';
import '../ServerConfig.dart';
import '../model/user.dart';

class NewEvent extends StatefulWidget {
  final User user;

  const NewEvent({super.key, required this.user});

  @override
  State<NewEvent> createState() => _NewEvent();
}

class _NewEvent extends State<NewEvent> {
  File? _imageone;
  File? _imagetwo;
  File? _imagetree;
  var m1 = false;
  var m2 = false;
  var m3 = false;
  bool isDisable = true;

  var dateofevent = "";
  var pathAsset = "assets/images/camera.png";

  final TextEditingController _TitalController = TextEditingController();
  final TextEditingController _DecController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _DueDateController = TextEditingController();
  final TextEditingController _SpeakerController = TextEditingController();

//
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //_getAddress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Event registration form",
              style: TextStyle(
                color: Colors.black,
              )),
        ),
        body: SingleChildScrollView(
            // show image 1
            child: Column(children: [
          SizedBox(
            height: 250,
            child: ListView(scrollDirection: Axis.horizontal, children: [
              GestureDetector(
                onTap: _1selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imageone == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imageone!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),

              //show image 2

              GestureDetector(
                onTap: _2selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imagetwo == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imagetwo!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),

              //show image 3

              GestureDetector(
                onTap: _3selectImage,
                child: Card(
                  elevation: 8,
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: _imagetree == null
                          ? AssetImage(pathAsset)
                          : FileImage(_imagetree!) as ImageProvider,
                      fit: BoxFit.cover,
                    )),
                  ),
                ),
              ),
            ]),
          ),

          // start text form
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Add New Event",
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
                        // Flexible(
                        //     flex: 5,
                        //     child: CheckboxListTile(
                        //       title: const Text(
                        //           "accept agreement"), //    <‐‐ label
                        //       value: _isChecked,
                        //       onChanged: (bool? value) {
                        //         setState(() {
                        //           _isChecked = value!;
                        //         });
                        //       },
                        //     )),
                      ]),

                      const SizedBox(
                        height: 10,
                      ),

                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          child: const Text('Add Event'),
                          onPressed: () => {
                            _newEventDialog(),
                          },
                        ),
                      ),
                    ]),
                  )),
            ])),
          ),
        ])));
  }

// start select image 1
  void _1selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _1oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _1ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _1oncamra() async {
    m1 = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imageone = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _1ongallrye() async {
    m1 = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imageone = File(pickedFile.path);
      cropImage();
    } else {}
  }
// end of select image 1

// Start select image 2
  void _2selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _2oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _2ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _2oncamra() async {
    m2 = true;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imagetwo = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _2ongallrye() async {
    m2 = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imagetwo = File(pickedFile.path);
      cropImage();
    } else {}
  }
// end of select image 2

// start select image 3
  void _3selectImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            title: const Text(
              "Select image from",
              style: TextStyle(),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: _3oncamra, icon: const Icon(Icons.camera)),
                IconButton(
                    onPressed: _3ongallrye,
                    icon: const Icon(Icons.browse_gallery))
              ],
            ));
      },
    );
  }

  Future<void> _3oncamra() async {
    m3 = true;

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _imagetree = File(pickedFile.path);
      cropImage();
    } else {}
  }

  Future<void> _3ongallrye() async {
    m3 = true;
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _imagetree = File(pickedFile.path);
      cropImage();
    } else {}
  }
// end of select image 3

// crop image for image 1 and image 2 and image 3
  Future<void> cropImage() async {
    if (m1 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imageone!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.ratio3x2,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 159, 34, 255),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.ratio3x2,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );
      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imageone = imageFile;
        setState(() {});
      }
      m1 = false;
      return;
    }

    if (m2 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagetwo!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 255, 34, 170),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper image 2',
          ),
        ],
      );
      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imagetwo = imageFile;
        setState(() {});
      }
      m2 = false;
      return;
    }

    if (m3 == true) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: _imagetree!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Color.fromARGB(255, 34, 60, 255),
              toolbarWidgetColor: Color.fromARGB(255, 22, 6, 21),
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper image 3',
          ),
        ],
      );

      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        _imagetree = imageFile;
        setState(() {});
      }
      m3 = false;
      return;
    }
  }

  // _getAddress() async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(
  //       widget.position.latitude, widget.position.longitude);
  //   setState(() {
  //     _stateController.text = placemarks[0].administrativeArea.toString();

  //     _localController.text = placemarks[0].locality.toString();
  //   });
  // }

  _newEventDialog() {
    if (_imageone == null || _imagetwo == null || _imagetree == null) {
      Fluttertoast.showToast(
          msg: "Please take picture of your Event",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(
          msg: "Please complete the form first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      return;
    }
    // if (!_isChecked) {
    //   Fluttertoast.showToast(
    //       msg: "Please check agree checkbox",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       fontSize: 14.0);
    //   return;
    // }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Insert this New Event?",
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
                  insertEvent();
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

  void insertEvent() {
    String event_Tital = _TitalController.text;
    String eventdesc = _DecController.text;
    String speaker = _SpeakerController.text;
    String event_date = _dataController.text;
    String duedate = _DueDateController.text;
    String base64_Imageone = base64Encode(_imageone!.readAsBytesSync());
    String base64_Imagetwo = base64Encode(_imagetwo!.readAsBytesSync());
    String base64_Imagetree = base64Encode(_imagetree!.readAsBytesSync());
    http.post(Uri.parse("${ServerConfig.SERVER}/php/addevent.php"), body: {
      "userid": widget.user.id,
      "event_title": event_Tital,
      "event_desc": eventdesc,
      "speaker": speaker,
      "event_date": event_date,
      "duedate": duedate,
      "image_one": base64_Imageone,
      "image_two": base64_Imagetwo,
      "image_tree": base64_Imagetree,
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

  void _ShowdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2027),
    ).then((value) => dateofevent);

    print(dateofevent.toString());
  }
}
