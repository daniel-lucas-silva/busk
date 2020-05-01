//library some_calendar;
//
//import 'package:cupertino/cupertino.dart';
//
////import 'package:flutter/material.dart';
//import 'package:jiffy/jiffy.dart';
//export 'package:jiffy/jiffy.dart';
//
//typedef void OnTapFunction(DateTime date);
//typedef void OnDoneFunction(date);
//
//enum SomeMode { Range, Single, Multi }
//
//class SomeCalendar extends StatefulWidget {
//  final SomeMode mode;
//  final OnDoneFunction done;
//
//  DateTime startDate;
//  DateTime lastDate;
//  DateTime selectedDate;
//  List<DateTime> selectedDates;
//
//  SomeCalendar(
//      {@required this.mode,
//      this.startDate,
//      this.lastDate,
//      this.done,
//      this.selectedDate,
//      this.selectedDates}) {
//    DateTime now = Jiffy().dateTime;
//    assert(mode != null);
//    if (startDate == null) startDate = SomeUtils.getStartDateDefault();
//    if (lastDate == null) lastDate = SomeUtils.getLastDateDefault();
//    if (selectedDates == null) selectedDates = List();
//    if (selectedDate == null) {
//      selectedDate = Jiffy(DateTime(now.year, now.month, now.day)).dateTime;
//    }
//  }
//
//  @override
//  SomeCalendarState createState() => SomeCalendarState(
//      lastDate: lastDate,
//      startDate: startDate,
//      mode: mode,
//      done: done,
//      selectedDates: selectedDates,
//      selectedDate: selectedDate);
//
//  static SomeCalendarState of(BuildContext context) =>
//      context.findAncestorStateOfType();
//}
//
//class SomeCalendarState extends State<SomeCalendar> {
//  final OnDoneFunction done;
//
//  DateTime startDate;
//  DateTime lastDate;
//  SomeMode mode;
//
//  PageView pageView;
//  PageController controller;
//
//  int pagesCount;
//  String month;
//  String year;
//
//  String monthFirstDate;
//  String yearFirstDate;
//  String dateFirstDate;
//
//  String monthEndDate;
//  String yearEndDate;
//  String dateEndDate;
//
//  List<DateTime> selectedDates;
//  DateTime selectedDate;
//  DateTime firstRangeDate;
//  DateTime endRangeDate;
//
//  DateTime now;
//  bool isSelectedModeFirstDateRange;
//
//  SomeCalendarState(
//      {@required this.done,
//      this.startDate,
//      this.lastDate,
//      this.selectedDate,
//      this.selectedDates,
//      this.mode}) {
//    now = Jiffy().dateTime;
//
//    if (mode == SomeMode.Range) {
//      if (selectedDates == null) {
//        firstRangeDate = Jiffy(DateTime(now.year, now.month, now.day)).dateTime;
//        endRangeDate =
//            Jiffy(DateTime(now.year, now.month, now.day)).add(days: 4);
//      } else {
//        DateTime dateRange = now;
//        if (selectedDates.length > 0) {
//          dateRange = selectedDates[0];
//        }
//
//        if (dateRange.difference(startDate).inDays >= 0) {
//          firstRangeDate = Jiffy(selectedDates[0]).dateTime;
//          endRangeDate =
//              Jiffy(selectedDates[selectedDates.length - 1]).dateTime;
//        } else {
//          firstRangeDate =
//              Jiffy(DateTime(now.year, now.month, now.day)).dateTime;
//          endRangeDate =
//              Jiffy(DateTime(now.year, now.month, now.day)).add(days: 4);
//        }
//      }
//      isSelectedModeFirstDateRange = true;
//      dateFirstDate = Jiffy(firstRangeDate).format("dd");
//      monthFirstDate = Jiffy(firstRangeDate).format("MMM");
//      yearFirstDate = Jiffy(firstRangeDate).format("yyyy");
//
//      dateEndDate = Jiffy(endRangeDate).format("dd");
//      monthEndDate = Jiffy(endRangeDate).format("MMM");
//      yearEndDate = Jiffy(endRangeDate).format("yyyy");
//      if (selectedDates.length <= 0)
//        generateListDateRange();
//      else {
//        var diff = selectedDates[selectedDates.length - 1]
//                .difference(selectedDates[0])
//                .inDays +
//            1;
//        var date = selectedDates[0];
//        selectedDates.clear();
//        for (int i = 0; i < diff; i++) {
//          selectedDates.add(date);
//          date = Jiffy(date).add(days: 1);
//        }
//      }
//    } else {
//      dateFirstDate = Jiffy(selectedDate).format("dd");
//      monthFirstDate = Jiffy(selectedDate).format("MMM");
//      yearFirstDate = Jiffy(selectedDate).format("yyyy");
//    }
//  }
//
//  @override
//  void initState() {
//    month = monthFirstDate;
//    year = yearFirstDate;
//    startDate = SomeUtils.setToMidnight(startDate);
//    lastDate = SomeUtils.setToMidnight(lastDate);
//    pagesCount = SomeUtils.getCountFromDiffDate(startDate, lastDate);
//    controller =
//        PageController(keepPage: false, initialPage: getInitialController());
//
//    pageView = PageView.builder(
//      controller: controller,
//      scrollDirection: Axis.vertical,
//      itemCount: pagesCount,
//      onPageChanged: (index) {
//        SomeDateRange someDateRange = getDateRange(index);
//        setState(() {
//          if (mode == SomeMode.Multi) {
//            monthFirstDate = Jiffy(someDateRange.startDate).format("MMM");
//            yearFirstDate = Jiffy(someDateRange.startDate).format("yyyy");
//            month = Jiffy(someDateRange.startDate).format("MMM");
//            year = Jiffy(someDateRange.startDate).format("yyyy");
//          } else if (mode == SomeMode.Range || mode == SomeMode.Single) {
//            month = Jiffy(someDateRange.startDate).format("MMM");
//            year = Jiffy(someDateRange.startDate).format("yyyy");
//          }
//        });
//      },
//      itemBuilder: (context, index) {
//        SomeDateRange someDateRange = getDateRange(index);
//        return Container(
//            child: SomeCalendarPage(
//          startDate: someDateRange.startDate,
//          lastDate: someDateRange.endDate,
//          onTapFunction: onCallback,
//          state: SomeCalendar.of(context),
//          mode: mode,
//        ));
//      },
//    );
//
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return show();
//  }
//
//  int getInitialController() {
//    if (selectedDate == null) {
//      return SomeUtils.getDiffMonth(startDate, Jiffy().dateTime);
//    } else {
//      if (selectedDate.difference(startDate).inDays >= 0)
//        return SomeUtils.getDiffMonth(startDate, selectedDate);
//      else
//        return SomeUtils.getDiffMonth(startDate, Jiffy().dateTime);
//    }
//  }
//
//  void onCallback(DateTime a) {
//    if (mode == SomeMode.Multi) {
//      if (selectedDates.contains(a))
//        selectedDates.remove(a);
//      else
//        selectedDates.add(a);
//      selectedDates.sort((a, b) {
//        return a.compareTo(b);
//      });
//    } else if (mode == SomeMode.Single) {
//      selectedDate = a;
//      setState(() {
//        dateFirstDate = Jiffy(selectedDate).format("dd");
//        monthFirstDate = Jiffy(selectedDate).format("MMM");
//        yearFirstDate = Jiffy(selectedDate).format("yyyy");
//      });
//    } else {
//      if (isSelectedModeFirstDateRange) {
//        if (a.isBefore(endRangeDate)) {
//          firstRangeDate = a;
//        } else {
//          endRangeDate = a;
//        }
//      } else {
//        if (a.isBefore(firstRangeDate)) {
//          firstRangeDate = a;
//        } else {
//          endRangeDate = a;
//        }
//      }
//
//      selectedDates.clear();
//      generateListDateRange();
//      selectedDates.sort((a, b) => a.compareTo(b));
//      setState(() {
//        dateFirstDate = Jiffy(firstRangeDate).format("dd");
//        monthFirstDate = Jiffy(firstRangeDate).format("MMM");
//        yearFirstDate = Jiffy(firstRangeDate).format("yyyy");
//        dateEndDate = Jiffy(endRangeDate).format("dd");
//        monthEndDate = Jiffy(endRangeDate).format("MMM");
//        yearEndDate = Jiffy(endRangeDate).format("yyyy");
//      });
//    }
//  }
//
//  void generateListDateRange() {
//    var diff = endRangeDate.difference(firstRangeDate).inDays + 1;
//    var date = firstRangeDate;
//    for (int i = 0; i < diff; i++) {
//      selectedDates.add(date);
//      date = Jiffy(date).add(days: 1);
//    }
//  }
//
//  SomeDateRange getDateRange(int position) {
//    DateTime pageStartDate;
//    DateTime pageEndDate;
//
//    if (position == 0) {
//      pageStartDate = startDate;
//      if (pagesCount <= 1) {
//        pageEndDate = lastDate;
//      } else {
//        var last = Jiffy(DateTime(startDate.year, startDate.month))
//          ..add(months: 1);
//        var lastDayOfMonth = last..subtract(days: 1);
//        pageEndDate = lastDayOfMonth.dateTime;
//      }
//    } else if (position == pagesCount - 1) {
//      var start = Jiffy(DateTime(lastDate.year, lastDate.month))
//        ..subtract(months: 1);
//      pageStartDate = start.dateTime;
//      pageEndDate = Jiffy(lastDate).subtract(days: 1);
//    } else {
//      var firstDateOfCurrentMonth =
//          Jiffy(DateTime(startDate.year, startDate.month))
//            ..add(months: position);
//      pageStartDate = firstDateOfCurrentMonth.dateTime;
//      var a = firstDateOfCurrentMonth
//        ..add(months: 1)
//        ..subtract(days: 1);
//      pageEndDate = a.dateTime;
//    }
//    return SomeDateRange(pageStartDate, pageEndDate);
//  }
//
//  show() {
//    final theme = CupertinoTheme.of(context);
//    var heightContainer = mode == SomeMode.Range ? 50 * 6 : 44 * 6;
//
//    return CupertinoAlertDialog(
//      title: Column(
//        children: <Widget>[
//          Container(
//            child: Row(
//              crossAxisAlignment: CrossAxisAlignment.center,
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              children: <Widget>[
//                if (mode == SomeMode.Range) ...[
//                  Expanded(
//                    child: GestureDetector(
//                      behavior: HitTestBehavior.opaque,
//                      onTap: () {
//                        setState(() {
//                          isSelectedModeFirstDateRange = true;
//                        });
//                      },
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            "First Date",
//                            style: TextStyle(
//                                fontFamily: "playfair-regular",
//                                fontSize: 12,
//                                color: CupertinoColors.white),
//                          ),
//                          SizedBox(
//                            height: 2,
//                          ),
//                          Text(
//                            "$dateFirstDate $monthFirstDate, $yearFirstDate",
//                            style: TextStyle(
//                                fontFamily: "playfair-regular",
//                                color: isSelectedModeFirstDateRange
//                                    ? theme.primaryColor
//                                    : theme.primaryColor.withAlpha(150),
//                                fontWeight: FontWeight.bold,
//                                fontSize: 18),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                  Expanded(
//                    child: GestureDetector(
//                      behavior: HitTestBehavior.opaque,
//                      onTap: () {
//                        setState(() {
//                          isSelectedModeFirstDateRange = false;
//                        });
//                      },
//                      child: Column(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Text(
//                            "last Date",
//                            style: TextStyle(
//                                fontFamily: "playfair-regular",
//                                fontSize: 12,
//                                color: CupertinoColors.white),
//                          ),
//                          SizedBox(
//                            height: 2,
//                          ),
//                          Text(
//                            "$dateEndDate $monthEndDate, $yearEndDate",
//                            style: TextStyle(
//                              fontFamily: "playfair-regular",
//                              color: isSelectedModeFirstDateRange
//                                  ? theme.primaryColor.withAlpha(150)
//                                  : theme.primaryColor,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 18,
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ] else if (mode == SomeMode.Single) ...[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Text(
//                          "Selected Date",
//                          style: theme.textTheme.tabLabelTextStyle,
//                        ),
//                        Text(
//                          "$dateFirstDate $monthFirstDate, $yearFirstDate",
//                          style: theme.textTheme.textStyle,
//                        ),
//                      ],
//                    ),
//                  ),
//                ] else ...[
//                  Expanded(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text(
//                          "Selected Date",
//                          style: theme.textTheme.tabLabelTextStyle,
//                        ),
//                        Text(
//                          "$monthFirstDate, $yearFirstDate",
//                          style: theme.textTheme.textStyle,
//                        ),
//                      ],
//                    ),
//                  ),
//                ]
//              ],
//            ),
//          ),
//        ],
//      ),
//      content: Container(
//        height: heightContainer.toDouble(),
//        width: MediaQuery.of(context).size.width,
//        child: Column(
//          children: <Widget>[
//            if (mode != SomeMode.Multi) ...[
//              Text(
//                "$month, $year",
//                style: theme.textTheme.textStyle.copyWith(
//                  color: theme.primaryColor,
//                ),
//              ),
//            ],
//            SizedBox(
//              height: 10,
//            ),
//            Expanded(
//              child: ListView(
//                shrinkWrap: true,
//                children: <Widget>[
//                  Container(
//                    height: heightContainer.toDouble(),
//                    child: pageView,
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//      actions: <Widget>[
//        CupertinoDialogAction(
//          child: Text("Voltar"),
//          isDestructiveAction: true,
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//        ),
//        CupertinoDialogAction(
//          child: Text("Selecionar"),
//          onPressed: () {
//            if (mode == SomeMode.Multi || mode == SomeMode.Range) {
//              done(selectedDates);
//            } else if (mode == SomeMode.Single) {
//              done(selectedDate);
//            }
//            Navigator.of(context).pop();
//          },
//        ),
//      ],
//    );
//
////    return AlertDialog(
////      titlePadding: EdgeInsets.fromLTRB(0, 16, 0, 5),
////      shape: RoundedRectangleBorder(
////        borderRadius: BorderRadius.all(
////          Radius.circular(20),
////        ),
////      ),
////      title: Column(
////        children: <Widget>[
////          Padding(
////            padding: EdgeInsets.only(left: 15, right: 15),
////            child: Row(
////              crossAxisAlignment: CrossAxisAlignment.center,
////              mainAxisAlignment: MainAxisAlignment.spaceBetween,
////              children: <Widget>[
////                if (mode == SomeMode.Range) ...[
////                  Expanded(
////                    child: InkWell(
////                      onTap: () {
////                        setState(() {
////                          isSelectedModeFirstDateRange = true;
////                        });
////                      },
////                      child: Column(
////                        crossAxisAlignment: CrossAxisAlignment.start,
////                        children: <Widget>[
////                          Text(
////                            "First Date",
////                            style: TextStyle(
////                                fontFamily: "playfair-regular",
////                                fontSize: 12,
////                                color: CupertinoColors.white),
////                          ),
////                          SizedBox(
////                            height: 2,
////                          ),
////                          Text(
////                            "$dateFirstDate $monthFirstDate, $yearFirstDate",
////                            style: TextStyle(
////                                fontFamily: "playfair-regular",
////                                color: isSelectedModeFirstDateRange
////                                    ? Color(0xff365535)
////                                    : Color(0xff365535).withAlpha(150),
////                                fontWeight: FontWeight.bold,
////                                fontSize: 18),
////                          ),
////                        ],
////                      ),
////                    ),
////                  ),
////                  Expanded(
////                    child: InkWell(
////                      onTap: () {
////                        setState(() {
////                          isSelectedModeFirstDateRange = false;
////                        });
////                      },
////                      child: Column(
////                        crossAxisAlignment: CrossAxisAlignment.start,
////                        children: <Widget>[
////                          Text(
////                            "last Date",
////                            style: TextStyle(
////                                fontFamily: "playfair-regular",
////                                fontSize: 12,
////                                color: CupertinoColors.white),
////                          ),
////                          SizedBox(
////                            height: 2,
////                          ),
////                          Text(
////                            "$dateEndDate $monthEndDate, $yearEndDate",
////                            style: TextStyle(
////                                fontFamily: "playfair-regular",
////                                color: isSelectedModeFirstDateRange
////                                    ? Color(0xff365535).withAlpha(150)
////                                    : Color(0xff365535),
////                                fontWeight: FontWeight.bold,
////                                fontSize: 18),
////                          ),
////                        ],
////                      ),
////                    ),
////                  ),
////                ] else if (mode == SomeMode.Single) ...[
////                  Expanded(
////                    child: Column(
////                      crossAxisAlignment: CrossAxisAlignment.start,
////                      children: <Widget>[
////                        Text(
////                          "Selected Date",
////                          style: TextStyle(
////                              fontFamily: "playfair-regular",
////                              fontSize: 12,
////                              color: CupertinoColors.white),
////                        ),
////                        Text(
////                          "$dateFirstDate $monthFirstDate, $yearFirstDate",
////                          style: TextStyle(
////                              fontFamily: "playfair-regular",
////                              color: CupertinoColors.white,
////                              fontWeight: FontWeight.bold,
////                              fontSize: 18),
////                        ),
////                      ],
////                    ),
////                  ),
////                ] else ...[
////                  Expanded(
////                    child: Column(
////                      crossAxisAlignment: CrossAxisAlignment.start,
////                      children: <Widget>[
////                        Text(
////                          "Selected Date",
////                          style: TextStyle(
////                              fontFamily: "playfair-regular",
////                              fontSize: 12,
////                              color: CupertinoColors.white),
////                        ),
////                        Text(
////                          "$monthFirstDate, $yearFirstDate",
////                          style: TextStyle(
////                              fontFamily: "playfair-regular",
////                              color: CupertinoColors.white,
////                              fontWeight: FontWeight.bold,
////                              fontSize: 18),
////                        ),
////                      ],
////                    ),
////                  ),
////                ]
////              ],
////            ),
////          ),
////          SizedBox(
////            height: 16,
////          ),
////          Divider(
////            color: Color(0xffdedede),
////            height: 1,
////          ),
////          SizedBox(
////            height: 14,
////          ),
////        ],
////      ),
////      contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 10),
////      content: Container(
////        height: heightContainer.toDouble(),
////        width: MediaQuery.of(context).size.width,
////        child: Column(
////          children: <Widget>[
////            if (mode != SomeMode.Multi) ...[
////              Text(
////                "$month, $year",
////                style: TextStyle(
////                    fontFamily: "playfair-regular",
////                    fontSize: 14.2,
////                    fontWeight: FontWeight.w600,
////                    letterSpacing: 1,
////                    color: Color(0xff365535)),
////              ),
////            ],
////            SizedBox(
////              height: 10,
////            ),
////            Expanded(
////              child: ListView(
////                shrinkWrap: true,
////                children: <Widget>[
////                  Container(
////                      height: heightContainer.toDouble(), child: pageView),
////                ],
////              ),
////            ),
////            Row(
////              children: <Widget>[
////                Expanded(
////                  child: RaisedButton(
////                    elevation: 0,
////                    color: Color(0xff365535),
////                    shape: RoundedRectangleBorder(
////                      borderRadius: BorderRadius.all(Radius.circular(18)),
////                    ),
////                    onPressed: () {
////                      if (mode == SomeMode.Multi || mode == SomeMode.Range) {
////                        done(selectedDates);
////                      } else if (mode == SomeMode.Single) {
////                        done(selectedDate);
////                      }
////                      Navigator.of(context).pop();
////                    },
////                    child: Padding(
////                      padding: EdgeInsets.only(top: 8, bottom: 8),
////                      child: Text(
////                        "Done",
////                        style: TextStyle(
////                            fontFamily: "Avenir",
////                            fontSize: 14,
////                            color: CupertinoColors.white),
////                      ),
////                    ),
////                  ),
////                ),
////                RaisedButton(
////                  elevation: 0,
////                  color: CupertinoColors.white,
////                  shape: RoundedRectangleBorder(
////                    borderRadius: BorderRadius.all(Radius.circular(10)),
////                  ),
////                  onPressed: () {
////                    Navigator.of(context).pop();
////                  },
////                  child: Padding(
////                    padding: EdgeInsets.only(top: 8, bottom: 8),
////                    child: Text(
////                      "Cancel",
////                      style: TextStyle(
////                          fontFamily: "Avenir",
////                          fontSize: 14,
////                          color: Color(0xff365535)),
////                    ),
////                  ),
////                ),
////              ],
////            ),
////          ],
////        ),
////      ),
////    );
//  }
//}
//
//class SomeCalendarPage extends StatefulWidget {
//  final DateTime startDate;
//  final DateTime lastDate;
//  final OnTapFunction onTapFunction;
//  final SomeCalendarState state;
//  final SomeMode mode;
//
//  SomeCalendarPage(
//      {Key key,
//      @required this.startDate,
//      @required this.lastDate,
//      this.onTapFunction,
//      this.state,
//      this.mode});
//
//  @override
//  _SomeCalendarPageState createState() => _SomeCalendarPageState(
//      startDate: startDate,
//      lastDate: lastDate,
//      onTapFunction: onTapFunction,
//      state: state,
//      mode: mode);
//}
//
//class _SomeCalendarPageState extends State<SomeCalendarPage> {
//  final DateTime startDate;
//  final DateTime lastDate;
//  final OnTapFunction onTapFunction;
//  final SomeCalendarState state;
//  final SomeMode mode;
//
//  int startDayOffset = 0;
//  List<DateTime> selectedDates;
//  DateTime selectedDate;
//
//  _SomeCalendarPageState(
//      {this.startDate,
//      this.lastDate,
//      this.onTapFunction,
//      this.state,
//      this.mode});
//
//  @override
//  void initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    if (mode == SomeMode.Multi || mode == SomeMode.Range) {
//      selectedDates = state.selectedDates;
//    } else if (mode == SomeMode.Single) {
//      selectedDate = state.selectedDate;
//    }
//    List<Widget> rows = [];
//    rows.add(SomeWeekLabelEN());
//
//    var dateTime = Jiffy(startDate);
//    for (int i = 1; i < 7; i++) {
//      if (lastDate.isAfter(dateTime.dateTime)) {
//        rows.add(Row(
//          children: buildSomeCalendarDay(dateTime.dateTime, lastDate, i),
//        ));
//        dateTime = dateTime..add(days: startDayOffset);
//      } else {
//        rows.add(Row(
//            children: buildSomeCalendarDay(dateTime.dateTime, lastDate, i)));
//      }
//    }
//
//    return Column(mainAxisSize: MainAxisSize.min, children: rows);
//  }
//
//  List<Widget> buildSomeCalendarDay(
//      DateTime rowStartDate, DateTime rowEndDate, int position) {
//    List<Widget> items = [];
//    DateTime currentDate = rowStartDate;
//    rowEndDate = Jiffy(rowEndDate).add(days: 1);
//    startDayOffset = 0;
//    if (position == 1) {
//      for (int i = 0; i < 7; i++) {
//        if (i + 1 == rowStartDate.weekday) {
//          items.add(someDay(currentDate));
//          startDayOffset++;
//          currentDate = currentDate.add(Duration(days: 1));
//        } else if (i + 1 > rowStartDate.weekday) {
//          if (rowEndDate.isAfter(currentDate)) {
//            items.add(someDay(currentDate));
//            startDayOffset++;
//            currentDate = currentDate.add(Duration(days: 1));
//          } else {
//            items.add(someDayEmpty());
//          }
//        } else {
//          items.add(someDayEmpty());
//        }
//      }
//    } else {
//      for (int i = 0; i < 7; i++) {
//        if (rowEndDate.isAfter(currentDate)) {
//          items.add(someDay(currentDate));
//          startDayOffset++;
//          currentDate = currentDate.add(Duration(days: 1));
//        } else {
//          items.add(someDayEmpty());
//        }
//      }
//    }
//    return items;
//  }
//
//  Widget someDay(currentDate) {
//    return Expanded(
//      child: Container(
//        decoration: getDecoration(currentDate),
//        margin: EdgeInsets.only(top: 2, bottom: 2),
//        child: Padding(
//          padding: const EdgeInsets.all(1),
//          child: GestureDetector(
//            behavior: HitTestBehavior.opaque,
//            onTap: () {
//              setState(() {
//                onTapFunction(currentDate);
//              });
//            },
//            child: Container(
//                child: Padding(
//              padding: const EdgeInsets.all(6),
//              child: Center(
//                  child: Text(
//                "${currentDate.day}",
//                style: TextStyle(color: getColor(currentDate)),
//              )),
//            )),
//          ),
//        ),
//      ),
//    );
//  }
//
//  Widget someDayEmpty() {
//    return Expanded(
//      child: Padding(
//        padding: const EdgeInsets.all(8.0),
//        child: Center(child: Text("")),
//      ),
//    );
//  }
//
//  Color getColor(currentDate) {
//    if (mode == SomeMode.Multi || mode == SomeMode.Range) {
//      return selectedDates.contains(currentDate)
//          ? CupertinoColors.white
//          : CupertinoColors.white;
//    } else if (mode == SomeMode.Single) {
//      return selectedDate == currentDate
//          ? CupertinoColors.white
//          : CupertinoColors.white;
//    } else {
//      return null;
//    }
//  }
//
//  Decoration getDecoration(currentDate) {
//    final theme = CupertinoTheme.of(context);
//
//    var decoration = BoxDecoration(
//      color: theme.primaryColor,
//      shape: BoxShape.circle,
//    );
//    if (mode == SomeMode.Multi) {
//      return selectedDates.contains(currentDate) ? decoration : null;
//    } else if (mode == SomeMode.Single) {
//      return selectedDate == currentDate ? decoration : null;
//    } else {
//      if (selectedDates[0] == currentDate) {
//        return BoxDecoration(
//          color: theme.primaryColor,
//          borderRadius: BorderRadius.only(
//            bottomLeft: Radius.circular(50),
//            topLeft: Radius.circular(50),
//          ),
//        );
//      } else if (selectedDates[selectedDates.length - 1] == currentDate) {
//        return BoxDecoration(
//          color: theme.primaryColor,
//          borderRadius: BorderRadius.only(
//            bottomRight: Radius.circular(50),
//            topRight: Radius.circular(50),
//          ),
//        );
//      } else {
//        if (selectedDates.contains(currentDate)) {
//          return BoxDecoration(
//            color: theme.primaryColor.withAlpha(180),
//            shape: BoxShape.rectangle,
//          );
//        } else {
//          return null;
//        }
//      }
//    }
//  }
//}
//
//class SomeDateRange {
//  DateTime startDate;
//  DateTime endDate;
//
//  SomeDateRange(this.startDate, this.endDate);
//}
//
//class SomeModel {
//  bool result = false;
//
//  SomeModel({this.result});
//}
//
//class SomeUtils {
//  static DateTime getStartDateDefault() {
//    var now = Jiffy();
//    return DateTime(now.year, now.month, now.date);
//  }
//
//  static DateTime getLastDateDefault() {
//    var now = Jiffy()..add(months: 2);
//    return DateTime(now.year, now.month);
//  }
//
//  static DateTime setToMidnight(DateTime date) {
//    return DateTime(date.year, date.month);
//  }
//
//  static int getCountFromDiffDate(DateTime firstDate, DateTime lastDate) {
//    var yearsDifference = lastDate.year - firstDate.year;
//    return 12 * yearsDifference + lastDate.month - firstDate.month;
//  }
//
//  static int getDiffMonth(DateTime startDate, DateTime date) {
//    return (date.year * 12 + date.month) -
//        (startDate.year * 12 + startDate.month);
//  }
//}
//
//class SomeWeekLabelEN extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final theme = CupertinoTheme.of(context);
//
//    final style = theme.textTheme.pickerTextStyle.copyWith(
//      color: theme.primaryColor,
//      fontSize: 13.0,
//      fontWeight: FontWeight.w600,
//      letterSpacing: 1,
//    );
//
//    return Row(
//      children: <Widget>[
//        Expanded(
//          child: Text("Seg", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Ter", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Qua", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Qui", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Sex", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Sab", textAlign: TextAlign.center, style: style),
//        ),
//        Expanded(
//          child: Text("Dom", textAlign: TextAlign.center, style: style),
//        ),
//      ],
//    );
//  }
//
//  TextStyle textStyle() => TextStyle(
//        fontFamily: "playfair-regular",
//        fontSize: 14.2,
//        fontWeight: FontWeight.w600,
//        letterSpacing: 1,
//        color: Color(0xff365535),
//      );
//}
