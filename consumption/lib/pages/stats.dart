import 'dart:math';

import 'package:consumption/Constants.dart';
import 'package:consumption/firebase/fireStoreService.dart';
import 'package:consumption/firebase/helpers.dart';
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
              Map<String, int> consumptionHistory;

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

                    snapshot.data["consumptions"] != null
                        ? consumptionHistory =
                            debtEvolution(snapshot.data["consumptions"])
                        : consumptionHistory = null;
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
                      "Mijn statistieken",
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
                          child: BarChart(
                            BarChartData(
                                barTouchData: BarTouchData(
                                  enabled: false,
                                  touchTooltipData: BarTouchTooltipData(
                                    tooltipBgColor: Colors.transparent,
                                    tooltipPadding: const EdgeInsets.all(0),
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
                                  leftTitles: SideTitles(showTitles: false),
                                  topTitles: SideTitles(showTitles: false),
                                  rightTitles: SideTitles(showTitles: false),
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
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 260,
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: Constants.tileColor,
                        child: LineChart(LineChartData(
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
                              interval: 1,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                      color: Color(0xff68737d),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 2:
                                    return 'MAR';
                                  case 5:
                                    return 'JUN';
                                  case 8:
                                    return 'SEP';
                                }
                                return '';
                              },
                              margin: 8,
                            ),
                            leftTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTextStyles: (context, value) =>
                                  const TextStyle(
                                color: Color(0xff67727d),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              getTitles: (value) {
                                switch (value.toInt()) {
                                  case 1:
                                    return '10k';
                                  case 3:
                                    return '30k';
                                  case 5:
                                    return '50k';
                                }
                                return '';
                              },
                              reservedSize: 32,
                              margin: 12,
                            ),
                          ),
                          borderData: FlBorderData(
                              show: true,
                              border: Border.all(
                                  color: const Color(0xff37434d), width: 1)),
                          minX: 0,
                          maxX: 11,
                          minY: 0,
                          maxY: 6,
                          lineBarsData: [
                            LineChartBarData(
                              spots: consumptionHistory.entries
                                  .map((e) => FlSpot(
                                      DateTime.parse(e.key)
                                          .millisecondsSinceEpoch
                                          .toDouble(),
                                      e.value.toDouble()))
                                  .toList(),
                              isCurved: true,
                              colors: [
                                Constants.secondColor,
                                Constants.greenAccent
                              ],
                              barWidth: 5,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: false,
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                colors: [
                                  Constants.secondColor,
                                  Constants.greenAccent
                                ]
                                    .map((color) => color.withOpacity(0.3))
                                    .toList(),
                              ),
                            ),
                          ],
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
                        child: Center(
                          child: Text("Coming soon"),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
