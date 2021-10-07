import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/AuthService.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/main.dart';
import 'package:consumption/models/consumption.dart';
import 'package:consumption/models/drink.dart';
import 'package:consumption/widgets/consumptionTile.dart';
import 'package:consumption/widgets/debtCard.dart';
import 'package:consumption/widgets/drinkTile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class History extends StatefulWidget {
  History({Key key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, Object>>(
            future: firestoreService.getUserData(), // async work
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Object>> snapshot) {
              List<Consumption> consumptions;
              double debt;

              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  consumptions = null;
                  debt = 0.0;
                  break;
                default:
                  if (snapshot.hasError) {
                    consumptions = [];
                    debt = null;
                    break;
                  } else {
                    consumptions = snapshot.data["consumptions"];
                    debt = snapshot.data["debt"];

                    break;
                  }
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        color: Colors.black54,
                        iconSize: 20,
                        icon: FaIcon(FontAwesomeIcons.arrowLeft),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Historiek",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        snapshot.connectionState == ConnectionState.waiting
                            ? SizedBox()
                            : Text("Openstaande schuld: ",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w300)),
                        snapshot.connectionState == ConnectionState.waiting
                            ? Text("Laden...",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w300))
                            : Text(debt.toStringAsFixed(2) + " €",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w300)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: Constants.secondColor,
                      child: InkWell(
                        onTap: () async {
                          await firestoreService.settleDebt(consumptions);
                          setState(() {});
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Vereffen schuld",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Constants.accentColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    snapshot.connectionState == ConnectionState.waiting
                        ? Container(
                            height: 500,
                            width: 500,
                            child: Center(
                              child: Text("laden..."),
                            ))
                        : consumptions.length == 0
                            ? Container(
                                height: 500,
                                width: 500,
                                child: Center(
                                  child: Text("Nog geen consumpties..."),
                                ))
                            : Container(
                                height: 500,
                                width: 500,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: consumptions.length,
                                    itemBuilder: (context, index) {
                                      Consumption consumption =
                                          consumptions[index];

                                      return new ConsumptionTile(
                                          consumption: consumption);
                                    }))
                  ],
                ),
              );
            }));
  }
}
