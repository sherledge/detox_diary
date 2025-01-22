import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'database_helper.dart';
import 'activity.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import 'quotes.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GraphScreenState createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> with SingleTickerProviderStateMixin {
  List<Activity> goodActivities = [];
  List<Activity> badActivities = [];
  late TooltipBehavior _tooltipBehavior;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String adviceText = "";

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    goodActivities = await dbHelper.getActivities(true);
    badActivities = await dbHelper.getActivities(false);
    _animationController.forward();

    showQuote();
    setState(() {});
  }

  void showQuote() {
    int goodCount = goodActivities.where((activity) => activity.isCompleted).length;
    int badCount = badActivities.where((activity) => activity.isCompleted).length;

    if (goodCount > badCount) {
      var quote = QuotesData.goodDopamineQuotes[Random().nextInt(QuotesData.goodDopamineQuotes.length)];
      adviceText = "${quote.text} - ${quote.author}";
    } else if (badCount > goodCount) {
      var quote = QuotesData.badDopamineQuotes[Random().nextInt(QuotesData.badDopamineQuotes.length)];
      adviceText = "${quote.text} - ${quote.author}";
    } else {
      adviceText = "You're balancing well. Keep evaluating your activities!";
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int goodCount = goodActivities.where((activity) => activity.isCompleted).length;
    int badCount = badActivities.where((activity) => activity.isCompleted).length;
    int maxCount = (goodCount > badCount) ? goodCount : badCount;

    final List<Map<String, dynamic>> dataSource = [
      {'name': 'Good', 'count': goodCount, 'color': Colors.green},
      {'name': 'Bad', 'count': badCount, 'color': Colors.red},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detox Diary',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _animation,
              child: Text(
                adviceText,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FadeTransition(
                opacity: _animation,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat('#'),
                    maximum: maxCount + 1,
                    interval: 1,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  tooltipBehavior: _tooltipBehavior,
                  series: <CartesianSeries>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: dataSource,
                      xValueMapper: (Map<String, dynamic> data, _) => data['name'],
                      yValueMapper: (Map<String, dynamic> data, _) => data['count'],
                      pointColorMapper: (Map<String, dynamic> data, _) => data['color'],
                      borderColor: Colors.black,
                      borderWidth: 1,
                    ),
                  ],
                  backgroundColor: const Color(0xFF1B2631),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text('Good Activities', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Container(width: 12, height: 12, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text('Bad Activities', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
