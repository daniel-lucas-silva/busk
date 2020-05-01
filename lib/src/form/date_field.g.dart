part of 'date_field.dart';

class DatePickerSettings {
  final CupertinoDatePickerMode mode;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final int minimumYear;
  final int maximumYear;
  final int minuteInterval;
  final bool use24hFormat;
  final Color backgroundColor;

  const DatePickerSettings({
    this.mode = CupertinoDatePickerMode.dateAndTime,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear = 1,
    this.maximumYear,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.backgroundColor,
  });

  DatePickerSettings copyWith({
    CupertinoDatePickerMode mode,
    DateTime minimumDate,
    DateTime maximumDate,
    int minimumYear,
    int maximumYear,
    int minuteInterval,
    bool use24hFormat,
    Color backgroundColor,
  }) {
    return DatePickerSettings(
      mode: mode ?? this.mode,
      minimumDate: minimumDate ?? this.minimumDate,
      maximumDate: maximumDate ?? this.maximumDate,
      minimumYear: minimumYear ?? this.minimumYear,
      maximumYear: maximumYear ?? this.maximumYear,
      minuteInterval: minuteInterval ?? this.minuteInterval,
      use24hFormat: use24hFormat ?? this.use24hFormat,
      backgroundColor: backgroundColor ?? this.backgroundColor,
    );
  }
}