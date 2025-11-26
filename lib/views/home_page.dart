//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter/models/app_user.dart';
import 'package:firebase_flutter/models/notes.dart';
import 'package:firebase_flutter/models/study_planner.dart';
import 'package:firebase_flutter/routes/app_router.dart';
import 'package:firebase_flutter/services/auth_service.dart';
import 'package:firebase_flutter/views/notes_screen.dart';
import 'package:firebase_flutter/views/plan_detail_screen.dart';
import 'package:firebase_flutter/views/plan_form.dart';
import 'package:firebase_flutter/views/study_tip_detail_screen.dart';
import 'package:firebase_flutter/views/study_tips_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  final String email;
  const MainPage({super.key, required this.email});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  Future<AppUser?>? _userFuture;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.currentUser != null) {
      _userFuture = auth.getUserData(auth.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      drawer: _buildDrawer(context, authService),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<AppUser?>(
          future: _userFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(child: Text('Error loading user data'));
            }

            final user = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserCard(context, user),
                const SizedBox(height: 16),
                _buildStudyTipsPreview(context),
                const SizedBox(height: 16),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _selectedIndex == 0
                        ? _buildNotesList(context, authService)
                        : _buildPlansList(context, authService),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedIndex == 0) {
            _showAddNoteDialog(context);
          } else {
            _showAddPlanDialog(context);
          }
        },
        label: Text(
          _selectedIndex == 0 ? 'Add Note' : 'Add Plan',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // === Drawer ===
  Widget _buildDrawer(BuildContext context, AuthService authService) {
    final theme = Theme.of(context);
    return Drawer(
      child: FutureBuilder<AppUser?>(
        future: authService.getUserData(authService.currentUser!.uid),
        builder: (context, snapshot) {
          String name = 'User';
          String email = widget.email;
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            name = snapshot.data!.name;
            email = snapshot.data!.email;
          } else if (snapshot.hasError) {
            name = 'Error';
            email = 'Failed to load user data';
          }
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: theme.colorScheme.primary),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.onPrimary,
                      child: Icon(Icons.person, color: theme.colorScheme.primary),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onPrimary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.note_alt_outlined,
                    color: _selectedIndex == 0
                        ? theme.colorScheme.primary
                        : null),
                title: Text(
                  'Notes',
                  style: TextStyle(
                    color: _selectedIndex == 0
                        ? theme.colorScheme.primary
                        : null,
                    fontWeight: _selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == 0,
                selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
                onTap: () {
                  setState(() => _selectedIndex = 0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.school_outlined,
                    color: _selectedIndex == 1
                        ? theme.colorScheme.primary
                        : null),
                title: Text(
                  'Study Plans',
                  style: TextStyle(
                    color: _selectedIndex == 1
                        ? theme.colorScheme.primary
                        : null,
                    fontWeight: _selectedIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == 1,
                selectedTileColor: theme.colorScheme.primary.withOpacity(0.1),
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RouteManager.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text('Logout',
                    style: TextStyle(color: Colors.redAccent)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(
                    context,
                    RouteManager.loginPage,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // === User Card ===
  Widget _buildUserCard(BuildContext context, AppUser user) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme.colorScheme.primaryContainer,
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, RouteManager.profile),
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: theme.colorScheme.onPrimaryContainer,
          child: Icon(Icons.person, color: theme.colorScheme.primary),
        ),
        trailing: Icon(Icons.edit, color: theme.colorScheme.primary),
        title: Text(
          user.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        subtitle: Text(
          widget.email,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
          ),
        ),
      ),
    );
  }

  // === Study Tips Preview ===
  Widget _buildStudyTipsPreview(BuildContext context) {
    final theme = Theme.of(context);
    final previewTips = studyTips.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Study Tips',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StudyTipsListScreen(),
                  ),
                );
              },
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: previewTips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final tip = previewTips[i];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => StudyTipDetailScreen(tip: tip),
                    ),
                  );
                },
                child: Container(
                  width: 260,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.title!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(tip.category,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text(tip.preview,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // === Notes List ===
  Widget _buildNotesList(BuildContext context, AuthService authService) {
    return StreamBuilder<List<Note>>(
      stream: authService.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading notes'));
        }
        final notes = snapshot.data ?? [];
        if (notes.isEmpty) {
          return const Center(child: Text('No notes yet.'));
        }
        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            return ListTile(
              title: Text(note.name),
              subtitle: Text(note.description),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteNote(context, note.id),
              ),
            );
          },
        );
      },
    );
  }

  // === Study Plans List ===
  Widget _buildPlansList(BuildContext context, AuthService planner) {
    return StreamBuilder<List<StudyPlan>>(
      stream: planner.getStudyPlans(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading study plans'));
        }
        final plans = snapshot.data ?? [];
        if (plans.isEmpty) {
          return const Center(child: Text('No study plans yet.'));
        }
        return ListView.builder(
          itemCount: plans.length,
          itemBuilder: (context, index) {
            final plan = plans[index];
            return ListTile(
              title: Text(plan.title),
              subtitle:
                  Text('Priority: ${plan.priority} | Due: ${plan.dueDate}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanDetailScreen(plan: plan),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // === Dialogs ===
  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Note'),
        content: SizedBox(
          height: 280,
          child: NoteForm(onSubmit: (name, description) async {
            await Provider.of<AuthService>(context, listen: false)
                .addNote(name, description);
            Navigator.pop(context);
          }),
        ),
      ),
    );
  }

  void _showAddPlanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Study Plan'),
        content: SizedBox(
          height: 400,
          width: 300,
          child: PlanForm(onSaved: () => Navigator.pushNamed(context, RouteManager.mainPage)),
        ),
      ),
    );
  }

  Future<void> _deleteNote(BuildContext context, String noteId) async {
    await Provider.of<AuthService>(context, listen: false).deleteNote(noteId);
  }
}
