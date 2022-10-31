import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:name_capturer/provider.dart';
import 'person_model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(backgroundColor: Colors.blueGrey),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Name Taker')),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Consumer(builder: (context, ref, child) {
          final personProvider = ref.watch(peopleProvider);

          return ListView.builder(
              itemCount: personProvider.count,
              itemBuilder: (context, index) {
                final person = personProvider.people[index];
                return ListTile(
                  title: InkWell(
                      onTap: () async {
                        final updatedPerson =
                            await savePersonDialog(context, person);

                        if (updatedPerson != null) {
                          personProvider.update(updatedPerson);
                        }
                      },
                      child: Text(person.displayName)),
                );
              });
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final person = await savePersonDialog(context);
          if (person != null) {
            final dataModel = ref.read(peopleProvider);
            dataModel.addPerson(person);
          }
        },
        tooltip: 'add Some One',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final nameController = TextEditingController();
  final ageController = TextEditingController();

  Future<Person?> savePersonDialog(BuildContext context,
      [Person? existingPerson]) {
    String? name = existingPerson?.name;
    int? age = existingPerson?.age;

    nameController.text = name ?? '';
    ageController.text = age?.toString() ?? "";

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("create a person here"),
            content: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Enter name ........",
                    ),
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  TextField(
                    controller: ageController,
                    decoration: const InputDecoration(
                      labelText: "Enter age ........",
                    ),
                    onChanged: (value) {
                      age = int.parse(value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    if (name != null && age != null) {
                      if (existingPerson != null) {
                        final newPerson = existingPerson.updated(name, age);
                        Navigator.of(context).pop(newPerson);
                      } else {
                        Navigator.of(context).pop(
                          Person(age: age!, name: name!),
                        );
                      }
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("Save")),
            ],
          );
        });
  }
}
