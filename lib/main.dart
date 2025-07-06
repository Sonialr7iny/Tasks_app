import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:tasks_app/shared/style/bloc_observer.dart';
import 'layout/home_layout.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              selectedItemColor: Colors.indigo
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          splashFactory: InkSplash.splashFactory
      ),

      home: HomeLayout(),
    );
  }
}
