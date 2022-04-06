import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmcmerchant/providers/merchant_provider.dart';
import 'package:tmcmerchant/screens/drawer_screen.dart';
import 'package:tmcmerchant/utils/map_utils.dart';
import 'package:tmcmerchant/utils/utils.dart';
import 'package:tmcmerchant/models/merchant.dart' as model;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
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
    Timer(const Duration(seconds: 5), () {});
    return SafeArea(
      child: Scaffold(
        drawer: const DrawerScreen(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 18,
                        ),
                        CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(merchant.photoUrl)),
                        const SizedBox(
                          height: 15,
                        ),
                        //text field for username
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            merchant.merchantname,
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Pacifico'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                            Text(
                              "4.5",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 180,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: SingleChildScrollView(
                          child: Text(
                            merchant.description,
                            style: const TextStyle(color: Colors.white60),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              height: 28,
              child: const Text(
                "Images Uploaded by Merchant",
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Pacifico'),
              ),
              width: MediaQuery.of(context).size.width * 0.97,
            ),
            SizedBox(
              height: 530,
              child: GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: (Colors.teal[100])!,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://images.indianexpress.com/2020/04/Vegetable-seller-759.jpg"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: (Colors.teal[100])!,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyBS5U_Ic04SdE-DZnJSBJFtpTa1e_murbDA&usqp=CAU"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: (Colors.teal[200])!,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://static.india.com/wp-content/uploads/2019/08/Vegetable-Market-IANS.jpg?impolicy=Medium_Resize&w=1200&h=800"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: (Colors.teal[400])!,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://images.hindustantimes.com/rf/image_size_960x540/HT/p2/2020/05/19/Pictures/mosque-street-vendor-stands-vegetable-jama-masjid_f528198a-99d6-11ea-871b-70b2176894d0.jpg"),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: (Colors.teal[500])!,
                          width: 3,
                        ),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        )),
                    child: const Image(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          "https://previews.123rf.com/images/funlovingvolvo/funlovingvolvo1402/funlovingvolvo140200137/26205613-different-sorts-of-fruit-and-vegetables-at-a-market-in-france.jpg"),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            MapUtils.openMap(double.parse(merchant.latitude),
                double.parse(merchant.longitude));
          },
          child: const Icon(
            Icons.navigation,
          ),
        ),
      ),
    );
  }
}
