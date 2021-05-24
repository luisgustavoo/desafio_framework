import 'dart:convert';

import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage() {
    SharedPreferences.getInstance().then((instance) => _prefs = instance);
  }

  late SharedPreferences _prefs;

  Future<void> addFavorites(PokemonModel pokemon) async {
    try {
      await _prefs.setString(
          pokemon.id.toString(), json.encode(pokemon.toMap()));
    } on Exception catch (error) {
      print(error);
      rethrow;
    }
    //await localStoragePlus.write(pokemon.id.toString(), jsonEncode(pokemon.toMap()));
  }

  Future<void> removeFavorites(PokemonModel pokemon) async {
    try {
      await _prefs.remove(pokemon.id.toString());
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<PokemonModel>> fetchFavorites() async {
    try {
      return _prefs.getKeys().map((key) {
        return PokemonModel.fromMap(
            jsonDecode(_prefs.getString(key) ?? '') as Map<String, dynamic>);
      }).toList();
    } on Exception catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<bool> isFavorites(PokemonModel pokemon) async {
    return _prefs.containsKey(pokemon.id.toString());
    //return await localStoragePlus.containsKey(pokemon.id.toString());
  }
}
