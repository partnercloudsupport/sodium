import 'dart:async';

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/calendar_tile.dart';
import 'package:tuple/tuple.dart';

typedef DayBuilder(BuildContext context, DateTime day);

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<Tuple2<DateTime, DateTime>> onSelectedRangeChange;
  final bool isExpandable;
  final bool showFixedBody;
  final DayBuilder dayBuilder;
  final Widget fixedBody;
  final bool showChevronsToChangeRange;
  final bool showTodayAction;
  final bool showCalendarPickerIcon;
  final DateTime initialCalendarDateOverride;

  Calendar({
    this.onDateSelected,
    this.onSelectedRangeChange,
    this.isExpandable: false,
    this.dayBuilder,
    this.showTodayAction: true,
    this.showChevronsToChangeRange: true,
    this.showCalendarPickerIcon: true,
    this.initialCalendarDateOverride,
    this.showFixedBody: false,
    this.fixedBody,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final calendarUtils = Utils();
  List<DateTime> selectedMonthsDays;
  Iterable<DateTime> selectedWeeksDays;
  DateTime _selectedDate = DateTime.now();
  String currentMonth;
  bool isExpanded = true;
  String displayMonth;

  DateTime get selectedDate => _selectedDate;

  void initState() {
    super.initState();
    if (widget.initialCalendarDateOverride != null) _selectedDate = widget.initialCalendarDateOverride;
    selectedMonthsDays = Utils.daysInMonth(_selectedDate);
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
    selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
    displayMonth = Utils.formatMonth(_selectedDate);
  }

  Widget get nameAndIconRow {
    var leftInnerIcon;
    var rightInnerIcon;
    var leftOuterIcon;
    var rightOuterIcon;

    if (widget.showCalendarPickerIcon) {
      rightInnerIcon = IconButton(
        onPressed: () => selectDateFromPicker(),
        icon: Icon(Icons.calendar_today),
      );
    } else {
      rightInnerIcon = Container();
    }

    if (widget.showChevronsToChangeRange) {
      leftOuterIcon = IconButton(
        onPressed: isExpanded ? previousMonth : previousWeek,
        icon: Icon(Icons.chevron_left, color: Colors.grey),
      );
      rightOuterIcon = IconButton(
        onPressed: isExpanded ? nextMonth : nextWeek,
        icon: Icon(Icons.chevron_right, color: Colors.grey),
      );
    } else {
      leftOuterIcon = Container();
      rightOuterIcon = Container();
    }

    if (widget.showTodayAction) {
      leftInnerIcon = InkWell(
        child: Text('Today'),
        onTap: resetToToday,
      );
    } else {
      leftInnerIcon = Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        leftOuterIcon ?? Container(),
        leftInnerIcon ?? Container(),
        Text(
          displayMonth,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20.0,
          ),
        ),
        rightInnerIcon ?? Container(),
        rightOuterIcon ?? Container(),
      ],
    );
  }

  Widget get calendarGridView {
    return Container(
      color: Colors.white,
      child: GestureDetector(
        onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
        onHorizontalDragUpdate: (gestureDetails) => getDirection(gestureDetails),
        onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 7,
          padding: EdgeInsets.only(bottom: 0.0),
          children: calendarBuilder(),
        ),
      ),
    );
  }

  List<Widget> calendarBuilder() {
    List<Widget> dayWidgets = [];
    List<DateTime> calendarDays = isExpanded ? selectedMonthsDays : selectedWeeksDays;

    Utils.weekdays.forEach(
      (day) {
        dayWidgets.add(
          CalendarTile(
            isDayOfWeek: true,
            dayOfWeek: day,
            dayOfWeekStyles: TextStyle(color: Theme.of(context).primaryColor),
          ),
        );
      },
    );

    bool monthStarted = false;
    bool monthEnded = false;

    calendarDays.forEach(
      (day) {
        if (monthStarted && day.day == 01) {
          monthEnded = true;
        }

        if (Utils.isFirstDayOfMonth(day)) {
          monthStarted = true;
        }

        if (this.widget.dayBuilder != null) {
          dayWidgets.add(
            CalendarTile(
              child: this.widget.dayBuilder(context, day),
              date: day,
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
            ),
          );
        } else {
          dayWidgets.add(
            CalendarTile(
              onDateSelected: () => handleSelectedDateAndUserCallback(day),
              date: day,
              dateStyles: configureDateStyle(monthStarted, monthEnded),
              isSelected: Utils.isSameDay(selectedDate, day),
            ),
          );
        }
      },
    );
    return dayWidgets;
  }

  TextStyle configureDateStyle(monthStarted, monthEnded) {
    TextStyle dateStyles;
    if (isExpanded) {
      dateStyles = monthStarted && !monthEnded ? TextStyle(color: Colors.black) : TextStyle(color: Colors.black38);
    } else {
      dateStyles = TextStyle(color: Colors.black);
    }
    return dateStyles;
  }

  Widget get expansionButtonRow {
    if (widget.isExpandable) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            iconSize: 20.0,
            padding: EdgeInsets.all(0.0),
            onPressed: toggleExpanded,
            icon: isExpanded ? Icon(Icons.arrow_drop_up) : Icon(Icons.arrow_drop_down),
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          nameAndIconRow,
          widget.showFixedBody
              ? Container()
              : ExpansionCrossFade(
                  collapsed: calendarGridView,
                  expanded: calendarGridView,
                  isExpanded: isExpanded,
                ),
          widget.showFixedBody
              ? GestureDetector(
                  onHorizontalDragStart: (gestureDetails) => beginSwipe(gestureDetails),
                  onHorizontalDragUpdate: (gestureDetails) => getDirection(gestureDetails),
                  onHorizontalDragEnd: (gestureDetails) => endSwipe(gestureDetails),
                  child: widget.fixedBody,
                )
              : Container(),
        ],
      ),
    );
  }

  void resetToToday() {
    _selectedDate = DateTime.now();
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);

    setState(() {
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      displayMonth = Utils.formatMonth(_selectedDate);
    });

    _launchDateSelectionCallback(_selectedDate);
  }

  void nextMonth() {
    setState(() {
      _selectedDate = Utils.nextMonth(_selectedDate);
      var firstDateOfMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfMonth, lastDateOfMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void previousMonth() {
    setState(() {
      _selectedDate = Utils.previousMonth(_selectedDate);
      var firstDateOfMonth = Utils.firstDayOfMonth(_selectedDate);
      var lastDateOfMonth = Utils.lastDayOfMonth(_selectedDate);
      updateSelectedRange(firstDateOfMonth, lastDateOfMonth);
      selectedMonthsDays = Utils.daysInMonth(_selectedDate);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
  }

  void nextWeek() {
    setState(() {
      _selectedDate = Utils.nextWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void previousWeek() {
    setState(() {
      _selectedDate = Utils.previousWeek(_selectedDate);
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(_selectedDate);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(_selectedDate);
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList().sublist(0, 7);
      displayMonth = Utils.formatMonth(_selectedDate);
    });
    _launchDateSelectionCallback(_selectedDate);
  }

  void updateSelectedRange(DateTime start, DateTime end) {
    var selectedRange = Tuple2<DateTime, DateTime>(start, end);
    if (widget.onSelectedRangeChange != null) {
      widget.onSelectedRangeChange(selectedRange);
    }
  }

  Future<Null> selectDateFromPicker() async {
    DateTime selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
    );

    if (selected != null) {
      var firstDayOfCurrentWeek = Utils.firstDayOfWeek(selected);
      var lastDayOfCurrentWeek = Utils.lastDayOfWeek(selected);

      setState(() {
        _selectedDate = selected;
        selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
        selectedMonthsDays = Utils.daysInMonth(selected);
        displayMonth = Utils.formatMonth(selected);
      });
      // updating selected date range based on selected week
      updateSelectedRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek);
      _launchDateSelectionCallback(selected);
    }
  }

  var gestureStart;
  var gestureDirection;

  void beginSwipe(DragStartDetails gestureDetails) {
    gestureStart = gestureDetails.globalPosition.dx;
  }

  void getDirection(DragUpdateDetails gestureDetails) {
    if (gestureDetails.globalPosition.dx < gestureStart) {
      gestureDirection = 'rightToLeft';
    } else {
      gestureDirection = 'leftToRight';
    }
  }

  void endSwipe(DragEndDetails gestureDetails) {
    if (gestureDirection == 'rightToLeft') {
      if (isExpanded) {
        nextMonth();
      } else {
        nextWeek();
      }
    } else {
      if (isExpanded) {
        previousMonth();
      } else {
        previousWeek();
      }
    }
  }

  void toggleExpanded() {
    if (widget.isExpandable) {
      setState(() => isExpanded = !isExpanded);
    }
  }

  void handleSelectedDateAndUserCallback(DateTime day) {
    var firstDayOfCurrentWeek = Utils.firstDayOfWeek(day);
    var lastDayOfCurrentWeek = Utils.lastDayOfWeek(day);
    setState(() {
      _selectedDate = day;
      selectedWeeksDays = Utils.daysInRange(firstDayOfCurrentWeek, lastDayOfCurrentWeek).toList();
      selectedMonthsDays = Utils.daysInMonth(day);
    });
    _launchDateSelectionCallback(day);
  }

  void _launchDateSelectionCallback(DateTime day) {
    if (widget.onDateSelected != null) {
      widget.onDateSelected(day);
    }
  }
}

class ExpansionCrossFade extends StatelessWidget {
  final Widget collapsed;
  final Widget expanded;
  final bool isExpanded;

  ExpansionCrossFade({this.collapsed, this.expanded, this.isExpanded});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AnimatedCrossFade(
        firstChild: collapsed,
        secondChild: expanded,
        firstCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.0, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.decelerate,
        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }
}
