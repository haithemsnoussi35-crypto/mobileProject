import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'root_shell.dart';

class StudyMatchApp extends StatelessWidget {
  const StudyMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StudyMatch',
      theme: getAppTheme(),
      home: const RootShell(),
      debugShowCheckedModeBanner: false,
    );
  }
}




