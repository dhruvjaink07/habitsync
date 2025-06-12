import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitsync/core/color/colors.dart';
import 'package:habitsync/features/auth/domain/user_model.dart';
import 'package:habitsync/features/habits/controller/habit_controller.dart';
import 'package:habitsync/features/habits/domain/habit_model.dart';
import 'package:habitsync/features/habits/widgets/category_button.dart';
import 'package:habitsync/features/habits/widgets/color_emoji_section.dart';
import 'package:habitsync/features/habits/widgets/date_time_repeat_section.dart';
import 'package:habitsync/features/habits/widgets/reminder_collaborator_section.dart';
import 'package:habitsync/services/profile_cache_service.dart';

class AddHabitScreen extends ConsumerStatefulWidget {
  final VoidCallback? onHabitAdded;
  final VoidCallback? onAddCollaborator;
  const AddHabitScreen({super.key, this.onHabitAdded, this.onAddCollaborator});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  String _selectedRepeat = 'Daily';
  bool _reminder = true;
  Color _selectedColor = AppColors.primary;
  final List<String> _repeatOptions = ['Daily', 'Weekly'];
  // final List<String> _permissionOptions = ['Edit', 'View', 'Updates'];
  final List<Color> _colorOptions = [
    AppColors.primary,
    AppColors.readingColor,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.yellow,
  ];

  User? _user;
  List<String> _selectedCollaboratorIds = []; // <-- Add this

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await ProfileCacheService.getCachedUserProfile();
    setState(() {
      _user = user;
    });
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveHabit() async {
    if (_user == null) return; // Or show error

    final habit = Habit.create(
      title: _titleController.text.trim(),
      notes: _notesController.text.trim(),
      ownerId: _user!.id,
      sharedWithIds: _selectedCollaboratorIds, // <-- Use selected collaborators
      repeatPattern: _selectedRepeat.toLowerCase(),
      color: '#${_selectedColor.value.toRadixString(16).padLeft(8, '0')}',
      createdAt: DateTime.now(),
      reminders: _reminder
          ? [
              // Example: combine date and time to a string, or use your own logic
              DateTime(
                _selectedDate.year,
                _selectedDate.month,
                _selectedDate.day,
                _selectedTime.hour,
                _selectedTime.minute,
              ).toIso8601String()
            ]
          : [],
    );

    await ref.read(habitControllerProvider.notifier).createHabit(habit);

    if (mounted) {
      widget.onHabitAdded!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final subTextColor =
        theme.textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.white70;
    final primary = theme.primaryColor;

    String formattedDate = _selectedDate == DateTime.now()
        ? 'Today, ${_selectedDate.month}/${_selectedDate.day}'
        : '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year}';
    String formattedTime = _selectedTime.format(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _HeaderSection(
                  textColor: textColor,
                  subTextColor: subTextColor,
                  theme: theme),
              const SizedBox(height: 24),
              _TitleInputSection(
                controller: _titleController,
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
              ),
              const SizedBox(height: 20),
              const SizedBox(height: 24),
              DateTimeRepeatSection(
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
                formattedDate: formattedDate,
                formattedTime: formattedTime,
                onPickDate: () => _pickDate(context),
                onPickTime: () => _pickTime(context),
                repeatOptions: _repeatOptions,
                selectedRepeat: _selectedRepeat,
                onRepeatSelected: (val) {
                  setState(() {
                    _selectedRepeat = val;
                  });
                },
                primary: primary,
                theme: theme,
              ),
              const SizedBox(height: 18),
              ReminderCollaboratorsPermissionSection(
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
                reminder: _reminder,
                onReminderChanged: (val) {
                  setState(() {
                    _reminder = val;
                  });
                },
                primary: primary,
                theme: theme,
                // Add this callback:
                onCollaboratorsChanged: (ids) {
                  setState(() {
                    _selectedCollaboratorIds = ids;
                  });
                },
                onAddCollaborator: widget.onAddCollaborator,
              ),
              const SizedBox(height: 18),
              ColorEmojiNotesSection(
                theme: theme,
                cardColor: cardColor,
                textColor: textColor,
                subTextColor: subTextColor,
                colorOptions: _colorOptions,
                selectedColor: _selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    _selectedColor = color;
                  });
                },
                notesController: _notesController,
              ),
              const SizedBox(height: 28),
              _SaveButton(
                theme: theme,
                onPressed: _saveHabit,
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// Header Section
class _HeaderSection extends StatelessWidget {
  final Color textColor;
  final Color subTextColor;
  final ThemeData theme;
  const _HeaderSection({
    required this.textColor,
    required this.subTextColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Habit',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Create and share your habit',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: subTextColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Title Input Section
class _TitleInputSection extends StatelessWidget {
  final TextEditingController controller;
  final Color cardColor;
  final Color textColor;
  final Color subTextColor;
  const _TitleInputSection({
    required this.controller,
    required this.cardColor,
    required this.textColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter habit title',
        hintStyle: TextStyle(color: subTextColor.withOpacity(0.5)),
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      style: TextStyle(color: textColor),
    );
  }
}

// Category Section
class _CategorySection extends StatelessWidget {
  final List<String> categories;
  final List<Map<String, dynamic>> categoryIcons;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;
  const _CategorySection({
    required this.categories,
    required this.categoryIcons,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(categories.length, (i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < categories.length - 1 ? 10 : 0),
            child: CategoryButton(
              label: categories[i],
              icon: categoryIcons[i]['icon'],
              selected: selectedCategory == categories[i],
              color: categoryIcons[i]['color'],
              onTap: () => onCategorySelected(categories[i]),
            ),
          ),
        );
      }),
    );
  }
}

// Save Button Section
class _SaveButton extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onPressed;
  const _SaveButton({required this.theme, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    bool isDark = theme.brightness == Brightness.dark;
    final gradient = isDark
        ? AppColors.darkBackgroundGradient
        : AppColors.lightBackgroundGradient;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Habit saved!')),
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              'Save & Share',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 14,
      backgroundColor: Colors.white24,
      child: Icon(Icons.person, color: Colors.white, size: 16),
    );
  }
}
