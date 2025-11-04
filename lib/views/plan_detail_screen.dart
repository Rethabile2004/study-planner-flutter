//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/models/study_planner.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class PlanDetailScreen extends StatelessWidget {
  final StudyPlan plan;

  const PlanDetailScreen({super.key, required this.plan});

  Future<void> _confirmRegenerate(BuildContext context) async {
    final planner = Provider.of<AuthService>(context, listen: false);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Regenerate Sessions'),
            content: const Text(
              'This will delete all current sessions and create a new schedule. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Regenerate'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      await planner.deleteAllSessions(plan.id);
      await planner.generateSessionsForPlan(
        plan.id,
        dailyAvailableMinutes: 60,
        fromDate: DateTime.now(),
      );
    }
  }

  Future<void> _toggleCompleted(
    BuildContext context,
    StudySession session,
    bool newValue,
  ) async {
    final planner = Provider.of<AuthService>(context, listen: false);
    await planner.updateSession(
      plan.id,
      StudySession(
        id: session.id,
        start: session.start,
        end: session.end,
        durationMinutes: session.durationMinutes,
        completed: newValue,
        notes: session.notes,
      ),
    );
  }

  Future<void> _deletePlan(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Delete Plan'),
            content: const Text('Delete this study plan and all its sessions?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).deleteStudyPlan(plan.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final planner = Provider.of<AuthService>(context);
    final dateFormatter = DateFormat('MMM d, yyyy – h:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(plan.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Regenerate sessions',
            onPressed: () => _confirmRegenerate(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete plan',
            onPressed: () => _deletePlan(context),
          ),
        ],
      ),
      body: StreamBuilder<List<StudySession>>(
        stream: planner.getSessions(plan.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              _buildPlanDetails(context, plan),
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              Text(
                'Sessions (${sessions.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (sessions.isEmpty)
                const Text('No sessions yet. Tap refresh to generate.'),
              ...sessions.map((s) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: CheckboxListTile(
                    value: s.completed,
                    onChanged:
                        (val) => _toggleCompleted(context, s, val ?? false),
                    title: Text(
                      'Session ${sessions.indexOf(s) + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start: ${dateFormatter.format(s.start)}'),
                        Text('End: ${dateFormatter.format(s.end)}'),
                        Text('Duration: ${s.durationMinutes} min'),
                        Text('Completed: ${s.completed ? "Yes" : "No"}'),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPlanDetails(BuildContext context, StudyPlan plan) {
    final dateFormatter = DateFormat('MMM d, yyyy');
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study Plan Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _buildInfoRow('Title', plan.title),
            _buildInfoRow('Subject', plan.subject ?? '—'),
            _buildInfoRow('Priority', plan.priority.toString()),
            _buildInfoRow('Estimated Hours', '${plan.estimatedHours} h'),
            _buildInfoRow(
              'Due Date',
              plan.dueDate != null
                  ? dateFormatter.format(plan.dueDate!)
                  : 'No due date',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text('$label:')),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
