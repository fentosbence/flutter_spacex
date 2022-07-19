import 'package:flutter/material.dart';
import 'package:flutter_spacex/data_model.dart';

import 'package:flutter_spacex/payload.dart';
import 'package:flutter_spacex/view/mylist_widget.dart';

import 'api.dart';

class LaunchesViewModel extends ChangeNotifier {
  List<Launch> _launches = [];
  List<PayloadViewModel> _payloads = [];

  final Api api;

  LaunchesViewModel({required this.api});

  List<Launch> get launches => _launches;

  List<PayloadViewModel> get payloads => _payloads;

  Future<void> loadAllLaunches() async {
    _launches = await api.fetchLaunches();
    _payloads = List.generate(
      _launches.length,
      (index) => PayloadViewModel(null, LoadingState.loading),
    );
    notifyListeners();
  }

  Future<void> loadPayloadForLaunchAt(int index) async {
    final launch = _launches[index];
    PayloadViewModel model = _payloads[index];

    if (model.state == LoadingState.content) return;

    final data = await Api().fetchPayloads(launch);
    model.payload = data;
    model.state = LoadingState.content;

    notifyListeners();
  }
}

void main() => runApp(
      const MaterialApp(home: MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _model = LaunchesViewModel(api: MockApi());

  @override
  void initState() {
    super.initState();
    _model.loadAllLaunches();
    _model.addListener(_updateContents);
  }

  @override
  void dispose() {
    super.dispose();
    _model.removeListener(_updateContents);
  }

  void _updateContents() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SpaceX Launches"),
      ),
      body: MyListWidget(
        launches: _model.launches,
        payloads: _model.payloads,
        onLaunchDetailsExpanded: (index) =>
            _model.loadPayloadForLaunchAt(index),
      ),
    );
  }
}
