import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

class DetailsController extends ChangeNotifier {
  DetailsController(this._repository);

  final PokemonRepository _repository;

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
    notifyListeners();
  }
}
