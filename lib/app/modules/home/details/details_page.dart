import 'package:cached_network_image/cached_network_image.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:desafio_framework/app/models/stats_model.dart';
import 'package:desafio_framework/app/modules/home/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_plus/flutter_plus.dart';
import 'package:provider/provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({required this.pokemonModel, Key? key}) : super(key: key);

  static const routeName = 'details';

  final PokemonModel pokemonModel;

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      backgroundColor: widget.pokemonModel.color,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
              tag: 'pokemonImage${widget.pokemonModel.id}',
              child: CachedNetworkImage(
                imageUrl: widget.pokemonModel.urlImage,
                height: 200,
                width: 200,
              )),
          const SizedBox(
            height: 24,
          ),
          TextPlus(
            widget.pokemonModel.name,
            color: Colors.white,
            textAlign: TextAlign.center,
            fontSize: 36,
            fontWeight: FontWeight.w900,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildContentType(widget.pokemonModel),
          )
        ],
      ),
      bottomNavigationBar: ContainerPlus(
        height: 280,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        radius: RadiusPlus.only(topLeft: 20, topRight: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextPlus(
                'Status',
                textDecorationPlus: TextDecorationPlus(
                  textDecoration: TextDecoration.underline,
                ),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              ...widget.pokemonModel.stats.map(_buildContentStats).toList(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContentType(PokemonModel pokemonModel) {
    final list = <Widget>[];

    for (var i = 0; i < pokemonModel.type.length; i++) {
      if ((i / 2) != 0) {
        list.add(const SizedBox(
          width: 10,
        ));
      }
      list.add(ContainerPlus(
        radius: RadiusPlus.all(20),
        color: Colors.white.withOpacity(0.3),
        border: BorderPlus(width: 0.5, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: TextPlus(
          pokemonModel.type[i].name,
          fontSize: 16,
          color: Colors.white,
        ),
      ));
    }

    return list;
  }

  Widget _buildContentStats(StatsModel stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: TextPlus(
            stats.name.toUpperCase(),
            fontSize: 16,
            fontWeight: FontWeight.w300,
            color: const Color(0xFF4A4A4A),
          ),
        ),
        Expanded(
          child: TextPlus(
            stats.baseStats.toString(),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          flex: 3,
          child: _buildProgressBaseStats(stats.baseStats),
        ),
      ],
    );
  }

  Widget _buildProgressBaseStats(int baseStats) {
    return ContainerPlus(
      height: 10,
      radius: RadiusPlus.all(20),
      child: LinearProgressIndicator(
        color: _getProgressColor(baseStats / 100),
        value: baseStats / 100,
        backgroundColor: const Color(0xFFF6F6F6),
      ),
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.5) {
      return const Color(0xFFFB6C6C);
    }

    if (value < 0.8) {
      return const Color(0xFFFBED6C);
    }
    return Colors.green.shade300;
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Consumer<HomeController>(builder: (context, controller, _) {
                return IconButton(
                    onPressed: () =>
                        controller.toggleFavorite(widget.pokemonModel),
                    icon: widget.pokemonModel.isFavorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                          ));
              })
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }
}
