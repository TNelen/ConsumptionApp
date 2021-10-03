
class Drink {
  Drink({this.name, this.price});

  Drink.fromJson(Map<String, Object> json)
    : this(
        name: json['name'] as String,
        price: json['price'] as double,
      );

  final String name;
  final double price;

  Map<String, Object> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}