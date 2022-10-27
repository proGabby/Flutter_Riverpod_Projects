import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(
    //riverpod need a providerscope at root of application
    const ProviderScope(
      child: HomePage(),
    ),
  );
}

const names = [
  "Abigail",
  "George",
  "Bassey",
  "John",
  "Micheal",
  "Eden",
  "Lois",
  "Silver"
];

class Reset extends StateNotifier<bool> {
  Reset() : super(false);

  void resetState() {
    state = !state;
  }
}

final resetProvider = StateNotifierProvider<Reset, bool>((ref) => Reset());
//produces a stream value every seconds
final tickerProvider = StreamProvider((ref) {
  final _isReset = ref.watch(resetProvider);
  return _isReset
      ? Stream.periodic(
          Duration(seconds: 1),
          (num) => num + 1,
        )
      : Stream.periodic(
          Duration(seconds: 1),
          (num) => num + 1,
        );
});

//produces a iterable of names ranging from the index 0 to num provider by tickerprovider
//if tickprovider produces a num that is not an index of names, it will throw an error
final nameProvider = StreamProvider((ref) {
  //read and listen to the tickerProvider value
  final tickstream = ref.watch(tickerProvider.stream);
  //.map transforms each element of this stream into a new stream event.
  //produce range of value of name eg [ nameA, nameB] or [nameA, nameB, nameC, nameD] yields depending the result of tickerprovider
  return tickstream.map((event) => names.getRange(0, event));
});

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MainPage(),
    );
  }
}

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watching the nameProvider for values and update
    final names = ref.watch(nameProvider);
    final resetter = ref.read(resetProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                resetter.resetState();
              },
              child: const Text("restart"))
        ],
        title: const Center(
          child: Center(child: Text("Stream Provider")),
        ),
      ),
      body: names.when(
        // since names is an async value, we can use the .when property
        data: (names) {
          return ListView.builder(
              itemCount: names.length,
              itemBuilder: (context, index) => ListTile(
                    title: Text(
                      names.elementAt(index),
                    ),
                  ));
        },
        error: (error, stackTrace) => const Center(child: Text("Done Listing")),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
