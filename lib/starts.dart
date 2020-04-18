import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'app_bar.dart';
import 'loading_screen.dart';

class TotalStats {
  List<RegionStats> regionsStatsList;
  final int infected;
  final int deceased;

  TotalStats({this.regionsStatsList,this.infected, this.deceased});

  factory TotalStats.fromJson(Map<String, dynamic> json) {
    Iterable regionList = json['infectedByRegion'];
    List<RegionStats> regionsStats = regionList.map((i) =>
        RegionStats.fromJson(i)).toList();
    return TotalStats(
      regionsStatsList: regionsStats,
      infected: json['infected'],
      deceased: json['deceased'],
    );
  }
}

class RegionStats {
  final String region;
  final int infectedCount;
  final int deceasedCount;

  RegionStats({this.region, this.infectedCount, this.deceasedCount});

  factory RegionStats.fromJson(Map<String, dynamic> json) {
    return RegionStats(
      region: json['region'],
      infectedCount: json['infectedCount'],
      deceasedCount: json['deceasedCount'],
    );
  }
}

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  Future<TotalStats> futureData;

  Future<TotalStats> getData() async {
    final response =
    await http.get('https://api.apify.com/v2/key-value-stores/3Po6TV7wTht4vIEid/records/LATEST?disableRedirect=true');
    return TotalStats.fromJson(json.decode(response.body));
  }

  @override
  void initState() {
    super.initState();
    futureData = getData();
  }

  Future<TotalStats> _refresh() {
    futureData = getData();
    return futureData;

  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  TextStyle columnText = TextStyle(fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<RegionStats> data = snapshot.data.regionsStatsList;
          List<DataRow> rows = [
            DataRow(cells: <DataCell>[
              DataCell(Text('Summary',style: TextStyle(color: Colors.red[400]),)
              ),
              DataCell(Text(snapshot.data.infected.toString(),style: TextStyle(color: Colors.red[400]),),),
              DataCell(Text(snapshot.data.deceased.toString(),style: TextStyle(color: Colors.red[400]),)),
            ])
          ];
          for(var i = 0;i<data.length;i++){
            rows.add(DataRow(cells: <DataCell>[
              DataCell(
                Text(data[i].region[0].toUpperCase()+data[i].region.substring(1),style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              DataCell(Text(data[i].infectedCount.toString(),),
              ),
              DataCell(Text(data[i].deceasedCount.toString(),)),
            ]));
          }



          return Scaffold(
              appBar: appBar,
              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: <DataColumn>[
                            DataColumn(
                                label: Text('Region',style: columnText,)),
                            DataColumn(label: Text('Infected',style: columnText)
                            ),
                            DataColumn(label: Text('Deaths',style: columnText)),
                          ],
                          rows: rows
                      ),
                    ),

                  ),
                ),
              )
          );
        }

        return LoadingScreen();
      },
    );
  }
}
