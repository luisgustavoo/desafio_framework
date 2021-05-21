import 'package:desafio_framework/app/core/pokemon_colors.dart';
import 'package:desafio_framework/app/models/stats_model.dart';
import 'package:desafio_framework/app/models/types_model.dart';
import 'package:flutter/material.dart';

extension StringToColor on String {
  Color get parse {
    if (this is String) {
      if (this == 'black') {
        return PokemonColors.black;
      }
      if (this == 'blue') {
        return PokemonColors.blue;
      }
      if (this == 'brown') {
        return PokemonColors.brown;
      }
      if (this == 'gray') {
        return PokemonColors.gray;
      }
      if (this == 'green') {
        return PokemonColors.green;
      }
      if (this == 'pink') {
        return PokemonColors.pink;
      }
      if (this == 'purple') {
        return PokemonColors.purple;
      }
      if (this == 'red') {
        return PokemonColors.red;
      }
/*      if (this == 'black') {
        return PokemonColors.white;
      }*/
      if (this == 'yellow') {
        return PokemonColors.yellow;
      }
    }
    return Colors.white;

    /*
    switch (this) {
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
    */
  }
}

extension ColorToString on Color {
  String get parse {
    if (this is Color) {
      if (this == PokemonColors.black) {
        return 'black';
      }
      if (this == PokemonColors.blue) {
        return 'blue';
      }
      if (this == PokemonColors.brown) {
        return 'brown';
      }
      if (this == PokemonColors.gray) {
        return 'gray';
      }
      if (this == PokemonColors.green) {
        return 'green';
      }
      if (this == PokemonColors.pink) {
        return 'pink';
      }
      if (this == PokemonColors.purple) {
        return 'purple';
      }
      if (this == PokemonColors.red) {
        return 'red';
      }
      if (this == PokemonColors.white) {
        return 'black';
      }
      if (this == PokemonColors.yellow) {
        return 'yellow';
      }
    }

    return 'white';

/*    switch (this) {
      case PokemonColors.black:
        return 'black';
      case PokemonColors.blue:
        return 'blue';
      case PokemonColors.brown:
        return 'brown';
      case PokemonColors.gray:
        return 'gray';
      case PokemonColors.green:
        return 'green';
      case PokemonColors.pink:
        return 'pink';
      case PokemonColors.purple:
        return 'purple';
      case PokemonColors.red:
        return 'red';
      case PokemonColors.black:
        return 'white';//PokemonColors.white;
      case PokemonColors.yellow:
        return 'yellow';
      default:
        return 'white';
    }
    */
  }
}

class PokemonModel {
  PokemonModel(
      {required this.id,
      required this.name,
      required this.urlImage,
      required this.color,
      required this.stats,
      required this.type,
      this.isFavorite = false});

  factory PokemonModel.fromMap(Map<String, dynamic> map) {
    return PokemonModel(
        id: map['id'] as int,
        name: map['name'] as String,
        urlImage: map['urlImage'] as String,
        color: map['color'].toString().parse,
        stats:
            List<Map<String, dynamic>>.from(map['stats'] as Iterable<dynamic>)
                .map((s) => StatsModel.fromMap(s))
                .toList(),
        type: List<Map<String, dynamic>>.from(map['type'] as Iterable<dynamic>)
            .map((t) => TypesModel.fromMap(t))
            .toList(),
        isFavorite: map['isFavorite'] as bool);
  }

  late final int id;
  late final String name;
  late final String urlImage;
  late final Color color;
  late List<StatsModel> stats;
  late List<TypesModel> type;
  late bool isFavorite;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'urlImage': urlImage,
      'color': color.parse,
      'stats': stats.map((s) => s.toMap()).toList(),
      'type': type.map((t) => t.toMap()).toList(),
      'isFavorite': isFavorite
    };
  }

  @override
  String toString() {
    return 'Pokemon{id: $id, name: $name, urlImage: $urlImage, color: $color, stats: $stats, type: $type,, isFavorite: $isFavorite}';
  }
}
