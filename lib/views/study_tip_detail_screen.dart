//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/models/study_tip.dart';
import 'package:flutter/material.dart';


class StudyTipDetailScreen extends StatelessWidget {
  final StudyTip tip;

  const StudyTipDetailScreen({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final authService = Provider.of<AuthService>(context);

    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Back to list'),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(tip.title!),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tip.category,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tip.title!,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tips:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: tip.tips.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.check_circle_outline,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      tip.tips[index],
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
