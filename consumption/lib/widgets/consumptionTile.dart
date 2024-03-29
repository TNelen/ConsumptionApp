// @dart=2.9

import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/models/consumption.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsumptionTile extends StatefulWidget {
  final Consumption consumption;
  bool isNewFlag = false;

  ConsumptionTile({Key key, this.consumption}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DrinkTileState();
  }
}

class DrinkTileState extends State<ConsumptionTile> {
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
          //nothing here
        },
        child: Container(
          width: MediaQuery.of(context).size.width - 60,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 8, left: 20.0, right: 20, bottom: 8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.consumption.name,
                        style: widget.consumption.settled
                            ? TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade600)
                            : TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                      ),
                      Text(
                        widget.consumption.price.toString() + " €",
                        style: widget.consumption.settled
                            ? TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade600,
                              )
                            : TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                      ),
                    ],
                  ),
                  Text(
                    DateFormat('dd/MM/yyyy').format(
                        DateTime.fromMicrosecondsSinceEpoch(
                            widget.consumption.date.microsecondsSinceEpoch)),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
