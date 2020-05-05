import 'dart:math' as math;

import 'package:busk/theme.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../intl/localizations.dart';
import '../picker.dart';

const double _kItemExtent = 32.0;

const double _kPickerWidth = 320.0;
const double _kPickerHeight = 216.0;
const bool _kUseMagnifier = true;
const double _kMagnification = 2.35 / 2.1;
const double _kDatePickerPadSize = 15.0;

const double _kSqueeze = 1.25;

const Color _kBackgroundColor = Colors.white;

const TextStyle _kDefaultPickerTextStyle = TextStyle(
  letterSpacing: -0.83,
);

const double _kTimerPickerHalfColumnPadding = 2;

const double _kTimerPickerLabelPadSize = 4.5;
const double _kTimerPickerLabelFontSize = 17.0;

const double _kTimerPickerColumnIntrinsicWidth = 106;

const double _kTimerPickerNumberLabelFontSize = 23;

TextStyle _themeTextStyle(BuildContext context, {bool isValid = true}) {
  final TextStyle style =
      CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle;
  return isValid
      ? style
      : style.copyWith(
          color: DynamicColor.resolve(
              Colors.inactiveGray, context));
}

class _DatePickerLayoutDelegate extends MultiChildLayoutDelegate {
  _DatePickerLayoutDelegate({
    @required this.columnWidths,
    @required this.textDirectionFactor,
  })  : assert(columnWidths != null),
        assert(textDirectionFactor != null);

  final List<double> columnWidths;

  final int textDirectionFactor;

  @override
  void performLayout(Size size) {
    double remainingWidth = size.width;

    for (int i = 0; i < columnWidths.length; i++)
      remainingWidth -= columnWidths[i] + _kDatePickerPadSize * 2;

    double currentHorizontalOffset = 0.0;

    for (int i = 0; i < columnWidths.length; i++) {
      final int index =
          textDirectionFactor == 1 ? i : columnWidths.length - i - 1;

      double childWidth = columnWidths[index] + _kDatePickerPadSize * 2;
      if (index == 0 || index == columnWidths.length - 1)
        childWidth += remainingWidth / 2;

      assert(() {
        if (childWidth < 0) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: FlutterError(
                'Insufficient horizontal space to render the '
                'CupertinoDatePicker because the parent is too narrow at '
                '${size.width}px.\n'
                'An additional ${-remainingWidth}px is needed to avoid '
                'overlapping columns.',
              ),
            ),
          );
        }
        return true;
      }());
      layoutChild(index,
          BoxConstraints.tight(Size(math.max(0.0, childWidth), size.height)));
      positionChild(index, Offset(currentHorizontalOffset, 0.0));

      currentHorizontalOffset += childWidth;
    }
  }

  @override
  bool shouldRelayout(_DatePickerLayoutDelegate oldDelegate) {
    return columnWidths != oldDelegate.columnWidths ||
        textDirectionFactor != oldDelegate.textDirectionFactor;
  }
}

enum CupertinoDatePickerMode {
  time,
  date,
  dateAndTime,
}

enum _PickerColumnType {
  dayOfMonth,
  month,
  year,
  date,
  hour,
  minute,
  dayPeriod,
}

class CupertinoDatePicker extends StatefulWidget {
  CupertinoDatePicker({
    this.mode = CupertinoDatePickerMode.dateAndTime,
    @required this.onDateTimeChanged,
    DateTime initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.minimumYear = 1,
    this.maximumYear,
    this.minuteInterval = 1,
    this.use24hFormat = false,
    this.backgroundColor = _kBackgroundColor,
  })  : initialDateTime = initialDateTime ?? DateTime.now(),
        assert(mode != null),
        assert(onDateTimeChanged != null),
        assert(minimumYear != null),
        assert(backgroundColor != null),
        assert(
          minuteInterval > 0 && 60 % minuteInterval == 0,
          'minute interval is not a positive integer factor of 60',
        ) {
    assert(this.initialDateTime != null);
    assert(
      mode != CupertinoDatePickerMode.dateAndTime ||
          minimumDate == null ||
          !this.initialDateTime.isBefore(minimumDate),
      'initial date is before minimum date',
    );
    assert(
      mode != CupertinoDatePickerMode.dateAndTime ||
          maximumDate == null ||
          !this.initialDateTime.isAfter(maximumDate),
      'initial date is after maximum date',
    );
    assert(
      mode != CupertinoDatePickerMode.date ||
          (minimumYear >= 1 && this.initialDateTime.year >= minimumYear),
      'initial year is not greater than minimum year, or mininum year is not positive',
    );
    assert(
      mode != CupertinoDatePickerMode.date ||
          maximumYear == null ||
          this.initialDateTime.year <= maximumYear,
      'initial year is not smaller than maximum year',
    );
    assert(
      mode != CupertinoDatePickerMode.date ||
          minimumDate == null ||
          !minimumDate.isAfter(this.initialDateTime),
      'initial date ${this.initialDateTime} is not greater than or euqal to minimumDate $minimumDate',
    );
    assert(
      mode != CupertinoDatePickerMode.date ||
          maximumDate == null ||
          !maximumDate.isBefore(this.initialDateTime),
      'initial date ${this.initialDateTime} is not less than or euqal to maximumDate $maximumDate',
    );
    assert(
      this.initialDateTime.minute % minuteInterval == 0,
      'initial minute is not divisible by minute interval',
    );
  }

  final CupertinoDatePickerMode mode;
  final DateTime initialDateTime;
  final DateTime minimumDate;
  final DateTime maximumDate;
  final int minimumYear;
  final int maximumYear;
  final int minuteInterval;
  final bool use24hFormat;
  final ValueChanged<DateTime> onDateTimeChanged;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() {
    switch (mode) {
      case CupertinoDatePickerMode.time:
      case CupertinoDatePickerMode.dateAndTime:
        return _CupertinoDatePickerDateTimeState();
      case CupertinoDatePickerMode.date:
        return _CupertinoDatePickerDateState();
    }

    assert(false);
    return _CupertinoDatePickerDateTimeState();
  }

  static double _getColumnWidth(
    _PickerColumnType columnType,
    CupertinoLocalizations localizations,
    BuildContext context,
  ) {
    String longestText = '';

    switch (columnType) {
      case _PickerColumnType.date:
        for (int i = 1; i <= 12; i++) {
          final String date =
              localizations.datePickerMediumDate(DateTime(2018, i, 25));
          if (longestText.length < date.length) longestText = date;
        }
        break;
      case _PickerColumnType.hour:
        for (int i = 0; i < 24; i++) {
          final String hour = localizations.datePickerHour(i);
          if (longestText.length < hour.length) longestText = hour;
        }
        break;
      case _PickerColumnType.minute:
        for (int i = 0; i < 60; i++) {
          final String minute = localizations.datePickerMinute(i);
          if (longestText.length < minute.length) longestText = minute;
        }
        break;
      case _PickerColumnType.dayPeriod:
        longestText = localizations.anteMeridiemAbbreviation.length >
                localizations.postMeridiemAbbreviation.length
            ? localizations.anteMeridiemAbbreviation
            : localizations.postMeridiemAbbreviation;
        break;
      case _PickerColumnType.dayOfMonth:
        for (int i = 1; i <= 31; i++) {
          final String dayOfMonth = localizations.datePickerDayOfMonth(i);
          if (longestText.length < dayOfMonth.length) longestText = dayOfMonth;
        }
        break;
      case _PickerColumnType.month:
        for (int i = 1; i <= 12; i++) {
          final String month = localizations.datePickerMonth(i);
          if (longestText.length < month.length) longestText = month;
        }
        break;
      case _PickerColumnType.year:
        longestText = localizations.datePickerYear(2018);
        break;
    }

    assert(longestText != '', 'column type is not appropriate');

    final TextPainter painter = TextPainter(
      text: TextSpan(
        style: _themeTextStyle(context),
        text: longestText,
      ),
      textDirection: Directionality.of(context),
    );

    painter.layout();

    return painter.maxIntrinsicWidth;
  }
}

typedef _ColumnBuilder = Widget Function(
    double offAxisFraction, TransitionBuilder itemPositioningBuilder);

class _CupertinoDatePickerDateTimeState extends State<CupertinoDatePicker> {
  static const double _kMaximumOffAxisFraction = 0.45;

  int textDirectionFactor;
  CupertinoLocalizations localizations;
  Alignment alignCenterLeft;
  Alignment alignCenterRight;
  DateTime initialDateTime;
  int selectedDayFromInitial;
  int selectedHour;
  int previousHourIndex;
  int selectedMinute;
  int selectedAmPm;
  FixedExtentScrollController amPmController;

  final Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    initialDateTime = widget.initialDateTime;
    selectedDayFromInitial = 0;
    selectedHour = widget.initialDateTime.hour;
    selectedMinute = widget.initialDateTime.minute;
    selectedAmPm = 0;

    if (!widget.use24hFormat) {
      selectedAmPm = selectedHour ~/ 12;
      selectedHour = selectedHour % 12;
      if (selectedHour == 0) selectedHour = 12;

      amPmController = FixedExtentScrollController(initialItem: selectedAmPm);
    }

    previousHourIndex = selectedHour;

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      estimatedColumnWidths.clear();
    });
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(
      oldWidget.mode == widget.mode,
      "The CupertinoDatePicker's mode cannot change once it's built",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    estimatedColumnWidths.clear();
  }

  double _getEstimatedColumnWidth(_PickerColumnType columnType) {
    if (estimatedColumnWidths[columnType.index] == null) {
      estimatedColumnWidths[columnType.index] =
          CupertinoDatePicker._getColumnWidth(
              columnType, localizations, context);
    }

    return estimatedColumnWidths[columnType.index];
  }

  DateTime _getDateTime() {
    final DateTime date = DateTime(
      initialDateTime.year,
      initialDateTime.month,
      initialDateTime.day,
    ).add(Duration(days: selectedDayFromInitial));

    return DateTime(
      date.year,
      date.month,
      date.day,
      widget.use24hFormat
          ? selectedHour
          : selectedHour % 12 + selectedAmPm * 12,
      selectedMinute,
    );
  }

  Widget _buildMediumDatePicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return CupertinoPicker.builder(
      scrollController:
          FixedExtentScrollController(initialItem: selectedDayFromInitial),
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      useMagnifier: _kUseMagnifier,
      magnification: _kMagnification,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        selectedDayFromInitial = index;
        widget.onDateTimeChanged(_getDateTime());
      },
      itemBuilder: (BuildContext context, int index) {
        final DateTime dateTime = DateTime(
          initialDateTime.year,
          initialDateTime.month,
          initialDateTime.day,
        ).add(Duration(days: index));

        if (widget.minimumDate != null && dateTime.isBefore(widget.minimumDate))
          return null;
        if (widget.maximumDate != null && dateTime.isAfter(widget.maximumDate))
          return null;

        final DateTime now = DateTime.now();
        String dateText;

        if (dateTime == DateTime(now.year, now.month, now.day)) {
          dateText = localizations.todayLabel;
        } else {
          dateText = localizations.datePickerMediumDate(dateTime);
        }

        return itemPositioningBuilder(
          context,
          Text(
            dateText,
            style: _themeTextStyle(context),
          ),
        );
      },
    );
  }

  Widget _buildHourPicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: selectedHour),
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      useMagnifier: _kUseMagnifier,
      magnification: _kMagnification,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        if (widget.use24hFormat) {
          selectedHour = index;
          widget.onDateTimeChanged(_getDateTime());
        } else {
          selectedHour = index % 12;

          final bool wasAm = previousHourIndex >= 0 && previousHourIndex <= 11;
          final bool isAm = index >= 0 && index <= 11;

          if (wasAm != isAm) {
            amPmController.animateToItem(
              1 - amPmController.selectedItem,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else {
            widget.onDateTimeChanged(_getDateTime());
          }
        }

        previousHourIndex = index;
      },
      children: List<Widget>.generate(24, (int index) {
        int hour = index;
        if (!widget.use24hFormat) hour = hour % 12 == 0 ? 12 : hour % 12;

        return itemPositioningBuilder(
          context,
          Text(
            localizations.datePickerHour(hour),
            semanticsLabel: localizations.datePickerHourSemanticsLabel(hour),
            style: _themeTextStyle(context),
          ),
        );
      }),
      looping: true,
    );
  }

  Widget _buildMinutePicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
          initialItem: selectedMinute ~/ widget.minuteInterval),
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      useMagnifier: _kUseMagnifier,
      magnification: _kMagnification,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        selectedMinute = index * widget.minuteInterval;
        widget.onDateTimeChanged(_getDateTime());
      },
      children: List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
        final int minute = index * widget.minuteInterval;
        return itemPositioningBuilder(
          context,
          Text(
            localizations.datePickerMinute(minute),
            semanticsLabel:
                localizations.datePickerMinuteSemanticsLabel(minute),
            style: _themeTextStyle(context),
          ),
        );
      }),
      looping: true,
    );
  }

  Widget _buildAmPmPicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return CupertinoPicker(
      scrollController: amPmController,
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      useMagnifier: _kUseMagnifier,
      magnification: _kMagnification,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        selectedAmPm = index;
        widget.onDateTimeChanged(_getDateTime());
      },
      children: List<Widget>.generate(2, (int index) {
        return itemPositioningBuilder(
          context,
          Text(
            index == 0
                ? localizations.anteMeridiemAbbreviation
                : localizations.postMeridiemAbbreviation,
            style: _themeTextStyle(context),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<double> columnWidths = <double>[
      _getEstimatedColumnWidth(_PickerColumnType.hour),
      _getEstimatedColumnWidth(_PickerColumnType.minute),
    ];
    final List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[
      _buildHourPicker,
      _buildMinutePicker,
    ];

    if (!widget.use24hFormat) {
      if (localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.date_time_dayPeriod ||
          localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.time_dayPeriod_date) {
        pickerBuilders.add(_buildAmPmPicker);
        columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      } else {
        pickerBuilders.insert(0, _buildAmPmPicker);
        columnWidths.insert(
            0, _getEstimatedColumnWidth(_PickerColumnType.dayPeriod));
      }
    }

    if (widget.mode == CupertinoDatePickerMode.dateAndTime) {
      if (localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.time_dayPeriod_date ||
          localizations.datePickerDateTimeOrder ==
              DatePickerDateTimeOrder.dayPeriod_time_date) {
        pickerBuilders.add(_buildMediumDatePicker);
        columnWidths.add(_getEstimatedColumnWidth(_PickerColumnType.date));
      } else {
        pickerBuilders.insert(0, _buildMediumDatePicker);
        columnWidths.insert(
            0, _getEstimatedColumnWidth(_PickerColumnType.date));
      }
    }

    final List<Widget> pickers = <Widget>[];

    for (int i = 0; i < columnWidths.length; i++) {
      double offAxisFraction = 0.0;
      if (i == 0)
        offAxisFraction = -_kMaximumOffAxisFraction * textDirectionFactor;
      else if (i >= 2 || columnWidths.length == 2)
        offAxisFraction = _kMaximumOffAxisFraction * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (i == columnWidths.length - 1) padding = padding.flipped;
      if (textDirectionFactor == -1) padding = padding.flipped;

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: padding,
              child: Container(
                alignment: i == columnWidths.length - 1
                    ? alignCenterLeft
                    : alignCenterRight,
                width: i == 0 || i == columnWidths.length - 1
                    ? null
                    : columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
        ),
      ));
    }

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

class _CupertinoDatePickerDateState extends State<CupertinoDatePicker> {
  int textDirectionFactor;
  CupertinoLocalizations localizations;
  Alignment alignCenterLeft;
  Alignment alignCenterRight;
  int selectedDay;
  int selectedMonth;
  int selectedYear;
  FixedExtentScrollController dayController;
  FixedExtentScrollController monthController;
  FixedExtentScrollController yearController;
  bool isDayPickerScrolling = false;
  bool isMonthPickerScrolling = false;
  bool isYearPickerScrolling = false;

  bool get isScrolling =>
      isDayPickerScrolling || isMonthPickerScrolling || isYearPickerScrolling;

  Map<int, double> estimatedColumnWidths = <int, double>{};

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDateTime.day;
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;

    dayController = FixedExtentScrollController(initialItem: selectedDay - 1);
    monthController =
        FixedExtentScrollController(initialItem: selectedMonth - 1);
    yearController = FixedExtentScrollController(initialItem: selectedYear);

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      _refreshEstimatedColumnWidths();
    });
  }

  @override
  void dispose() {
    dayController.dispose();
    monthController.dispose();
    yearController.dispose();

    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirectionFactor =
        Directionality.of(context) == TextDirection.ltr ? 1 : -1;
    localizations = CupertinoLocalizations.of(context);

    alignCenterLeft =
        textDirectionFactor == 1 ? Alignment.centerLeft : Alignment.centerRight;
    alignCenterRight =
        textDirectionFactor == 1 ? Alignment.centerRight : Alignment.centerLeft;

    _refreshEstimatedColumnWidths();
  }

  void _refreshEstimatedColumnWidths() {
    estimatedColumnWidths[_PickerColumnType.dayOfMonth.index] =
        CupertinoDatePicker._getColumnWidth(
            _PickerColumnType.dayOfMonth, localizations, context);
    estimatedColumnWidths[_PickerColumnType.month.index] =
        CupertinoDatePicker._getColumnWidth(
            _PickerColumnType.month, localizations, context);
    estimatedColumnWidths[_PickerColumnType.year.index] =
        CupertinoDatePicker._getColumnWidth(
            _PickerColumnType.year, localizations, context);
  }

  DateTime _lastDayInMonth(int year, int month) => DateTime(year, month + 1, 0);

  Widget _buildDayPicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    final int daysInCurrentMonth =
        _lastDayInMonth(selectedYear, selectedMonth).day;
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isDayPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isDayPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: dayController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedDay = index + 1;
          if (_isCurrentDateValid)
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
        },
        children: List<Widget>.generate(31, (int index) {
          final int day = index + 1;
          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerDayOfMonth(day),
              style:
                  _themeTextStyle(context, isValid: day <= daysInCurrentMonth),
            ),
          );
        }),
        looping: true,
      ),
    );
  }

  Widget _buildMonthPicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isMonthPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isMonthPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker(
        scrollController: monthController,
        offAxisFraction: offAxisFraction,
        itemExtent: _kItemExtent,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        squeeze: _kSqueeze,
        onSelectedItemChanged: (int index) {
          selectedMonth = index + 1;
          if (_isCurrentDateValid)
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
        },
        children: List<Widget>.generate(12, (int index) {
          final int month = index + 1;
          final bool isInvalidMonth =
              (widget?.minimumDate?.year == selectedYear &&
                      widget.minimumDate.month > month) ||
                  (widget?.maximumDate?.year == selectedYear &&
                      widget.maximumDate.month < month);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerMonth(month),
              style: _themeTextStyle(context, isValid: !isInvalidMonth),
            ),
          );
        }),
        looping: true,
      ),
    );
  }

  Widget _buildYearPicker(
      double offAxisFraction, TransitionBuilder itemPositioningBuilder) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          isYearPickerScrolling = true;
        } else if (notification is ScrollEndNotification) {
          isYearPickerScrolling = false;
          _pickerDidStopScrolling();
        }

        return false;
      },
      child: CupertinoPicker.builder(
        scrollController: yearController,
        itemExtent: _kItemExtent,
        offAxisFraction: offAxisFraction,
        useMagnifier: _kUseMagnifier,
        magnification: _kMagnification,
        backgroundColor: widget.backgroundColor,
        onSelectedItemChanged: (int index) {
          selectedYear = index;
          if (_isCurrentDateValid)
            widget.onDateTimeChanged(
                DateTime(selectedYear, selectedMonth, selectedDay));
        },
        itemBuilder: (BuildContext context, int year) {
          if (year < widget.minimumYear) return null;

          if (widget.maximumYear != null && year > widget.maximumYear)
            return null;

          final bool isValidYear = (widget?.minimumDate == null ||
                  widget.minimumDate.year <= year) &&
              (widget?.maximumDate == null || widget.maximumDate.year >= year);

          return itemPositioningBuilder(
            context,
            Text(
              localizations.datePickerYear(year),
              style: _themeTextStyle(context, isValid: isValidYear),
            ),
          );
        },
      ),
    );
  }

  bool get _isCurrentDateValid {
    final DateTime selectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay);

    final bool minCheck = widget.minimumDate?.isAfter(selectedDate) ?? false;
    final bool maxCheck = widget.maximumDate?.isBefore(selectedDate) ?? false;

    return !minCheck && !maxCheck && selectedDate.day == selectedDay;
  }

  void _pickerDidStopScrolling() {
    setState(() {});

    if (isScrolling) {
      return;
    }

    final DateTime selectedDate =
        DateTime(selectedYear, selectedMonth, selectedDay);

    final bool minCheck = widget.minimumDate?.isAfter(selectedDate) ?? false;
    final bool maxCheck = widget.maximumDate?.isBefore(selectedDate) ?? false;

    if (minCheck || maxCheck) {
      final DateTime targetDate =
          minCheck ? widget.minimumDate : widget.maximumDate;
      _scrollToDate(targetDate);
      return;
    }

    if (selectedDate.day != selectedDay) {
      final DateTime lastDay = _lastDayInMonth(selectedYear, selectedMonth);
      _scrollToDate(lastDay);
    }
  }

  void _scrollToDate(DateTime newDate) {
    assert(newDate != null);
    SchedulerBinding.instance.addPostFrameCallback((Duration timestamp) {
      if (selectedYear != newDate.year) {
        yearController.animateToItem(
          newDate.year,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      if (selectedMonth != newDate.month) {
        monthController.animateToItem(
          newDate.month - 1,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
        );
      }

      if (selectedDay != newDate.day) {
        dayController.animateToItem(
          newDate.day - 1,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 200),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<_ColumnBuilder> pickerBuilders = <_ColumnBuilder>[];
    List<double> columnWidths = <double>[];

    switch (localizations.datePickerDateOrder) {
      case DatePickerDateOrder.mdy:
        pickerBuilders = <_ColumnBuilder>[
          _buildMonthPicker,
          _buildDayPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.year.index]
        ];
        break;
      case DatePickerDateOrder.dmy:
        pickerBuilders = <_ColumnBuilder>[
          _buildDayPicker,
          _buildMonthPicker,
          _buildYearPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.year.index]
        ];
        break;
      case DatePickerDateOrder.ymd:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildMonthPicker,
          _buildDayPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index],
          estimatedColumnWidths[_PickerColumnType.month.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index]
        ];
        break;
      case DatePickerDateOrder.ydm:
        pickerBuilders = <_ColumnBuilder>[
          _buildYearPicker,
          _buildDayPicker,
          _buildMonthPicker
        ];
        columnWidths = <double>[
          estimatedColumnWidths[_PickerColumnType.year.index],
          estimatedColumnWidths[_PickerColumnType.dayOfMonth.index],
          estimatedColumnWidths[_PickerColumnType.month.index]
        ];
        break;
      default:
        assert(false, 'date order is not specified');
    }

    final List<Widget> pickers = <Widget>[];

    for (int i = 0; i < columnWidths.length; i++) {
      final double offAxisFraction = (i - 1) * 0.3 * textDirectionFactor;

      EdgeInsets padding = const EdgeInsets.only(right: _kDatePickerPadSize);
      if (textDirectionFactor == -1)
        padding = const EdgeInsets.only(left: _kDatePickerPadSize);

      pickers.add(LayoutId(
        id: i,
        child: pickerBuilders[i](
          offAxisFraction,
          (BuildContext context, Widget child) {
            return Container(
              alignment: i == columnWidths.length - 1
                  ? alignCenterLeft
                  : alignCenterRight,
              padding: i == 0 ? null : padding,
              child: Container(
                alignment: i == 0 ? alignCenterLeft : alignCenterRight,
                width: columnWidths[i] + _kDatePickerPadSize,
                child: child,
              ),
            );
          },
        ),
      ));
    }

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: DefaultTextStyle.merge(
        style: _kDefaultPickerTextStyle,
        child: CustomMultiChildLayout(
          delegate: _DatePickerLayoutDelegate(
            columnWidths: columnWidths,
            textDirectionFactor: textDirectionFactor,
          ),
          children: pickers,
        ),
      ),
    );
  }
}

enum CupertinoTimerPickerMode {
  hm,
  ms,
  hms,
}

class CupertinoTimerPicker extends StatefulWidget {
  CupertinoTimerPicker({
    Key key,
    this.mode = CupertinoTimerPickerMode.hms,
    this.initialTimerDuration = Duration.zero,
    this.minuteInterval = 1,
    this.secondInterval = 1,
    this.alignment = Alignment.center,
    this.backgroundColor = _kBackgroundColor,
    @required this.onTimerDurationChanged,
  })  : assert(mode != null),
        assert(onTimerDurationChanged != null),
        assert(initialTimerDuration >= Duration.zero),
        assert(initialTimerDuration < const Duration(days: 1)),
        assert(minuteInterval > 0 && 60 % minuteInterval == 0),
        assert(secondInterval > 0 && 60 % secondInterval == 0),
        assert(initialTimerDuration.inMinutes % minuteInterval == 0),
        assert(initialTimerDuration.inSeconds % secondInterval == 0),
        assert(backgroundColor != null),
        assert(alignment != null),
        super(key: key);

  final CupertinoTimerPickerMode mode;

  final Duration initialTimerDuration;

  final int minuteInterval;

  final int secondInterval;

  final ValueChanged<Duration> onTimerDurationChanged;

  final AlignmentGeometry alignment;

  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _CupertinoTimerPickerState();
}

class _CupertinoTimerPickerState extends State<CupertinoTimerPicker> {
  TextDirection textDirection;
  CupertinoLocalizations localizations;

  int get textDirectionFactor {
    switch (textDirection) {
      case TextDirection.ltr:
        return 1;
      case TextDirection.rtl:
        return -1;
    }
    return 1;
  }

  int selectedHour;
  int selectedMinute;
  int selectedSecond;

  int lastSelectedHour;
  int lastSelectedMinute;
  int lastSelectedSecond;

  final TextPainter textPainter = TextPainter();
  final List<String> numbers = List<String>.generate(10, (int i) => '${9 - i}');
  double numberLabelWidth;
  double numberLabelHeight;
  double numberLabelBaseline;

  @override
  void initState() {
    super.initState();

    selectedMinute = widget.initialTimerDuration.inMinutes % 60;

    if (widget.mode != CupertinoTimerPickerMode.ms)
      selectedHour = widget.initialTimerDuration.inHours;

    if (widget.mode != CupertinoTimerPickerMode.hm)
      selectedSecond = widget.initialTimerDuration.inSeconds % 60;

    PaintingBinding.instance.systemFonts.addListener(_handleSystemFontsChange);
  }

  void _handleSystemFontsChange() {
    setState(() {
      textPainter.markNeedsLayout();
      _measureLabelMetrics();
    });
  }

  @override
  void dispose() {
    PaintingBinding.instance.systemFonts
        .removeListener(_handleSystemFontsChange);
    super.dispose();
  }

  @override
  void didUpdateWidget(CupertinoTimerPicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    assert(
      oldWidget.mode == widget.mode,
      "The CupertinoTimerPicker's mode cannot change once it's built",
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    textDirection = Directionality.of(context);
    localizations = CupertinoLocalizations.of(context);

    _measureLabelMetrics();
  }

  void _measureLabelMetrics() {
    textPainter.textDirection = textDirection;
    final TextStyle textStyle = _textStyleFrom(context);

    double maxWidth = double.negativeInfinity;
    String widestNumber;

    for (String input in numbers) {
      textPainter.text = TextSpan(
        text: input,
        style: textStyle,
      );
      textPainter.layout();

      if (textPainter.maxIntrinsicWidth > maxWidth) {
        maxWidth = textPainter.maxIntrinsicWidth;
        widestNumber = input;
      }
    }

    textPainter.text = TextSpan(
      text: '$widestNumber$widestNumber',
      style: textStyle,
    );

    textPainter.layout();
    numberLabelWidth = textPainter.maxIntrinsicWidth;
    numberLabelHeight = textPainter.height;
    numberLabelBaseline =
        textPainter.computeDistanceToActualBaseline(TextBaseline.alphabetic);
  }

  Widget _buildLabel(String text, EdgeInsetsDirectional pickerPadding) {
    final EdgeInsetsDirectional padding = EdgeInsetsDirectional.only(
      start: numberLabelWidth + _kTimerPickerLabelPadSize + pickerPadding.start,
    );

    return IgnorePointer(
      child: Container(
        alignment: AlignmentDirectional.centerStart.resolve(textDirection),
        padding: padding.resolve(textDirection),
        child: SizedBox(
          height: numberLabelHeight,
          child: Baseline(
            baseline: numberLabelBaseline,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: _kTimerPickerLabelFontSize,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerNumberLabel(String text, EdgeInsetsDirectional padding) {
    return Container(
      width: _kTimerPickerColumnIntrinsicWidth + padding.horizontal,
      padding: padding.resolve(textDirection),
      alignment: AlignmentDirectional.centerStart.resolve(textDirection),
      child: Container(
        width: numberLabelWidth,
        alignment: AlignmentDirectional.centerEnd.resolve(textDirection),
        child: Text(text,
            softWrap: false, maxLines: 1, overflow: TextOverflow.visible),
      ),
    );
  }

  Widget _buildHourPicker(EdgeInsetsDirectional additionalPadding) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: selectedHour),
      offAxisFraction: -0.5 * textDirectionFactor,
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedHour = index;
          widget.onTimerDurationChanged(Duration(
              hours: selectedHour,
              minutes: selectedMinute,
              seconds: selectedSecond ?? 0));
        });
      },
      children: List<Widget>.generate(24, (int index) {
        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerHour(index) +
                localizations.timerPickerHourLabel(index)
            : localizations.timerPickerHourLabel(index) +
                localizations.timerPickerHour(index);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerHour(index), additionalPadding),
        );
      }),
    );
  }

  Widget _buildHourColumn(EdgeInsetsDirectional additionalPadding) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedHour = selectedHour;
            });
            return false;
          },
          child: _buildHourPicker(additionalPadding),
        ),
        _buildLabel(
          localizations.timerPickerHourLabel(lastSelectedHour ?? selectedHour),
          additionalPadding,
        ),
      ],
    );
  }

  Widget _buildMinutePicker(EdgeInsetsDirectional additionalPadding) {
    double offAxisFraction;
    switch (widget.mode) {
      case CupertinoTimerPickerMode.hm:
        offAxisFraction = 0.5 * textDirectionFactor;
        break;
      case CupertinoTimerPickerMode.hms:
        offAxisFraction = 0.0;
        break;
      case CupertinoTimerPickerMode.ms:
        offAxisFraction = -0.5 * textDirectionFactor;
    }

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedMinute ~/ widget.minuteInterval,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      looping: true,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedMinute = index * widget.minuteInterval;
          widget.onTimerDurationChanged(Duration(
              hours: selectedHour ?? 0,
              minutes: selectedMinute,
              seconds: selectedSecond ?? 0));
        });
      },
      children: List<Widget>.generate(60 ~/ widget.minuteInterval, (int index) {
        final int minute = index * widget.minuteInterval;

        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerMinute(minute) +
                localizations.timerPickerMinuteLabel(minute)
            : localizations.timerPickerMinuteLabel(minute) +
                localizations.timerPickerMinute(minute);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerMinute(minute), additionalPadding),
        );
      }),
    );
  }

  Widget _buildMinuteColumn(EdgeInsetsDirectional additionalPadding) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedMinute = selectedMinute;
            });
            return false;
          },
          child: _buildMinutePicker(additionalPadding),
        ),
        _buildLabel(
          localizations
              .timerPickerMinuteLabel(lastSelectedMinute ?? selectedMinute),
          additionalPadding,
        ),
      ],
    );
  }

  Widget _buildSecondPicker(EdgeInsetsDirectional additionalPadding) {
    final double offAxisFraction = 0.5 * textDirectionFactor;

    return CupertinoPicker(
      scrollController: FixedExtentScrollController(
        initialItem: selectedSecond ~/ widget.secondInterval,
      ),
      offAxisFraction: offAxisFraction,
      itemExtent: _kItemExtent,
      backgroundColor: widget.backgroundColor,
      squeeze: _kSqueeze,
      looping: true,
      onSelectedItemChanged: (int index) {
        setState(() {
          selectedSecond = index * widget.secondInterval;
          widget.onTimerDurationChanged(Duration(
              hours: selectedHour ?? 0,
              minutes: selectedMinute,
              seconds: selectedSecond));
        });
      },
      children: List<Widget>.generate(60 ~/ widget.secondInterval, (int index) {
        final int second = index * widget.secondInterval;

        final String semanticsLabel = textDirectionFactor == 1
            ? localizations.timerPickerSecond(second) +
                localizations.timerPickerSecondLabel(second)
            : localizations.timerPickerSecondLabel(second) +
                localizations.timerPickerSecond(second);

        return Semantics(
          label: semanticsLabel,
          excludeSemantics: true,
          child: _buildPickerNumberLabel(
              localizations.timerPickerSecond(second), additionalPadding),
        );
      }),
    );
  }

  Widget _buildSecondColumn(EdgeInsetsDirectional additionalPadding) {
    return Stack(
      children: <Widget>[
        NotificationListener<ScrollEndNotification>(
          onNotification: (ScrollEndNotification notification) {
            setState(() {
              lastSelectedSecond = selectedSecond;
            });
            return false;
          },
          child: _buildSecondPicker(additionalPadding),
        ),
        _buildLabel(
          localizations
              .timerPickerSecondLabel(lastSelectedSecond ?? selectedSecond),
          additionalPadding,
        ),
      ],
    );
  }

  TextStyle _textStyleFrom(BuildContext context) {
    return CupertinoTheme.of(context).textTheme.pickerTextStyle.merge(
          const TextStyle(
            fontSize: _kTimerPickerNumberLabelFontSize,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns;
    const double paddingValue = _kPickerWidth -
        2 * _kTimerPickerColumnIntrinsicWidth -
        2 * _kTimerPickerHalfColumnPadding;

    double totalWidth = _kPickerWidth;
    assert(paddingValue >= 0);

    switch (widget.mode) {
      case CupertinoTimerPickerMode.hm:
        columns = <Widget>[
          _buildHourColumn(const EdgeInsetsDirectional.only(
              start: paddingValue / 2, end: _kTimerPickerHalfColumnPadding)),
          _buildMinuteColumn(const EdgeInsetsDirectional.only(
              start: _kTimerPickerHalfColumnPadding, end: paddingValue / 2)),
        ];
        break;
      case CupertinoTimerPickerMode.ms:
        columns = <Widget>[
          _buildMinuteColumn(const EdgeInsetsDirectional.only(
              start: paddingValue / 2, end: _kTimerPickerHalfColumnPadding)),
          _buildSecondColumn(const EdgeInsetsDirectional.only(
              start: _kTimerPickerHalfColumnPadding, end: paddingValue / 2)),
        ];
        break;
      case CupertinoTimerPickerMode.hms:
        const double paddingValue = _kTimerPickerHalfColumnPadding * 2;
        totalWidth = _kTimerPickerColumnIntrinsicWidth * 3 +
            4 * _kTimerPickerHalfColumnPadding +
            paddingValue;
        columns = <Widget>[
          _buildHourColumn(const EdgeInsetsDirectional.only(
              start: paddingValue / 2, end: _kTimerPickerHalfColumnPadding)),
          _buildMinuteColumn(const EdgeInsetsDirectional.only(
              start: _kTimerPickerHalfColumnPadding,
              end: _kTimerPickerHalfColumnPadding)),
          _buildSecondColumn(const EdgeInsetsDirectional.only(
              start: _kTimerPickerHalfColumnPadding, end: paddingValue / 2)),
        ];
        break;
    }
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    return MediaQuery(
      data: const MediaQueryData(
        textScaleFactor: 1.0,
      ),
      child: CupertinoTheme(
        data: themeData.copyWith(
          textTheme: themeData.textTheme.copyWith(
            pickerTextStyle: _textStyleFrom(context),
          ),
        ),
        child: Align(
          alignment: widget.alignment,
          child: Container(
            color: _kBackgroundColor,
            width: totalWidth,
            height: _kPickerHeight,
            child: DefaultTextStyle(
              style: _textStyleFrom(context),
              child: Row(
                  children: columns
                      .map((Widget child) => Expanded(child: child))
                      .toList(growable: false)),
            ),
          ),
        ),
      ),
    );
  }
}
