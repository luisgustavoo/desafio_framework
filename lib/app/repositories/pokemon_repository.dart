import 'package:desafio_framework/app/error/rest_exception.dart';
import 'package:desafio_framework/app/services/client_http.dart';
import 'package:desafio_framework/app/shared/pokemon_colors.dart';
import 'package:desafio_framework/app/models/pagination_filter.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/models/stats_model.dart';
import 'package:desafio_framework/app/models/types_model.dart';
import 'package:desafio_framework/app/repositories/local_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


class PokemonRepository {
  PokemonRepository(this.clientHttp, this._localStorage);

  final ClientHttp clientHttp;
  final _pokemonsList = <PokemonModel>[];
  final LocalStorage _localStorage;

  Future<List<PokemonModel>> fetchPokemons(PaginationFilter filter) async {
    try {
      late Color color;

      final response = await clientHttp.get('/pokemon',
          queryParameters: <String, dynamic>{
            'offset': filter.offset,
            'limit': filter.limit
          });

      if (response.isNotEmpty) {
        for (var i = 0; i < (response['results'] as List).length; i++) {
          final pokemonResponse =
              await clientHttp.get(response['results'][i]['url'].toString());

          if (pokemonResponse.isNotEmpty) {
            final pokemonData = pokemonResponse;

            final pokemonSpecieResponse =
                await clientHttp.get(pokemonData['species']['url'].toString());

            if (pokemonSpecieResponse.isNotEmpty) {
              color = _getColor(
                  pokemonSpecieResponse['color']['name'].toString());
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
    await _localStorage.addFavorites(pokemon);
    //await localStoragePlus.write(pokemon.id.toString(), jsonEncode(pokemon.toMap()));
  }

  Future<void> removeFavorites(PokemonModel pokemon) async {
    await _localStorage.removeFavorites(pokemon);
  }

  Future<List<PokemonModel>> fetchFavorites() async {
    return _localStorage.fetchFavorites();
  }

  Future<bool> _isFavorites(PokemonModel pokemon) async {
    return _localStorage.isFavorites(pokemon);
  }

  List<StatsModel> _getStatsModel(List<Map<String, dynamic>> stats) {
    return stats
        .map((stat) => StatsModel(
            name: stat['stat']['name'] as String,
            baseStats: stat['base_stat'] as int))
        .toList();
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
