import 'dart:convert';

import 'package:equatable/equatable.dart';

class Source extends Equatable {
  Source({
    required this.id,
    required this.name,
  });

  final dynamic id;
  final String? name;

  factory Source.fromRawJson(String str) => Source.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  @override
  List<Object?> get props => [id, name];
}
