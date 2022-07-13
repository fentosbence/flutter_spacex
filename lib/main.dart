import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spacex/dataModel.dart';

import 'package:http/http.dart' as http;

void main() => runApp(
      MaterialApp(home: MyApp()),
    );

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyApp> {
  late Future<List<Launch>> launchList;

  @override
  void initState() {
    super.initState();
    launchList = fetchLaunches();
  }

  Future<List<Launch>> fetchLaunches() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/launches'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      return parsed.map<Launch>((json) => Launch.fromJson(json)).toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load launches');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SpaceX Launches"),
      ),
      body: FutureBuilder<List<Launch>>(
        future: launchList,
        builder: (BuildContext context, snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Expanded(
                  child: MyListWidget(
                launches: snapshot.data!,
              )),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}

class MyListWidget extends StatefulWidget {
  final List<Launch> launches;

  const MyListWidget({required this.launches});

  @override
  State<StatefulWidget> createState() => MyListState(launches);
}

class MyListState extends State<MyListWidget> {
  late Map<Launch, bool> isFavourite;

  final List<Launch> launches;

  MyListState(this.launches) {
    isFavourite = {for (var item in launches) item: false};
  }

  Future<List<Payload>> fetchPayloads(List<String> ids) async {
    return await Future.wait([
      for (var id in ids) fetchPayload(id),
    ]);
  }

  Future<Payload> fetchPayload(String id) async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/payloads/$id'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final parsed = json.decode(response.body);
      return Payload.fromJson(parsed);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load payloads');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: launches.length,
      itemBuilder: (context, index) {
        return Padding(
            padding: const EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4),
            child: ExpansionTile(
              title: Row(
                children: [
                  const SizedBox(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          child: Icon(Icons.rocket_launch),
                        ),
                      )),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          launches[index].name,
                        ),
                        Text(launches[index].date.toString()),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: isFavourite[launches[index]] == true
                        ? Icon(Icons.favorite)
                        : Icon(Icons.favorite_border),
                    onPressed: () {
                      setState(() {
                        isFavourite[launches[index]] =
                            isFavourite[launches[index]] == false
                                ? true
                                : false;
                      });
                    },
                  ),
                ],
              ),
              children: [
                FutureBuilder<List<Payload>>(
                  future: fetchPayloads(launches[index].payloadIds),
                  builder: (BuildContext context, snapshot) {
                    print(snapshot.data![0].type);
                    if (snapshot.hasError) {
                      return Text('Még mindig nem jó');
                    } else if (snapshot.hasData) {
                      return Container(
                        height: 100,
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              var list = fetchPayloads(launches[i].payloadIds);
                              return ListTile(
                                leading: Text(snapshot.data![i].name),
                                trailing: Text(snapshot.data![i].type),
                              );
                            }),
                      );
                    } else {
                      return Text('Még nincs érték');
                    }
                    return Text('Még mindig szar ez a fos');
                  },
                ),
              ],
            ));
      },
    );
  }
}
