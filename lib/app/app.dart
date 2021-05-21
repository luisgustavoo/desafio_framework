import 'package:desafio_framework/app/core/dio/custom_dio.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/favorites/favorites_controller.dart';
import 'package:desafio_framework/app/modules/favorites/favorites_page.dart';
import 'package:desafio_framework/app/modules/home/details/details_controller.dart';
import 'package:desafio_framework/app/modules/home/details/details_page.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:desafio_framework/app/modules/home/home_page.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => PokemonRepository(CustomDio.instance))
      ],
      child: FlutterAppPlus(
        title: 'Flutter Pokédex',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: const Color(0xFFFCFCFC)),
        initialRoute: '/',
        routes: {
          HomePage.routeName: (_) => ChangeNotifierProvider(
                create: (context) =>
                    HomeController(context.read<PokemonRepository>())
                      ..fetchPokemon(),
                builder: (context, _) => HomePage(
                  controller: context.read<HomeController>(),
                ),
              ),
          DetailsPage.routeName: (_) => ChangeNotifierProvider(
                create: (context) =>
                    DetailsController(context.read<PokemonRepository>()),
                builder: (context, _) {
                  final pokemonModel = ModalRoute.of(context)!
                      .settings
                      .arguments! as PokemonModel;
                  return DetailsPage(
                    controller: context.read<DetailsController>(),
                    pokemonModel: pokemonModel,
                  );
                },
              ),
          FavoritesPage.routeName: (_) => ChangeNotifierProvider(
                create: (context) =>
                    FavoritesController(context.read<PokemonRepository>())
                      ..fetchFavorites(),
                builder: (context, _) => const FavoritesPage(),
              )
        },
      ),
    );
  }
}
