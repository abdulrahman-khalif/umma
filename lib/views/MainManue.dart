import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:umma/views/Mangage_Donation.dart';
import 'package:umma/views/adminScreen.dart';
import 'package:umma/views/profilescreen.dart';

import '../ServerConfig.dart';
import '../model/user.dart';

class MainManue extends StatefulWidget {
  final User user;
  const MainManue({super.key, required this.user});

  @override
  State<MainManue> createState() => _MainManueState();
}

class _MainManueState extends State<MainManue> {
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
          title: const Text('Manage Events'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => adminside(
                          user: widget.user,
                        )));
          },
        ),
        ListTile(
          title: const Text('Manage Donations'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (content) => manage_donation(user: widget.user)));
          },
        ),
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
