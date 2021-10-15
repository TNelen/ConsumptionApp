import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/firebase/helpers.dart';
import 'package:consumption/models/consumption.dart';
import 'package:consumption/widgets/consumptionTile.dart';
import 'package:consumption/widgets/indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'home.dart';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Map<String, Object>>(
            future: firestoreService.getUserData(), // async work
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Object>> snapshot) {
              Map<String, int> categoryHistory;
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  categoryHistory = null;
                  break;
                default:
                  if (snapshot.hasError) {
                    categoryHistory = null;
                    break;
                  } else {
                    snapshot.data["consumptions"] != null
                        ? categoryHistory =
                            groupCategory(snapshot.data["consumptions"])
                        : categoryHistory = null;
                    break;
                  }
              }

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: ListView(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        color: Colors.black54,
                        iconSize: 20,
                        icon: FaIcon(FontAwesomeIcons.arrowLeft),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Statistieken",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Work in progress",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Kom snel terug om het resultaat te zien",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                    categoryHistory != null
                        ? Container(
                            width: 500,
                            height: 500,
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(PieChartData(
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 100,
                                    centerSpaceRadius: 60,
                                    sections: categoryHistory.entries
                                        .map((e) => PieChartSectionData(
                                              title: e.key,
                                              value: e.value.toDouble(),
                                              color: (Constants.colors..shuffle()).first
                                            ))
                                        .toList()))))
                        : SizedBox(),
                  ],
                ),
              );
            }));
  }
}
