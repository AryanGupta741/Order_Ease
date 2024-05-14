import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

class ChartModel {
  final String date;
  final int income;

  ChartModel({required this.date, required this.income});

  factory ChartModel.fromJson(Map<String, dynamic> json) {
    return ChartModel(
      date: json['date'],
      income: json['income'],
    );
  }
}

Future<List<ChartModel>> fetchChartData() async {
  final response = await http.get(Uri.parse('http://localhost:3000/api/chartdata'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ChartModel.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load chart data');
  }
}

class ChartPage extends StatefulWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late Future<List<ChartModel>> _futureChartData;

  @override
  void initState() {
    super.initState();
    _futureChartData = fetchChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<ChartModel>>(
          future: _futureChartData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildChart(snapshot.data!),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildList(snapshot.data!),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildChart(List<ChartModel> data) {
    List<charts.Series<ChartModel, String>> series = [
      charts.Series(
        id: "Income",
        data: data,
        domainFn: (ChartModel series, _) =>
            DateTime
                .parse(series.date)
                .day
                .toString(),
        measureFn: (ChartModel series, _) => series.income,
        colorFn: (_, __) => charts.MaterialPalette.teal.shadeDefault,
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
    );
  }

  Widget _buildList(List<ChartModel> data) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Income ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff2A977D),
              ),
            ),
            const Divider(
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];
                // Parse the date string
                DateTime dateTime = DateTime.parse(item.date);
                // Format the date to display only the day
                String formattedDate = '${dateTime.day}-${dateTime
                    .month}-${dateTime.year}';
                return ListTile(
                  title: Text(formattedDate),
                  subtitle: Text('Income: \₹${item.income}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}