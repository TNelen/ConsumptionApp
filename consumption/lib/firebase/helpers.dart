import 'package:consumption/models/consumption.dart';

//helper function to sort consumptions on date
List<Consumption> sortList(List<Consumption> consumptions) {
  consumptions.sort((a, b) => b.date.compareTo(a.date));
  return consumptions;
}

//helper function to filter list on open consumptions (consumptions that still need to be paid)
List<Consumption> filterOpenConsumptions(List<Consumption> consumptions) {
  consumptions.removeWhere((item) => item.settled);
  return consumptions;
}

//helper function to group the consumptions in category and amount
//returns: Map<drinkname, amount>
Map<String, int> groupCategory(List<Consumption> consumptions) {
  Map<String, int> map = {};

  void addNew(Consumption c) {
    map[c.name] = 1;
  }

  void update(Consumption c) {
    map.update(c.name, (value) => value + 1);
  }

  for (Consumption c in consumptions) {
    map.containsKey(c.name) ? update(c) : addNew(c);
  }

  print(map);

  return map;
}
