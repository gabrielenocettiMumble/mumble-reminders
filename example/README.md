# Mumble Reminders Example App

This example demonstrates how to use the `mumble_reminders` package to create and manage recurring reminders with local notifications in a Flutter application.

## Features Demonstrated

This example app demonstrates:

1. **Reminder Creation with Multiple Frequencies**
   - Daily reminders at specific times
   - Weekly reminders on selected days
   - Monthly reminders on specific days of the month
   - Quarterly reminders

2. **Customizable Notification Content**
   - Set custom titles and messages for reminders
   - Preview how notifications will appear

3. **Complete Reminder Management**
   - View all configured reminders
   - Delete individual reminders
   - Clear all reminders at once

4. **Permission Handling**
   - Notification permissions on iOS and Android
   - Exact alarm permissions on Android

## App Structure

### Setup and Configuration

The app demonstrates how to:
- Create a custom provider extending `RemindersManager`
- Configure Android notification channel settings
- Set up navigation callbacks for handling notification taps
- Initialize the plugin at app startup

```dart
// Example Provider Implementation
class ReminderProvider extends RemindersManager {
  ReminderProvider()
      : super(
          options: ReminderManagerOptions(
            androidOptions: AndroidReminderManagerOptions(
              androidChannelId: 'reminders_channel',
              androidChannelName: 'Reminders',
              defaultDrawableIcon: '@mipmap/ic_launcher',
              useExactAlarm: true,
            ),
          ),
          navigationCallback: (payload) {
            // Handle tapping on notifications
            print('Notification tapped with payload: $payload');
          },
        );
}
```

### User Interface

The app includes specialized widgets for:
- Selecting reminder frequency (daily, weekly, monthly, quarterly)
- Picking days of the week for weekly reminders
- Selecting days of the month, including "last day" option
- Setting notification time
- Viewing and managing existing reminders

## Key Implementation Notes

- The app uses a tab-based UI to separate reminder creation and management
- Demonstrates proper error handling for permissions
- Shows how to use `ListenableBuilder` to keep UI in sync with reminder changes
- Implements form validation for reminder creation
- Uses Material 3 design principles

This example serves as a comprehensive reference implementation of the `mumble_reminders` package, showing how to integrate and use it effectively in a Flutter application.