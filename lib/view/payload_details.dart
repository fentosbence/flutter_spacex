import 'package:flutter/material.dart';
import 'package:flutter_spacex/payload.dart';

import 'package:flutter_spacex/main.dart';
import 'package:flutter_spacex/view/details_page.dart';

class PayloadDetails extends StatelessWidget {
  final PayloadViewModel payloadModel;

  const PayloadDetails( {required this.payloadModel, super.key});

  @override
  Widget build(BuildContext context) {
    switch (payloadModel.state) {
      case LoadingState.loading:
        return Container(height: 100, color: Colors.blue);

      case LoadingState.error:
        return Container(height: 100, color: Colors.red);

      case LoadingState.content:
        return ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: payloadModel.payload!.length,
          itemBuilder: (context, i) {
            final payload = payloadModel.payload![i];
            return ListTile(
              leading: Text(payload.name),
              trailing: Text(payload.type),
            );
          },
        );
    }
  }
}
