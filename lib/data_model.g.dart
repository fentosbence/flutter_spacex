// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Launch _$LaunchFromJson(Map<String, dynamic> json) => Launch(
      json['id'] as String,
      json['name'] as String,
      DateTime.parse(json['date_utc'] as String),
      (json['payloads'] as List<dynamic>).map((e) => e as String).toList(),
      LinkContainer.fromJson(json['links'] as Map<String, dynamic>),
    );

LinkContainer _$LinkContainerFromJson(Map<String, dynamic> json) =>
    LinkContainer(
      ImageContainer.fromJson(json['patch'] as Map<String, dynamic>),
    );

ImageContainer _$ImageContainerFromJson(Map<String, dynamic> json) =>
    ImageContainer(
      json['small'] == null ? null : Uri.parse(json['small'] as String),
      json['large'] == null ? null : Uri.parse(json['large'] as String),
    );

Payload _$PayloadFromJson(Map<String, dynamic> json) => Payload(
      json['id'] as String,
      json['name'] as String,
      json['type'] as String,
    );
