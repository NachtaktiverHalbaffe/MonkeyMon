import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/model/pokemon_dto.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "load_pokemons.g.dart";

@Riverpod(keepAlive: true)
class LoadPokemons extends _$LoadPokemons {
  @override
  Stream<PokemonDto> build({CancellationToken? cancellationToken}) async* {
    PokemonRepository repository =
        ref.read(pokemonRepositoryImplProvider.notifier);
    ref.onDispose(() {
      if (cancellationToken != null) {
        cancellationToken.cancel();
      }
    });

    yield* repository.streamAllPokemon(cancellationToken: cancellationToken);
  }
}
