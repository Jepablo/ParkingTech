import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class ParkingChartPage extends StatefulWidget {
  double? totalMon,totalTue,totalWed,totalThurs,totalFri,totalSat,totalSun;
  ParkingChartPage({Key? key, this.totalMon,this.totalTue,this.totalWed,this.totalThurs,this.totalFri,this.totalSat,this.totalSun}) : super(key: key);

  @override
  State<ParkingChartPage> createState() => _ParkingChartPageState();
}


class _ParkingChartPageState extends State<ParkingChartPage> {
  late List<CarChart> _chartData;
  // late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    // _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
    checkStatus();
  }
  checkStatus() async {
  }
  List<CarChart> getChartData() {
    final List<CarChart> chartData = [
      CarChart('Monday', widget.totalMon!),
      CarChart('Tuesday', widget.totalTue!),
      CarChart('Wednesday', widget.totalWed!),
      CarChart('Thursday', widget.totalThurs!),
      CarChart('Friday', widget.totalFri!),
      CarChart('Saturday', widget.totalSat!),
      CarChart('Sunday', widget.totalSun!),
    ];
    return chartData;
  }
  @override
  Widget build(BuildContext context) {
    // print(totalSat);
    return Text('hello');
    // return SafeArea(
    //     child: Scaffold(
    //       body: SfCartesianChart(
    //         title: ChartTitle(text: 'Total Parking Per Day'),
    //         legend: Legend(isVisible: true),
    //         tooltipBehavior: _tooltipBehavior,
    //         series: <ChartSeries>[
    //           BarSeries<CarChart, String>(
    //               name: '',
    //               dataSource: _chartData,
    //               xValueMapper: (CarChart chart, _) => chart.day,
    //               yValueMapper: (CarChart chart, _) => chart.car,
    //               dataLabelSettings: const DataLabelSettings(isVisible: true),
    //               enableTooltip: true)
    //         ],
    //         primaryXAxis: CategoryAxis(),
    //         primaryYAxis: NumericAxis(
    //             edgeLabelPlacement: EdgeLabelPlacement.shift,
    //             title: AxisTitle(text: 'Car', textStyle:const TextStyle(
    //               fontWeight: FontWeight.bold,
    //               fontSize: 18
    //             ))),
    //       ),
    //     ));
  }
}

class CarChart {
  CarChart(this.day, this.car);
  final String day;
  final double car;
}

