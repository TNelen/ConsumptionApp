import 'dart:html';

import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/models/drink.dart';
import 'package:consumption/pages/home.dart';
import 'package:flutter/material.dart';

class Popup {
  static void makeConfirmPopup(
    BuildContext context,
    Drink drink,
  ) {
    FirestoreService firestoreService = FirestoreService();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            "Bevestig je consumptie",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          content: Text(
            drink.name,
            style: TextStyle(
                color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            MaterialButton(
              padding: EdgeInsets.all(15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Constants.tileColor,
              child: Text(
                "Annuleer",
                style: TextStyle(
                    fontFamily: "roboto",
                    color: Colors.grey,
                    fontSize: 17,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              padding: EdgeInsets.all(15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Constants.secondColor,
              child: Text(
                "Bevestig",
                style: TextStyle(
                    color: Constants.accentColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                firestoreService.addDrink(drink);
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
