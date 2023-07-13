// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:franata_test_kompetensi/db/notes_database.dart';
import 'package:franata_test_kompetensi/screens/notes/notes_add.dart';
import 'package:intl/intl.dart';
import 'package:franata_test_kompetensi/models/note_model.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 30),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(
                      id: notes[index].id ?? 0,
                      title: notes[index].title,
                      content: notes[index].content,
                      modifiedTime: notes[index].modifiedTime,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                EditNote(note: notes[index]),
                          ),
                        );
                        if (result != null) {
                          final note = Note(
                            id: result[0],
                            title: result[1],
                            content: result[2],
                            modifiedTime: DateTime.now(),
                          );

                          NotesDatabase.instance.update(note);

                          refreshNotes();
                        }
                      },
                      onDelete: () async {
                        final result = await confirmDialog(context);
                        if (result != null && result) {
                          NotesDatabase.instance.delete(notes[index].id ?? 0);

                          refreshNotes();
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.note_add,
          color: Colors.white,
        ),
        foregroundColor: Colors.blue,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditNote(),
            ),
          );

          if (result != null) {
            final note = Note(
              title: result[1],
              content: result[2],
              modifiedTime: DateTime.now(),
            );

            NotesDatabase.instance.create(note);

            refreshNotes();

          }
        },
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          title: const Text(
            'Are you sure you want to delete?',
            style: TextStyle(color: Colors.white),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: const SizedBox(
                    width: 60,
                    child: Text(
                      'Yes',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class NoteCard extends StatelessWidget {
  int id;
  String title;
  String content;
  DateTime modifiedTime;
  final onTap;
  final onDelete;

  NoteCard({
    Key? key,
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
    required this.onTap,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          onTap: onTap,
          title: RichText(
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              text: title + ' \n',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  height: 1.5),
              children: [
                TextSpan(
                  text: content,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      height: 1.5),
                ),
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              DateFormat('EEE, MMM d yyyy h:mm a').format(modifiedTime),
              style: TextStyle(
                  fontSize: 10,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade800),
            ),
          ),
          trailing: IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ),
      ),
    );
  }
}
