import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:umma/views/Events_Registred.dart';
import 'package:umma/views/customerScreen.dart';
import 'package:umma/views/profilescreen.dart';

import '../ServerConfig.dart';
import '../model/user.dart';

class MainManue2 extends StatefulWidget {
  final User user;
  const MainManue2({super.key, required this.user});

  @override
  State<MainManue2> createState() => _MainManue2State();
}

class _MainManue2State extends State<MainManue2> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(children: [
        UserAccountsDrawerHeader(
          accountName: Text(widget.user.name.toString()),
          accountEmail: Text(widget.user.email.toString()),
          currentAccountPicture: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: CachedNetworkImage(
                imageUrl:
                    "${ServerConfig.SERVER}/assets/profileimages/${widget.user.id}.png",
                imageBuilder: (context, imageProvider) => Container(
                  width: 350.0,
                  height: 350.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => const LinearProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(
                  Icons.image_not_supported,
                  size: 128,
                ),
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text('Events List'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => customer_screen(
                          user: widget.user,
                        )));
          },
        ),
        ListTile(
          title: const Text('Events Registred'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => event_registered(user: widget.user)));
          },
        ),
        // ListTile(
        //   title: const Text('Make Daonation'),
        //   onTap: () {
        //     // Navigator.pop(context);
        //     // Navigator.push(
        //     //     context,
        //     //     MaterialPageRoute(
        //     //         builder: (content) => Mangage_Donation(user: widget.user)));
        //   },
        // ),
        ListTile(
          title: const Text('profile'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => ProfileScreen(user: widget.user)));
          },
        ),
      ]),
    );
  }
}
