import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/main.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/views/create_plan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../models/study_planner.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _appInfor(context),
          icon: Icon(Icons.info_outline),
        ),
        title: const Text("Study Planner"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, RouteManager.loginPage);
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _welcomeHeader(auth),
          const SizedBox(height: 20),
          _quickStats(auth),
          const SizedBox(height: 25),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Study Plans",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton.icon(
                    label: Text('Create Plan'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreatePlanScreen()),
                    );
                  },
                  icon: const Icon(Icons.add),
                ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          _studyPlanList(auth, context),
        ],
      ),

      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreatePlanScreen()),
          );
        },
        child: const Icon(Icons.add),
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

  // WELCOME HEADER
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
              "Welcome, ${user.name}",
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

  // QUICK STATS
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
          child: Column(
            children: [
              Icon(icon, size: 28, color: Colors.blueAccent),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  // STUDY PLAN LIST
  Widget _studyPlanList(AuthService auth, BuildContext context) {
    return StreamBuilder<List<StudyPlan>>(
      stream: auth.getStudyPlans(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final plans = snapshot.data!;
        if (plans.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: Text("No study plans yet. Add one!"),
            ),
          );
        }

        return Column(
          children: plans.map((plan) => _planCard(plan, context)).toList(),
        );
      },
    );
  }

  Widget _planCard(StudyPlan plan, BuildContext context) {
    double progress =
        (plan.completedHours / plan.estimatedHours).clamp(0, 1).toDouble();

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        title: Text(plan.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subject: ${plan.subject}"),
            const SizedBox(height: 4),
            LinearProgressIndicator(value: progress),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.pushNamed(
            context,
            RouteManager.studyPlanDetailsPage,
            arguments: plan,
          );
          // replace with your plan details route
        },
      ),
    );
  }
}
