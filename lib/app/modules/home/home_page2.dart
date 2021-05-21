import 'package:desafio_framework/app/modules/details/details_page.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:desafio_framework/app/modules/home/home_state.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:desafio_framework/app/shared/component/list_tile_pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          HomeController(context.read<PokemonRepository>())..fetchPokemon(),
      builder: (context, _) => const HomePage2Content(),
    );
  }
}

class HomePage2Content extends StatelessWidget {
  const HomePage2Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Consumer<HomeController>(
          builder: (context, controller, _) => _buildHomePage(controller),
        ));
  }

  PreferredSize _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(168),
      child: Material(
        elevation: 0.5,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: ContainerPlus(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 168,
          radius: RadiusPlus.bottom(20),
          child: Column(
            children: [
              const SizedBox(
                height: 52,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextPlus(
                    'Pokedéx',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  const Icon(Icons.favorite_border)
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              TextFieldPlus(
                radius: RadiusPlus.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                height: 48,
                backgroundColor: const Color(0xFFF6F6F6),
                enabled: true,
                placeholder: TextPlus(
                  'Search Pokemon',
                  color: const Color(0xFFCCCCCC),
                ),
                prefixWidget: const Icon(
                  Icons.search,
                  color: Color(0xFFCCCCCC),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(HomeController controller) {
    switch (controller.state) {
      case HomeState.loading:
        return const CircularProgressIndicator();
      case HomeState.error:
        return const Text('Erro oao listar pokemons');
      default:
        return _buildContent(controller);
    }
  }

  Widget _buildContent(HomeController controller) {
    return Column(
      children: [
        Expanded(
          child: LazyLoadScrollView(
            onEndOfPage: () => controller.nextPage(),
            isLoading: controller.lastPage,
            child: ListView.builder(
                padding: const EdgeInsets.all(24),
                physics: const BouncingScrollPhysics(),
                itemCount: controller.pokemonsList.length,
                itemBuilder: (context, index) {
                  final pokemon = controller.pokemonsList[index];

                  return ListTilePokemon(
                    pokemon,
                    onTapCard: () => Navigator.of(context)
                        .pushNamed(DetailsPage.routeName, arguments: pokemon),
                    onTapFavorite: () => controller.toggleFavorite(pokemon),
                  );

                  /*return ListTile(
                    title: Text(
                      pokemon.name,
                      style: TextStyle(color: pokemon.color),
                    ),
                    trailing: IconButton(
                      icon: pokemon.isFavorite
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : Icon(Icons.favorite_border),
                      onPressed: () => pokemon.isFavorite
                          ? controller.removeFavorites(pokemon)
                          : controller.addFavorites(pokemon),
                    ),
                  );*/
                }),
          ),
        ),
        Visibility(
            visible: controller.isLoadingNextPage,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: CircularProgressIndicator(),
            ))
      ],
    );
  }
}
