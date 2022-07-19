import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable(createToJson: false)
class Launch {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'date_utc')
  final DateTime date;

  @JsonKey(name: 'links')
  final LinkContainer links;

  @JsonKey(name: 'payloads')
  List<String> payloadIds;

  Uri? get smallImageUrl => links.imageDetails.smallImageUrl;
  Uri? get largeImageUrl => links.imageDetails.largeImageUrl;

  factory Launch.fromJson(Map<String, dynamic> json) => _$LaunchFromJson(json);

  Launch(this.id, this.name, this.date, this.payloadIds, this.links);
}

@JsonSerializable(createToJson: false)
class LinkContainer {
  @JsonKey(name: 'patch')
  final ImageContainer imageDetails;

  factory LinkContainer.fromJson(Map<String, dynamic> json) =>
      _$LinkContainerFromJson(json);

  LinkContainer(this.imageDetails);
}

@JsonSerializable(createToJson: false)
class ImageContainer {
  @JsonKey(name: 'small')
  final Uri? smallImageUrl;

  @JsonKey(name: 'large')
  final Uri? largeImageUrl;

  factory ImageContainer.fromJson(Map<String, dynamic> json) =>
      _$ImageContainerFromJson(json);

  ImageContainer(this.smallImageUrl, this.largeImageUrl);
}

@JsonSerializable(createToJson: false)
class Payload {
  Payload(this.id, this.name, this.type);

  @JsonKey(name: 'id')
  String id;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'type')
  String type;

  factory Payload.fromJson(Map<String, dynamic> json) =>
      _$PayloadFromJson(json);
}
