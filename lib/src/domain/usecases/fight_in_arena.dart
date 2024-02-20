import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monkey_mon/src/core/utils/logger.dart';
import 'package:monkey_mon/src/domain/model/mon.dart';
import 'package:monkey_mon/src/domain/model/monkey_dto.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// final arenaFightProvider = Provider<ArenaFight>((ref) => ArenaFight());

part "fight_in_arena.g.dart";

@Riverpod(keepAlive: true)
class ArenaFight extends _$ArenaFight {
  Mon? fighter;
  Mon? opponent;

  final log = getLogger();

  /// First returning value is fighter and second returning value is opponent
  @override
  Stream<(Mon, Mon)> build(Duration? speed) async* {
    while (fighter == null || opponent == null) {
      log.d("Not all fighters are present");
      await Future.delayed(const Duration(seconds: 1));
    }

    while (!(fighter!.isDefeated || opponent!.isDefeated)) {
      if (opponent!.currentHp <= 0) {
        opponent = opponent!.copyWith(isDefeated: true, currentHp: 0);
      }

      if (fighter!.currentHp <= 0) {
        fighter = fighter!.copyWith(isDefeated: true, currentHp: 0);
      }
      fightOneRound(speed);

      log.d("Current fight status");
      log.d("Fighter: ${fighter!.currentHp} hp");
      log.d("Opponent: ${opponent!.currentHp} hp");
      yield (fighter!, opponent!);
      await Future.delayed(speed ?? const Duration(seconds: 1));
    }
  }

  void fightOneRound(Duration? speed) async {
    if (_fighterIsFaster()) {
      _fighterAttack();
      if (opponent!.isDefeated) {
        log.d("fighter won");
        return;
      }
      await Future.delayed(speed ?? Duration.zero);
      _opponentAttack();
    } else {
      _opponentAttack();
      if (fighter!.isDefeated) {
        log.d("opponent won");
        return;
      }
      await Future.delayed(speed ?? Duration.zero);
      _fighterAttack();
    }
  }

  void setFighter({PokemonDto? pokemonDto, MonkeyDto? monkeyDto}) {
    if ((pokemonDto != null && monkeyDto != null)) {
      throw ArgumentError(
          "Both pokemonDto and monkeyDto are given. Only specify one");
    }
    if ((pokemonDto == null) && (monkeyDto == null)) {
      throw ArgumentError(
          "Neither pokemonDto or monkeyDto are given. Specify one");
    }

    _invalidateItselfWhenNewOpponent();

    if (pokemonDto != null) {
      fighter = Mon<PokemonDto>(
        currentHp: pokemonDto.hp,
        mon: pokemonDto,
      );
    } else {
      fighter = Mon<MonkeyDto>(currentHp: monkeyDto!.hp, mon: monkeyDto);
    }

    log.d("Set fighter $fighter");
  }

  void setOpponent({PokemonDto? pokemonDto, MonkeyDto? monkeyDto}) {
    if ((pokemonDto != null && monkeyDto != null)) {
      throw ArgumentError(
          "Both pokemonDto and monkeyDto are given. Only specify one");
    }
    if ((pokemonDto == null) && (monkeyDto == null)) {
      throw ArgumentError(
          "Neither pokemonDto or monkeyDto are given. Specify one");
    }

    _invalidateItselfWhenNewOpponent();

    if (pokemonDto != null) {
      opponent = Mon<PokemonDto>(
        currentHp: pokemonDto.hp,
        mon: pokemonDto,
      );
    } else {
      opponent = Mon<MonkeyDto>(currentHp: monkeyDto!.hp, mon: monkeyDto);
    }

    log.d("Set opponent $opponent");
  }

  void reset() {
    fighter = null;
    opponent = null;
  }

  void _invalidateItselfWhenNewOpponent() {
    if (opponent != null && fighter != null) {
      ref.invalidateSelf();
    }
  }

  bool _fighterIsFaster() {
    if (fighter == null || opponent == null) {
      throw ArgumentError("Not both fighter and value are set");
    }

    if (fighter is PokemonDto) {
      if (opponent is PokemonDto) {
        return (fighter!.mon as PokemonDto).speed >=
            (opponent!.mon as PokemonDto).speed;
      } else {
        return (fighter!.mon as PokemonDto).speed >=
            (opponent!.mon as MonkeyDto).speed;
      }
    } else if (fighter is MonkeyDto) {
      if (opponent is PokemonDto) {
        return (fighter!.mon as MonkeyDto).speed >=
            (opponent!.mon as PokemonDto).speed;
      } else {
        return (fighter!.mon as MonkeyDto).speed >=
            (opponent!.mon as MonkeyDto).speed;
      }
    } else {
      return true;
    }
  }

  void _fighterAttack() {
    if (fighter == null || opponent == null) {
      throw ArgumentError("Not both fighter and value are set");
    }
    int hpToLose = 0;
    if (fighter!.mon is PokemonDto) {
      if (opponent!.mon is PokemonDto) {
        hpToLose = (fighter!.mon as PokemonDto).attack -
            (opponent!.mon as PokemonDto).defense;
      } else {
        hpToLose = (fighter!.mon as PokemonDto).attack -
            (opponent!.mon as MonkeyDto).defense;
      }
    } else {
      if (opponent!.mon is PokemonDto) {
        hpToLose = (fighter!.mon as MonkeyDto).attack -
            (opponent!.mon as PokemonDto).defense;
      } else {
        hpToLose = (fighter!.mon as MonkeyDto).attack -
            (opponent!.mon as MonkeyDto).defense;
      }
    }

    if (hpToLose <= 0) {
      hpToLose = 1;
    }

    opponent = opponent!.copyWith(currentHp: opponent!.currentHp - hpToLose);

    log.d("Fighter attacked and damaged $hpToLose hp");
  }

  void _opponentAttack() {
    if (fighter == null || opponent == null) {
      throw ArgumentError("Not both fighter and value are set");
    }
    int hpToLose = 0;
    if (opponent!.mon is PokemonDto) {
      if (fighter!.mon is PokemonDto) {
        hpToLose = (opponent!.mon as PokemonDto).attack -
            (fighter!.mon as PokemonDto).defense;
      } else {
        hpToLose = (opponent!.mon as PokemonDto).attack -
            (fighter!.mon as MonkeyDto).defense;
      }
    } else {
      if (fighter!.mon is PokemonDto) {
        hpToLose = (opponent!.mon as MonkeyDto).attack -
            (fighter!.mon as PokemonDto).defense;
      } else {
        hpToLose = (opponent!.mon as MonkeyDto).attack -
            (fighter!.mon as MonkeyDto).defense;
      }
    }

    if (hpToLose <= 0) {
      hpToLose = 1;
    }

    fighter = fighter!.copyWith(currentHp: fighter!.currentHp - hpToLose);

    log.d("Opponent attacked and damaged $hpToLose hp");
  }
}
