import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });

  Film copy({
    required bool isFav,
  }) =>
      Film(id: id, title: title, description: description, isFavorite: isFav);

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([id, isFavorite]);
}

final allFilms = [
  Film(
    id: '1',
    title: 'Game of Heaven',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'Movie X',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'Downfall',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'Upon the sea',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
  Film(
    id: '5',
    title: 'Mason ride',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
  Film(
    id: '6',
    title: 'What the F**',
    description: 'secred movie of all time ',
    isFavorite: false,
  ),
];
