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

final CurrentDate = Provider(
  (ref) => DateTime.now(),
  //here provider does not observe changes
);

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //ref watches for changes and rebuild widget
    final currentDate = ref.watch(CurrentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Riverpod")),
      ),
      body: Center(child: Text(currentDate.toIso8601String())),
    );
  }
}
