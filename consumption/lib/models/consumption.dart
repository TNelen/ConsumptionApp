import 'package:cloud_firestore/cloud_firestore.dart';

class Consumption {
  Consumption(
      {this.name, this.price, this.user, this.date, this.settled, this.id});

  Consumption.fromJson(Map<String, Object> json, String id)
      : this(
            name: json['name'] as String,
            price: json['price'] as double,
            user: json['user'] as String,
            date: json['date'] as Timestamp,
            settled: json['settled'] as bool,
            id: id);

  final String name;
  final double price;
  final String user;
  final Timestamp date;
  final bool settled;
  final String id;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'price': price,
      'user': user,
      'date': date,
      'settled': settled,
      'id': id
    };
  }
}
