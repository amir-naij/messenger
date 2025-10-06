import 'package:flutter/material.dart';

class LightTheme {
  ThemeData get lightTheme {
    return ThemeData().copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
      listTileTheme: ListTileThemeData().copyWith(
        tileColor: const Color.fromARGB(255, 228, 228, 228),
        shape: LinearBorder.bottom(
          side: const BorderSide(
            color: Color.fromARGB(255, 189, 189, 189),
            width: 1.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme().copyWith(
        backgroundColor: const Color.fromARGB(255, 50, 50, 50),
        foregroundColor: const Color.fromARGB(255, 250, 250, 250),
        titleTextStyle: TextStyle(fontSize: 20),
        toolbarHeight: 50,
      ),
      cardTheme: CardThemeData(),
    );
  }
}
