import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class CreatePlanScreen extends StatefulWidget {
  const CreatePlanScreen({super.key});

  @override
  State<CreatePlanScreen> createState() => _CreatePlanScreenState();
}

class _CreatePlanScreenState extends State<CreatePlanScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _title = TextEditingController();
  final TextEditingController _subject = TextEditingController();

  DateTime? _dueDate;
  double _estimatedHours = 1;
  double _priority = 1;
  int _preferredMinutes = 60;

  Future<void> _pickDueDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a due date')),
      );
      return;
    }

    final auth = context.read<AuthService>();

    try {
      await auth.createStudyPlan(
        title: _title.text.trim(),
        subject: _subject.text.trim(),
        dueDate: _dueDate!,
        estimatedHours: _estimatedHours.toInt(),
        priority: _priority.toInt(),
        preferredSessionMinutes: _preferredMinutes,
      );

      // await auth.generateSessionsForPlan
      // (

      // );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Study Plan"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TITLE
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? "Enter a title" : null,
              ),

              const SizedBox(height: 16),

              // SUBJECT
              TextFormField(
                controller: _subject,
                decoration: const InputDecoration(
                  labelText: "Subject",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // DUE DATE PICKER
              InkWell(
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dueDate == null
                            ? "Select Due Date"
                            : "${_dueDate!.year}-${_dueDate!.month}-${_dueDate!.day}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_month),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ESTIMATED HOURS
              const Text("Estimated Hours"),
              Slider(
                value: _estimatedHours,
                min: 1,
                max: 5,
                divisions: 99,
                label: "${_estimatedHours.toInt()} hrs",
                onChanged: (v) => setState(() => _estimatedHours = v),
              ),

              const SizedBox(height: 16),

              // PRIORITY
              const Text("Priority (1 = low, 5 = high)"),
              Slider(
                value: _priority,
                min: 1,
                max: 5,
                divisions: 4,
                label: "${_priority.toInt()}",
                onChanged: (v) => setState(() => _priority = v),
              ),

              const SizedBox(height: 16),

              // PREFERRED SESSION LENGTH
              DropdownButtonFormField<int>(
                value: _preferredMinutes,
                decoration: const InputDecoration(
                  labelText: "Preferred Session Length",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 30, child: Text("30 minutes")),
                  DropdownMenuItem(value: 45, child: Text("45 minutes")),
                  DropdownMenuItem(value: 60, child: Text("60 minutes")),
                  DropdownMenuItem(value: 90, child: Text("90 minutes")),
                ],
                onChanged: (v) => setState(() => _preferredMinutes = v!),
              ),

              const SizedBox(height: 24),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Padding(
                    padding: EdgeInsets.all(14.0),
                    child: Text("Create Plan"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
