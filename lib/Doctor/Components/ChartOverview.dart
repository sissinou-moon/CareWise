// ignore_for_file: must_be_immutable

import 'package:carewise/Classes/Tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChartComponent extends StatefulWidget {
  ChartComponent({super.key});

  @override
  State<ChartComponent> createState() => _ChartComponentState();
}

class _ChartComponentState extends State<ChartComponent> {
  double MaxY = 40;
  double Day1Value = 0;
  double Day2Value = 0;
  double Day3Value = 0;
  double Day4Value = 0;
  double Day5Value = 0;
  double Day6Value = 0;
  double Day7Value = 0;

  //DATE
  DateTime NowaDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 5), (){
      FetchAppointmentsLength();
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: height*0.025,),
        MyTitle('   This Week Overview', Colors.black, height*0.029),
        SizedBox(height: height*0.01,),
        Row(
          children: [
            Expanded(child: SizedBox(width: height*0.06,)),
            MyDescription('Patient Overview', Colors.black, height*0.017, 1),
            SizedBox(width: height*0.01,),
            Image.asset('assets/icons/replace.png',height: height*0.02,),
            SizedBox(width: height*0.1,),
          ],
        ),
        SizedBox(height: height*0.06,),
        SizedBox(
          height: height*0.4,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: barGroups,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: MaxY,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> FetchAppointmentsLength() async {
    await FirebaseFirestore.instance.collection('Appointments').where('Did', isEqualTo: '1N18D62N').snapshots().listen((event) { 
      event.docs.forEach((element) { 
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay)) {
          setState(() {
            Day7Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 1)))) {
          setState(() {
            Day6Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 2)))) {
          setState(() {
            Day5Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 3)))) {
          setState(() {
            Day4Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 4)))) {
          setState(() {
            Day3Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 5)))) {
          setState(() {
            Day2Value++;
          });
        }
        if (element.data()['date'] == DateFormat.yMd().format(NowaDay.subtract(Duration(days: 6)))) {
          setState(() {
            Day1Value++;
          });
        }
      });
    });
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 2,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              TextStyle(
                color: MainColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mn';
        break;
      case 1:
        text = 'Te';
        break;
      case 2:
        text = 'Wd';
        break;
      case 3:
        text = 'Tu';
        break;
      case 4:
        text = 'Fr';
        break;
      case 5:
        text = 'St';
        break;
      case 6:
        text = 'Sn';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 15,
      child: MyDescription(text, Colors.black, 12.5, 1),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 10:
        text = '10';
        break;
      case 20:
        text = '20';
        break;
      case 30:
        text = '30';
        break;
      case 40:
        text = '40';
        break;
      case 50:
        text = '50';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: MyDescription(text, Colors.black, 12.5, 1),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: leftTitles,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          MainColor,
          MainColor,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: Day1Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: Day2Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: Day3Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: Day4Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: Day5Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: Day6Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: Day7Value,
              gradient: _barsGradient,
              borderRadius: BorderRadius.circular(4),
              width: 25
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

