import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF181A20) : const Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: const Text('My Insights',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Top stats row
          Row(
            children: [
              _StatCard(
                icon: Icons.local_fire_department,
                iconColor: Colors.deepOrange,
                value: '21',
                label: 'Day Streak',
              ),
              const SizedBox(width: 16),
              _StatCard(
                icon: Icons.circle_outlined,
                iconColor: Colors.blue,
                value: '89%',
                label: 'This Week',
                ring: true,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(), // Placeholder for additional card
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Weekly Activity
          const Text(
            'Weekly Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _WeeklyBarChart(),
          const SizedBox(height: 32),
          // Your Habits
          const Text(
            'Your Habits',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _HabitProgressCard(
            icon: Icons.directions_run,
            iconColor: Colors.deepPurple,
            title: 'Morning Run',
            streak: 12,
            percent: 0.85,
          ),
          _HabitProgressCard(
            icon: Icons.spa,
            iconColor: Colors.green,
            title: 'Meditation',
            streak: 21,
            percent: 0.92,
          ),
          _HabitProgressCard(
            icon: Icons.menu_book,
            iconColor: Colors.orange,
            title: 'Reading',
            streak: 8,
            percent: 0.75,
          ),
          _HabitProgressCard(
            icon: Icons.water,
            iconColor: Colors.blue,
            title: 'Water Intake',
            streak: 15,
            percent: 0.88,
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  final bool ring;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
    this.ring = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    return Expanded(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ring
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 32,
                        height: 32,
                        child: CircularProgressIndicator(
                          value: 0.89,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                          backgroundColor: iconColor.withOpacity(0.15),
                        ),
                      ),
                      Text(
                        value,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  )
                : Icon(icon, color: iconColor, size: 28),
            const SizedBox(height: 8),
            if (!ring)
              Text(
                value,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart();

  @override
  Widget build(BuildContext context) {
    final barColor = Colors.blue.shade700;
    final data = [80, 90, 75, 95, 85, 65, 80];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(7, (i) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    height: data[i].toDouble(),
                    width: 18,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    days[i],
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _HabitProgressCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final int streak;
  final double percent;

  const _HabitProgressCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.streak,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.12),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: textColor)),
                Text(
                  '$streak day streak',
                  style: TextStyle(
                      fontSize: 13, color: textColor?.withOpacity(0.7)),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 6,
                    backgroundColor: iconColor.withOpacity(0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(iconColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${(percent * 100).toInt()}%',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}
