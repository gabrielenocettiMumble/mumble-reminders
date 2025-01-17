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

  AndroidReminderManagerOptions({
    required this.androidChannelId,
    required this.androidChannelName,
    this.androidChannelDescription,
    required this.defaultDrawableIcon,
  });

  AndroidReminderManagerOptions copyWith({
    String? androidChannelId,
    String? androidChannelName,
    String? androidChannelDescription,
    String? defaultDrawableIcon,
  }) {
    return AndroidReminderManagerOptions(
      androidChannelId: androidChannelId ?? this.androidChannelId,
      androidChannelName: androidChannelName ?? this.androidChannelName,
      androidChannelDescription:
          androidChannelDescription ?? this.androidChannelDescription,
      defaultDrawableIcon: defaultDrawableIcon ?? this.defaultDrawableIcon,
    );
  }
}
