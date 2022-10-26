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

//An extension method that add extra functionalities to the num class
//It functionality is to enable us add an optional Int to an int
//if the 1st operand is an int
extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

// void testIt() {
//   final int? int1 = 1;
//   final int? int2 = null;
//   final result = int1 + int2;
// }

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

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() {
    //without the extionsion function OptionalInfixAddition, it will throw an error
    state = (state == null) ? 1 : state + 1;
  }

  void reset() {
    state = 1;
  }

  //state is the current state of this [StateNotifier].
  //it always available in a stateNotifier
  int? get value => state;
}

//
//A global stateNotifierProvider
//Note: the Counter class doesnt neccessary need to be in same file
//as ref with providerScope will ensure it will always be available any where
final counterProvider = StateNotifierProvider<Counter, int?>(
  (ref) => Counter(),
);

class MainPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Note using ref.watch before the widget will make the build method run anytime there is a change of state
    //which is performance optimistic... Hence, we use a consumer widget
    // final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Riverpod")),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 200,
            ),
            //Note the WidgetRef of the consumer is differrent from that of the build method
            //this ensure only the consumer widget is build not the entire screen
            Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final counterValue = ref.watch(counterProvider);
              final valueString = counterValue == null
                  ? 'Press the button'
                  : counterValue.toString();
              return Text(valueString);
              //Note the child of the consumer is a widget we dont want to rebuild
            }),

            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: () {
                      //notifier is the notifier of the stateNotifier class
                      //it obtain the state from the stateNotifier class
                      //Note: we cant access the counter class methods with counterProvider.notifier alone
                      //hence we use a widgetRef to read or watch
                      //here, we use read. read allow us to only read the current state and not the next changes
                      ref.read(counterProvider.notifier).increment();
                    },
                    child: const Text("Increase")),
                TextButton(
                    onPressed: () {
                      ref.read(counterProvider.notifier).reset();
                    },
                    child: const Text("reset")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
