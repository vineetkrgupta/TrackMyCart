import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trackmycart/models/user.dart' as model;
import 'package:trackmycart/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:trackmycart/resources/auth_methods.dart';
import 'package:trackmycart/screens/login_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    UserProvider _userProvider = Provider.of(context, listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Opacity(
      opacity: 1,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        color: Colors.white,
        child: Column(
          children: [
            Container(),
            const SizedBox(
              height: 64,
            ),
            //circular widget to accept and show our selected file
            CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                  user.photoUrl,
                )),
            const SizedBox(
              height: 15,
            ),
            //text field for username
            Text(
              user.username,
              style: const TextStyle(
                  fontSize: 25, fontFamily: 'Pacifico', color: Colors.black),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                AuthMethods().signOut();
                Timer(
                    const Duration(seconds: 2),
                    () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen())));
              },
              child: const Text(
                "Log Out",
              ),
            )
          ],
        ),
      ),
    );
  }
}
