// library kalendar;
//
// import 'package:flutter/material.dart';
// import 'package:date_utils/date_utils.dart';
//
// typedef ValueChanged<T> = void Function(T);
// typedef MarkBuilder = Widget Function(String event);
// typedef OnTappedOnDayTile = Widget Function(DateTime dateTime, bool isSelected);
// typedef HeaderBuilder = Widget Function(
//     DateTime dateTime, ValueChanged<DateTime> changedDateTime);
// typedef DayTileBuilder = Widget Function(DayProps dayProps);
// typedef WeekBuilder = Widget Function(List<String> weeks);
//
// class Kalendar extends StatefulWidget {
//   final Map<String, List<String>> markedDates;
//   final MarkBuilder markBuilder;
//   final double borderRadius;
//   final double dayTileMargin;
//   final OnTappedOnDayTile onTap;
//   final Set<String> selectedDates;
//   final Color dayTileBorderColor;
//   final DayTileBuilder dayTileBuilder;
//   final WeekBuilder weekBuilder;
//   final bool showBorder;
//   final HeaderBuilder headerBuilder;
//
//   Kalendar({
//     required this.markedDates,
//     required this.markBuilder,
//     this.borderRadius,
//     this.onTap,
//     this.selectedDates,
//     this.dayTileMargin,
//     this.dayTileBorderColor,
//     this.dayTileBuilder,
//     required this.weekBuilder,
//     this.showBorder,
//     this.headerBuilder,
//   });
//
//   @override
//   _KalendarState createState() => _KalendarState();
// }
//
// class _KalendarState extends State<Kalendar> {
//   DateTime _visibleMonth;
//
//   int _currentPageIndex = 999;
//   PageController _pageController;
//
//   _onPageChanged(pageIndex) {
//     if (pageIndex > _currentPageIndex) {
//       _visibleMonth = Utils.nextMonth(_visibleMonth);
//     } else if (pageIndex < _currentPageIndex) {
//       _visibleMonth = Utils.previousMonth(_visibleMonth);
//     }
//
//     setState(() {});
//
//     _currentPageIndex = pageIndex;
//   }
//
//   void initState() {
//     super.initState();
//     _visibleMonth = Utils.firstDayOfMonth(DateTime.now());
//     _pageController = PageController(initialPage: _currentPageIndex);
//   }
//
//   void _changeMonth(date) {
//     setState(() {
//       _visibleMonth = date;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         widget.headerBuilder != null
//             ? widget.headerBuilder(_visibleMonth, _changeMonth)
//             : _DefaultHeader(_visibleMonth, onChange: (date) {
//           _changeMonth(date);
//         }),
//         widget.weekBuilder != null
//             ? widget.weekBuilder(Utils.weekdays)
//             : Container(
//           padding: EdgeInsets.only(bottom: 12),
//           child: Row(
//             children: List.generate(Utils.weekdays.length, (index) {
//               return Expanded(
//                 child: Text(
//                   '${Utils.weekdays[index]}',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               );
//             }),
//           ),
//         ),
//         Expanded(
//           child: PageView.builder(
//             controller: _pageController,
//             onPageChanged: _onPageChanged,
//             itemBuilder: (context, pageIndex) {
//               List<DateTime> days = Utils.daysInMonth(_visibleMonth);
//               return GridView.builder(
//                   gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 7),
//                   itemCount: days.length,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         DayTileContainer(
//                           dateTime: days[index],
//                           isDayOfCurrentMonth:
//                           days[index].month == _visibleMonth.month,
//                           events: widget.markedDates != null
//                               ? widget.markedDates[formatDate(days[index])]
//                               : null,
//                           markBuilder: widget.markBuilder,
//                           borderRadius: widget.borderRadius ?? 4,
//                           dayTileMargin: widget.dayTileMargin,
//                           onTap: widget.onTap,
//                           isSelected: widget.selectedDates != null
//                               ? widget.selectedDates
//                               .contains(formatDate(days[index])) ??
//                               false
//                               : false,
//                           dayTileBorderColor: widget.dayTileBorderColor,
//                           dayTileBuilder: widget.dayTileBuilder,
//                           showBorder: widget.showBorder,
//                         ),
//                       ],
//                     );
//                   });
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _DefaultHeader extends StatelessWidget {
//   final DateTime visibleMonth;
//   final Function onChange;
//
//   _DefaultHeader(this.visibleMonth, {this.onChange});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.chevron_left,
//               color: Theme.of(context).primaryColor,
//             ),
//             onPressed: () {
//               onChange(Utils.previousMonth(visibleMonth));
//             },
//           ),
//           Text(
//             '${Utils.formatMonth(visibleMonth)}',
//             style: TextStyle(
//               color: Theme.of(context).primaryColor,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.chevron_right,
//               color: Theme.of(context).primaryColor,
//             ),
//             onPressed: () {
//               onChange(Utils.nextMonth(visibleMonth));
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class DayTileContainer extends StatelessWidget {
//   final DateTime dateTime;
//   final bool isDayOfCurrentMonth;
//   final List<String> events;
//   final Function markBuilder;
//   final double borderRadius;
//   final double dayTileMargin;
//   final Function onTap;
//   final bool isSelected;
//   final Color dayTileBorderColor;
//   final Function dayTileBuilder;
//   final bool showBorder;
//
//   DayTileContainer({
//     this.dateTime,
//     this.isDayOfCurrentMonth,
//     this.events,
//     this.markBuilder,
//     this.borderRadius,
//     this.dayTileMargin,
//     this.onTap,
//     this.isSelected,
//     this.dayTileBorderColor,
//     this.dayTileBuilder,
//     this.showBorder,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     DayProps dayProps = DayProps(
//       dateTime: dateTime,
//       onTap: onTap,
//       isDayOfCurrentMonth: isDayOfCurrentMonth,
//       events: events,
//       markBuilder: markBuilder,
//       borderRadius: borderRadius,
//       dayTileMargin: dayTileMargin,
//       isSelected: isSelected,
//       dayTileBorderColor: dayTileBorderColor,
//       showBorder: showBorder,
//       isToday: formatDate(dateTime) == formatDate(DateTime.now()),
//     );
//     return Expanded(
//       child: GestureDetector(
//           onTap: () {
//             if (onTap != null) {
//               onTap(dateTime, !isSelected);
//             }
//           },
//           onLongPress: () {},
//           child: Container(
//             width: double.infinity,
//             child: dayTileBuilder != null
//                 ? dayTileBuilder(dayProps)
//                 : _DayTile(dayProps),
//           )),
//     );
//   }
// }
//
// class DayProps {
//   final DateTime dateTime;
//   final bool isDayOfCurrentMonth;
//   final List<String> events;
//   final Function markBuilder;
//   final double borderRadius;
//   final double dayTileMargin;
//   final Function onTap;
//   final bool isSelected;
//   final Color dayTileBorderColor;
//   final bool showBorder;
//   final bool isToday;
//
//   DayProps({
//     this.dateTime,
//     this.isDayOfCurrentMonth,
//     this.events,
//     this.markBuilder,
//     this.borderRadius,
//     this.dayTileMargin,
//     this.onTap,
//     this.isSelected,
//     this.dayTileBorderColor,
//     this.showBorder,
//     this.isToday,
//   });
// }
//
// class _DayTile extends StatelessWidget {
//   final DayProps props;
//
//   _DayTile(this.props);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(props.dayTileMargin ?? 3),
//       decoration: BoxDecoration(
//           border: props.showBorder == true
//               ? Border.all(
//             width: 1,
//             color: props.dayTileBorderColor ?? Colors.grey,
//           )
//               : null,
//           borderRadius: BorderRadius.circular(props.borderRadius),
//           color: props.isSelected
//               ? Theme.of(context).primaryColor
//               : props.isToday
//               ? Theme.of(context).primaryColorLight
//               : Colors.transparent),
//       child: Stack(
//         children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text(
//                 '${props.dateTime.day}',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     color: props.isDayOfCurrentMonth
//                         ? Colors.black87
//                         : Colors.grey),
//               ),
//             ],
//           ),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: _EventMarks(props.events, markBuilder: props.markBuilder),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _EventMarks extends StatelessWidget {
//   final List<String> events;
//   final Function markBuilder;
//
//   _EventMarks(this.events, {this.markBuilder});
//
//   @override
//   Widget build(BuildContext context) {
//     if (events == null) {
//       return Container();
//     }
//
//     if (events.length == 0) {
//       return Container();
//     }
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List.generate(events.length, (index) {
//         if (this.markBuilder != null) {
//           return this.markBuilder(events[index]);
//         }
//
//         return _EventMark(Colors.black);
//       }),
//     );
//   }
// }
//
// class _EventMark extends StatelessWidget {
//   final Color color;
//
//   _EventMark(this.color);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 5),
//       child: Container(
//         width: 6,
//         height: 6,
//         margin: EdgeInsets.symmetric(horizontal: 1),
//         color: color,
//       ),
//     );
//   }
// }
//
// String formatDate(DateTime date) {
//   String day = date.day.toString().padLeft(2, '0');
//   String month = date.month.toString().padLeft(2, '0');
//   return '${date.year}-$month-$day';
// }