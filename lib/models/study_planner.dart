//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:cloud_firestore/cloud_firestore.dart';

class StudyPlan {
  final String id;
  final String title;
  final String? subject;
  final DateTime? dueDate;
  final int estimatedHours;
  final int completedHours;
  final int priority;
  final String userId;
  final int? preferredSessionMinutes;

  StudyPlan({
    required this.id,
    required this.title,
    this.subject,
    this.dueDate,
    required this.estimatedHours,
    required this.completedHours,
    required this.priority,
    required this.userId,
    this.preferredSessionMinutes,
  });

  factory StudyPlan.fromFirestore(String id, Map<String, dynamic> data) {
    return StudyPlan(
      id: id,
      title: data['title'] as String? ?? 'Untitled Plan',
      subject: data['subject'] as String?,
      dueDate: _toDateTime(data['dueDate']),
      estimatedHours: (data['estimatedHours'] as int?) ?? 0,
      completedHours: (data['completedHours'] as int?) ?? 0,
      priority: (data['priority'] as int?) ?? 0,
      userId: data['userId'] as String? ?? '',
      preferredSessionMinutes: data['preferredSessionMinutes'] as int?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'subject': subject,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'estimatedHours': estimatedHours,
      'completedHours': completedHours,
      'priority': priority,
      'userId': userId,
      'preferredSessionMinutes': preferredSessionMinutes,
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}

class StudySession {
  final String id;
  final DateTime start;
  final DateTime end;
  final int durationMinutes;
  final bool completed;
  final String? notes;

  StudySession({
    required this.id,
    required this.start,
    required this.end,
    required this.durationMinutes,
    this.completed = false,
    this.notes,
  });

  Map<String, dynamic> toFirestore() => {
        'start': Timestamp.fromDate(start),
        'end': Timestamp.fromDate(end),
        'durationMinutes': durationMinutes,
        'completed': completed,
        'notes': notes,
      };

  static StudySession fromFirestore(String id, Map<String, dynamic> data) {
    DateTime? start = _toDateTime(data['start']);
    DateTime? end = _toDateTime(data['end']);

    if (start == null && data['date'] != null) {
      start = _toDateTime(data['date']);
      if (start != null) {
        start = DateTime(start.year, start.month, start.day, 18, 0);
      }
    }

    int durationMinutes = (data['durationMinutes'] as int?) ?? 0;
    if (durationMinutes == 0 && data['plannedHours'] != null) {
      final ph = data['plannedHours'];
      if (ph is int) durationMinutes = ph * 60;
      else if (ph is double) durationMinutes = (ph * 60).round();
      else if (ph is String) durationMinutes = (int.tryParse(ph) ?? 0) * 60;
    }

    if (durationMinutes == 0 && start != null && end != null) {
      durationMinutes = end.difference(start).inMinutes;
    }
    if (end == null && start != null && durationMinutes > 0) {
      end = start.add(Duration(minutes: durationMinutes));
    }

    if (start == null || end == null) {
      throw FormatException(
        'StudySession $id missing valid start/end fields. Keys: ${data.keys}',
      );
    }

    return StudySession(
      id: id,
      start: start,
      end: end,
      durationMinutes: durationMinutes,
      completed: (data['completed'] as bool?) ?? false,
      notes: data['notes'] as String?,
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
