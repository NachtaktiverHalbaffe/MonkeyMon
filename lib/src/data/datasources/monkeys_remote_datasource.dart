import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/datasources/dio_remote_datasource.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final monkeyRemoteDatasourceProvider = Provider.autoDispose
    .family<MonkeysRemoteDatasource, String>((ref, baseUrl) {
  String fallbackUrl =
      (kDebugMode && Platform.isAndroid) ? "http://10.0.2.2:8080/api/v1/" : "";

  return MonkeysRemoteDatasource(
      baseUrl: baseUrl != "" ? baseUrl : fallbackUrl);
});

class MonkeysRemoteDatasource extends DioRemoteDatasource {
  static String get apiBaseUrl => "http://127.0.0.1/:8080/api/v1/";
  static Duration get sendTimeout => const Duration(seconds: 2);
  static Duration get connectTimeout => const Duration(seconds: 10);
  static Duration get receiveTimeout => const Duration(seconds: 2);

  MonkeysRemoteDatasource({super.headers, String baseUrl = ""})
      : super(
            baseUrl: baseUrl != "" ? baseUrl : apiBaseUrl,
            sendTimeout: sendTimeout,
            connectTimeout: connectTimeout,
            receiveTimeout: receiveTimeout);

  Future<(List<Monkey>, List<SingleSpecies>)> getAllMonkeys() async {
    List<Monkey> monkeys = List.empty(growable: true);
    List<SingleSpecies> species = List.empty(growable: true);

    Response<String> response;
    try {
      response = await performGet("/monkeys");
      if (response.data == null) {
        return (List<Monkey>.empty(), List<SingleSpecies>.empty());
      }
    } on NetworkExcpetion {
      rethrow;
    }

    Map<String, dynamic> responseJson = json.decode(response.data!);

    for (int i = 0; i < responseJson["content"].length; i++) {
      monkeys.add(_parseToMonkey(responseJson["content"][i]));
      species.add(_parseToSpecies(responseJson["content"][i]));
    }

    return (monkeys, species);
  }

  Future<(Monkey?, SingleSpecies?)> getMonkey(int id) async {
    Monkey monkey;
    SingleSpecies species;

    Response<String> response;
    try {
      response = await performGet("/monkeys/$id");
      if (response.data == null) {
        return (null, null);
      }
    } on NetworkExcpetion {
      rethrow;
    }

    var responseJson = json.decode(response.data!);

    if (responseJson["id"] == null) {
      return (null, null);
    }

    monkey = _parseToMonkey(responseJson);
    species = _parseToSpecies(responseJson);

    return (monkey, species);
  }

  Future<(Monkey?, SingleSpecies?)> createMonkey(MonkeysCompanion monkey,
      {File? image}) async {
    Response<String> response;

    Map<String, dynamic> jsonPayload = _monkeyToJson(monkey);

    FormData formData;
    if (image != null) {
      formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path,
            contentType:
                MediaType('image', image.path.split(".").last.toLowerCase())),
        "body": jsonEncode(jsonPayload),
      });
    } else {
      formData = FormData.fromMap({
        "body": jsonEncode(jsonPayload),
      });
    }

    try {
      getLogger().d(
          "Performing post request with payload: ${formData.fields.toString()}");
      response = await performPost("/monkeys", formData);
      if (response.data == null) {
        return (null, null);
      }
    } on NetworkExcpetion catch (e) {
      getLogger().e(e);
      rethrow;
    }

    var responseJson = json.decode(response.data!);

    if (responseJson["id"] == null) {
      return (null, null);
    }

    Monkey responseMonkey = _parseToMonkey(responseJson);
    SingleSpecies responseSpecies = _parseToSpecies(responseJson);

    return (responseMonkey, responseSpecies);
  }

  Future<(Monkey?, SingleSpecies?)> updateMonkey(MonkeysCompanion monkey,
      {File? image}) async {
    getLogger().d("Put-Request requested");
    Response<String> response;
    Map<String, dynamic> jsonPayload = _monkeyToJson(monkey, includeId: true);

    getLogger().d("Created Json-payload");

    FormData formData;
    if (image != null) {
      formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path,
            contentType:
                MediaType('image', image.path.split(".").last.toLowerCase())),
        "body": jsonEncode(jsonPayload),
      });
    } else {
      formData = FormData.fromMap({
        "body": jsonEncode(jsonPayload),
      });
    }

    getLogger().d("Got Formdata");

    try {
      getLogger().d(
          "Performing put request with payload: ${formData.fields.toString()}");
      response = await performPut("/monkeys/${monkey.id.value}", formData);
      if (response.data == null) {
        return (null, null);
      }
    } on NetworkExcpetion {
      rethrow;
    }
    getLogger().d("Got response $response from server");
    var responseJson = json.decode(response.data!);

    if (responseJson["id"] == null) {
      return (null, null);
    }

    Monkey responseMonkey = _parseToMonkey(responseJson);
    SingleSpecies responseSpecies = _parseToSpecies(responseJson);

    return (responseMonkey, responseSpecies);
  }

  Monkey _parseToMonkey(Map<String, dynamic> jsonPayload) {
    return Monkey(
      id: jsonPayload["id"] as int,
      name: jsonPayload["name"] as String,
      knownFrom: jsonPayload["known_from"] as String,
      description: jsonPayload["description"] as String,
      image: jsonPayload["image"] as String,
      strength: jsonPayload["strength"] as String,
      weaknesses: jsonPayload["weaknesses"] as String,
      attack: jsonPayload["attack"] as int,
      defense: jsonPayload["defense"] as int,
      specialAttack: jsonPayload["special_attack"] as int,
      specialDefense: jsonPayload["special_defense"] as int,
      speed: jsonPayload["speed"] as int,
      healthPoints: jsonPayload["health_points"] as int,
      species: jsonPayload["species_name"] as String,
    );
  }

  SingleSpecies _parseToSpecies(Map<String, dynamic> jsonPayload) {
    return SingleSpecies(
      name: jsonPayload["species_content"]["name"] as String,
      taxonomy:
          (jsonPayload["species_content"]["taxonomy"] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as String)),
      locations: (jsonPayload["species_content"]["locations"] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      characteristics: (jsonPayload["species_content"]["characteristics"]
              as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, value as String)),
    );
  }

  Map<String, dynamic> _monkeyToJson(MonkeysCompanion data,
      {bool includeId = false}) {
    Map<String, dynamic> json = {
      "name": data.name.value,
    };
    if (includeId) {
      json.putIfAbsent("id", () => data.id.value);
    }
    if (data.knownFrom.present) {
      json.putIfAbsent("known_from", () => data.knownFrom.value);
    }
    if (data.description.present) {
      json.putIfAbsent("description", () => data.description.value);
    }
    if (data.strength.present) {
      json.putIfAbsent("strength", () => data.strength.value);
    }
    if (data.weaknesses.present) {
      json.putIfAbsent("weaknesses", () => data.weaknesses.value);
    }
    if (data.healthPoints.present) {
      json.putIfAbsent("health_points", () => data.healthPoints.value);
    }
    if (data.attack.present) {
      json.putIfAbsent("attack", () => data.attack.value);
    }
    if (data.defense.present) {
      json.putIfAbsent("defense", () => data.defense.value);
    }
    if (data.specialAttack.present) {
      json.putIfAbsent("special_attack", () => data.specialAttack.value);
    }
    if (data.specialDefense.present) {
      json.putIfAbsent("special_defense", () => data.specialDefense.value);
    }
    if (data.speed.present) {
      json.putIfAbsent("speed", () => data.speed.value);
    }
    if (data.species.present) {
      json.putIfAbsent("species_name", () => data.species.value);
    }

    return json;
  }
}
