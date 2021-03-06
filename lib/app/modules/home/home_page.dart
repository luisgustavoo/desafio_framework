import 'package:desafio_framework/app/modules/home/details/details_page.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:desafio_framework/app/modules/home/home_state.dart';
import 'package:desafio_framework/app/shared/component/list_tile_pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  const HomePage(this.controller);

  static const routeName = '/';

  final HomeController controller;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _filterController = TextEditingController();


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      widget.controller.fetchPokemon();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _filterController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
        builder: (context, controller, _) => Scaffold(
            appBar: _buildAppBar(context, controller),
            body: Center(child: _buildHomePage(controller))));
  }

  PreferredSize _buildAppBar(BuildContext context, HomeController controller) {
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
                    'Poked??x',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    splashRadius: 20,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    onPressed: () =>
                        Navigator.of(context).pushNamed('favorites'),
                  ),
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
                onChanged: controller.filterPokemon,
                controller: _filterController,
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
