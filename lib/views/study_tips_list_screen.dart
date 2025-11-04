//
// Rethabile Erick Siase
// github.com/2004
// https://www.linkedin.com/in/rethabile-eric-siase-6199a131a
//

import 'package:firebase_flutter/models/study_tip.dart';
import 'package:firebase_flutter/views/study_tip_detail_screen.dart';
import 'package:flutter/material.dart';

final List<StudyTip> studyTips = [
  StudyTip(
    id: 'exam_stress',
    title: 'Dealing with Exam Stress',
    category: 'Well-being',
    preview:
        'Reduce anxiety and perform your best during exams with these tips.',
    tips: [
      'Prepare early to avoid last-minute cramming and panic.',
      'Practice relaxation techniques like deep breathing or meditation.',
      'Maintain a consistent sleep schedule before exams.',
      'Avoid caffeine overload; hydrate with water instead.',
      'Remind yourself that progress matters more than perfection.',
    ],
  ),

  StudyTip(
    id: 'time_management',
    title: 'Time Management for Students',
    category: 'Productivity',
    preview: 'Learn to manage your study schedule efficiently.',
    tips: [
      'Use a planner or digital calendar to schedule study blocks.',
      'Prioritize tasks using the Eisenhower Matrix (urgent vs. important).',
      'Set specific goals for each session to stay focused.',
      'Take 5–10 minute breaks after every 45 minutes of study.',
      'Avoid multitasking—focus on one subject at a time.',
    ],
  ),

  StudyTip(
    id: 'note_taking',
    title: 'Effective Note-Taking Techniques',
    category: 'Study Skills',
    preview: 'Improve retention with structured and organized notes.',
    tips: [
      'Use the Cornell method to divide notes into key ideas and summaries.',
      'Highlight or underline key concepts after class, not during.',
      'Rewrite notes in your own words to aid understanding.',
      'Organize notes by topic and date for easy revision.',
      'Use color coding for definitions, examples, and key points.',
    ],
  ),

  StudyTip(
    id: 'focus_concentration',
    title: 'Improving Focus and Concentration',
    category: 'Productivity',
    preview:
        'Boost your attention span and reduce distractions while studying.',
    tips: [
      'Study in a quiet, clutter-free environment.',
      'Use the Pomodoro Technique (25 mins study, 5 mins rest).',
      'Put your phone in another room or use focus apps.',
      'Study at your most productive time of day.',
      'Eat light meals and stay hydrated to maintain energy levels.',
    ],
  ),

  StudyTip(
    id: 'memorization',
    title: 'Memory-Boosting Study Methods',
    category: 'Cognitive Skills',
    preview: 'Enhance recall using proven memory techniques.',
    tips: [
      'Use mnemonic devices to link new info with familiar ideas.',
      'Practice spaced repetition instead of mass memorization.',
      'Visualize information using charts, images, or mind maps.',
      'Teach others to reinforce memory retention.',
      'Sleep well—your brain consolidates memory during rest.',
    ],
  ),

  StudyTip(
    id: 'group_study',
    title: 'Maximize Group Study Sessions',
    category: 'Collaboration',
    preview: 'Work effectively in study groups for better results.',
    tips: [
      'Keep groups small (3–5 people) to stay organized.',
      'Assign roles like note-taker or discussion leader.',
      'Set clear goals before each session.',
      'Review each other’s understanding through questions.',
      'Summarize the session’s key takeaways together.',
    ],
  ),

  StudyTip(
    id: 'exam_prep',
    title: 'Smart Exam Preparation',
    category: 'Exams',
    preview: 'Prepare efficiently and confidently for any test.',
    tips: [
      'Start revision at least two weeks before the exam date.',
      'Focus on weak topics but review strong ones briefly.',
      'Simulate exam conditions by timing practice tests.',
      'Use past papers to understand question patterns.',
      'Review mistakes carefully to avoid repeating them.',
    ],
  ),

  StudyTip(
    id: 'essay_writing',
    title: 'Improving Essay Writing Skills',
    category: 'Writing',
    preview: 'Craft strong, well-structured essays with these tips.',
    tips: [
      'Plan your essay before writing: introduction, body, and conclusion.',
      'Use topic sentences to guide readers through each paragraph.',
      'Support arguments with credible evidence and examples.',
      'Edit and proofread for clarity, grammar, and flow.',
      'Read sample essays to understand good structure and tone.',
    ],
  ),

  StudyTip(
    id: 'public_speaking',
    title: 'Mastering Presentations and Public Speaking',
    category: 'Communication',
    preview: 'Speak confidently and clearly in academic presentations.',
    tips: [
      'Practice aloud multiple times before presenting.',
      'Use cue cards instead of reading slides verbatim.',
      'Make eye contact and engage your audience.',
      'Control your breathing to stay calm.',
      'Start with a story or question to capture interest.',
    ],
  ),

  StudyTip(
    id: 'online_learning',
    title: 'Thriving in Online Classes',
    category: 'Digital Learning',
    preview: 'Stay engaged and productive while learning remotely.',
    tips: [
      'Create a dedicated workspace for studying.',
      'Participate actively in discussions or forums.',
      'Keep your camera on to stay accountable.',
      'Take handwritten notes during online lectures.',
      'Schedule breaks away from screens to rest your eyes.',
    ],
  ),

  StudyTip(
    id: 'critical_thinking',
    title: 'Developing Critical Thinking Skills',
    category: 'Learning Strategies',
    preview: 'Learn to question, analyze, and reason effectively.',
    tips: [
      'Ask “why” and “how” questions about key ideas.',
      'Compare multiple viewpoints before forming conclusions.',
      'Use evidence to support or challenge arguments.',
      'Reflect on your reasoning process after solving problems.',
      'Discuss topics with peers to broaden perspectives.',
    ],
  ),

  StudyTip(
    id: 'reading_comprehension',
    title: 'Enhance Reading Comprehension',
    category: 'Reading',
    preview: 'Understand and retain more from what you read.',
    tips: [
      'Preview headings and summaries before deep reading.',
      'Highlight key ideas sparingly to avoid clutter.',
      'Pause after each section to summarize mentally.',
      'Ask questions while reading to stay engaged.',
      'Revisit challenging parts instead of skipping them.',
    ],
  ),

  StudyTip(
    id: 'science_learning',
    title: 'Excelling in Science Subjects',
    category: 'Science',
    preview: 'Study smarter in physics, chemistry, and biology.',
    tips: [
      'Understand experiments conceptually, not just procedurally.',
      'Draw diagrams and label components clearly.',
      'Use analogies to relate concepts to real life.',
      'Memorize formulas with examples, not in isolation.',
      'Practice applying theories to different scenarios.',
    ],
  ),

  StudyTip(
    id: 'language_learning',
    title: 'Mastering a New Language',
    category: 'Languages',
    preview: 'Accelerate your progress with effective language techniques.',
    tips: [
      'Immerse yourself by listening to native speakers daily.',
      'Use flashcards or spaced repetition apps for vocabulary.',
      'Speak out loud—even when alone—to build fluency.',
      'Learn grammar through context instead of rote rules.',
      'Watch movies or read books in the target language.',
    ],
  ),

  StudyTip(
    id: 'motivation',
    title: 'Staying Motivated to Study',
    category: 'Mindset',
    preview: 'Maintain discipline and enthusiasm throughout your semester.',
    tips: [
      'Set achievable short-term goals to track progress.',
      'Reward yourself after completing difficult tasks.',
      'Visualize success and the reasons you started studying.',
      'Study with a friend to stay accountable.',
      'Focus on improvement, not perfection.',
    ],
  ),

  StudyTip(
    id: 'test_anxiety',
    title: 'Overcoming Test Anxiety',
    category: 'Well-being',
    preview: 'Stay calm and focused during exams with these techniques.',
    tips: [
      'Prepare thoroughly to build confidence.',
      'Arrive early to avoid last-minute rush.',
      'Use deep breathing to relax before the test starts.',
      'Focus on one question at a time, not the whole paper.',
      'Replace negative thoughts with positive affirmations.',
    ],
  ),

  StudyTip(
    id: 'self_discipline',
    title: 'Building Self-Discipline for Study Success',
    category: 'Personal Development',
    preview: 'Train your mind to stay consistent and productive.',
    tips: [
      'Create a daily routine and stick to it.',
      'Eliminate distractions like phone notifications.',
      'Track your study time using habit-tracking apps.',
      'Set realistic goals and celebrate progress.',
      'Reflect weekly on what worked and what didn’t.',
    ],
  ),

  StudyTip(
    id: 'research_skills',
    title: 'Sharpen Your Research Skills',
    category: 'Academics',
    preview: 'Gather and evaluate academic information effectively.',
    tips: [
      'Use reliable databases like Google Scholar or JSTOR.',
      'Evaluate sources for credibility and bias.',
      'Take notes on citations for easy referencing.',
      'Summarize findings instead of copying directly.',
      'Synthesize information across multiple sources.',
    ],
  ),

  StudyTip(
    id: 'procrastination',
    title: 'Beat Procrastination',
    category: 'Productivity',
    preview: 'Stop delaying tasks and take consistent action.',
    tips: [
      'Break tasks into smaller, less intimidating chunks.',
      'Start with a 5-minute commitment to overcome inertia.',
      'Eliminate distractions from your workspace.',
      'Track progress visually using checklists or progress bars.',
      'Reward yourself for finishing tasks promptly.',
    ],
  ),

  StudyTip(
    id: 'goal_setting',
    title: 'Setting and Achieving Study Goals',
    category: 'Motivation',
    preview: 'Turn your academic dreams into actionable steps.',
    tips: [
      'Set SMART goals: Specific, Measurable, Achievable, Relevant, Time-bound.',
      'Write your goals down to stay accountable.',
      'Review your goals weekly and adjust as needed.',
      'Celebrate milestones to stay motivated.',
      'Focus on habits that lead to long-term success.',
    ],
  ),

  StudyTip(
    id: 'theory',
    title: 'Mastering Theory Subjects',
    category: 'Theory',
    preview:
        'Learn how to study theory-heavy subjects effectively with these concise tips.',
    tips: [
      'Break content into small sections and summarize each in your own words.',
      'Use active recall: test yourself on key concepts without looking at notes.',
      'Create mind maps to connect related ideas and improve retention.',
      'Schedule regular review sessions to reinforce long-term memory.',
      'Teach concepts to a peer to solidify your understanding.',
    ],
  ),
  StudyTip(
    id: 'math',
    title: 'Effective Math Study Strategies',
    category: 'Mathematics',
    preview:
        'Tackle math with confidence using these practical study techniques.',
    tips: [
      'Practice problems daily to build problem-solving skills.',
      'Understand the theory behind formulas before memorizing them.',
      'Work through mistakes step-by-step to identify errors.',
      'Use visual aids like graphs or diagrams to grasp abstract concepts.',
      'Group similar problems to recognize patterns and shortcuts.',
      'Take short breaks to maintain focus during long study sessions.',
    ],
  ),
  StudyTip(
    id: 'coding',
    title: 'Boost Your Coding Skills',
    category: 'Coding',
    preview: 'Improve your programming abilities with these focused tips.',
    tips: [
      'Code daily to build muscle memory and familiarity with syntax.',
      'Break down complex problems into smaller, manageable parts.',
      'Debug systematically: test small code segments to isolate issues.',
      'Read others’ code on platforms like GitHub to learn new approaches.',
      'Build small projects to apply concepts in real-world scenarios.',
    ],
  ),
];

class StudyTipsListScreen extends StatefulWidget {
  const StudyTipsListScreen({super.key});

  @override
  State<StudyTipsListScreen> createState() => _StudyTipsListScreenState();
}

class _StudyTipsListScreenState extends State<StudyTipsListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter tips based on search query
    final filteredTips = studyTips
        .where((tip) =>
            tip.title!.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Study Tips'),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by title...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // 🧾 List of Filtered Tips
          Expanded(
            child: filteredTips.isEmpty
                ? const Center(
                    child: Text(
                      'No matching tips found.',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    itemCount: filteredTips.length,
                    itemBuilder: (context, index) {
                      final tip = filteredTips[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          title: Text(
                            tip.title!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            '${tip.category} • ${tip.preview}',
                            style: theme.textTheme.bodySmall,
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudyTipDetailScreen(tip: tip),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
