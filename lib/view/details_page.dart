import 'package:flutter/material.dart';
import 'package:flutter_spacex/data_model.dart';
import 'package:flutter_spacex/view/payload_details.dart';

import 'package:flutter_spacex/main.dart';
import 'package:flutter_spacex/payload.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final PayloadViewModel payloadModel;
  const DetailsPage({super.key, required this.title, required this.payloadModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PayloadDetails(payloadModel: payloadModel)
    );
  }
}