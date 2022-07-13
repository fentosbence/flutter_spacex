import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';



@JsonSerializable(explicitToJson: true)
class Launch {
  Launch(this.id, this.name, this.date, this.smallImageUrl, this.largeImageUrl, this.payloadIds);

  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'date_utc')
  final DateTime date;


  final Uri? smallImageUrl;


  final Uri? largeImageUrl;

  @JsonKey(name: 'payloads')
  List<String> payloadIds;

  factory Launch.fromJson(Map<String, dynamic> json) => Launch(
    json['id'] as String,
    json['name'] as String,
    DateTime.parse(json['date_utc'] as String),
    json['links']['patch']['small'] == null ? null : Uri.parse(json['links']['patch']['small']),
    json['links']['patch']['large'] == null ? null : Uri.parse(json['links']['patch']['large']),
    (json['payloads'] as List<dynamic>).map((e) => e as String).toList(),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'date_utc': date.toIso8601String(),
    'smallImageUrl': smallImageUrl.toString(),
    'largeImageUrl': largeImageUrl.toString(),
    'payloads': payloadIds,
  };

}


@JsonSerializable()
class Payload {
  Payload(this.id, this.name, this.type);

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'type')
  String type;

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    json['id'] as String,
    json['name'] as String,
    json['type'] as String,
  );


}