import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tmcmerchant/models/merchant.dart' as model;
import 'package:tmcmerchant/providers/merchant_provider.dart';
import 'package:provider/provider.dart';
import 'package:tmcmerchant/resources/auth_methods.dart';
import 'package:tmcmerchant/screens/login_screen.dart';

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
    MerchantProvider _merchantProvider = Provider.of(context, listen: false);
    await _merchantProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final model.Merchant merchant =
        Provider.of<MerchantProvider>(context).getMerchant;

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
                  merchant.photoUrl,
                )),
            const SizedBox(
              height: 15,
            ),
            //text field for username
            Text(
              merchant.merchantname,
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
