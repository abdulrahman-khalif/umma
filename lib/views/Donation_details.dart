import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:umma/ServerConfig.dart';
import 'package:umma/model/donation.dart';
import 'package:umma/model/user.dart';

class donation_details extends StatefulWidget {
  final User user;
  final Donation donation;
  const donation_details(
      {super.key, required this.user, required this.donation});

  @override
  State<donation_details> createState() => _donation_detailsState();
}

class _donation_detailsState extends State<donation_details> {
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
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
                    height: 350,
                    width: 250,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: CachedNetworkImage(
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                        imageUrl:
                            "${ServerConfig.SERVER}/assets/profileimages/${widget.donation.userId}.png",
                        placeholder: (context, url) =>
                            const LinearProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
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
                            '${widget.donation.userName}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Donate: ${widget.donation.amount}.00 RM',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    const SizedBox(height: 22),
                    const Text(
                      'The user donate to this event:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${widget.donation.eventName}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'the date of donation:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                        df.format(
                            DateTime.parse(widget.donation.date.toString())),
                        style: const TextStyle(
                          fontSize: 16,
                        )),
                    const SizedBox(height: 10),
                    const Text(
                      'Sate:',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      ' ${widget.donation.state}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ]),
            ),
          ]))
        ]));
  }
}
