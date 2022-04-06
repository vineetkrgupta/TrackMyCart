import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trackmycart/providers/user_provider.dart';
import 'package:trackmycart/resources/auth_methods.dart';
import 'package:trackmycart/screens/drawer_screen.dart';
import 'package:trackmycart/screens/login_screen.dart';
import 'package:trackmycart/screens/merchant_profile.dart';
import 'package:trackmycart/utils/colors.dart';
import 'package:trackmycart/models/user.dart' as model;
import 'package:trackmycart/widgets/merchant_card.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  String rate = "";
  String getRandom10() {
    String str = "";
    Random random = new Random();
    double randomNumber = random.nextInt(10) + 3 + (random.nextInt(9) * 0.1);
    str = randomNumber.toString();
    str += "Km";
    return str;
  }

  String getRandom5() {
    String str = "";
    Random random = new Random();
    double randomNumber = random.nextInt(2) + 3 + (random.nextInt(9) * 0.1);
    str = randomNumber.toString();
    return str;
  }

  addData() async {
    UserProvider _userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await _userProvider.refreshUser();
  }

  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerScreen(),
      appBar: AppBar(
        actions: [Container()],
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: "Search Merchent by Name",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
                print(_);
              },
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('merchant')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Card(
                            child: InkWell(
                              splashColor: Colors.white54,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MerchantProfileScreen(
                                      uid: (snapshot.data! as dynamic)
                                          .docs[index]['uid'],
                                      rating: rate,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                              (snapshot.data! as dynamic)
                                                  .docs[index]['photoUrl']),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (snapshot.data! as dynamic)
                                                .docs[index]['username'],
                                            textAlign: TextAlign.start,
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.green,
                                                  ),
                                                  Text(getRandom5()),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on,
                                                    color: Colors.blue,
                                                  ),
                                                  Text(rate = getRandom5()),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/tomato.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[100])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/banana.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[200])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/coriander.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[300])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/brinjal.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[400])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/ladyfinger.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[500])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/mango.png',
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: (Colors.teal[600])!,
                        width: 5,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      )),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isShowUsers = false;
          });
        },
        child: const Icon(Icons.my_location_rounded),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
