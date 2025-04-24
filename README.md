# Mumble Reminders

A Flutter package that simplifies scheduling and managing recurring reminders with local notifications. This package provides an abstraction layer over [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications), making it easier to implement reminder functionality in Flutter apps for Mumble.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Multiple Reminder Frequencies**: Daily, weekly, monthly, and quarterly reminders
- **Customizable Content**: Set title and body text for notifications
- **Flexible Scheduling Options**:
  - Daily: Set time of day
  - Weekly: Choose specific days of the week
  - Monthly: Select days of the month or last day
- **Persistent Storage**: Automatic saving and loading of reminder settings
- **Permissions Handling**: Built-in permission requests
- **Cross-Platform**: Works on both Android and iOS
- **Exact Alarms**: Optional exact alarm scheduling on Android

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  mumble_reminders: <latest-version>
```

## Usage

### Setup

1. Create a class extending `RemindersManager` with your configuration:

```dart
class YourReminderProvider extends RemindersManager {
  YourReminderProvider()
      : super(
          options: ReminderManagerOptions(
            androidOptions: AndroidReminderManagerOptions(
              androidChannelId: 'your_channel_id',
              androidChannelName: 'Your Channel Name',
              defaultDrawableIcon: '@mipmap/ic_launcher',
              useExactAlarm: true,
            ),
          ),
          navigationCallback: (payload) {
            // Handle notification tap
          },
        );
}
```

2. Initialize the manager in your app:

```dart
final remindersManager = YourReminderProvider();
await remindersManager.initializePlugin();
```

### Managing Reminders

```dart
// Create/update a reminder
await remindersManager.updateReminderSettings(
  'reminder_id',
  ReminderSettings(
    time: DailyReminderTime(TimeOfDay(hour: 8, minute: 0)),
    content: ReminderContent(
      title: 'Daily Reminder',
      body: 'This is your daily reminder',
    ),
  ),
);

// Get a reminder's settings
ReminderSettings? settings = remindersManager.getReminderSettings('reminder_id');

// Remove a reminder
await remindersManager.removeReminderSettings('reminder_id');

// Clear all reminders
await remindersManager.clearAllReminderSettings();
```

## Platform Configuration

This package builds on Flutter Local Notifications. For complete setup instructions, refer to the [Flutter Local Notifications documentation](https://pub.dev/packages/flutter_local_notifications).

### Android

For detailed Android configuration, see [Flutter Local Notifications Android setup](https://pub.dev/packages/flutter_local_notifications#-android-setup).

### iOS

For detailed iOS configuration, see [Flutter Local Notifications iOS setup](https://pub.dev/packages/flutter_local_notifications#-ios-setup).

## Example

The package includes a complete example app demonstrating:
- Creating reminders with various frequencies
- Customizing notification content
- Managing existing reminders
- Handling permissions

To run the example:

```
cd example
flutter run
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.