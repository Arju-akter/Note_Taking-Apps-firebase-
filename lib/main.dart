import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/models/note_model.dart';
import 'package:firebase_app/repositories/firebase_notes_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _noteBodyTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) => Container(
                    padding: const EdgeInsets.all(12.0),
                    width: double.infinity,
                    height: 600.0,
                    child: Column(
                      children: [
                        const Text(
                          "Write a note",
                          style: TextStyle(fontSize: 40.0),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextField(
                          controller: _titleTextEditingController,
                          decoration: const InputDecoration(
                            hintText: "Title of the note",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextField(
                          controller: _noteBodyTextEditingController,
                          maxLines: 5,
                          decoration: const InputDecoration(
                              hintText: "Note Text",
                              border: OutlineInputBorder()),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                          onPressed: () => FireBaseNoteRepository.saveNote(
                              NoteModel(
                                  id: "00",
                                  title: _titleTextEditingController.text,
                                  text: _noteBodyTextEditingController.text)),
                          child: const Text("Save Note"),
                        )
                      ],
                    ),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: FireBaseNoteRepository.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error loading data"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(" Loading data"),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, int index) {
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(0, 2, 71, 75).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(12.0)),
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(12.0),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data?[index].title ?? "No Title",
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          Text(
                            snapshot.data?[index].text ?? "No Text",
                            style: const TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                _titleTextEditingController.text =
                                    snapshot.data?[index].title ?? "No Title";
                                _noteBodyTextEditingController.text =
                                    snapshot.data?[index].text ?? "No Text";
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                          padding: const EdgeInsets.all(12.0),
                                          width: double.infinity,
                                          height: 600.0,
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Edit Note",
                                                style:
                                                    TextStyle(fontSize: 40.0),
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              TextField(
                                                controller:
                                                    _titleTextEditingController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Title of the note",
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              TextField(
                                                controller:
                                                    _noteBodyTextEditingController,
                                                maxLines: 5,
                                                decoration: const InputDecoration(
                                                    hintText: "Note Text",
                                                    border:
                                                        OutlineInputBorder()),
                                              ),
                                              const SizedBox(
                                                height: 12.0,
                                              ),
                                              ElevatedButton(
                                                onPressed: () => FireBaseNoteRepository
                                                    .updateNote(NoteModel(
                                                        id: snapshot
                                                            .data![index].id,
                                                        title:
                                                            _titleTextEditingController
                                                                .text,
                                                        text:
                                                            _noteBodyTextEditingController
                                                                .text)),
                                                child:
                                                    const Text("Save Changes"),
                                              )
                                            ],
                                          ),
                                        ));
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              onPressed: () =>
                                  FireBaseNoteRepository.deleteNote(
                                      snapshot.data![index]),
                              icon: const Icon(Icons.delete)),
                        ],
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
