import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/home/favorites/favorites_state.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._repository, this._homeController);

  final PokemonRepository _repository;
  final HomeController _homeController;

  FavoriteState state = FavoriteState.idle;

  List<PokemonModel> _favoriteList = <PokemonModel>[];

  List<PokemonModel> get favoriteList => _favoriteList;


  Future<void>removeFavorites(PokemonModel pokemon) async {
    await _repository.removeFavorites(pokemon);
    _homeController.toggleFavorite(pokemon);
    _favoriteList.remove(pokemon);
    notifyListeners();
  }

  Future<void> fetchFavorites() async {
    try {
      state = FavoriteState.loading;
      _favoriteList = await _repository.fetchFavorites();
      state = FavoriteState.success;
    } on Exception catch (error) {
      state = FavoriteState.error;
      Exception('Erro ao buscar favoritos $error');
    } finally {
      notifyListeners();
    }
  }
}
