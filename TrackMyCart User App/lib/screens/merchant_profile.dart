import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmycart/providers/user_provider.dart';
import 'package:trackmycart/screens/drawer_screen.dart';
import 'package:trackmycart/utils/map_utils.dart';
import 'package:trackmycart/utils/utils.dart';
import 'package:trackmycart/models/user.dart' as model;

class MerchantProfileScreen extends StatefulWidget {
  final String uid;
  final String rating;
  const MerchantProfileScreen(
      {Key? key, required this.uid, required this.rating})
      : super(key: key);

  @override
  State<MerchantProfileScreen> createState() => _MerchantProfileScreenState();
}

class _MerchantProfileScreenState extends State<MerchantProfileScreen> {
  var merchantData = {};
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var merchantSnap = await FirebaseFirestore.instance
          .collection('merchant')
          .doc(widget.uid)
          .get();
      merchantData = merchantSnap.data()!;

      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User merchant = Provider.of<UserProvider>(context).getUser;
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
                            backgroundImage:
                                NetworkImage(merchantData['photoUrl'])),
                        const SizedBox(
                          height: 15,
                        ),
                        //text field for username
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            merchantData['username'],
                            style: const TextStyle(
                                fontSize: 18, fontFamily: 'Pacifico'),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                            Text(
                              widget.rating,
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
                            merchantData['description'],
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
            MapUtils.openMap(double.parse(merchantData['latitude']),
                double.parse(merchantData['longitude']));
          },
          child: const Icon(
            Icons.navigation,
          ),
        ),
      ),
    );
  }
}
