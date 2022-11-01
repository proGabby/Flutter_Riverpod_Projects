import 'package:favourited_list_app_wth_statenotifier_provider/file_model.dart';
import 'package:favourited_list_app_wth_statenotifier_provider/notifier.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.all,
);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const Center(child: Text("StateNotifierProvider"))),
        body: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Center(
            child: Column(
              children: [
                const FilterWidget(),
                Consumer(builder: (context, ref, child) {
                  final filter = ref.watch(favoriteStatusProvider);
                  switch (filter) {
                    case FavoriteStatus.all:
                      return FilmList(
                        provider: allFilmProvider,
                      );
                    case FavoriteStatus.favorite:
                      return FilmList(
                        provider: favoriteFilmProvider,
                      );
                    case FavoriteStatus.notFavorite:
                      return FilmList(
                        provider: notFavoriteFilmProvider,
                      );
                  }
                })
              ],
            ),
          ),
        ));
  }
}

class FilmList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;
  const FilmList({required this.provider, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            final film = films.elementAt(index);
            final favIcon = film.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border);

            return ListTile(
                title: Text(film.title),
                subtitle: Text(film.description),
                trailing: IconButton(
                    icon: favIcon,
                    onPressed: () {
                      final isFav = !film.isFavorite;
                      ref
                          .read(allFilmProvider.notifier)
                          .updateFilm(film, isFav);
                    }));
          }),
    );
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return DropdownButton(
          value: ref.watch(favoriteStatusProvider),
          items: FavoriteStatus.values
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item.toString().split('.').last,
                  ),
                ),
              )
              .toList(),
          onChanged: (FavoriteStatus? value) {
            ref.read(favoriteStatusProvider.state).state = value!;
          },
        );
      },
    );
  }
}
