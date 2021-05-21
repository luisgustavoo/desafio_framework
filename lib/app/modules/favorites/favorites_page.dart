import 'package:desafio_framework/app/modules/favorites/favorites_controller.dart';
import 'package:desafio_framework/app/modules/favorites/favorites_state.dart';
import 'package:desafio_framework/app/shared/component/list_tile_pokemon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  static const routeName = 'favorites';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Consumer<FavoritesController>(
                builder: (context, controller, _) =>
                    _buildFavoritePage(controller)),
          )),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close)),
            const Spacer(),
            TextPlus(
              'Favoritos',
              fontSize: 24,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
            const Spacer()
          ],
        )));
  }

  Widget _buildFavoritePage(FavoritesController controller) {
    switch (controller.state) {
      case FavoriteState.loading:
        return const CircularProgressIndicator();
      case FavoriteState.error:
        return const Text('Erro oao listar pokemons');
      default:
        return _buildContent(controller);
    }
  }

  Widget _buildContent(FavoritesController controller) {
    if (controller.favoriteList.isEmpty) {
      return Center(
        child: TextPlus('Você não tem nenhum pokemon favorito'),
      );
    }

    return ListView.builder(
      itemBuilder: (context, index) => ListTilePokemon(
          controller.favoriteList[index],
          onTapFavorite: () =>
              controller.toggleFavorite(controller.favoriteList[index]),
          onTapCard: () {}),
      itemCount: controller.favoriteList.length,
    );
  }
}
