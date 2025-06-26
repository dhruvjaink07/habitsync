import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:habitsync/features/friends/screen/friend_screen.dart';
import 'package:habitsync/features/habits/data/habit_service.dart';
import 'package:habitsync/features/habits/screens/add_habit_screen.dart';
import 'package:habitsync/features/home/screen/home_screen.dart';
import 'package:habitsync/features/profile/screen/profile_screen.dart';
import 'package:habitsync/features/stats/screen/stats_screen.dart';
import 'package:habitsync/widgets/bottom_navigation_bar.dart';

void setupConnectivitySync() {
  Connectivity().onConnectivityChanged.listen((result) {
    if (result != ConnectivityResult.none) {
      HabitService().syncPendingCompletions();
    }
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    setupConnectivitySync(); // Start connectivity sync listener
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Pass the callback to ProfileScreen
    final pages = [
      HomeScreen(
        onProfileTap: () => _onItemTapped(4),
        onAddHabitTap: () => _onItemTapped(1),
      ),
      AddHabitScreen(
        onHabitAdded: () => _onItemTapped(0),
        onAddCollaborator: () => _onItemTapped(3),
      ),
      const StatsScreen(),
      const FriendsScreen(),
      ProfileScreen(
        onAddHabitTap: () => _onItemTapped(1),
        onAddFriendTap: () => _onItemTapped(3),
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        isDark: isDark,
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
