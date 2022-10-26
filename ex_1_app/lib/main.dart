import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(child: HomePage()),
  );
}

enum City {
  paris,
  london,
  abuja,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(milliseconds: 800),
    () =>
        {
          City.abuja: "🌧",
          City.london: "☁",
          City.paris: "❄",
        }[city] ??
        "🌞",
    //here we unwarp and make the key the city
  );
}

//stateProvider exposes a value that can be modified from outside
//currentCityProvider will be changed by the UI
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);

//FutureProvider An async Provider that return a single value in this instance a weather Emoji
//it return a future or the object specify in the generic
//UI only read this
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  //reads and listen to changes on the currentCityProvider
  final fetchedcity = ref.watch(currentCityProvider);
  if (fetchedcity != null) {
    return getWeather(fetchedcity);
  } else {
    return "😥";
  }
});

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //we watch for changes in weatherProvider and save them
    //currentWeather returns an async value since it is gotten from a futureprovidere
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Riverpod")),
      ),
      body: Column(children: [
        const SizedBox(
          height: 30,
        ),
        //currentWeather is an async value, hence is has when property
        //which can be use to set when the data arrives, error occur or loading
        currentWeather.when(
            data: (data) => Text(
                  data,
                  style: const TextStyle(fontSize: 30),
                ),
            error: (error, stackTrace) => Text(error.toString()),
            loading: () => const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )),

        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            final city = City.values[index];
            final isSelected = city == ref.watch(currentCityProvider);
            return ListTile(
              title: Text(city.toString()),
              trailing: isSelected ? const Icon(Icons.check) : null,
              onTap: () => ref.read(currentCityProvider.notifier).state = city,
            );
          },
          itemCount: City.values.length,
        ))
      ]),
    );
  }
}
