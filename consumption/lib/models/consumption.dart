import 'package:cloud_firestore/cloud_firestore.dart';

class Consumption {
  Consumption({this.name, this.price, this.user, this.date, this.settled});

  Consumption.fromJson(Map<String, Object> json)
      : this(
            name: json['name'] as String,
            price: json['price'] as double,
            user: json['user'] as String,
            date: json['date'] as Timestamp,
            settled: json['settled'] as bool);

  final String name;
  final double price;
  final String user;
  final Timestamp date;
  final bool settled;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'price': price,
      'user': user,
      'date': date,
      'settled': settled,
    };
  }
}
