import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spacex/data_model.dart';
import 'package:http/http.dart' as http;


class Api {
  Future<List<Launch>> fetchLaunches() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/launches'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
      final launches =
          parsed.map<Launch>((json) => Launch.fromJson(json)).toList();

      return launches;
    } else {
      throw Exception('Failed to load launches');
    }
  }

  Future<Payload> fetchPayload(String id) async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/payloads/$id'));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Payload.fromJson(parsed);
    } else {
      throw Exception('Failed to load payloads');
    }
  }

  Future<List<Payload>> fetchPayloads(Launch launch) async {
    return await Future.wait([
      for (var id in launch.payloadIds) fetchPayload(id),
    ]);
  }
}
