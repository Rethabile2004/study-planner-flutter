//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:flutter/material.dart';

class NoteForm extends StatefulWidget {
  final String? noteId;
  final String? initialName;
  final String? initialDescription;
  final Function(String name, String description) onSubmit;

  const NoteForm({
    super.key,
    this.noteId,
    this.initialName,
    this.initialDescription,
    required this.onSubmit,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialName != null) _nameController.text = widget.initialName!;
    if (widget.initialDescription != null) {
      _descriptionController.text = widget.initialDescription!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Title Field ===
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Note Title',
                hintText: 'e.g. Software Engineering || Notes',
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                prefixIcon: const Icon(Icons.title_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Title is required' : null,
            ),

            const SizedBox(height: 16),

            // === Description Field ===
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Focus on Unit 2 for the main test...',
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Description is required'
                  : null,
            ),

            const SizedBox(height: 30),

            // === Submit Button ===
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSubmit(
                      _nameController.text.trim(),
                      _descriptionController.text.trim(),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: Icon(
                  widget.noteId == null ? Icons.add : Icons.update,
                  size: 20,
                ),
                label: Text(
                  widget.noteId == null ? 'Add Note' : 'Update Note',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
