import 'package:flutter/material.dart';

import '../models/note.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, this.note});
  final Note? note;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  @override
  void initState() {
    if (widget.note != null) {
      _titleController = TextEditingController(text: widget.note!.title);
      _contentController = TextEditingController(text: widget.note!.content);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
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
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                    controller: _titleController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 30)),
                  ),
                  TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    maxLines: null,
                    controller: _contentController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type something here...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(
            context,
            [_titleController.text, _contentController.text],
          );
        },
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.save),
      ),
    );
  }
}
