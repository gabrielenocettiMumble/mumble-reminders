class ReminderContent {
  final String title;
  final String? body;

  const ReminderContent({required this.title, this.body});

  factory ReminderContent.fromDbMap(Map<String, dynamic> map) {
    String title = map['title'];
    String? body = map['body'];

    return ReminderContent(
      title: title,
      body: body,
    );
  }

  ReminderContent copyWith({
    String? title,
    String? body,
  }) {
    return ReminderContent(
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  Map<String, dynamic> toDbMap() => {
        'title': title,
        'body': body,
      };

  @override
  String toString() {
    return 'ReminderContent{title: $title, body: $body}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderContent &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          body == other.body;

  @override
  int get hashCode => title.hashCode ^ body.hashCode;
}
