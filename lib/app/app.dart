import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/modules/home/details/details_page.dart';
import 'package:desafio_framework/app/modules/home/favorites/favorites_controller.dart';
import 'package:desafio_framework/app/modules/home/favorites/favorites_page.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:desafio_framework/app/modules/home/home_page.dart';
import 'package:desafio_framework/app/repositories/pokemon_repository.dart';
import 'package:desafio_framework/app/repositories/local_storage.dart';
import 'package:desafio_framework/app/services/client_http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ClientHttp()),
        Provider(create: (_) => LocalStorage()),
        Provider(create: (context) => PokemonRepository(context.read<ClientHttp>(), context.read<LocalStorage>())),
        ChangeNotifierProvider(
            create: (context) =>
                HomeController(context.read<PokemonRepository>())),
        ChangeNotifierProvider(
            create: (context) => FavoritesController(
                context.read<PokemonRepository>(),
                context.read<HomeController>())),
      ],
      child: FlutterAppPlus(
        title: 'Flutter Pokédex',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: const Color(0xFFFCFCFC)),
        initialRoute: '/',
        routes: {
          HomePage.routeName: (context) {
            //context.read<HomeController>().fetchPokemon();
            return HomePage(context.read<HomeController>());
          },
          DetailsPage.routeName: (context) {
            final pokemonModel =
            ModalRoute.of(context)!.settings.arguments! as PokemonModel;
            return DetailsPage(
              pokemonModel: pokemonModel,
            );
          },
          FavoritesPage.routeName: (context) {
            context.read<FavoritesController>().fetchFavorites();
            return const FavoritesPage();
          }
        },
      ),
    );
  }
}