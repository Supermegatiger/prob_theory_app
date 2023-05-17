import 'dart:io';
import 'package:flutter/material.dart';
import 'package:prob_theory_app/pages/paramsPage.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  if (Platform.isWindows) {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();
    WindowManager.instance.setMinimumSize(const Size(600, 800));
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            primary: Colors.grey.shade800,
            background: Colors.white,
            shadow: Colors.transparent,
            outline: Colors.transparent),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          background: Colors.grey.shade900,
        ),
        useMaterial3: true,
      ),
      home: const ParamsPage(title: 'Generator'),
    );
  }
}
