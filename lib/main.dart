import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light,
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;
  int _styleIndex = 0;

  final List<String> _styleFormats = [
    'MMMM d, y - h:mm:ss a', // Month, day, year - hour:minute:second am/pm
    'EEEE, MMMM d, y - H:mm:ss', // Day of week, month, day, year - 24-hour hour:minute:second
    'y-MM-dd HH:mm:ss', // Year-month-day - 24-hour hour:minute:second
    'h:mm:ss a', // Hour:minute:second am/pm
    'H:mm:ss', // 24-hour hour:minute:second
  ];

  String _clockText() {
    // Format the date and time to a string in the user's locale and the selected style.
    return DateFormat(_styleFormats[_styleIndex]).format(_dateTime);
  }

  void _changeStyle(int delta) {
    // Change the clock style by moving the style index by the specified delta.
    setState(() {
      _styleIndex = (_styleIndex + delta) % _styleFormats.length;
      if (_styleIndex < 0) {
        _styleIndex += _styleFormats.length;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Update the clock every second.
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _dateTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // When the user swipes left or right, change the clock style accordingly.
        if (details.primaryVelocity! > 0) {
          _changeStyle(-1); // Swipe right
        } else if (details.primaryVelocity! < 0) {
          _changeStyle(1); // Swipe left
        }
      },
      child: MaterialApp(
        home: Scaffold(
          body: Container(
            color: Colors.black,
            child: Center(
              child: Text(
                _clockText(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
