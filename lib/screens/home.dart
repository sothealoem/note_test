import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/constants/colors.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/screens/edit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Note> filteredNotes = [];
  bool sorted = false;
  @override
  void initState() {
    super.initState();
    filteredNotes = sampleNotes;
  }
//sort by time
  List<Note> sortNoteByModifiedTime(List<Note> modifiedTimeSort) {
    if (sorted) {
      modifiedTimeSort.sort((a, b) => a.modifiedTime.compareTo(b.modifiedTime));
    } else {
      modifiedTimeSort.sort((b, a) => a.modifiedTime.compareTo(b.modifiedTime));
    }
    sorted = !sorted;
    return modifiedTimeSort;
  }

  //random color
  getRandomColor() {
    Random random = Random();
    return backgroundColors[random.nextInt(backgroundColors.length)];
  }

  //search
  void onSearchTextChange(String searchText) {
    setState(
      () {
        filteredNotes = sampleNotes
            .where((note) =>
                note.content.toLowerCase().contains(searchText.toLowerCase()) ||
                note.title.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
      },
    );
  }

  //delete
  void deleteNote(int index) {
    setState(() {
      Note note = filteredNotes[index];
      sampleNotes.remove(note);
      filteredNotes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Notes',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      filteredNotes = sortNoteByModifiedTime(filteredNotes);
                    });
                  },
                  padding: const EdgeInsets.all(0),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.sort,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            //search bar
            TextField(
              onChanged: onSearchTextChange,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: "Search note...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                fillColor: Colors.grey.shade800,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 30),
                itemBuilder: (context, index) {
                  return Card(
                    color: getRandomColor(),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => EditScreen(
                                note: filteredNotes[index],
                              ),
                            ),
                          );
                          if (result != null) {
                            setState(
                              () {
                                int originalIndex =
                                    sampleNotes.indexOf(filteredNotes[index]);
                                sampleNotes[originalIndex] = Note(
                                  id: sampleNotes[originalIndex].id,
                                  title: result[0],
                                  content: result[1],
                                  modifiedTime: DateTime.now(),
                                );
                                filteredNotes[index] = Note(
                                  id: filteredNotes[index].id,
                                  title: result[0],
                                  content: result[1],
                                  modifiedTime: DateTime.now(),
                                );
                              },
                            );
                          }
                        },
                        title: RichText(
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            text: '${filteredNotes[index].title} \n',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: filteredNotes[index].content,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              )
                            ],
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Edited : ${DateFormat('EEE MMM d, yyyy h:mm a').format(sampleNotes[index].modifiedTime)}',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade800,
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () async {
                            final result = await confirmDialog(context);
                            if (result != null && result) {
                              deleteNote(index);
                            }
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: filteredNotes.length,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const EditScreen(),
            ),
          );
          if (result != null) {
            setState(
              () {
                sampleNotes.add(
                  Note(
                    id: sampleNotes.length,
                    title: result[0],
                    content: result[1],
                    modifiedTime: DateTime.now(),
                  ),
                );
                filteredNotes = sampleNotes;
              },
            );
          }
        },
        backgroundColor: Colors.grey.shade800,
        elevation: 10,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }

  Future<dynamic> confirmDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade800,
          icon: const Icon(Icons.info),
          title: const Text(
            'Are you sure want to delete?',
            style: TextStyle(color: Colors.white),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'Yes',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const SizedBox(
                  width: 60,
                  child: Text(
                    'No',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
