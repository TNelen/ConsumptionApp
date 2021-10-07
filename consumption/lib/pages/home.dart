import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption/firebase/AuthService.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/main.dart';
import 'package:consumption/models/drink.dart';
import 'package:consumption/widgets/debtCard.dart';
import 'package:consumption/widgets/drinkTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User user;
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    print(user.displayName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('drinks').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              print("Query result: ");

              print(snapshot.data.docs.length);
              return ListView(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.signOutAlt,
                                  size: 25,
                                  color: Colors.black54,
                                ),
                                onPressed: () async {
                                  AuthService service = new AuthService();
                                  try {
                                    await service.signOutFromGoogle();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyApp()),
                                    );
                                  } catch (e) {
                                    print(e);
                                    if (e is FirebaseAuthException) {
                                      print(e.message);
                                    }
                                  }
                                })
                          ],
                        )),
                    Row(
                      children: [
                        Text(
                          "Hi, ",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.w300),
                        ),
                        Text(user.displayName.split(' ')[0],
                            style: TextStyle(
                                fontSize: 50, fontWeight: FontWeight.w600)),
                        SizedBox(
                          width: 15,
                        ),
                        Image.asset(
                          "assets/images/wave-hand.png",
                          scale: 25,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    DebtCard(),
                    SizedBox(height: 30),
                    Text("Registreer een nieuwe consumptie...",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300)),
                    SizedBox(height: 20),
                    Container(
                        height: 500,
                        width: 500,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds = snapshot.data.docs[index];
                              Drink drink = Drink(
                                  name: ds['name'].toString(),
                                  price: (ds['price']));
                              return new DrinkTile(
                                drink: drink,
                              );
                            }))
                  ]);
          }
        },
      ),
    );
  }
}
