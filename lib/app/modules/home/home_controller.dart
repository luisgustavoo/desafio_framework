import 'package:desafio_framework/app/models/pagination_filter.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/home/home_state.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/foundation.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._repository);

  final PokemonRepository _repository;
  HomeState _state = HomeState.empty;
  var _pokemonsList = <PokemonModel>[];
  var _pokemonsListOrigem = <PokemonModel>[];
  var _lastPage = false;
  bool isLoadingNextPage = false;
  final _paginationFilter = PaginationFilter(offset: 0, limit: 20);

  HomeState get state => _state;

  List<PokemonModel> get pokemonsList => _pokemonsList;

  set pokemonsList(List<PokemonModel> value) => _pokemonsList = value;

  bool get lastPage => _lastPage;

  HomeState set(HomeState state) => _state = state;

  Future<List<PokemonModel>> fetchPokemon() async {
    _state = HomeState.loading;
    notifyListeners();

    try {
      _pokemonsList = await _repository.fetchPokemons(_paginationFilter);
      _pokemonsListOrigem = _pokemonsList;

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
    pokemonsList = _pokemonsListOrigem;

    final filteredList = pokemonsList.where(
        (pokemon) => pokemon.name.toUpperCase().contains(text.toUpperCase()));
    pokemonsList = List<PokemonModel>.from(filteredList);
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
    await _repository.addFavorites(pokemon);
    pokemon.isFavorite = true;
    notifyListeners();
  }

  Future<void> _removeFavorites(PokemonModel pokemon) async {
    await _repository.removeFavorites(pokemon);
    pokemon.isFavorite = false;
    notifyListeners();
  }

/*  Future<bool> isFavorites(PokemonModel pokemon) async {
    return _repository.isFavorites(pokemon);
  }*/

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
    print(_paginationFilter);

    isLoadingNextPage = true;
    notifyListeners();

    _pokemonsList = await _repository.fetchPokemons(_paginationFilter);

    isLoadingNextPage = false;
    notifyListeners();
  }
}
