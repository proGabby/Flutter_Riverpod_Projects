import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'file_model.dart';

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

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void updateFilm(Film film, bool isFavorite) {
    state = state
        .map((currentFilm) => currentFilm.id == film.id
            ? currentFilm.copy(isFav: isFavorite)
            : currentFilm)
        .toList();
  }
}

final allFilmProvider = StateNotifierProvider<FilmsNotifier, List<Film>>((ref) {
  return FilmsNotifier();
});

final favoriteFilmProvider = Provider(
    (ref) => ref.watch(allFilmProvider).where((film) => film.isFavorite));

final notFavoriteFilmProvider = Provider(
    (ref) => ref.watch(allFilmProvider).where((film) => !film.isFavorite));
