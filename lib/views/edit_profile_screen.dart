//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/main.dart';
import 'package:firebase_flutter/models/study_planner.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:firebase_flutter/views/user_infromation_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class UserSettingsPage extends StatelessWidget {
  final String userId;
  final String? name;
  final String? surname;
  final String? phone;

  const UserSettingsPage({
    super.key,
    required this.userId,
    this.name,
    this.surname,
    this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _appInfor(context),
          icon: Icon(Icons.info_outline),
        ),
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // const Text(
          //   "Profile",
          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // ),
          _welcomeHeader(auth),
          const SizedBox(height: 12),

          // UPDATE PERSONAL INFORMATION
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Update Personal Information"),
            subtitle: const Text("Name, surname, phone"),
            onTap: () => _openUpdateInfo(context, auth),
            trailing: const Icon(Icons.chevron_right),
          ),

          const Divider(height: 32),
          _quickStats(auth),
          const Text(
            "Privacy & Security",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text("Privacy & Data"),
            subtitle: const Text("Manage what data you share"),
            onTap: () => _showPrivacyBottomSheet(context),
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => _confirmLogout(context),
          ),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Delete Account"),
            titleTextStyle: const TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            onTap: () => _confirmDeleteAccount(context),
          ),
        ],
      ),
    );
  }

  void _openUpdateInfo(BuildContext context, AuthService auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (_) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FutureBuilder(
              future: auth.getUserData(auth.currentUser!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const LinearProgressIndicator();
                }
                final user = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInformationForm(
                      userId: userId,
                      initialName: user.name,
                      initialSurname: user.surname,
                      initialPhoneNumber: user.phoneNumber,
                      onSubmit: (n, s, p) async {
                        auth.updateUserInfo(n, s, p);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
    );
  }

  Widget _welcomeHeader(AuthService auth) {
    return FutureBuilder(
      future: auth.getUserData(auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }
        final user = snapshot.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.name}'s Profile",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              "Stay organized. Stay ahead.",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Privacy & Data",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Text(
                  "• Your data is stored securely in Firestore.\n"
                  "• You control what personal information is visible.\n"
                  "• You can delete your account anytime.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  void _appInfor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 218, 218, 218),
          icon: Icon(Icons.info, size: 65),
          title: Text(
            "Study Planner",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 31),
          ),
          content: SizedBox(
            height: 210,
            child: Center(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Study planner helps students manage their time, by allowing them to allocate specific hours to their subjects for a specific amount of time.",
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color.fromARGB(255, 84, 83, 83),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Developed by",
                    style: TextStyle(color: Colors.blueGrey, fontSize: 18),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: WebsiteButton(),
                        ),
                        Text(
                          style: TextStyle(fontSize: 18),
                          " - December 2025",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("close"),
            ),
          ],
        );
      },
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Logout"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(
                    context,
                    RouteManager.loginPage,
                  ); // back to login
                },
                child: const Text("Logout"),
              ),
            ],
          ),
    );
  }

  Widget _quickStats(AuthService auth) {
    return StreamBuilder<List<StudyPlan>>(
      stream: auth.getStudyPlans(),
      builder: (context, snapshot) {
        final plans = snapshot.data ?? [];

        int total = plans.length;
        int completed =
            plans.where((p) => p.completedHours >= p.estimatedHours).length;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _statCard("Total Plans", total.toString(), Icons.assignment),
            _statCard("Completed", completed.toString(), Icons.check_circle),
          ],
        );
      },
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: ListTile(
            leading: Icon(icon, size: 28, color: Colors.blueAccent),
            title: Text(label),
            subtitle: Text(value),
          ),
          // Column(
          //   children: [
          //     Icon(icon, size: 28, color: Colors.blueAccent),
          //     const SizedBox(height: 6),
          //     Text(
          //       value,
          //       style: const TextStyle(
          //         fontSize: 20,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //     Text(label),
          //   ],
          // ),
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text(
              "Delete Account",
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              "This action is irreversible.\n\nAll your study plans and sessions will be permanently deleted.",
            ),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  Navigator.pop(context);
                  await _deleteAccount();
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, RouteManager.loginPage);
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteAccount() async {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    await FirebaseFirestore.instance.collection("users").doc(userId).delete();
    await FirebaseFirestore.instance
        .collection("studyPlans")
        .where("userId", isEqualTo: userId)
        .get()
        .then((snap) async {
          for (var d in snap.docs) {
            await d.reference.delete();
          }
        });

    await FirebaseFirestore.instance
        .collection("sessions")
        .where("userId", isEqualTo: userId)
        .get()
        .then((snap) async {
          for (var d in snap.docs) {
            await d.reference.delete();
          }
        });

    await user?.delete();
  }
}
