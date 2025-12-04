// study_plan_details_screen.dart
// Shows a StudyPlan (your model) + its sessions (from AuthService.getSessions(plan.id))
// Allows toggling each session's `completed` flag and keeps the StudyPlan.completedHours in Firestore in sync.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/study_planner.dart'; // your StudyPlan & StudySession classes
import '../services/auth_service.dart';

class StudyPlanDetailsPage extends StatefulWidget {
  final StudyPlan plan;
  const StudyPlanDetailsPage({super.key, required this.plan});

  @override
  State<StudyPlanDetailsPage> createState() => _StudyPlanDetailsScreenState();
}

class _StudyPlanDetailsScreenState extends State<StudyPlanDetailsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _toggling = false;

  Color _priorityColor(int p) {
    if (p >= 3) return Colors.red.shade700;
    if (p == 2) return Colors.orange.shade700;
    if (p == 1) return Colors.amber.shade700;
    return Colors.green.shade600;
  }

  String _priorityLabel(int p) {
    if (p >= 3) return 'Critical';
    if (p == 2) return 'High';
    if (p == 1) return 'Medium';
    return 'Low';
  }

  String _formatDateTime(DateTime d) {
    final date = "${d.day.toString().padLeft(2, '0')}/"
        "${d.month.toString().padLeft(2, '0')}/"
        "${d.year}";
    final time = "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
    return "$date • $time";
  }

  Future<void> _toggleSessionComplete({
    required AuthService auth,
    required StudySession session,
  }) async {
    if (_toggling) return;
    setState(() => _toggling = true);

    final newCompleted = !session.completed;

    // Create updated StudySession
    final updated = StudySession(
      id: session.id,
      start: session.start,
      end: session.end,
      durationMinutes: session.durationMinutes,
      completed: newCompleted,
      notes: session.notes,
    );

    try {
      // 1) update session document via AuthService
      await auth.updateSession(widget.plan.id, updated);

      // 2) update plan.completedHours using a numeric increment (hours as float)
      //    convert minutes -> hours (float). Firestore supports fractional increments.
      final double hoursDelta = session.durationMinutes / 60.0;
      final String planDocPath = 'studyPlans/${widget.plan.id}';

      final docRef = _firestore.doc(planDocPath);
      if (newCompleted) {
        await docRef.update({
          'completedHours': FieldValue.increment(hoursDelta),
        });
      } else {
        await docRef.update({
          'completedHours': FieldValue.increment(-hoursDelta),
        });
      }
    } catch (e) {
      // show error, but do not crash
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to toggle session: ${e.toString()}')),
      );
    } finally {
      setState(() => _toggling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plan.title),
        actions: [
          IconButton(
            tooltip: 'Delete all sessions',
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final ok = await showDialog<bool>(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: const Text('Delete all sessions?'),
                      content: const Text(
                          'This will remove all generated sessions for this plan.'),
                      actions: [
                        TextButton(
                            onPressed: null, child: const Text('Cancel')),
                        TextButton(
                            onPressed: () => Navigator.of(c).pop(true),
                            child: const Text('Delete')),
                      ],
                    ),
                  ) ??
                  false;

              if (!ok) return;
              try {
                await auth.deleteAllSessions(widget.plan.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All sessions deleted')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Delete failed: ${e.toString()}')),
                );
              }
            },
          )
        ],
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // PLAN OVERVIEW
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  // left: priority badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _priorityColor(widget.plan.priority),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _priorityLabel(widget.plan.priority),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // right: details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.plan.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        if (widget.plan.subject != null)
                          Text(
                            widget.plan.subject!,
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            if (widget.plan.dueDate != null)
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    "${widget.plan.dueDate!.day.toString().padLeft(2, '0')}/"
                                    "${widget.plan.dueDate!.month.toString().padLeft(2, '0')}/"
                                    "${widget.plan.dueDate!.year}",
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                            const Icon(Icons.access_time, size: 14),
                            const SizedBox(width: 6),
                            Text(
                                "${widget.plan.estimatedHours}h estimated • ${widget.plan.completedHours}h done"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // SESSIONS HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sessions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<List<StudySession>>(
                  stream: auth.getSessions(widget.plan.id),
                  builder: (context, sSnap) {
                    final sessions = sSnap.data ?? [];
                    final remaining = sessions.where((s) => !s.completed).length;
                    return Text('$remaining remaining',
                        style: TextStyle(color: Colors.grey.shade600));
                  },
                )
              ],
            ),

            const SizedBox(height: 10),

            // SESSIONS LIST (stream)
            Expanded(
              child: StreamBuilder<List<StudySession>>(
                stream: auth.getSessions(widget.plan.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final sessions = snapshot.data ?? [];
                  if (sessions.isEmpty) {
                    return const Center(
                        child: Text('No sessions created for this plan.'));
                  }

                  // sort by start ascending
                  sessions.sort((a, b) => a.start.compareTo(b.start));

                  return ListView.separated(
                    itemCount: sessions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, idx) {
                      final s = sessions[idx];
                      final isPast = s.end.isBefore(DateTime.now());
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          leading: Container(
                            width: 54,
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  s.start.day.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _shortMonth(s.start.month),
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                )
                              ],
                            ),
                          ),
                          title: Text(_formatDateTime(s.start)),
                          subtitle: Text(
                              "${(s.durationMinutes / 60).toStringAsFixed(2)} hrs • ${isPast ? 'Past' : 'Upcoming'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // toggle complete button
                              IconButton(
                                tooltip:
                                    s.completed ? 'Mark as incomplete' : 'Mark as complete',
                                onPressed: _toggling
                                    ? null
                                    : () => _toggleSessionComplete(
                                          auth: auth,
                                          session: s,
                                        ),
                                icon: Icon(
                                  s.completed
                                      ? Icons.check_circle
                                      : Icons.radio_button_unchecked,
                                  color: s.completed
                                      ? Colors.green
                                      : Colors.grey.shade600,
                                  size: 28,
                                ),
                              ),

                              // optional quick edit (notes)
                              IconButton(
                                tooltip: 'Edit notes',
                                icon: const Icon(Icons.note_alt_outlined),
                                onPressed: () async {
                                  final newNotes = await showDialog<String?>(
                                    context: context,
                                    builder: (c) {
                                      final ctrl = TextEditingController(text: s.notes);
                                      return AlertDialog(
                                        title: const Text('Session notes'),
                                        content: TextField(
                                          controller: ctrl,
                                          maxLines: 4,
                                          decoration: const InputDecoration(
                                              hintText: 'Short notes...'),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(c).pop(null),
                                              child: const Text('Cancel')),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(c).pop(ctrl.text),
                                              child: const Text('Save')),
                                        ],
                                      );
                                    },
                                  );

                                  if (newNotes != null) {
                                    final updated = StudySession(
                                      id: s.id,
                                      start: s.start,
                                      end: s.end,
                                      durationMinutes: s.durationMinutes,
                                      completed: s.completed,
                                      notes: newNotes,
                                    );
                                    try {
                                      await auth.updateSession(widget.plan.id, updated);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Notes updated')));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Update failed: ${e.toString()}')));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // expand details or open session detail page (optional)
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _shortMonth(int m) {
    const names = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return names[m - 1];
  }
}
