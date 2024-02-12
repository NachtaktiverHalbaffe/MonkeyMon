import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monkey_mon/src/core/utils/internet_connection_checker.dart';
import 'package:monkey_mon/src/data/datasources/app_database.dart';
import 'package:monkey_mon/src/data/repository/monkey_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/species_dto.dart';

import '../../riverpod_textcontainer.dart';
import '../test_data.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late AppDatabase mockAppDatabase;
  late MockInternetChecker mockInternetChecker;

  late MonkeyRepositoryImpl sut;

  setUp(() {
    mockAppDatabase = AppDatabase(testingEngine: NativeDatabase.memory());
    mockInternetChecker = MockInternetChecker();
  });

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });

  tearDown(() async {
    await mockAppDatabase.close();
  });

  group("createMonkey", () {
    test("Dto is created without species data", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();
      final MonkeyDto expectedResult = generateMonkeyDto();

      final result = await sut.createMonkey(monkeyDto: testData);
      expect(result, expectedResult);
    });

    test('Dto is created with species data', () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testDataMonkey = generateMonkeyDto();
      final SpeciesDto testDataSpecies = generateSpeciesDto();
      final MonkeyDto expectedResult = generateMonkeyDtoWithSpeciesData();

      final result = await sut.createMonkey(
          monkeyDto: testDataMonkey, speciesDto: testDataSpecies);
      expect(result!.id, expectedResult.id);
      expect(result.species, expectedResult.species);
    });

    test('Dto without species data isnt created because entity already exists',
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();
      final MonkeyDto expectedResult = generateMonkeyDto();

      final result = await sut.createMonkey(monkeyDto: testData);
      expect(result, expectedResult);

      final result2 = await sut.createMonkey(monkeyDto: testData);
      expect(result2, null);
    });

    test('Dto with species data isnt created because entity already exists',
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testDataMonkey = generateMonkeyDto();
      final SpeciesDto testDataSpecies = generateSpeciesDto();
      final MonkeyDto expectedResult = generateMonkeyDtoWithSpeciesData();

      final result = await sut.createMonkey(
          monkeyDto: testDataMonkey, speciesDto: testDataSpecies);
      expect(result!.id, expectedResult.id);
      expect(result.species, expectedResult.species);
      final result2 = await sut.createMonkey(
          monkeyDto: testDataMonkey, speciesDto: testDataSpecies);
      expect(result2, null);
    });
  });

  group("deleteMonkey", () {
    test("Monkey that exists is deleted and returns true", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();

      await sut.createMonkey(monkeyDto: testData);
      final result = await sut.deleteMonkey(testData.id);
      final MonkeyDto? checkResult = await sut.getMonkey(testData.id);
      expect(checkResult, isNull);

      expect(result, true);
    });

    test("Monkey that doesn't exists isnt deleted returns false", () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();

      final result = await sut.deleteMonkey(testData.id);
      final MonkeyDto? checkResult = await sut.getMonkey(testData.id);

      expect(result, false);
      expect(checkResult, isNull);
    });
  });

  group("getMonkey", () {
    test('A monkey that exists is returned', () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();

      await sut.createMonkey(monkeyDto: testData);
      final MonkeyDto? result = await sut.getMonkey(testData.id);

      expect(result, testData);
    });

    test('A monkey that doesnt exists returns null', () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker)
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();

      final MonkeyDto? result = await sut.getMonkey(testData.id);

      expect(result, isNull);
    });

    test(
        'When a monkey doesnt exist, a monkey is pulled from a REST-API when connected to the internet',
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker)
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();

      // TODO mock rest api

      final MonkeyDto? result = await sut.getMonkey(testData.id);

      expect(result, isNull);
    });
  });

  group("getAllMonkeys", () {
    test(
        'Empty list is returned when no entries are stored inside db and when theres no internet connection',
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(false));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker)
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);

      final List<MonkeyDto> result = await sut.getAllMonkeys();

      expect(result.length, 0);
    });

    test('List of entries is returned when db has data', () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker)
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto();
      await sut.createMonkey(monkeyDto: testData);
      await sut.createMonkey(monkeyDto: testData.copyWith(id: 3));
      await sut.createMonkey(monkeyDto: testData.copyWith(id: 5));

      final List<MonkeyDto> result = await sut.getAllMonkeys();

      expect(result.length, 3);
      expect(result[0], testData);
      expect(result[1], testData.copyWith(id: 3));
      expect(result[2], testData.copyWith(id: 5));
    });

    test(
        """When there are no entries in the db and theres a internet connection,
         it calls an REST-API to fetch data and returns this as list""",
        () async {
      when(() => mockInternetChecker.isConnected())
          .thenAnswer((_) => Future.value(true));
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
        internetConnectionCheckerProvider
            .overrideWith(() => mockInternetChecker)
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);

      final List<MonkeyDto> result = await sut.getAllMonkeys();

      expect(result.length, 0);
    });
  });

  group("updateMonkey", () {
    test(
        'A monkey that exists is updated and then returned (all without species information)',
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData = generateMonkeyDto().copyWith(name: "Felix");

      await sut.createMonkey(monkeyDto: generateMonkeyDto());
      final MonkeyDto? result = await sut.updateMonkey(monkeyDto: testData);

      expect(result, testData);
    });

    test(
        """A monkey that doesnt exists is not updated and returns null (all without species information)""",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData =
          generateMonkeyDto().copyWith(name: "Felix", id: 5);

      final MonkeyDto? result = await sut.updateMonkey(monkeyDto: testData);

      expect(result, isNull);
    });

    test(
        'A monkey that exists is updated and then returned (all with species information)',
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testDataMonkey =
          generateMonkeyDto().copyWith(name: "Felix");
      final SpeciesDto testDataSpecies = generateSpeciesDto();
      final expectedResult = testDataMonkey.copyWith(species: testDataSpecies);

      await sut.createMonkey(
          monkeyDto: generateMonkeyDto(), speciesDto: testDataSpecies);
      final MonkeyDto? result = await sut.updateMonkey(
          monkeyDto: testDataMonkey, speciesDto: testDataSpecies);

      expect(result, expectedResult);
    });

    test(
        """A monkey that doesnt exists is not updated and returns null (all with species information)""",
        () async {
      final testContainer = createContainer(overrides: [
        databaseProvider.overrideWith((ref) => mockAppDatabase),
      ]);
      sut = testContainer.read(monkeyRepositoryImplProvider.notifier);
      final MonkeyDto testData =
          generateMonkeyDto().copyWith(name: "Felix", id: 5);
      final SpeciesDto testDataSpecies = generateSpeciesDto();

      final MonkeyDto? result = await sut.updateMonkey(
          monkeyDto: testData, speciesDto: testDataSpecies);

      expect(result, isNull);
    });
  });
}
