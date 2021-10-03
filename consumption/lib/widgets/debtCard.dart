// @dart=2.9
import 'package:consumption/firebase/firestoreService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../Constants.dart';

class DebtCard extends StatefulWidget {
  DebtCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DebtCardState();
  }
}

class DebtCardState extends State<DebtCard> {
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: firestoreService.getDebt(), // async work
        builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
          String debt;
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              debt = 'Loading....';
              break;
            default:
              if (snapshot.hasError) {
                debt = "Something went wrong: " + snapshot.error;
                break;
              } else {
                debt = snapshot.data.toStringAsFixed(2) + " €";
                break;
              }
          }

          return Card(
            elevation: 0.0,
            color: Constants.secondColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 60,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Column(
                  children: [
                    Text(
                      "Je bent verschuldigd ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      debt,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Constants.accentColor),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
