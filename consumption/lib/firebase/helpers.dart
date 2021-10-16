import 'package:consumption/models/consumption.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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

//helper function to get historical debt action (total consumed overtime)
//returns: Map<String , amount>
//String is a date: dd-MM-yy (we do not take into account hours, this will be parsed to the same day)
Map<String, int> debtEvolution(List<Consumption> consumptions) {
  Map<String, int> map = {};
  var newFormat = DateFormat("dd-MM-yy");

  void addNew(Consumption c) {
    map[newFormat.format(c.date.toDate())] = c.price.toInt();
  }

  void update(Consumption c) {
    map.update(
        newFormat.format(c.date.toDate()), (value) => value + c.price.toInt());
  }

  //create list
  for (Consumption c in consumptions) {
    map.containsKey(newFormat.format(c.date.toDate())) ? update(c) : addNew(c);
  }

  print(map);

  return map;
}
