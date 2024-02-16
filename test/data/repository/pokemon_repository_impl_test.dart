import 'dart:math';

import 'package:cancellation_token/cancellation_token.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/datasources/pokemon_remote_datasource.dart';
import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';

import '../../riverpod_textcontainer.dart';
import '../test_data.dart';

class MockRemoteDatasource extends Mock implements PokemonRemoteDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase mockAppDatabase;
  late MockInternetChecker mockInternetChecker;
  late MockRemoteDatasource mockRemoteDatasource;

  late PokemonRepositoryImpl sut;

  setUp(() {
    mockAppDatabase = AppDatabase();
    mockInternetChecker = MockInternetChecker();
    mockRemoteDatasource = MockRemoteDatasource();
  });

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  tearDown(() async {
    await mockAppDatabase.close();
  });

  group('createPokemon', () {
    test("test that a pokemon that doesnt exist is created", () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      try {
        await sut.getPokemon(id: testData.id, name: testData.name);
      } catch (e) {
        expect(e, isArgumentError);
      }
    });

    test("""pokemon is fetched from REST-API  when 
        theres no pokemon cached and a internet connection avialable""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.getPokemon(id: any(named: "id")))
          .thenAnswer((invocation) => Future.value(generatePokemon()));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();

      var result = await sut.getPokemon(id: testData.id);
      expect(result, testData);
    });

    test(
        """if theres no pokemon in local db and no internet connection, null is returned""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      when(() => mockRemoteDatasource.getPokemon(id: any(named: "id")))
          .thenAnswer((invocation) => Future.value(generatePokemon()));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();

      var result = await sut.getPokemon(id: testData.id);

      verifyNever(() => mockRemoteDatasource.getPokemon());
      expect(result, isNull);
    });

    test("test that a pokemon that exist isnt created and returns null",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);
      final result = await sut.createPokemon(testData);

      expect(result, isNull);
      expect(await sut.getNrOfCachedPokemon(), 1);
    });
  });

  group("deletePokemon", () {
    test("Test that a existing pokemon identified by id is deleted ", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);
      expect(await sut.getNrOfCachedPokemon(), 1);

      final bool result = await sut.deletePokemon(id: testData.id);

      expect(result, true);
      expect(await sut.getNrOfCachedPokemon(), 0);
    });

    test("Test that a existing pokemon identified by name is deleted ",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);
      expect(await sut.getNrOfCachedPokemon(), 1);

      bool result = await sut.deletePokemon(name: testData.name);

      expect(result, true);
      expect(await sut.getNrOfCachedPokemon(), 0);
    });

    test("Test that a not-existing pokemon isnt deleted", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();

      bool result = await sut.deletePokemon(name: testData.name);

      expect(result, false);
      expect(await sut.getNrOfCachedPokemon(), 0);
    });

    test(
        "Test that a existing pokemon identified by name and id throws an argumenterror ",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      try {
        await sut.deletePokemon(name: testData.name, id: testData.id);
      } catch (e) {
        expect(e, isArgumentError);
      }

      try {
        await sut.deletePokemon();
      } catch (e) {
        expect(e, isArgumentError);
      }
    });
  });

  group("getAllPokemon", () {
    test("returns a list of pokemons when there are some in db", () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(0));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);
      await sut.createPokemon(testData.copyWith(id: 2));
      await sut.createPokemon(testData.copyWith(id: 3));

      final result = await sut.getAllPokemon();

      expect(result.length, 3);
      expect(result.any((element) => element == testData), isTrue);
    });

    test("""list of pokemon is fetched from REST-API  when 
        theres no pokemon cached and a internet connection avialable""",
        () async {
      final PokemonDto testData = generatePokemonDto();
      final Pokemon expectedElement = generatePokemon();
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource
              .getAllPokemon(offset: any<int?>(named: "offset")))
          .thenAnswer((_) => Future.value([
                expectedElement,
                expectedElement.copyWith(id: 2),
                expectedElement.copyWith(id: 3)
              ]));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(3));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);

      var result = await sut.getAllPokemon();
      expect(result.length, 3);
      expect(result.any((element) => element == testData), isTrue);
    });

    test(
        """if theres no pokemon in local db and no internet connection, a empty list""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(3));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);

      var result = await sut.getAllPokemon();

      verifyNever(() => mockRemoteDatasource.getPokemon());
      expect(result.length, 0);
    });
  });

  test("getNrOfCachedPokemon", () async {
    final testContainer = createContainer(overrides: [
      databaseProvider.overrideWith((ref) => mockAppDatabase),
    ]);
    sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
    expect(await sut.getNrOfCachedPokemon(), 0);

    final PokemonDto testData = generatePokemonDto();
    await sut.createPokemon(testData);
    expect(await sut.getNrOfCachedPokemon(), 1);
  });

  group("getPokemon", () {
    test(
        "pokemon either identified by id or name can be fetched from the local db",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);

      var result = await sut.getPokemon(id: testData.id);
      expect(result, testData);
      result = await sut.getPokemon(name: testData.name);
      expect(result, testData);
    });

    test("pokemon  identified by both id and name throws a argument error",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      try {
        await sut.getPokemon(id: testData.id, name: testData.name);
      } catch (e) {
        expect(e, isArgumentError);
      }
    });

    test("""pokemon is fetched from REST-API  when 
        theres no pokemon cached and a internet connection avialable""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.getPokemon(id: any(named: "id")))
          .thenAnswer((invocation) => Future.value(generatePokemon()));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();

      var result = await sut.getPokemon(id: testData.id);
      expect(result, testData);
    });

    test(
        """if theres no pokemon in local db and no internet connection, null is returned""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      when(() => mockRemoteDatasource.getPokemon(id: any(named: "id")))
          .thenAnswer((invocation) => Future.value(generatePokemon()));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();

      var result = await sut.getPokemon(id: testData.id);

      verifyNever(() => mockRemoteDatasource.getPokemon());
      expect(result, isNull);
    });
  });

  group("streamAllPokemon", () {
    test("list of pokemons is streamed when there are some in db", () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(0));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto testData = generatePokemonDto();
      await sut.createPokemon(testData);
      await sut.createPokemon(testData.copyWith(id: 2));
      await sut.createPokemon(testData.copyWith(id: 3));

      final stream = sut.streamAllPokemon();
      List<PokemonDto> result = List.empty(growable: true);
      await for (final value in stream) {
        result.add(value);
      }

      expect(result.length, 3);
      expect(result.any((element) => element == testData), isTrue);
    });

    test("""list of pokemon is fetched from REST-API  when 
        theres no pokemon cached, a internet connection avialable and the output is streamed""",
        () async {
      final PokemonDto testData = generatePokemonDto();
      final Pokemon expectedElement = generatePokemon();
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.streamAllPokemon(
              offset: any<int?>(named: "offset")))
          .thenAnswer((_) => Stream.fromIterable([
                expectedElement,
                expectedElement.copyWith(id: 2),
                expectedElement.copyWith(id: 3)
              ]));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(3));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);

      final stream = sut.streamAllPokemon();
      List<PokemonDto> result = List.empty(growable: true);
      await for (final value in stream) {
        result.add(value);
      }
      expect(result.length, 3);
      expect(result.any((element) => element == testData), isTrue);
    });

    test(
        """if theres no pokemon in local db and no internet connection, a empty list is streamed""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(3));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);

      final stream = sut.streamAllPokemon();
      List<PokemonDto> result = List.empty(growable: true);
      await for (final value in stream) {
        result.add(value);
      }
      expect(result.length, 0);
    });

    test("""when a canceltoken is activated, it stops streaming""", () async {
      final PokemonDto testData = generatePokemonDto();
      final Pokemon expectedElement = generatePokemon();
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      when(() => mockRemoteDatasource.streamAllPokemon(
              offset: any<int?>(named: "offset")))
          .thenAnswer((_) => Stream.fromIterable([
                expectedElement.copyWith(id: 12),
                expectedElement.copyWith(id: 13),
                expectedElement.copyWith(id: 14),
                expectedElement.copyWith(id: 15),
                expectedElement.copyWith(id: 16),
                expectedElement.copyWith(id: 17),
                expectedElement.copyWith(id: 18),
                expectedElement.copyWith(id: 19),
                expectedElement.copyWith(id: 20),
              ]));
      when(() => mockRemoteDatasource.getNrOfTotalPokemon())
          .thenAnswer((invocation) => Future.value(3));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker),
        pokemonRemoteDatasourceProvider
            .overrideWith((ref) => mockRemoteDatasource)
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      await sut.createPokemon(testData);
      await sut.createPokemon(testData.copyWith(id: 2));
      await sut.createPokemon(testData.copyWith(id: 3));
      await sut.createPokemon(testData.copyWith(id: 4));
      await sut.createPokemon(testData.copyWith(id: 5));
      await sut.createPokemon(testData.copyWith(id: 6));
      await sut.createPokemon(testData.copyWith(id: 7));
      await sut.createPokemon(testData.copyWith(id: 8));
      await sut.createPokemon(testData.copyWith(id: 9));
      await sut.createPokemon(testData.copyWith(id: 10));
      await sut.createPokemon(testData.copyWith(id: 11));

      CancellationToken cancellationToken = CancellationToken();
      var stream = sut.streamAllPokemon(cancellationToken: cancellationToken);
      List<PokemonDto> result = List.empty(growable: true);
      int i = 0;
      await for (final value in stream) {
        if (i == 7) {
          cancellationToken.cancel();
        }
        result.add(value);
        i++;
      }
      expect(result.length, greaterThanOrEqualTo(3));
      expect(result.length, lessThanOrEqualTo(10));
      // expect(result.any((element) => element == testData), isTrue);

      cancellationToken = CancellationToken();
      stream = sut.streamAllPokemon(cancellationToken: cancellationToken);
      result.clear();
      i = 0;
      await for (final value in stream) {
        if (i == 14) {
          cancellationToken.cancel();
        }
        result.add(value);
        i++;
      }
      expect(result.length, greaterThanOrEqualTo(10));
      // expect(result.any((element) => element == testData), isTrue);
    });
  });

  group("updatePokemon", () {
    test("test that a existing pokemon is updated", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto updateData =
          generatePokemonDto().copyWith(name: "Felix");
      await sut.createPokemon(generatePokemonDto());

      final result = await sut.updatePokemon(updateData);

      expect(result, updateData);
    });

    test("test that a not-existing pokemon isn't updated and returns null",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(pokemonRepositoryImplProvider.notifier);
      final PokemonDto updateData =
          generatePokemonDto().copyWith(name: "Felix");

      final result = await sut.updatePokemon(updateData);

      expect(result, isNull);
    });
  });
}
