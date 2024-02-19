import 'package:cancellation_token/cancellation_token.dart';
import 'package:monkey_mon/src/data/repository/pokemon_repository_impl.dart';
import 'package:monkey_mon/src/domain/repository/pokemon_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "pokemon_needs_remote_fetching.g.dart";

@Riverpod(keepAlive: true)
class PokemonNeedsRemoteFetching extends _$PokemonNeedsRemoteFetching {
  @override
  Future<bool> build() async {
    PokemonRepository repository =
        ref.read(pokemonRepositoryImplProvider.notifier);

    var (needsFetching, _) = await repository.computeOffset();
    return needsFetching;
  }
}
