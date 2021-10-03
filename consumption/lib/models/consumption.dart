class Consumption {
  Consumption({this.name, this.price, this.user, this.date});

  Consumption.fromJson(Map<String, Object> json)
      : this(
          name: json['name'] as String,
          price: json['price'] as double,
          user: json['user'] as String,
          date: json['date'] as DateTime,
        );

  final String name;
  final double price;
  final String user;
  final DateTime date;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'price': price,
      'user': user,
      'date': date,
    };
  }
}
