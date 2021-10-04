// @dart=2.9

import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/models/drink.dart';
import 'package:consumption/widgets/confirmPopup.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DrinkTile extends StatefulWidget {
  final Drink drink;
  bool isNewFlag = false;

  DrinkTile({Key key, this.drink}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrinkTileState();
  }
}

class DrinkTileState extends State<DrinkTile> {
  FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: Constants.tileColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
        splashColor: Constants.accentColor,
        onTap: () {
          Popup.makeConfirmPopup(context, widget.drink);
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 20.0, right: 5, bottom: 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.drink.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w300),
                  ),
                  Text(
                    widget.drink.price.toString() + " €",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
