import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Stats',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('Habits Completed'),
                trailing: Text('12'),
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.stacked_line_chart, color: Colors.blue),
                title: Text('Current Streak'),
                trailing: Text('5 days'),
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.amber),
                title: Text('Best Streak'),
                trailing: Text('10 days'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
