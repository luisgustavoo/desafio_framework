import 'package:cached_network_image/cached_network_image.dart';
import 'package:desafio_framework/app/models/pokemon_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plus/flutter_plus.dart';

class ListTilePokemon extends StatefulWidget {
  const ListTilePokemon(this.pokemonModel,
      {required this.onTapFavorite, required this.onTapCard, Key? key})
      : super(key: key);

  final PokemonModel pokemonModel;
  final VoidCallback onTapFavorite;
  final VoidCallback onTapCard;

  @override
  _ListTilePokemonState createState() => _ListTilePokemonState();
}

class _ListTilePokemonState extends State<ListTilePokemon> {
  @override
  Widget build(BuildContext context) {
    return ContainerPlus(
      onTap: widget.onTapCard,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      height: 85,
      radius: RadiusPlus.all(20),
      color: widget.pokemonModel.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextPlus(
                '#${widget.pokemonModel.id.toString().padLeft(3, '0')}',
                fontSize: 10,
                color: Colors.white,
              ),
              TextPlus(
                widget.pokemonModel.name,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildContentType(widget.pokemonModel),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'pokemonImage${widget.pokemonModel.id}',
                child: CachedNetworkImage(
                  //placeholder: (context, url) => kTransparentImage,
                  imageUrl: widget.pokemonModel.urlImage,
                  //errorWidget: (context, url, error) => Container(),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              _getFavoriteIcon(widget.pokemonModel),
            ],
          ),
        ],
      ),
    );
  }

  IconButton _getFavoriteIcon(PokemonModel pokemonModel) {

    return IconButton(
      padding: EdgeInsets.zero,
      splashRadius: 20,
      icon: pokemonModel.isFavorite
          ? const Icon(
              Icons.favorite,
              color: Colors.white,
            )
          : const Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
      iconSize: 13,
      onPressed: widget.onTapFavorite,
    );
  }

  List<Widget> _buildContentType(PokemonModel pokemonModel) {
    final list = <Widget>[];

    for (var i = 0; i < pokemonModel.type.length; i++) {

      if( (i % 2) != 0){
        list.add(const SizedBox(
          width: 4,
        ));
      }
      list.add(ContainerPlus(
        radius: RadiusPlus.all(20),
        color: Colors.white.withOpacity(0.3),
        border: BorderPlus(width: 0.5, color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: TextPlus(
          pokemonModel.type[i].name,
          fontSize: 10,
          color: Colors.white,
        ),
      ));
    }

    return list;

  }

}
