import 'package:desafio_framework/app/models/pagination_filter.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/home/home_state.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._repository);

  final PokemonRepository _repository;
  HomeState _state = HomeState.idle;
  var _pokemonsList = <PokemonModel>[];
  var _pokemonsListOrigin = <PokemonModel>[];
  var _lastPage = false;
  bool isLoadingNextPage = false;
  final _paginationFilter = PaginationFilter(offset: 0, limit: 20);

  HomeState get state => _state;

  List<PokemonModel> get pokemonsList => _pokemonsList;

  bool get lastPage => _lastPage;

  HomeState set(HomeState state) => _state = state;

  Future<List<PokemonModel>> fetchPokemon() async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      _pokemonsList = await _repository.fetchPokemons(_paginationFilter);
      _pokemonsListOrigin = _pokemonsList;

      if (_pokemonsList.isEmpty) {
        _lastPage = true;
      }
      _state = HomeState.success;
    } on Exception catch (error) {
      print(error);
      _state = HomeState.error;
    } finally {
      notifyListeners();
    }
    return _pokemonsList;
  }

  void filterPokemon(String text) {
    _pokemonsList = _pokemonsListOrigin;

    final filteredList = _pokemonsList.where(
        (pokemon) => pokemon.name.toUpperCase().contains(text.toUpperCase()));
    _pokemonsList = List<PokemonModel>.from(filteredList);
    notifyListeners();
  }

  void toggleFavorite(PokemonModel pokemon) {
    if (pokemon.isFavorite) {
      _removeFavorites(pokemon);
    } else {
      _addFavorites(pokemon);
    }
  }

  Future<void> _addFavorites(PokemonModel pokemon) async {
    pokemon.isFavorite = true;
    _pokemonsList[_pokemonsList
        .indexWhere((element) => element.id == pokemon.id)] = pokemon;
    await _repository.addFavorites(pokemon);
    notifyListeners();
  }

  Future<void> _removeFavorites(PokemonModel pokemon) async {
    pokemon.isFavorite = false;
    _pokemonsList[_pokemonsList
        .indexWhere((element) => element.id == pokemon.id)] = pokemon;
    await _repository.removeFavorites(pokemon);
    notifyListeners();
  }

  Future<List<PokemonModel>> fetchFavorites() async {
    return _repository.fetchFavorites();
  }

  void _changePaginationFilter(int offset, int limit) {
    _paginationFilter
      ..offset = offset
      ..limit = limit;
  }

  Future<void> nextPage() async {
    _changePaginationFilter(_paginationFilter.offset + 20, 20);

    isLoadingNextPage = true;
    notifyListeners();

    _pokemonsList = await _repository.fetchPokemons(_paginationFilter);

    isLoadingNextPage = false;
    notifyListeners();
  }
}
