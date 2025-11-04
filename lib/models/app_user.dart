//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String email; 
  final String name;
  final String surname;
  final String studentNumber; 
  final String phoneNumber; 
  final DateTime createdAt; 

  AppUser({
    required this.email,
    required this.name,
    required this.createdAt,
    required this.surname,
    required this.studentNumber,
    required this.phoneNumber,
  });

  
  factory AppUser.fromFirestore(Map<String, dynamic> data) {
    return AppUser(
      email: data['email'],
      name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      surname: data['surname'],
      studentNumber: data['studentNumber'],
      phoneNumber: data['phoneNumber'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'surname': surname,
      'studentNumber': studentNumber,
      'phoneNumber': phoneNumber,
    };
  }
}
