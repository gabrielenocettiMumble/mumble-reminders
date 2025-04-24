import 'package:flutter/material.dart';
import 'package:mumble_reminders_example/providers/providers.dart';
import 'package:mumble_reminders_example/widgets/reminder_creator_widget.dart';
import 'package:mumble_reminders_example/widgets/reminder_logger_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Mumble Reminders"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.add_alert), text: "Create"),
            Tab(icon: Icon(Icons.list), text: "Reminders"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear all reminders',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear all reminders'),
                  content: const Text('Are you sure you want to delete all reminders?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Providers.remindersManager.clearAllReminderSettings();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('All reminders cleared'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Create Tab
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Create a New Reminder',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const ReminderCreatorWidget(),
              ],
            ),
          ),
          
          // Reminders Tab (Logger)
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text(
                  'Configured Reminders',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const ReminderLoggerWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}