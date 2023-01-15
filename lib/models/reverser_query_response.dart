// To parse this JSON data, do
//
//     final reverseQueryResponse = reverseQueryResponseFromJson(jsonString);

import 'dart:convert';

ReverseQueryResponse? reverseQueryResponseFromJson(String str) =>
    ReverseQueryResponse.fromJson(json.decode(str));

String reverseQueryResponseToJson(ReverseQueryResponse? data) =>
    json.encode(data!.toJson());

class ReverseQueryResponse {
  ReverseQueryResponse({
    this.type,
    this.query,
    this.features,
    this.attribution,
  });

  String? type;
  List<double?>? query;
  List<Feature?>? features;
  String? attribution;

  factory ReverseQueryResponse.fromJson(Map<String, dynamic> json) =>
      ReverseQueryResponse(
        type: json["type"],
        query: json["query"] == null
            ? []
            : List<double?>.from(json["query"]!.map((x) => x.toDouble())),
        features: json["features"] == null
            ? []
            : List<Feature?>.from(
                json["features"]!.map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "query": query == null ? [] : List<dynamic>.from(query!.map((x) => x)),
        "features": features == null
            ? []
            : List<dynamic>.from(features!.map((x) => x!.toJson())),
        "attribution": attribution,
      };
}

class Feature {
  Feature({
    this.id,
    this.type,
    this.placeType,
    this.relevance,
    this.properties,
    this.textEs,
    this.placeNameEs,
    this.text,
    this.placeName,
    this.center,
    this.geometry,
    this.address,
    this.context,
  });

  String? id;
  String? type;
  List<String?>? placeType;
  int? relevance;
  Properties? properties;
  String? textEs;
  String? placeNameEs;
  String? text;
  String? placeName;
  List<double?>? center;
  Geometry? geometry;
  String? address;
  List<Context?>? context;

  factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: json["place_type"] == null
            ? []
            : List<String?>.from(json["place_type"]!.map((x) => x)),
        relevance: json["relevance"],
        properties: Properties.fromJson(json["properties"]),
        textEs: json["text_es"],
        placeNameEs: json["place_name_es"],
        text: json["text"],
        placeName: json["place_name"],
        center: json["center"] == null
            ? []
            : List<double?>.from(json["center"]!.map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        address: json["address"],
        context: json["context"] == null
            ? []
            : List<Context?>.from(
                json["context"]!.map((x) => Context.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": placeType == null
            ? []
            : List<dynamic>.from(placeType!.map((x) => x)),
        "relevance": relevance,
        "properties": properties!.toJson(),
        "text_es": textEs,
        "place_name_es": placeNameEs,
        "text": text,
        "place_name": placeName,
        "center":
            center == null ? [] : List<dynamic>.from(center!.map((x) => x)),
        "geometry": geometry!.toJson(),
        "address": address,
        "context": context == null
            ? []
            : List<dynamic>.from(context!.map((x) => x!.toJson())),
      };
}

class Context {
  Context({
    this.id,
    this.textEs,
    this.text,
    this.wikidata,
    this.languageEs,
    this.language,
    this.shortCode,
  });

  String? id;
  String? textEs;
  String? text;
  String? wikidata;
  String? languageEs;
  String? language;
  String? shortCode;

  factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        textEs: json["text_es"],
        text: json["text"],
        wikidata: json["wikidata"],
        languageEs: json["language_es"],
        language: json["language"],
        shortCode: json["short_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text_es": textEs,
        "text": text,
        "wikidata": wikidata,
        "language_es": languageEs,
        "language": language,
        "short_code": shortCode,
      };
}

class Geometry {
  Geometry({
    this.type,
    this.coordinates,
  });

  String? type;
  List<double?>? coordinates;

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        type: json["type"],
        coordinates: json["coordinates"] == null
            ? []
            : List<double?>.from(json["coordinates"]!.map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": coordinates == null
            ? []
            : List<dynamic>.from(coordinates!.map((x) => x)),
      };
}

class Properties {
  Properties({
    this.accuracy,
  });

  String? accuracy;

  factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"],
      );

  Map<String, dynamic> toJson() => {
        "accuracy": accuracy,
      };
}
