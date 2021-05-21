import 'dart:convert';
import 'package:desafio_framework/app/core/pokemon_colors.dart';
import 'package:desafio_framework/app/exceptions/rest_exception.dart';
import 'package:desafio_framework/app/models/pagination_filter.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/models/stats_model.dart';
import 'package:desafio_framework/app/models/types_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:shared_preferences/shared_preferences.dart';

class PokemonRepository {
  PokemonRepository(this._dio);

  final Dio _dio;
  final _pokemonsList = <PokemonModel>[];

  Future<List<PokemonModel>> fetchPokemons(PaginationFilter filter) async {
    try {
      late Color color;

      final response = await _dio.get<Map<String, dynamic>>('/pokemon',
          queryParameters: <String, dynamic>{
            'offset': filter.offset,
            'limit': filter.limit
          });

      if ((response.data ?? <String, dynamic>{}).isNotEmpty) {
        for (var i = 0; i < (response.data!['results'] as List).length; i++) {
          final pokemonResponse = await _dio.get<Map<String, dynamic>>(
              response.data!['results'][i]['url'].toString());

          if ((pokemonResponse.data ?? <String, dynamic>{}).isNotEmpty) {
            final pokemonData = pokemonResponse.data!;

            final pokemonSpecieResponse = await _dio.get<Map<String, dynamic>>(
                pokemonData['species']['url'].toString());

            if ((pokemonSpecieResponse.data ?? <String, dynamic>{})
                .isNotEmpty) {
              color = _getColor(
                  pokemonSpecieResponse.data!['color']['name'].toString());
            }

            final statsModelList = _getStatsModel(
                List<Map<String, dynamic>>.from(
                    pokemonData['stats'] as Iterable<dynamic>));

            final typesModelList = List<Map<String, dynamic>>.from(
                    pokemonData['types'] as Iterable)
                .map((type) => TypesModel(
                    slot: type['slot'] as int,
                    name: type['type']['name'] as String))
                .toList();

            final pokemonModel = PokemonModel(
                id: pokemonData['id'] as int,
                name: pokemonData['name'] as String,
                urlImage: dotenv.env['urlImage']
                    .toString()
                    .replaceAll('{id}', pokemonData['id'].toString()),
                color: color,
                stats: statsModelList,
                type: typesModelList);

            pokemonModel.isFavorite = await _isFavorites(pokemonModel);

            _pokemonsList.add(pokemonModel);
          }
        }
      }
    } on DioError catch (error) {
      print(error);
      throw RestException(error.message);
    } on Exception {
      rethrow;
    }

    return _pokemonsList;
  }

  Future<void> addFavorites(PokemonModel pokemon) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      pokemon.isFavorite = true;
      print(pokemon.toMap());
      await prefs.setString(
          pokemon.id.toString(), json.encode(pokemon.toMap()));

    } on Exception catch (error) {
      print(error);
      rethrow;
    }
    //await localStoragePlus.write(pokemon.id.toString(), jsonEncode(pokemon.toMap()));
  }

  Future<void> removeFavorites(PokemonModel pokemon) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      pokemon.isFavorite = false;
      await prefs.remove(pokemon.id.toString());
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<PokemonModel>> fetchFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return prefs.getKeys().map((key) {
        return PokemonModel.fromMap(
            jsonDecode(prefs.getString(key) ?? '') as Map<String, dynamic>);
      }).toList();
    } on Exception catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<bool> _isFavorites(PokemonModel pokemon) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(pokemon.id.toString());
    //return await localStoragePlus.containsKey(pokemon.id.toString());
  }

  List<StatsModel> _getStatsModel(List<Map<String, dynamic>> stats) {
    return stats
        .map((stat) => StatsModel(
            name: stat['stat']['name'] as String,
            baseStats: stat['base_stat'] as int))
        .toList();

/*    return List<Map<String, dynamic>>.from(stats)
        .map((stat) => StatsModel(
            name: stat['stat']['name'] as String,
            baseStats: stat['base_stat'] as int))
        .toList();*/
  }

  Color _getColor(String color) {
    switch (color) {
      case 'black':
        return PokemonColors.black;
      case 'blue':
        return PokemonColors.blue;
      case 'brown':
        return PokemonColors.brown;
      case 'gray':
        return PokemonColors.gray;
      case 'green':
        return PokemonColors.green;
      case 'pink':
        return PokemonColors.pink;
      case 'purple':
        return PokemonColors.purple;
      case 'red':
        return PokemonColors.red;
      case 'white':
        return PokemonColors.black; //PokemonColors.white;
      case 'yellow':
        return PokemonColors.yellow;
      default:
        return PokemonColors.white;
    }
  }
}
