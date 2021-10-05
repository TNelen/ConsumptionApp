import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumption/models/consumption.dart';
import 'package:consumption/models/drink.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference drinks = FirebaseFirestore.instance.collection('drinks');

  /// Add a new drink for a user
  Future<void> addDrink(Drink drink) {
    var userId = FirebaseAuth.instance.currentUser.uid;

    CollectionReference consumptions =
        FirebaseFirestore.instance.collection('consumptions');

    return consumptions
        .add({
          'user': userId,
          'name': drink.name, // John Doe
          'price': drink.price, // Stokes and Sons
          'date': DateTime.now(),
          'settled': false, // 42
        })
        .then((value) => print("Consumption registered"))
        .catchError((error) => print("Failed register consumption: $error"));
  }

  //get all consumptions for a user
  Future<List<Consumption>> getConsumptions() async {
    var userId = FirebaseAuth.instance.currentUser.uid;
    List<Consumption> consumptions = new List();

    await FirebaseFirestore.instance
        .collection('consumptions')
        .where('user', isEqualTo: userId)
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((element) {
              consumptions.add(Consumption.fromJson(element.data()));
            }));

    consumptions = sortList(consumptions);

    return consumptions;
  }

  ///getdebt for a user
  Future<double> getDebt() async {
    var userId = FirebaseAuth.instance.currentUser.uid;
    double debt = 0.0;

    print("Getting debt for user: ${userId}");

    await FirebaseFirestore.instance
        .collection('consumptions')
        .where('user', isEqualTo: userId)
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((element) {
              if (!element.data()["settled"]) {
                debt += element.data()["price"];
              }
            }));

    print("Debt for user: " + debt.toString());

    return debt;
  }

  Future<Map<String, Object>> getUserData() async {
    var userId = FirebaseAuth.instance.currentUser.uid;
    double debt = 0.0;
    List<Consumption> consumptions = new List();

    print("Getting userdata for user: ${userId}");

    await FirebaseFirestore.instance
        .collection('consumptions')
        .where('user', isEqualTo: userId)
        .get()
        .then((querySnapshot) => querySnapshot.docs.forEach((element) {
              if (!element.data()["settled"]) {
                debt += element.data()["price"];
              }
              consumptions.add(Consumption.fromJson(element.data()));
            }));

    consumptions = sortList(consumptions);

    var map = {"consumptions": consumptions, "debt": debt};

    return map;
  }

  //helper function to sort consumptions on date
  List<Consumption> sortList(List<Consumption> consumptions) {
    consumptions.sort((a, b) => b.date.compareTo(a.date));
    return consumptions;
  }
}
