import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkey_mon/src/data/datasources/dio_remote_datasource.dart';
import 'package:monkey_mon/src/data/datasources/monkeys_remote_datasource.dart';

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
      expect(species[0].name,
          expectedResult["content"][0]["species_content"]["name"]);
    });
  });
}
