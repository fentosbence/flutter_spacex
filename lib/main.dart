import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spacex/data_model.dart';


import 'package:flutter_spacex/payload.dart';
import 'package:flutter_spacex/view/mylist_widget.dart';

import 'api.dart';

void main() => runApp(
      const MaterialApp(home: MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Launch>> launchListFuture;
  late List<PayloadViewModel> payloads;

  @override
  void initState() {
    super.initState();
    launchListFuture = Api().fetchLaunches();
    payloads = <PayloadViewModel>[];
  }

  Future<void> _loadPayloadForLaunchAt(int index, List<Launch> launches) async {
    final launch = launches[index];
    PayloadViewModel model = payloads[index];

    if (model.state == LoadingState.content) return;

    final data = await Api().fetchPayloads(launch);

    model.payload = data;
    model.state = LoadingState.content;
    setState(() {
      print("done");
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpaceX Launches"),
      ),
      body: FutureBuilder<List<Launch>>(
        future: launchListFuture,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            payloads = List.generate(snapshot.data!.length,
                    (index) => PayloadViewModel(null, LoadingState.loading));
            return Data(
              snapshot.data!,
              payloads,
              child: MyListWidget(
                launches: snapshot.data!,
                onLaunchDetailsExpanded: (index) =>
                    _loadPayloadForLaunchAt(index, snapshot.data!),
              ),
            );
          }

          if (snapshot.hasError) {
            return Container(
              color: Colors.red,
            );
          }
          return Container(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}

class Data extends InheritedWidget {
  final List<Launch> launches;
  List<PayloadViewModel> payloadModel;

  Data(this.launches, this.payloadModel, {Key? key, required super.child})
      : super(key: key);

  @override
  bool updateShouldNotify(covariant Data oldWidget) =>
      oldWidget.payloadModel != payloadModel;

  static Data of(context) => context.dependOnInheritedWidgetOfExactType<Data>();
}
