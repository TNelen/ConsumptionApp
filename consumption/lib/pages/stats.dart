import 'dart:math';

import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/firebase/helpers.dart';
import 'package:consumption/models/consumption.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'home.dart';

class Stats extends StatefulWidget {
  Stats({Key key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  FirestoreService firestoreService = FirestoreService();
  Map<String, int> categoryHistory = {};
  Map<String, int> consumptionHistory = {};
  Future<Map<String, Object>> _userdata;
  var format = new DateFormat("dd-MM-yy");

  @override
  void initState() {
    super.initState();
    _userdata = firestoreService.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
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
                  "Mijn statistieken",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Work in progress",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Kom snel terug om het resultaat te zien",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 260,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Constants.tileColor,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 60, top: 30),
                        child: FutureBuilder<Map<String, Object>>(
                          future: _userdata,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Map<String, Object>> snapshot,
                          ) {
                            print(snapshot.connectionState);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                categoryHistory = groupCategory(
                                    snapshot.data["consumptions"]);
                                return BarChart(
                                  BarChartData(
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                        touchTooltipData: BarTouchTooltipData(
                                          tooltipBgColor: Colors.transparent,
                                          tooltipPadding:
                                              const EdgeInsets.all(0),
                                          tooltipMargin: 8,
                                          getTooltipItem: (
                                            BarChartGroupData group,
                                            int groupIndex,
                                            BarChartRodData rod,
                                            int rodIndex,
                                          ) {
                                            return BarTooltipItem(
                                              rod.y.round().toString(),
                                              const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      titlesData: FlTitlesData(
                                        show: true,
                                        bottomTitles: SideTitles(
                                            rotateAngle: -90,
                                            showTitles: true,
                                            getTextStyles: (context, value) =>
                                                const TextStyle(
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                            margin: 10,
                                            getTitles: (double index) {
                                              return categoryHistory.keys
                                                  .toList()[index.toInt()];
                                            }),
                                        leftTitles:
                                            SideTitles(showTitles: false),
                                        topTitles:
                                            SideTitles(showTitles: false),
                                        rightTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      borderData: FlBorderData(
                                        show: false,
                                      ),
                                      barGroups: categoryHistory.entries
                                          .map(
                                            (e) => BarChartGroupData(
                                              x: categoryHistory.keys
                                                  .toList()
                                                  .indexOf(e.key),
                                              barRods: [
                                                BarChartRodData(
                                                    y: e.value.toDouble(),
                                                    colors: [
                                                      Constants.secondColor,
                                                      Constants.greenAccent
                                                    ])
                                              ],
                                              showingTooltipIndicators: [0],
                                            ),
                                          )
                                          .toList(),
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: categoryHistory.values
                                              .reduce(max)
                                              .toDouble() +
                                          2), // +2 for padding on top
                                );
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        )),
                  ),
                ),
                Container(
                  height: 260,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Constants.tileColor,
                    child: Padding(
                        padding:
                            EdgeInsets.only(bottom: 60, top: 30, right: 20),
                        child: FutureBuilder<Map<String, Object>>(
                          future: _userdata,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Map<String, Object>> snapshot,
                          ) {
                            print(snapshot.connectionState);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                consumptionHistory = debtEvolution(
                                    snapshot.data["consumptions"]);
                                return LineChart(LineChartData(
                                  gridData: FlGridData(
                                    show: false,
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: SideTitles(showTitles: false),
                                    topTitles: SideTitles(showTitles: false),
                                    bottomTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 22,
                                      interval:
                                          debtEvolutionTimeIntervalCalculation(
                                              consumptionHistory,
                                              5), //5 labels on x-axis
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10),
                                      getTitles: (value) {
                                        print(value);
                                        return format.format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                value.toInt()));
                                      },
                                      margin: 8,
                                    ),
                                    leftTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTextStyles: (context, value) =>
                                          const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                      ),
                                      getTitles: (value) {
                                        return value.toString();
                                      },
                                      reservedSize: 32,
                                      margin: 12,
                                    ),
                                  ),
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots:
                                          consumptionHistory.entries.map((e) {
                                        return FlSpot(
                                            DateFormat("dd-MM-yy")
                                                .parse(e.key)
                                                .millisecondsSinceEpoch
                                                .toDouble(),
                                            e.value.toDouble());
                                      }).toList(),
                                      isCurved: true,
                                      colors: [
                                        Constants.secondColor,
                                        Constants.greenAccent
                                      ],
                                      barWidth: 5,
                                      isStrokeCapRound: true,
                                      dotData: FlDotData(
                                        show: true,
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        colors: [
                                          Constants.secondColor,
                                          Constants.greenAccent
                                        ]
                                            .map((color) =>
                                                color.withOpacity(0.3))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ));
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        )),
                  ),
                ),
                Container(
                  height: 260,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Constants.tileColor,
                    child: Padding(
                        padding: EdgeInsets.only(bottom: 60, top: 30),
                        child: FutureBuilder<Map<String, Object>>(
                          future: _userdata,
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<Map<String, Object>> snapshot,
                          ) {
                            print(snapshot.connectionState);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasError) {
                                return const Text('Error');
                              } else if (snapshot.hasData) {
                                List<Consumption> consumptionList =
                                    snapshot.data["consumptions"];
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 50),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Totaal aantal consumpties: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            consumptionList.length.toString(),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total gespendeerd: ",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            totalSpent(consumptionList)
                                                    .toStringAsFixed(2) +
                                                "€",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              } else {
                                return const Text('Empty data');
                              }
                            } else {
                              return Text('State: ${snapshot.connectionState}');
                            }
                          },
                        )),
                  ),
                ),
              ],
            )));
  }
}
