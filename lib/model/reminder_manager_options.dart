class ReminderManagerOptions {
  final AndroidReminderManagerOptions androidOptions;

  ReminderManagerOptions({
    required this.androidOptions,
  });

  ReminderManagerOptions copyWith({
    AndroidReminderManagerOptions? androidOptions,
  }) {
    return ReminderManagerOptions(
      androidOptions: androidOptions ?? this.androidOptions,
    );
  }
}

class AndroidReminderManagerOptions {
  final String androidChannelId;
  final String androidChannelName;
  final String? androidChannelDescription;
  final String defaultDrawableIcon;
  final bool useExactAlarm;

  AndroidReminderManagerOptions({
    required this.androidChannelId,
    required this.androidChannelName,
    this.androidChannelDescription,
    required this.defaultDrawableIcon,
    this.useExactAlarm = false,
  });

  AndroidReminderManagerOptions copyWith({
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    String? defaultDrawableIcon,
    bool? useExactAlarm,
  }) {
    return AndroidReminderManagerOptions(
      androidChannelId: androidChannelId ?? this.androidChannelId,
      androidChannelName: androidChannelName ?? this.androidChannelName,
      androidChannelDescription:
          androidChannelDescription ?? this.androidChannelDescription,
      defaultDrawableIcon: defaultDrawableIcon ?? this.defaultDrawableIcon,
      useExactAlarm: useExactAlarm ?? this.useExactAlarm,
    );
  }
}
