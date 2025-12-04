//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/models/study_planner.dart';
import 'package:flutter/material.dart';
import '../models/app_user.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get m => _firestore;

  // Getter for currently authenticated user
  User? get currentUser => _auth.currentUser;

  int selectedIndex = 0;

  void updatedSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  // ---------------------- AUTH METHODS ----------------------

  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners(); // Only needed for auth state
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code);
    }
  }

  Future<User?> register(
    String email,
    String password,
    String name,
    String surname,
    String studentNumber,
    String phoneNumber,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser appUser = AppUser(
        email: email,
        name: name,
        createdAt: DateTime.now(),
        surname: surname,
        studentNumber: studentNumber,
        phoneNumber: phoneNumber,
      );

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(appUser.toFirestore());

      notifyListeners(); // Safe to keep for user creation
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _authError(e.code);
    }
  }

    Future<UserCredential> signInWithGoogle() async {
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    return await _auth.signInWithPopup(provider);
  }

  Future<User?> createUserCollection(
    String name,
    surname,
    email,
    phoneNumber,
    studentNumber,
    uid,
  ) async {
    // final userCredential = await _auth.currentUser(
    //     email: email,
    //     password: name,
    //   );
    // Create an AppUser object with additional user data
    AppUser appUser = AppUser(
      email: email,
      name: name,
      createdAt: DateTime.now(),
      surname: surname,
      studentNumber: studentNumber,
      phoneNumber: phoneNumber,
    );

    // Save the user data to Firestore
    await _firestore.collection('users').doc(uid).set(appUser.toFirestore());
    return _auth.currentUser;
    // ScaffoldMessenger.of(context).showSnackBar(
    //                       const SnackBar(content: Text("Please enter your email")),
    //                     );
    // return userCredential.user; // Return the newly created user
  }
  
  Future<void> resetPassword(String email) async {
    if (email.isEmpty) throw 'Email is required for password reset';
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  String _authError(String description) {
    switch (description) {
      case 'invalid-email':
        return 'Invalid CUT email address';
      case 'weak-password':
        return 'Password must be 8+ chars with @ symbol';
      default:
        return 'Authentication failed';
    }
  }

  Future<AppUser?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return AppUser.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUserInfo(
    String name,
    String surname,
    String phoneNumber,
  ) async {
    if (currentUser == null) throw Exception('User not authenticated');

    await _firestore.collection('users').doc(currentUser!.uid).update({
      'name': name,
      'surname': surname,
      'phoneNumber': phoneNumber,
    });

    notifyListeners(); // Profile info changed
  }

  String get _uid {
    final u = _auth.currentUser;
    if (u == null) throw Exception('User not authenticated');
    return u.uid;
    // Auth state managed via FirebaseAuth, not provider
  }

  CollectionReference<Map<String, dynamic>> get _studyPlansCollection =>
      _firestore.collection('studyPlans');
  CollectionReference<Map<String, dynamic>> get _sessionsCollection =>
      _firestore.collection('sessions');

  Future<String> addStudyPlan(StudyPlan plan) async {
    final docRef = await _studyPlansCollection.add({
      ...plan.toFirestore(),
      'userId': _uid,
    });
    // No notifyListeners() here — Firestore streams auto-update UI
    return docRef.id;
  }

  Future<void> updateStudyPlan(StudyPlan plan) async {
    final planDoc = await _studyPlansCollection.doc(plan.id).get();
    if (!planDoc.exists || planDoc.data()?['userId'] != _uid) {
      throw Exception('StudyPlan not found or unauthorized');
    }

    await _studyPlansCollection.doc(plan.id).update({
      ...plan.toFirestore(),
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteStudyPlan(String planId) async {
    final planDoc = await _studyPlansCollection.doc(planId).get();
    if (!planDoc.exists || planDoc.data()?['userId'] != _uid) {
      throw Exception('StudyPlan not found or unauthorized');
    }

    final sessionsQuery = _sessionsCollection
        .where('userId', isEqualTo: _uid)
        .where('planId', isEqualTo: planId);
    final sessions = await sessionsQuery.get();
    final batch = _firestore.batch();

    for (final doc in sessions.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_studyPlansCollection.doc(planId));
    await batch.commit();
  }

  Stream<List<StudyPlan>> getStudyPlans() {
    return _studyPlansCollection
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => StudyPlan.fromFirestore(d.id, d.data()))
                  .toList(),
        );
  }

  Future<void> createStudyPlan({
    required String title,
    required String subject,
    required DateTime dueDate,
    required int estimatedHours,
    required int priority,
    int preferredSessionMinutes = 60,
  }) async {
    if (currentUser == null) throw Exception('User not authenticated');

    // Validate input to catch nulls or wrong types early
    if (title.isEmpty || subject.isEmpty) {
      throw Exception('Title and subject cannot be empty.');
    }

    final planRef = _studyPlansCollection.doc();
    final now = DateTime.now();

    final newPlan = {
      'id': planRef.id,
      'title': title,
      'subject': subject,
      'startDate': Timestamp.fromDate(now),
      'dueDate': Timestamp.fromDate(dueDate),
      'estimatedHours': estimatedHours,
      'completedHours': 0,
      'priority': priority,
      'userId': currentUser!.uid,
      'preferredSessionMinutes': preferredSessionMinutes,
      'createdAt': Timestamp.fromDate(now),
      'updatedAt': Timestamp.fromDate(now),
    };

    // Write plan
    await planRef.set(newPlan);

    // ---- Generate sessions ----
    final totalDays = dueDate.difference(now).inDays + 1; // include end date
    if (totalDays > 0) {
      final sessionsRef = _sessionsCollection;
      final dailyHours = (estimatedHours / totalDays).ceil();

      for (int i = 0; i < totalDays; i++) {
        final day = now.add(Duration(days: i));
        final start = DateTime(day.year, day.month, day.day, 18, 0);
        final durationMinutes = dailyHours * 60;
        final end = start.add(Duration(minutes: durationMinutes));

        await sessionsRef.add({
          'start': Timestamp.fromDate(start),
          'end': Timestamp.fromDate(end),
          'durationMinutes': durationMinutes,
          'completed': false,
          'userId': currentUser!.uid,
          'planId': planRef.id,
          'createdAt': Timestamp.fromDate(now),
        });
      }
    }

    notifyListeners();
  }

  Future<void> addSession(String planId, StudySession session) async {
    final planDoc = await _studyPlansCollection.doc(planId).get();
    if (!planDoc.exists || planDoc.data()?['userId'] != _uid) {
      throw Exception('StudyPlan not found or unauthorized');
    }

    await _sessionsCollection.add({
      ...session.toFirestore(),
      'userId': _uid,
      'planId': planId,
    });
  }

  Stream<List<StudySession>> getSessions(String planId) {
    return _sessionsCollection
        .where('userId', isEqualTo: _uid)
        .where('planId', isEqualTo: planId)
        .snapshots()
        .map(
          (snap) =>
              snap.docs
                  .map((d) => StudySession.fromFirestore(d.id, d.data()))
                  .toList(),
        );
  }

  Future<void> deleteAllSessions(String planId) async {
    final planDoc = await _studyPlansCollection.doc(planId).get();
    if (!planDoc.exists || planDoc.data()?['userId'] != _uid) {
      throw Exception('StudyPlan not found or unauthorized');
    }

    final ref = _sessionsCollection
        .where('userId', isEqualTo: _uid)
        .where('planId', isEqualTo: planId);
    final snapshots = await ref.get();

    for (final doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateSession(String planId, StudySession session) async {
    final sessionDoc = await _sessionsCollection.doc(session.id).get();
    if (!sessionDoc.exists ||
        sessionDoc.data()?['userId'] != _uid ||
        sessionDoc.data()?['planId'] != planId) {
      throw Exception('StudySession not found or unauthorized');
    }

    await _sessionsCollection.doc(session.id).update(session.toFirestore());
  }

  List<StudySession> _generateSessionsGreedy({
    required DateTime from,
    required DateTime due,
    required double estimatedHours,
    required int preferredMinutes,
    required Map<int, int> minutesAvailablePerWeekday,
  }) {
    final totalMinutes = (estimatedHours * 60).ceil();
    int remaining = totalMinutes;
    final List<StudySession> out = [];

    DateTime cursor = DateTime(from.year, from.month, from.day);
    final DateTime lastDay = DateTime(due.year, due.month, due.day);

    while (!cursor.isAfter(lastDay) && remaining > 0) {
      final weekday = cursor.weekday;
      final available = minutesAvailablePerWeekday[weekday] ?? 0;

      int dayRemaining = available;
      DateTime slotCursor = DateTime(
        cursor.year,
        cursor.month,
        cursor.day,
        18,
        0,
      );

      while (dayRemaining >= 15 && remaining > 0) {
        final take =
            (preferredMinutes <= dayRemaining && preferredMinutes <= remaining)
                ? preferredMinutes
                : (remaining < preferredMinutes
                    ? remaining
                    : (dayRemaining < preferredMinutes
                        ? dayRemaining
                        : preferredMinutes));

        final start = slotCursor;
        final end = start.add(Duration(minutes: take));

        out.add(
          StudySession(
            id: '',
            start: start,
            end: end,
            durationMinutes: take,
            completed: false,
          ),
        );

        remaining -= take;
        dayRemaining -= take;
        slotCursor = slotCursor.add(Duration(minutes: take + 5));
      }

      cursor = cursor.add(const Duration(days: 1));
    }

    return out;
  }

  Future<int> generateSessionsForPlan(
    String planId, {
    Map<int, int>? minutesAvailablePerWeekday,
    int? dailyAvailableMinutes,
    DateTime? fromDate,
  }) async {
    final planDoc = await _studyPlansCollection.doc(planId).get();
    if (!planDoc.exists || planDoc.data()?['userId'] != _uid) {
      throw Exception('StudyPlan not found or unauthorized');
    }

    final plan = StudyPlan.fromFirestore(planDoc.id, planDoc.data()!);
    final start = (fromDate ?? DateTime.now()).toLocal();
    final due = plan.dueDate?.toLocal();

    if (due == null) throw Exception('Due date is required');
    if (!start.isBefore(due))
      throw Exception('Due date must be after start date');

    final availability = <int, int>{};
    final uniform = dailyAvailableMinutes ?? 60;
    for (int i = 1; i <= 7; i++) {
      availability[i] = minutesAvailablePerWeekday?[i] ?? uniform;
    }

    final sessions = _generateSessionsGreedy(
      from: start,
      due: due,
      estimatedHours: plan.estimatedHours.toDouble(),
      preferredMinutes: plan.preferredSessionMinutes ?? 60,
      minutesAvailablePerWeekday: availability,
    );

    final batch = _firestore.batch();
    for (final s in sessions) {
      final doc = _sessionsCollection.doc();
      batch.set(doc, {...s.toFirestore(), 'userId': _uid, 'planId': planId});
    }
    await batch.commit();
    return sessions.length;
  }

} 
