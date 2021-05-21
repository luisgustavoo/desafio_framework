import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/favorites/favorites_state.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._repository);

  final PokemonRepository _repository;

  FavoriteState state = FavoriteState.empty;

  List<PokemonModel> _favoriteList = <PokemonModel>[];

  List<PokemonModel> get favoriteList => _favoriteList;

  void toggleFavorite(PokemonModel pokemon) {
    if (pokemon.isFavorite) {
      _removeFavorites(pokemon);
    } else {
      _addFavorites(pokemon);
    }
  }

  Future<void> _addFavorites(PokemonModel pokemon) async {
    await _repository.addFavorites(pokemon);
    pokemon.isFavorite = true;
    notifyListeners();
  }

  Future<void> _removeFavorites(PokemonModel pokemon) async {
    await _repository.removeFavorites(pokemon);
    pokemon.isFavorite = false;
    _favoriteList.remove(pokemon);
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    try {
      state = FavoriteState.loading;
      _favoriteList = await _repository.fetchFavorites();
      state = FavoriteState.success;
    } on Exception catch (error) {
      print(error);
      state = FavoriteState.error;
      Exception('Erro ao buscar favoritos');
    } finally {
      notifyListeners();
    }
  }
}
