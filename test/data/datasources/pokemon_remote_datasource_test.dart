@Timeout(Duration(minutes: 15))
import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monkey_mon/src/data/datasources/pokemon_remote_datasource.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';

void main() {
  late PokemonRemoteDatasource sut;

  setUp(() {
    sut = PokemonRemoteDatasource();
  });

  group('get single pokemon', () {
    test('test that get a single pokemon works', () async {
      final Pokemon? result = await sut.getPokemon(name: "infernape");
      expect(result, isNotNull);
    });

    test(
        'test that get a single pokemon fails if neither id or name are specified',
        () async {
      try {
        await sut.getPokemon();
      } on ArgumentError catch (e) {
        expect(e.message, "either id or name has to be given");
      }
    });
  });

  test('test that getting total amount of avialable pokemon works', () async {
    final int result = await sut.getNrOfTotalPokemon();
    expect(result, greaterThan(1000));
  });

  test('test that getall pokemon works', () async {
    final int count = await sut.getNrOfTotalPokemon();
    final List<Pokemon> result = await sut.getAllPokemon();

    expect(result, isNotNull);
    expect(result.length, count);
  }, skip: true);

  test('test that streaming pokemon works and that the stream is cancellable',
      () async {
    int i = 0;
    CancellationToken cancelToken = CancellationToken();
    final stream = sut.streamAllPokemon(cancellationToken: cancelToken);

    List<Pokemon> result = List.empty(growable: true);
    await for (final value in stream) {
      if (i == 20) {
        cancelToken.cancel();
      }
      result.add(value);
      i++;
    }

    expect(result.length, greaterThanOrEqualTo(20));
  });

  test('test that the number of available pokemon is gettable', () async {
    final result = await sut.getNrOfTotalPokemon();

    expect(result, greaterThanOrEqualTo(1000));
  });
}
