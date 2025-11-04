//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String name;
  final String description;
  final String studentId;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.name,
    required this.description,
    required this.studentId,
    required this.createdAt,
  });

  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      name: data['name'],
      description: data['description'],
      studentId: data['studentId'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );

  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'studentId': studentId,
      'createdAt': createdAt,
    };
  }
}