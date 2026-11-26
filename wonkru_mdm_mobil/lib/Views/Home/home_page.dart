import 'package:flutter/material.dart';
import 'package:wonkrumdm/Views/Launcher/launcher_page.dart';

const _tag = 'HomePage';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return LauncherPage();
  }
}
