import 'package:cloud_firestore/cloud_firestore.dart';

class Consumption {
  Consumption({this.name, this.price, this.user, this.date});

  Consumption.fromJson(Map<String, Object> json)
      : this(
          name: json['name'] as String,
          price: json['price'] as double,
          user: json['user'] as String,
          date: json['date'] as Timestamp,
        );

  final String name;
  final double price;
  final String user;
  final Timestamp date;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'price': price,
      'user': user,
      'date': date,
    };
  }
}
