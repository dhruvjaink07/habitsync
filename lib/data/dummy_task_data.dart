import 'package:habitsync/models/task_model.dart';

class DummyTaskData {
  // Example dummy data for TaskModel

  final List<TaskModel> dummyTasks = [
    TaskModel(
      id: '1',
      title: 'Morning Meditation',
      description: 'Meditate for 10 minutes after waking up.',
      streakCount: 5,
      isShared: true,
    ),
    TaskModel(
      id: '2',
      title: 'Read a Book',
      description: 'Read at least 20 pages of any book.',
      streakCount: 12,
      isShared: false,
    ),
    TaskModel(
      id: '3',
      title: 'Workout',
      description: 'Complete a 30-minute workout session.',
      streakCount: 8,
      isShared: true,
    ),
    TaskModel(
      id: '4',
      title: 'Drink Water',
      description: 'Drink 8 glasses of water.',
      streakCount: 20,
      isShared: false,
    ),
    TaskModel(
      id: '5',
      title: 'Write Journal',
      description: 'Write a daily journal entry.',
      streakCount: 3,
      isShared: true,
    ),
  ];
}
