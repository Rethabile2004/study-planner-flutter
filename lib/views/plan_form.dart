//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class PlanForm extends StatefulWidget {
  final VoidCallback onSaved;
  const PlanForm({super.key, required this.onSaved});

  @override
  State<PlanForm> createState() => _PlanFormState();
}

class _PlanFormState extends State<PlanForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _hoursController = TextEditingController();

  DateTime? _dueDate;
  int _priority = 1;

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final now = DateTime.now();
      final due = _dueDate ?? now.add(const Duration(days: 7));
      final hours = int.tryParse(_hoursController.text) ?? 1;


      await auth.createStudyPlan(
        title: _titleController.text.trim(),
        subject: _subjectController.text.trim(),
        dueDate: due,
        estimatedHours: hours,
        priority: _priority,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study plan created successfully')),
        );
      }

      widget.onSaved();
    } catch (e) {
      if (mounted) {
        // ScaffoldMessenger.of(
        //   context,
        // ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Plan Title'),
              validator:
                  (v) => v == null || v.trim().isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
              validator:
                  (v) =>
                      v == null || v.trim().isEmpty ? 'Enter a subject' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _hoursController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Estimated Study Hours',
              ),
              validator:
                  (v) =>
                      v == null || v.isEmpty ? 'Enter estimated hours' : null,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _dueDate == null
                        ? 'No due date selected'
                        : 'Due: ${_dueDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDueDate,
                ),
              ],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _priority,
              decoration: const InputDecoration(labelText: 'Priority'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Low')),
                DropdownMenuItem(value: 2, child: Text('Medium')),
                DropdownMenuItem(value: 3, child: Text('High')),
              ],
              onChanged: (v) => setState(() => _priority = v ?? 1),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.save),
              label: const Text('Create Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
