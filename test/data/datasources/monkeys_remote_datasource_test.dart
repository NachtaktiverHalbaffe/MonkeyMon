import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkey_mon/src/data/datasources/dio_remote_datasource.dart';
import 'package:monkey_mon/src/data/datasources/monkeys_remote_datasource.dart';
import 'package:monkey_mon/src/exceptions/network_exception.dart';

import '../test_data.dart';

class DioAdapterMock extends Mock implements DioRemoteDatasource {}

void main() {
  late MonkeysRemoteDatasource sut;
  late Dio dio;
  late DioAdapter dioAdapter;

  setUp(() {
    sut = MonkeysRemoteDatasource();
    dio = sut.dio;
    dioAdapter = DioAdapter(
        dio: dio, printLogs: true, matcher: const UrlRequestMatcher());
  });

  group("getAllMonkey", () {
    test(
        'a valid request returns a valid response which is parsed into monkey and species data class',
        () async {
      final Map<String, dynamic> expectedResult = generateMonkeyApiAllMonkeys();
      dioAdapter.onGet(
        "/monkeys",
        (server) {
          server.reply(
            200,
            expectedResult,
          );
        },
        data: Matchers.any,
      );
      var (monkeys, species) = await sut.getAllMonkeys();

      expect(monkeys.length, greaterThanOrEqualTo(1));
      expect(species.length, greaterThanOrEqualTo(1));
      expect(monkeys[0].id, expectedResult["content"][0]["id"]);
      expect(monkeys[0].name, expectedResult["content"][0]["name"]);
      expect(monkeys[0].knownFrom, expectedResult["content"][0]["known_from"]);
      expect(
          monkeys[0].description, expectedResult["content"][0]["description"]);
      expect(monkeys[0].strength, expectedResult["content"][0]["strength"]);
      expect(monkeys[0].weaknesses, expectedResult["content"][0]["weaknesses"]);
      expect(monkeys[0].attack, expectedResult["content"][0]["attack"]);
      expect(monkeys[0].defense, expectedResult["content"][0]["defense"]);
      expect(monkeys[0].specialAttack,
          expectedResult["content"][0]["special_attack"]);
      expect(monkeys[0].specialDefense,
          expectedResult["content"][0]["special_defense"]);
      expect(monkeys[0].speed, expectedResult["content"][0]["speed"]);
      expect(monkeys[0].healthPoints,
          expectedResult["content"][0]["health_points"]);

      expect(species[0].name,
          expectedResult["content"][0]["species_content"]["name"]);
      expect(species[0].taxonomy,
          expectedResult["content"][0]["species_content"]["taxonomy"]);
      expect(species[0].locations,
          expectedResult["content"][0]["species_content"]["locations"]);
      expect(species[0].characteristics,
          expectedResult["content"][0]["species_content"]["characteristics"]);
    });

    test('a valid request which responds with no data returns a empty list',
        () async {
      dioAdapter.onGet(
        "/monkeys",
        (server) {
          server.reply(
            200,
            generateMonkeyApiAllMonkeysEmpty(),
          );
        },
        data: Matchers.any,
      );
      var (monkeys, species) = await sut.getAllMonkeys();

      expect(monkeys.length, 0);
      expect(species.length, 0);
    });

    test(
        'when the server doesnt respond, the requests times out and a exception is thrown',
        () async {
      expect(() async => await sut.getAllMonkeys(),
          throwsA(isA<NetworkExcpetion>()));
    });

    test(
        'when the server doesnt respond with 200 status code, a networkexception with bad response type is thrown',
        () async {
      dioAdapter.onGet(
        "/monkeys",
        (server) {
          server.reply(
            404,
            {},
          );
        },
        data: Matchers.any,
      );
      try {
        await sut.getAllMonkeys();
      } on NetworkExcpetion catch (e) {
        expect(e, isA<NetworkExcpetion>());
        expect(e.type, NetworkExceptionType.badResponse);
      }
    });
  });

  group("getMonkey", () {
    test(
        'a valid request returns a valid response which is parsed into monkey and species data class',
        () async {
      final Map<String, dynamic> expectedResult = generateMonkeyApiOneMonkey();
      dioAdapter.onGet(
        "/monkeys/${expectedResult["id"]}",
        (server) {
          server.reply(
            200,
            expectedResult,
          );
        },
        data: Matchers.any,
      );
      var (monkey, species) = await sut.getMonkey(expectedResult["id"]);
      expect(monkey, isNotNull);
      expect(monkey!.id, expectedResult["id"]);
      expect(monkey.name, expectedResult["name"]);
      expect(monkey.knownFrom, expectedResult["known_from"]);
      expect(monkey.description, expectedResult["description"]);
      expect(monkey.strength, expectedResult["strength"]);
      expect(monkey.weaknesses, expectedResult["weaknesses"]);
      expect(monkey.attack, expectedResult["attack"]);
      expect(monkey.defense, expectedResult["defense"]);
      expect(monkey.specialAttack, expectedResult["special_attack"]);
      expect(monkey.specialDefense, expectedResult["special_defense"]);
      expect(monkey.speed, expectedResult["speed"]);
      expect(monkey.healthPoints, expectedResult["health_points"]);

      expect(species, isNotNull);
      expect(species!.name, expectedResult["species_content"]["name"]);
      expect(species.taxonomy, expectedResult["species_content"]["taxonomy"]);
      expect(species.locations, expectedResult["species_content"]["locations"]);
      expect(species.characteristics,
          expectedResult["species_content"]["characteristics"]);
    });

    test('a valid request which gets no data returns a null value', () async {
      dioAdapter.onGet(
        "/monkeys/1",
        (server) {
          server.reply(
            200,
            {},
          );
        },
        data: Matchers.any,
      );
      var (monkey, species) = await sut.getMonkey(1);
      expect(monkey, isNull);
      expect(species, isNull);
    });

    test(
        'when the server doesnt respond, the requests times out and a exception is thrown',
        () async {
      expect(
          () async => await sut.getMonkey(1), throwsA(isA<NetworkExcpetion>()));
    });

    test(
        'when the server doesnt respond with 200 status code, a networkexception with bad response type is thrown',
        () async {
      dioAdapter.onGet(
        "/monkeys/1",
        (server) {
          server.reply(
            500,
            {},
          );
        },
        data: Matchers.any,
      );
      try {
        await sut.getMonkey(1);
      } on NetworkExcpetion catch (e) {
        expect(e, isA<NetworkExcpetion>());
        expect(e.type, NetworkExceptionType.badResponse);
      }
    });
  });
}
