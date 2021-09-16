import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightMode() => ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff1C262F),
        elevation: 0.0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color(0xff1C262F),
          statusBarIconBrightness: Brightness.light,
        ),
        backwardsCompatibility: false,
        titleSpacing: 0.0,
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      fontFamily: 'Jannah',
      hintColor: Colors.grey[400],
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      splashColor: const Color(0xFF1B2C3B),
      scaffoldBackgroundColor: const Color(0xFF1B2C3B),
    );
