import 'package:example/payment_form.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipe Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorScheme: ColorScheme.fromSwatch(primarySwatch: primarySwipeColor)
            .copyWith(secondary: Colors.white),
      ),
      home: PaymentForm(title: 'Swipe Demo'),
    );
  }

  static const MaterialColor primarySwipeColor = MaterialColor(
    _primarySwipe,
    <int, Color>{
      50: Color(0xFF715698),
      100: Color(0xFF715698),
      200: Color(0xFF6d5098),
      300: Color(0xFF684a96),
      400: Color(0xFF654598),
      500: Color(_primarySwipe),
      600: Color(0xFF5f399a),
      700: Color(0xFF5a319a),
      800: Color(0xFF542998),
      900: Color(0xFF4d1f94),
    },
  );
  static const int _primarySwipe = 0xFF623F99;
}
